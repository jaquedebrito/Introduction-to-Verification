//-----------------------------------------------------------------------------
// Projeto: ULA Testbench self checking
// Aluna: Jaqueline Ferreira de Brito
// Data: 2025-02-23 20:56:59
// Descrição: Testbench auto verificado com testes determinísticos e aleatórios
//-----------------------------------------------------------------------------

`timescale 1ns/1ps // Definindo a unidade de tempo e a precisão para 1ns/1ps

// Importa os pacotes necessários para o testbench
`include "ula_enhanced_pkg.sv"
`include "testbench_utils_pkg.sv"
import ula_enhanced_pkg::*;
import testbench_utils_pkg::*;

// Módulo do testbench com verificação automática
module ULA_self_checking_tb;
    
    // Declaração de sinais de entrada e saída para o testbench
    logic        clock;          // Sinal de clock
    logic        reset;          // Sinal de reset
    logic [7:0]  A;              // Operando A
    logic [7:0]  B;              // Operando B
    logic [3:0]  ULA_Sel;        // Seleção da operação na ULA
    logic [7:0]  ULA_Out;        // Resultado da ULA
    logic        CarryOut;       // Sinal de carry (transbordo)

    // Instância do gerenciador de testes
    TestManager test_mgr;

    // Contadores de estatísticas de operações
    int num_adds = 0;
    int num_subs = 0;
    int num_muls = 0;
    int num_divs = 0;
    int num_invalids = 0;
    int num_errors = 0;
    int num_tests = 0;

    // Instância dos monitores e verificadores
    PerformanceMonitor perf_monitor;    
    TimingChecker timing_checker;       
    enhanced_error_stats_t enhanced_errors;

    // Definição de constantes
    localparam MIN_OPS = 2; // Número mínimo de operações válidas a serem realizadas

    // Enumeração das operações disponíveis
    typedef enum logic [3:0] {
        ADD = 4'b0000, // Operação de adição
        SUB = 4'b0001, // Operação de subtração
        MUL = 4'b0010, // Operação de multiplicação
        DIV = 4'b0011  // Operação de divisão
    } op_t;

    // Estrutura para armazenar estatísticas de erros
    typedef struct {
        int invalid_ops;      // Operações inválidas
        int timing_violations; // Violações de timing
        int overflow_errors;   // Erros de overflow
        int a_less_than_b;     // A < B (violação de ordem)
        int div_by_zero;       // Tentativa de divisão por zero
        int result_mismatch;   // Erro de comparação de resultados
        int carry_mismatch;    // Erro no carry
        int unknown_values;    // Valores desconhecidos
    } error_stats_t;

    // Instância de estatísticas de erro
    error_stats_t errors;

    // Instanciação do DUT (Dispositivo sob teste) ULA
    ULA dut (.*);

    // Geração do sinal de clock
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // Clock com período de 10 ns (5 ns para cada borda)
    end

    // Função para converter a operação em string para exibição
    function automatic string op_to_string(logic [3:0] op);
        case(op)
            ADD: return "ADD";
            SUB: return "SUB";
            MUL: return "MUL";
            DIV: return "DIV";
            default: return "INV"; // Retorna "INV" para operações inválidas
        endcase
    endfunction

    // Função para gerar um operando B válido, considerando a operação
    function automatic logic [7:0] gen_valid_b(input logic [7:0] a, input op_t op);
        logic [7:0] b;
        if (op == DIV) begin
            b = ($urandom % a); // Gera um valor de B menor que A para divisão
            return (b == 0) ? 8'h01 : b; // Evita divisão por zero
        end else begin
            return ($urandom % (a + 1)); // Gera um valor de B aleatório
        end
    endfunction

    // Task para verificar o resultado da operação
    task automatic check_result(input logic [7:0] a, input logic [7:0] b, input logic [3:0] op, input int test_num);
        time start_time;
        string op_str;
        string op_symbol;
        logic [8:0] full_result;
        logic [7:0] expected_result;
        logic expected_carry;

        // Define o símbolo da operação
        case(op)
            ADD: op_symbol = "+";
            SUB: op_symbol = "-";
            MUL: op_symbol = "*";
            DIV: op_symbol = "/";
            default: op_symbol = "?"; // Operação inválida
        endcase

        // Verificação de valores desconhecidos
        if ($isunknown({a, b, op})) begin
            $display("Teste %0d: Valores de entrada desconhecidos", test_num);
            errors.unknown_values++;
            enhanced_errors.unknown_values++;
            return;
        end

        // Cálculo do resultado esperado
        case (op)
            ADD: begin
                full_result = a + b;
                expected_result = full_result[7:0];
                expected_carry = full_result[8]; // Carry ocorre no resultado
            end
            SUB: begin
                expected_result = a - b;
                expected_carry = 0; // Não há carry em subtração
            end
            MUL: begin
                full_result = a * b;
                expected_result = full_result[7:0];
                expected_carry = 0; // Não há carry em multiplicação
            end
            DIV: begin
                expected_result = a / b;
                expected_carry = 0; // Não há carry em divisão
            end
        endcase

        @(posedge clock);
        A = a; // Atribui valores aos operandos
        B = b;
        ULA_Sel = op; // Define a operação a ser realizada
        start_time = $time;
        op_str = op_to_string(op); // Converte operação para string

        @(posedge clock);

        // Exibe informações detalhadas do teste
        $display("\n=== Teste %0d (%s) ===", test_num, op_str);
        $display("Cálculo: 0x%h %s 0x%h = 0x%h (%s)", a, op_symbol, b, expected_result, 
                 (expected_carry ? "com carry" : "sem carry"));
        $display("Valores em decimal:");
        $display("A = %0d, B = %0d, Resultado esperado = %0d", a, b, expected_result);
        $display("Tempo de execução: %0t ns", $time - start_time);

        if (CarryOut || expected_carry)
            $display("*** Operação com carry/overflow ***");

        // Verifica se o resultado está correto
        if (ULA_Out !== expected_result) begin
            $display("Status: FALHOU");
            $display("Resultado obtido: 0x%h (%0d) - INCORRETO", ULA_Out, ULA_Out);
            errors.result_mismatch++; // Incrementa o erro
            num_errors++;
        end else begin
            $display("Status: OK");
            $display("Resultado obtido: 0x%h (%0d)", ULA_Out, ULA_Out);
        end

        // Adiciona o resultado ao TestManager
        test_mgr.add_result(
            $sformatf("Teste %0d (%s)", test_num, op_str),
            $sformatf("0x%h %s 0x%h = 0x%h", a, op_symbol, b, expected_result),
            (ULA_Out === expected_result),
            $time - start_time,
            $sformatf("0x%h", expected_result),
            $sformatf("0x%h", ULA_Out),
            (CarryOut || expected_carry) ? "Com carry/overflow" : "Sem carry/overflow"
        );

        // Atualiza as estatísticas de operações realizadas
        case (op)
            ADD: num_adds++;
            SUB: num_subs++;
            MUL: num_muls++;
            DIV: num_divs++;
            default: num_invalids++;
        endcase

        num_tests++; // Incrementa o número total de testes
    endtask

    // Task para rodar os testes determinísticos
    task automatic run_deterministic_tests();
        int test_count = 0;
        $display("\n=== Testes Determinísticos ===");
        
        // Testes para adição
        check_result(8'h30, 8'h20, ADD, test_count++);
        check_result(8'hFF, 8'h01, ADD, test_count++);
        check_result(8'h80, 8'h80, ADD, test_count++);
        
        // Testes para subtração
        check_result(8'h50, 8'h20, SUB, test_count++);
        check_result(8'h30, 8'h30, SUB, test_count++);
        check_result(8'hFF, 8'h01, SUB, test_count++);
        
        // Testes para multiplicação
        check_result(8'h04, 8'h03, MUL, test_count++);
        check_result(8'h10, 8'h10, MUL, test_count++);
        check_result(8'hFF, 8'h02, MUL, test_count++);
        
        // Testes para divisão
        check_result(8'h20, 8'h04, DIV, test_count++);
        check_result(8'h0F, 8'h04, DIV, test_count++);
        check_result(8'hFF, 8'h02, DIV, test_count++);

        num_tests = test_count;
    endtask

    // Task para rodar os testes aleatórios
    task automatic run_random_tests(int num_random_tests);
        int remaining_tests;
        int test_count;
        logic [7:0] temp_a;
        logic [7:0] temp_b;
        op_t op;
        
        begin
            $display("\n=== Testes Aleatórios ===");
            remaining_tests = num_random_tests;
            test_count = num_tests;

            while (remaining_tests > 0) begin
                // Determina a operação a ser realizada de forma aleatória
                if (num_adds < MIN_OPS) op = ADD;
                else if (num_subs < MIN_OPS) op = SUB;
                else if (num_muls < MIN_OPS) op = MUL;
                else if (num_divs < MIN_OPS) op = DIV;
                else op = op_t'($urandom % 4);
                
                temp_a = $urandom; // Gera valor aleatório para A
                if (temp_a == 0) temp_a = 8'h01; // Garante que A não seja zero
                
                temp_b = gen_valid_b(temp_a, op); // Gera B válido com base em A e operação
                
                // Chama a task para verificar o resultado
                check_result(temp_a, temp_b, op, test_count++);
                
                remaining_tests--;
            end
        
            // Verifica se o número mínimo de operações foi realizado
            assert(num_adds >= MIN_OPS) else 
                $error("Número insuficiente de adições: %0d", num_adds);
            assert(num_subs >= MIN_OPS) else 
                $error("Número insuficiente de subtrações: %0d", num_subs);
            assert(num_muls >= MIN_OPS) else 
                $error("Número insuficiente de multiplicações: %0d", num_muls);
            assert(num_divs >= MIN_OPS) else 
                $error("Número insuficiente de divisões: %0d", num_divs);
        end
    endtask

    // Função para exibir relatório de erros
    function void print_error_report();
        $display("\n=== Relatório Final - %s ===", "2025-02-23 20:56:59");
        $display("Usuário: %s", "jaquedebrito");

        $display("\nEstatísticas de Testes:");
        $display("Total de testes: %0d", num_tests);
        $display("Adições: %0d", num_adds);
        $display("Subtrações: %0d", num_subs);
        $display("Multiplicações: %0d", num_muls);
        $display("Divisões: %0d", num_divs);
        $display("Operações Inválidas: %0d", num_invalids);

        $display("\n=== Relatório de Desempenho ===");
        perf_monitor.print_report();

        $display("\n=== Estatísticas de Erro ===");
        $display("Operações inválidas: %0d", errors.invalid_ops);
        $display("Violações de timing: %0d", errors.timing_violations);
        $display("Erros de overflow: %0d", errors.overflow_errors);
        $display("Violações A < B: %0d", errors.a_less_than_b);
        $display("Divisões por zero: %0d", errors.div_by_zero);
        $display("Resultados incorretos: %0d", errors.result_mismatch);
        $display("Carrys incorretos: %0d", errors.carry_mismatch);
        $display("Valores desconhecidos: %0d", errors.unknown_values);
    endfunction

    // Processo principal de teste
    initial begin
        // Formatação do tempo para exibição
        $timeformat(-9, 2, " ns", 20);
        
        // Inicializações do sistema
        test_mgr = new("2025-02-23 20:56:59", "jaquedebrito");
        perf_monitor = new();
        timing_checker = new();
        enhanced_errors = '{default: 0};
        errors = '{default: 0};
        
        // Cabeçalho do relatório inicial
        $display("//----------------------------------------");
        $display("// Iniciando testbench ULA with self checking");
        $display("// Data: 23/02/2025");
        $display("// Aluna: Jaqueline Ferreira de Brito");
        $display("//----------------------------------------");
        
        // Reset inicial
        reset = 1;
        A = 0;
        B = 0;
        ULA_Sel = 0;
        
        // Espera o clock para liberar o reset
        repeat(2) @(posedge clock);
        reset = 0;
        @(posedge clock);

        // Executa os testes determinísticos e aleatórios
        run_deterministic_tests();
        run_random_tests(10); // Realiza 10 testes aleatórios
        
        // Relatórios finais
        print_error_report();
        test_mgr.print_report();
        
        $display("\nTestbench concluído em %t", $time);
        repeat(2) @(posedge clock);
        $finish;
    end

    // Verificações contínuas durante o clock
    always @(posedge clock) begin
        if (!reset && !$isunknown({A, B, ULA_Sel})) begin
            // Verifica as condições de entrada
            assert(A >= B) else
                $error("Violação: A deve ser maior ou igual a B (A=%h, B=%h)", A, B);
            
            assert(ULA_Sel inside {[0:3]}) else
                $error("Operação inválida detectada: %h", ULA_Sel);
                
            assert(!(ULA_Sel == DIV && B == 0)) else
                $error("Tentativa de divisão por zero");
        end
    end

    // Cobertura funcional
    covergroup ULA_cov @(posedge clock);
        option.per_instance = 1;
        
        // Cobertura de operações
        cp_op: coverpoint ULA_Sel {
            bins ops[] = {[0:3]};
            illegal_bins invalid = {[4:$]};
        }
        
        // Cobertura de carry
        cp_carry: coverpoint CarryOut iff (ULA_Sel == ADD) {
            bins no_carry = {0};
            bins with_carry = {1};
        }
        
        // Cobertura de resultado zero
        cp_zero_result: coverpoint ULA_Out {
            bins zero = {0};
            bins non_zero = {[1:$]};
        }

        // Cobertura para divisão válida
        cp_division: coverpoint (ULA_Sel == DIV && B != 0) {
            bins valid_div = {1};
        }
        
        // Cobertura para A maior que B
        cp_a_gt_b: coverpoint (A > B) {
            bins a_greater = {1};
            bins a_equal = {0};
        }
    endgroup
    
    ULA_cov cov;
    
    initial begin
        cov = new(); // Inicializa a cobertura
    end

endmodule
