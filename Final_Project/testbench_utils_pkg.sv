//-----------------------------------------------------------------------------
// Projeto: Pacote de Utilitários para Testbench
// Aluna: Jaqueline Ferreira de Brito
// Data: 23/02/2025
// Descrição: Pacote com estruturas e classes para gerenciamento de testes
//-----------------------------------------------------------------------------

// Previne inclusão múltipla do pacote
`ifndef TESTBENCH_UTILS_PKG
`define TESTBENCH_UTILS_PKG

package testbench_utils_pkg;
    // Estrutura para armazenar informações de cada teste executado
    typedef struct {
        string test_name;      // Nome identificador do teste
        string calculation;    // Descrição do cálculo realizado
        logic success;         // Indica se o teste passou (1) ou falhou (0)
        time execution_time;   // Tempo de execução do teste
        string expected_value; // Valor esperado do teste
        string actual_value;   // Valor obtido do teste
        string notes;          // Observações adicionais sobre o teste
    } test_result_t;

    // Classe para gerenciar execução e resultados dos testes
    class TestManager;
        test_result_t results[$];  // Queue dinâmica para armazenar resultados
        string timestamp;          // Data/hora da execução
        string user;              // Usuário executando os testes
        int total_tests;          // Contador total de testes
        int passed_tests;         // Contador de testes bem sucedidos
        int failed_tests;         // Contador de testes falhos
        
        // Construtor - inicializa dados básicos do gerenciador
        function new(string timestamp, string user);
            this.timestamp = timestamp;    // Registra timestamp
            this.user = user;             // Registra usuário
            this.total_tests = 0;         // Zera contador total
            this.passed_tests = 0;        // Zera contador de sucessos
            this.failed_tests = 0;        // Zera contador de falhas
        endfunction
        
        // Adiciona um novo resultado de teste
        function void add_result(
            string test_name,     // Nome do teste
            string calculation,   // Descrição do cálculo
            logic success,        // Status do teste
            time exec_time,       // Tempo de execução
            string expected,      // Resultado esperado
            string actual,        // Resultado obtido
            string notes = ""     // Notas opcionais
        );
            test_result_t result;            // Cria nova estrutura de resultado
            result.test_name = test_name;    // Preenche nome
            result.calculation = calculation; // Preenche cálculo
            result.success = success;         // Preenche status
            result.execution_time = exec_time;// Preenche tempo
            result.expected_value = expected; // Preenche valor esperado
            result.actual_value = actual;     // Preenche valor obtido
            result.notes = notes;            // Preenche notas
            
            results.push_back(result);       // Adiciona à queue
            total_tests++;                   // Incrementa total
            if (success) passed_tests++;     // Incrementa passes se sucesso
            else failed_tests++;             // Incrementa falhas se erro
        endfunction
        
        // Gera relatório completo dos testes
        function void print_report();
            // Cabeçalho do relatório
            $display("\n=== Relatório de Testes ===");
            $display("Data/Hora: %s", timestamp);
            $display("Usuário: %s", user);
            $display("Total de testes: %0d", total_tests);
            $display("Testes passou: %0d", passed_tests);
            $display("Testes falhou: %0d", failed_tests);
            $display("\nResultados detalhados:");
            
            // Itera sobre todos os resultados
            foreach (results[i]) begin
                $display("\nTeste %0d: %s", i, results[i].test_name);
                $display("Cálculo: %s", results[i].calculation);
                $display("Status: %s", results[i].success ? "PASSOU" : "FALHOU");
                $display("Tempo: %0t", results[i].execution_time);
                // Mostra detalhes adicionais em caso de falha
                if (!results[i].success) begin
                    $display("Esperado: %s", results[i].expected_value);
                    $display("Obtido: %s", results[i].actual_value);
                end
                // Mostra notas se existirem
                if (results[i].notes != "")
                    $display("Notas: %s", results[i].notes);
            end
        endfunction
    endclass
endpackage

`endif