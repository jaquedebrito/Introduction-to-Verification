//-----------------------------------------------------------------------------
// Projeto: Pacote Enhanced para ULA
// Aluna: Jaqueline Ferreira de Brito
// Data: 23/02/2025
// Descrição: Pacote com estruturas e classes para verificação avançada da ULA
//-----------------------------------------------------------------------------

package ula_enhanced_pkg;
    // Estrutura para estatísticas básicas de erro
    // Usada no testbench simples e com vetores
    typedef struct {
        int invalid_ops;      // Contador de operações inválidas
        int timing_violations; // Violações de tempo
        int overflow_errors;   // Erros de overflow
        int a_less_than_b;    // Casos onde A < B (inválido)
        int div_by_zero;      // Tentativas de divisão por zero
        int result_mismatch;  // Resultados incorretos
        int carry_mismatch;   // Carry incorreto
        int unknown_values;   // Valores desconhecidos (X ou Z)
        int vector_format_errors; // Erros no formato dos vetores
    } error_stats_t;

    // Estrutura expandida para estatísticas de erro
    // Adiciona mais tipos de erro para verificação detalhada
    typedef struct {
        // Herda todos os campos da estrutura básica
        int invalid_ops;
        int timing_violations;
        int overflow_errors;
        int a_less_than_b;
        int div_by_zero;
        int result_mismatch;
        int carry_mismatch;
        int unknown_values;
        int vector_format_errors;
        
        // Campos adicionais para verificação avançada
        int setup_violations;      // Violações de setup time
        int hold_violations;       // Violações de hold time
        int stability_errors;      // Erros de estabilidade
        int reset_errors;         // Problemas com reset
        int performance_violations; // Violações de performance
    } enhanced_error_stats_t;

    // Classe para monitoramento de desempenho da ULA
    class PerformanceMonitor;
        time min_operation_time;   // Menor tempo de operação
        time max_operation_time;   // Maior tempo de operação
        real avg_operation_time;   // Tempo médio de operação
        int total_operations;      // Total de operações realizadas
        
        // Construtor - inicializa contadores
        function new();
            min_operation_time = '1;    // Inicializa com máximo valor possível
            max_operation_time = 0;     // Inicializa com zero
            avg_operation_time = 0;     // Média inicial zero
            total_operations = 0;       // Contador de operações zero
        endfunction
        
        // Atualiza estatísticas de timing
        function void update_timing(time operation_time);
            // Atualiza tempo mínimo se necessário
            if (operation_time < min_operation_time)
                min_operation_time = operation_time;
            // Atualiza tempo máximo se necessário    
            if (operation_time > max_operation_time)
                max_operation_time = operation_time;
            
            // Calcula nova média ponderada    
            avg_operation_time = (avg_operation_time * total_operations + 
                                real'(operation_time)) / (total_operations + 1);
            total_operations++;
        endfunction
        
        // Gera relatório de performance
        function void print_report();
            $display("\n=== Relatório de Desempenho ===");
            $display("Tempo mínimo de operação: %0t", min_operation_time);
            $display("Tempo máximo de operação: %0t", max_operation_time);
            $display("Tempo médio de operação: %0.2f ns", avg_operation_time);
            $display("Total de operações: %0d", total_operations);
        endfunction
    endclass

    // Classe para verificação de timing da ULA
    class TimingChecker;
        // Parâmetros de timing
        localparam time SETUP_TIME = 2;     // Tempo de setup requerido
        localparam time HOLD_TIME = 1;      // Tempo de hold requerido
        localparam time EXPECTED_TIME = 10;  // Tempo esperado de operação
        localparam time TOLERANCE = 1;       // Tolerância aceitável
        
        // Verifica tempo de setup
        function automatic bit check_setup(time window);
            return (window >= SETUP_TIME);
        endfunction
        
        // Verifica tempo de hold
        function automatic bit check_hold(time window);
            return (window >= HOLD_TIME);
        endfunction

        // Verifica timing geral
        function automatic bit check_timing(time delta);
            return (delta >= EXPECTED_TIME) && (delta <= EXPECTED_TIME + TOLERANCE);
        endfunction
    endclass

    // Função para formatar saída de cálculos
    function automatic string format_calculation(
        input logic [7:0] a,              // Operando A
        input logic [7:0] b,              // Operando B
        input logic [3:0] op,             // Código da operação
        input logic [7:0] expected_result, // Resultado esperado
        input logic expected_carry        // Carry esperado
    );
        string op_symbol;    // Símbolo da operação
        string carry_info;   // Informação sobre carry
        
        // Define símbolo e info de carry baseado na operação
        case(op)
            4'b0000: begin // ADD
                op_symbol = "+";
                carry_info = expected_carry ? " (com carry)" : " (sem carry)";
            end
            4'b0001: begin // SUB 
                op_symbol = "-";
                carry_info = expected_carry ? " (com borrow)" : " (sem borrow)";
            end
            4'b0010: begin // MUL
                op_symbol = "*";
                carry_info = expected_carry ? " (com overflow)" : " (sem overflow)";
            end
            4'b0011: begin // DIV
                op_symbol = "/";
                carry_info = "";
            end
            default: begin // Operação inválida
                op_symbol = "?";
                carry_info = "";
            end
        endcase
        
        // Retorna string formatada
        return $sformatf("Cálculo: 0x%h %s 0x%h = 0x%h%s", 
                        a, op_symbol, b, expected_result, carry_info);
    endfunction
endpackage