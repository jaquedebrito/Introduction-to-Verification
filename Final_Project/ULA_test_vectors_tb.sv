//-----------------------------------------------------------------------------
// Projeto: ULA Testbench self checking with Test Vectors
// Data: 23/02/2025
// Aluna: Jaqueline Ferreira de Brito
// Descrição: Testbench auto verificado com vetores e verificações aprimoradas
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

`include "ula_enhanced_pkg.sv"  // Inclusão de pacotes personalizados
`include "testbench_utils_pkg.sv"
import ula_enhanced_pkg::*;  // Importação do pacote de verificações aprimoradas
import testbench_utils_pkg::*;  // Importação de pacotes utilitários

module ULA_test_vectors_tb;  // Módulo do testbench para a ULA

    // Sinais do testbench
    logic        clock;  // Sinal de clock
    logic        reset;  // Sinal de reset
    logic [7:0]  A;     // Entradas de 8 bits para o A
    logic [7:0]  B;     // Entradas de 8 bits para o B
    logic [3:0]  ULA_Sel;  // Seleção de operação da ULA (4 bits)
    logic [7:0]  ULA_Out;  // Saída da ULA (resultado)
    logic        CarryOut;  // Sinal de carry (se ocorrer durante a operação)
    
    // Contadores para o número de operações realizadas
    int num_adds = 0;  // Contador de adições
    int num_subs = 0;  // Contador de subtrações
    int num_muls = 0;  // Contador de multiplicações
    int num_divs = 0;  // Contador de divisões
    int num_invalids = 0;  // Contador de operações inválidas
    int num_errors = 0;  // Contador de erros gerais
    int num_tests = 0;  // Contador de testes realizados
    
    // Monitoramento de timing
    logic timing_monitor_enabled = 1;  // Flag de monitoramento de timing
    time operation_start_time;  // Tempo de início de operação
    time last_operation_time;  // Tempo da última operação
    int timing_violations = 0;  // Contador de violações de timing
    
    // Arquivo de vetores de testes
    integer file;  // Handle para o arquivo
    string line;  // Linha lida do arquivo
    
    // Estruturas para monitoramento e verificação
    error_stats_t errors;  // Estrutura para estatísticas de erro
    PerformanceMonitor perf_monitor;  // Monitor de desempenho
    TimingChecker timing_checker;  // Verificador de timing
    enhanced_error_stats_t enhanced_errors;  // Estrutura para erros aprimorados
    
    // Instanciação da ULA (Unidade Lógica Aritmética)
    ULA dut (.*);  // Instância do DUT (Device Under Test)
    
    // Geração do clock
    initial begin
        clock = 0;  // Inicializa o clock
        forever #5 clock = ~clock;  // Gera um clock de 5ns
    end
    
    // Task para monitoramento de timing detalhado
    task automatic monitor_operation_timing(
        input time start_time,  // Tempo de início da operação
        input string operation,  // Nome da operação
        input int test_num  // Número do teste
    );
        time end_time, delta;
        end_time = $time;  // Tempo de término da operação
        delta = end_time - start_time;  // Calcula o tempo de execução da operação
        
        // Verifica se há violações de timing
        if (timing_monitor_enabled) begin
            if (delta != 10) begin
                timing_violations++;  // Incrementa as violações de timing
                $error("Violação de timing detectada no teste %0d (%s): %0t ns", 
                       test_num, operation, delta);  // Exibe erro
            end
        end
        
        // Atualiza as estatísticas de desempenho
        perf_monitor.update_timing(delta);
        last_operation_time = end_time;  // Atualiza o tempo da última operação
    endtask

    // Função para converter a operação para string
    function automatic string op_to_string(logic [3:0] op);
        case(op)
            4'b0000: return "ADD";  // Adição
            4'b0001: return "SUB";  // Subtração
            4'b0010: return "MUL";  // Multiplicação
            4'b0011: return "DIV";  // Divisão
            default: return "INV";  // Operação inválida
        endcase
    endfunction
    
    // Task para verificar o resultado da operação
    task automatic enhanced_check_result(
        input logic [7:0] a,  // Valor A
        input logic [7:0] b,  // Valor B
        input logic [3:0] op,  // Operação
        input logic [7:0] expected_result,  // Resultado esperado
        input logic expected_carry,  // Carry esperado
        input int test_num  // Número do teste
    );
        time start_time;
        string op_str;
        string op_symbol;
    
        // Determina o símbolo da operação
        case(op)
            4'b0000: op_symbol = "+";  // Adição
            4'b0001: op_symbol = "-";  // Subtração
            4'b0010: op_symbol = "*";  // Multiplicação
            4'b0011: op_symbol = "/";  // Divisão
            default: op_symbol = "?";  // Operação desconhecida
        endcase
        
        // Verifica se os valores de entrada são desconhecidos
        if ($isunknown({a, b, op})) begin
            $error("Teste %0d: Valores de entrada desconhecidos", test_num);
            errors.unknown_values++;  // Incrementa erro de valores desconhecidos
            enhanced_errors.unknown_values++;  // Incrementa erro aprimorado
            return;
        end

        @(posedge clock);
        A = a;  // Atribui o valor de A
        B = b;  // Atribui o valor de B
        ULA_Sel = op;  // Seleciona a operação
        start_time = $time;  // Registra o tempo de início
        op_str = op_to_string(op);  // Converte operação para string

        @(posedge clock);
        
        // Exibe os resultados de forma formatada
        $display("\n=== Teste %0d (%s) ===", test_num, op_to_string(op));
        $display("Cálculo: 0x%h %s 0x%h = 0x%h (%s)", 
                 a, op_symbol, b, expected_result, 
                 (expected_carry ? "com carry" : "sem carry"));
        $display("Valores em decimal:");
        $display("A = %0d, B = %0d, Resultado esperado = %0d", 
                 a, b, expected_result);
        $display("Tempo de execução: %0t ns", $time - start_time);

        // Verifica se houve carry na operação
        if (CarryOut || expected_carry)
            $display("*** Operação com carry/overflow ***");

        // Verifica se o resultado está correto
        $display("Status: %s", (ULA_Out === expected_result) ? "OK" : "FALHOU");
        $display("Resultado obtido: 0x%h (%0d)", ULA_Out, ULA_Out);
        
        // Verifica se o resultado obtido é o esperado
        if (ULA_Out !== expected_result) begin
            errors.result_mismatch++;  // Incrementa erro de mismatch
            num_errors++;  // Incrementa contador de erros
        end

        // Verifica o carry, se aplicável
        case (op)
            4'b0000, 4'b0001, 4'b0010: begin
                if (CarryOut !== expected_carry) begin
                    errors.carry_mismatch++;  // Incrementa erro de carry
                    num_errors++;  // Incrementa contador de erros
                end
            end
        endcase

        // Monitora o tempo da operação
        if (!timing_checker.check_timing($time - start_time))
            enhanced_errors.timing_violations++;  // Incrementa violação de timing
        
        monitor_operation_timing(start_time, op_str, test_num);  // Monitora o timing
        num_tests++;  // Incrementa o contador de testes
    endtask

    // Task para aplicar os vetores de teste
    task automatic apply_vector(
        input logic [7:0] in_a,  // Valor A
        input logic [7:0] in_b,  // Valor B
        input logic [3:0] op,  // Operação
        input logic [7:0] expected_result,  // Resultado esperado
        input logic expected_carry,  // Carry esperado
        input int test_num  // Número do teste
    );
        enhanced_check_result(in_a, in_b, op, expected_result, expected_carry, test_num);  // Chama a task de verificação
    endtask

    // Função para imprimir relatório completo ao final dos testes
    function void print_enhanced_report();
        $display("\n=== Relatório Final - %s ===", "2025-02-23 19:56:07");
        $display("Usuário: jaquedebrito");
        
        // Exibe as estatísticas de teste
        $display("\nEstatísticas de Testes:");
        $display("Total de testes: %0d", num_tests);
        $display("Adições: %0d", num_adds);
        $display("Subtrações: %0d", num_subs);
        $display("Multiplicações: %0d", num_muls);
        $display("Divisões: %0d", num_divs);
        $display("Operações Inválidas: %0d", num_invalids);
        
        perf_monitor.print_report();  // Imprime o relatório de desempenho
        
        // Exibe estatísticas de erro
        $display("\n=== Estatísticas de Erro ===");
        $display("Operações inválidas: %0d", errors.invalid_ops);
        $display("Violações de timing: %0d", errors.timing_violations);
        $display("Erros de overflow: %0d", errors.overflow_errors);
        $display("Violações A < B: %0d", errors.a_less_than_b);
        $display("Divisões por zero: %0d", errors.div_by_zero);
        $display("Resultados incorretos: %0d", errors.result_mismatch);
        $display("Carrys incorretos: %0d", errors.carry_mismatch);
        $display("Valores desconhecidos: %0d", errors.unknown_values);
        $display("Erros de formato de vetor: %0d", errors.vector_format_errors);
        
        // Exibe erros aprimorados
        $display("\n=== Erros Adicionais ===");
        $display("Violações de setup: %0d", enhanced_errors.setup_violations);
        $display("Violações de hold: %0d", enhanced_errors.hold_violations);
        $display("Erros de estabilidade: %0d", enhanced_errors.stability_errors);
        $display("Erros de reset: %0d", enhanced_errors.reset_errors);
        $display("Violações de desempenho: %0d", enhanced_errors.performance_violations);
        
        // Exibe estatísticas de timing
        $display("\n=== Estatísticas de Timing ===");
        $display("Total de violações de timing: %0d", timing_violations);
        $display("Última operação completada em: %0t", last_operation_time);
    endfunction

    // Processo principal de teste
    initial begin
        // Inicializações
        $timeformat(-9, 2, " ns", 20);
        
        // Inicializa monitores
        perf_monitor = new();
        timing_checker = new();
        enhanced_errors = '{default: 0};
        errors = '{default: 0};
        operation_start_time = 0;
        last_operation_time = 0;
        timing_violations = 0;
        
        // Cabeçalho
        $display("//----------------------------------------");
        $display("// Iniciando testbench ULA Test Vectors");
        $display("// Data: 23/02/2025");
        $display("// Aluna: Jaqueline Ferreira de Brito");
        $display("//----------------------------------------");
        
        // Reset
        reset = 1;
        A = 8'h01;
        B = 8'h01;
        ULA_Sel = 4'b0;
        
        repeat(2) @(posedge clock);
        reset = 0;
        @(posedge clock);

        // Processa vetores de teste a partir de arquivo
        file = $fopen("ULA_vectors.txt", "r");
        if (file == 0) begin
            $display("Erro: Não foi possível abrir o arquivo ULA_vectors.txt");
            $finish;
        end

        while ($fgets(line, file)) begin
            logic [3:0] op;
            logic [7:0] a, b, expected_result;
            logic expected_carry;
            string op_comment;
            
            // Remove espaços antes e depois
            while (line.len() > 0 && (line[0] == " " || line[0] == "\t"))
                line = line.substr(1, line.len()-1);
                
            while (line.len() > 0 && (line[line.len()-1] == " " || line[line.len()-1] == "\t" || line[line.len()-1] == "\n"))
                line = line.substr(0, line.len()-2);
            
            // Pula comentários
            if (line == "" || line.substr(0, 2) == "//")
                continue;
                
            // Parse da linha
            if ($sscanf(line, "%h %h %h %h %b // %s", 
                     op, a, b, expected_result, expected_carry, op_comment) != 6) begin
                if (line.len() > 0) begin
                    $display("Erro no formato do vetor: %s", line);
                    errors.vector_format_errors++;  // Erro de formato de vetor
                end
                continue;
            end
            
            apply_vector(a, b, op, expected_result, expected_carry, num_tests);  // Aplica o vetor de teste
            
            // Atualiza os contadores por tipo de operação
            case (op)
                4'b0000: num_adds++;
                4'b0001: num_subs++;
                4'b0010: num_muls++;
                4'b0011: num_divs++;
                default: num_invalids++;
            endcase
        end
        
        $fclose(file);  // Fecha o arquivo de vetores
        
        // Imprime relatório final
        print_enhanced_report();
        
        $display("\nTestbench concluído em %t", $time);
        repeat(2) @(posedge clock);
        $finish;
    end

    // Verificações contínuas durante o clock
    always @(posedge clock) begin
        if (!reset && !$isunknown({A, B, ULA_Sel})) begin
            assert(A >= B) else
                $error("Violação: A deve ser maior ou igual a B (A=%h, B=%h)", A, B);
            
            assert(ULA_Sel inside {[0:3]}) else
                $error("Operação inválida detectada: %h", ULA_Sel);
                
            assert(!(ULA_Sel == 4'b0011 && B == 0)) else
                $error("Tentativa de divisão por zero");
        end
    end

    // Cobertura funcional
    covergroup ULA_cov @(posedge clock);
        option.per_instance = 1;
        
        cp_op: coverpoint ULA_Sel {
            bins ops[] = {[0:3]};  // Cobertura para operações
            illegal_bins invalid = {[4:$]};  // Operações inválidas
        }
        
        cp_carry: coverpoint CarryOut iff (ULA_Sel == 4'b0000) {
            bins no_carry = {0};  // Cobertura para sem carry
            bins with_carry = {1};  // Cobertura para com carry
        }
        
        cp_zero_result: coverpoint ULA_Out {
            bins zero = {0};  // Resultado zero
            bins non_zero = {[1:$]};  // Resultado não zero
        }
        
        cp_division: coverpoint (ULA_Sel == 4'b0011 && B != 0) {
            bins valid_div = {1};  // Cobertura para divisão válida
        }
        
        cp_a_gt_b: coverpoint (A > B) {
            bins a_greater = {1};  // A > B
            bins a_equal = {0};  // A == B
        }
    endgroup
    
    ULA_cov cov;
    
    initial begin
        cov = new();  // Inicializa o grupo de cobertura
    end

endmodule
