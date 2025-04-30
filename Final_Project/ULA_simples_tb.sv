//-----------------------------------------------------------------------------
// Projeto: Testbench simples ULA
// Aluna: Jaqueline Ferreira de Brito
// Date: 23/02/2025
// Descrição: Testbench simples com testes determinísticos e aleatórios
//-----------------------------------------------------------------------------

// Definindo a escala de tempo para a simulação. O tempo de simulação será 1ns por unidade de tempo.
`timescale 1ns/1ps

module ULA_simples_tb;

    // Sinais do testbench
    logic        clock;          // Sinal de clock
    logic        reset;          // Sinal de reset
    logic [7:0]  A;              // Entrada A (8 bits)
    logic [7:0]  B;              // Entrada B (8 bits)
    logic [3:0]  ULA_Sel;        // Seletor de operação (4 bits)
    logic [7:0]  ULA_Out;        // Resultado da operação (8 bits)
    logic        CarryOut;       // Sinal de carry (indicativo de overflow ou carry)

    // Instanciação do DUT (Design Under Test - a ULA a ser testada)
    ULA dut (.*);  // Conecta automaticamente todas as entradas e saídas do DUT

    // Geração de clock
    initial begin
        clock = 0;                      // Inicializa o clock com valor 0
        forever #5 clock = ~clock;      // Alterna o clock a cada 5ns, com período de 10ns
    end

    // Task para aplicar estímulos e esperar resultado
    task automatic apply_test(
        input logic [7:0] in_a,       // Valor para a entrada A
        input logic [7:0] in_b,       // Valor para a entrada B
        input logic [3:0] op          // Operação a ser selecionada pelo ULA_Sel
    );
        @(posedge clock);              // Aplica os valores na borda positiva do clock
        A = in_a;                      // Atribui o valor a A
        B = in_b;                      // Atribui o valor a B
        ULA_Sel = op;                  // Atribui a operação ao seletor
        
        @(posedge clock);              // Espera um ciclo de clock para o resultado ser calculado
        #1;                            // Pequeno delay para estabilização do valor
    endtask

    // Processo de teste
    initial begin
        // Identificação do testbench
        $display("//----------------------------------------");
        $display("// Iniciando testbench ULA Simples");
        $display("// Data: 23/02/2025");
        $display("// Aluna: Jaqueline Ferreira de Brito");
        $display("//----------------------------------------\n");
        
        // Reset inicial
        reset = 1;                      // Ativa o reset
        A = 0;                          // Zera A
        B = 0;                          // Zera B
        ULA_Sel = 0;                    // Zera o seletor de operação
        repeat(2) @(posedge clock);     // Mantém o reset por 2 ciclos de clock
        reset = 0;                      // Desativa o reset
        @(posedge clock);               // Espera um ciclo após o reset
        
        // Testes de Adição
        $display("\n=== Testes de Adição ===");
        // Teste 1: Soma sem carry
        apply_test(8'h30, 8'h20, 4'b0000); // A = 0x30, B = 0x20, Operação de adição
        $display("ADD: %h + %h = %h (Carry=%b)", A, B, ULA_Out, CarryOut);

        // Teste 2: Soma com carry (overflow)
        apply_test(8'hFF, 8'h01, 4'b0000); // A = 0xFF, B = 0x01, Operação de adição com carry
        $display("ADD: %h + %h = %h (Carry=%b)", A, B, ULA_Out, CarryOut);

        // Testes de Subtração
        $display("\n=== Testes de Subtração ===");
        // Teste 1: Subtração simples (carry sempre 0)
        apply_test(8'h50, 8'h20, 4'b0001); // A = 0x50, B = 0x20, Operação de subtração
        $display("SUB: %h - %h = %h", A, B, ULA_Out);
        
        // Teste 2: Subtração com A = B
        apply_test(8'h30, 8'h30, 4'b0001); // A = 0x30, B = 0x30, Operação de subtração
        $display("SUB: %h - %h = %h", A, B, ULA_Out);

        // Testes de Multiplicação
        $display("\n=== Testes de Multiplicação ===");
        // Teste 1: Multiplicação simples
        apply_test(8'h04, 8'h03, 4'b0010); // A = 0x04, B = 0x03, Operação de multiplicação
        $display("MUL: %h * %h = %h", A, B, ULA_Out);
        
        // Teste 2: Multiplicação por zero
        apply_test(8'h10, 8'h00, 4'b0010); // A = 0x10, B = 0x00, Operação de multiplicação
        $display("MUL: %h * %h = %h", A, B, ULA_Out);

        // Testes de Divisão
        $display("\n=== Testes de Divisão ===");
        // Teste 1: Divisão exata
        apply_test(8'h20, 8'h04, 4'b0011); // A = 0x20, B = 0x04, Operação de divisão
        $display("DIV: %h / %h = %h", A, B, ULA_Out);
        
        // Teste 2: Divisão com resto
        apply_test(8'h0F, 8'h04, 4'b0011); // A = 0x0F, B = 0x04, Operação de divisão
        $display("DIV: %h / %h = %h", A, B, ULA_Out);

        // Testes Aleatórios
        $display("\n=== Testes Aleatórios ===");
        repeat(10) begin
            logic [7:0] temp_a, temp_b;
            logic [3:0] op;
            
            // Gera valores aleatórios para A, B e a operação
            temp_a = $urandom_range(1, 255); // Gera A entre 1 e 255
            temp_b = $urandom_range(1, temp_a); // Garante que B seja menor ou igual a A
            op = $urandom_range(0, 3);         // Gera uma operação aleatória (0 a 3)
            
            apply_test(temp_a, temp_b, op);    // Aplica os valores gerados
            
            // Exibe o resultado da operação aleatória
            case(op)
                4'b0000: $display("ADD Aleatório: %h + %h = %h (Carry=%b)", A, B, ULA_Out, CarryOut);
                4'b0001: $display("SUB Aleatório: %h - %h = %h", A, B, ULA_Out);
                4'b0010: $display("MUL Aleatório: %h * %h = %h", A, B, ULA_Out);
                4'b0011: $display("DIV Aleatório: %h / %h = %h", A, B, ULA_Out);
            endcase
        end
        
        // Fim dos testes
        $display("\n=== Fim dos Testes ===");
        $display("Testbench concluído em %0t", $time);
        repeat(2) @(posedge clock);       // Aguarda mais 2 ciclos antes de finalizar
        $finish;                          // Finaliza a simulação
    end
    
    // Verificações contínuas
    always @(posedge clock) begin
        // Verificações de consistência do comportamento da ALU
        if (!reset) begin
            assert(A >= B) else 
                $error("Violação: A deve ser maior ou igual a B (A=%h, B=%h)", A, B);
                
            assert(ULA_Sel inside {[0:3]}) else
                $error("Operação inválida detectada: %h", ULA_Sel);
                
            assert(!(ULA_Sel == 4'b0011 && B == 0)) else
                $error("Tentativa de divisão por zero");
        end
    end

endmodule
