//-----------------------------------------------------------------------------
// Projeto: Simple Arithmetic and Logic Unit (ALU 1.0)
// Aluna: Jaqueline Ferreira de Brito
// Data: 23/02/2025
// Descrição: ULA síncrona com reset ativo alto e latência de 1 ciclo
//-----------------------------------------------------------------------------

// Definindo a escala de tempo para a simulação. O tempo de simulação será 1ns por unidade de tempo.
`timescale 1ns/1ps

module ULA (
    input  logic        clock,      // Clock de entrada
    input  logic        reset,      // Reset ativo alto
    input  logic [7:0]  A,          // Entrada A (deve ser >= B)
    input  logic [7:0]  B,          // Entrada B
    input  logic [3:0]  ULA_Sel,    // Seletor de operação (4 bits para selecionar entre 16 operações possíveis)
    output logic [7:0]  ULA_Out,    // Resultado da operação
    output logic        CarryOut    // Sinal de carry, utilizado em operações como ADD
);

    // Declaração de variáveis internas para armazenar o próximo valor de resultado e carry
    logic [7:0] next_result;        // Próximo valor do resultado
    logic       next_carry;         // Próximo valor do carry

    // Lógica combinacional: avalia as operações com base no seletor ULA_Sel
    always_comb begin
        // Inicializa os valores de next_result e next_carry com os valores atuais de ULA_Out e CarryOut
        next_result = ULA_Out;      // Mantém o valor anterior de ULA_Out
        next_carry  = CarryOut;     // Mantém o valor anterior de CarryOut

        // Se reset não estiver ativo, realiza as operações
        if (!reset) begin
            // Seleção da operação baseada no código do seletor ULA_Sel
            case (ULA_Sel)
                4'b0000: begin      // Operação de adição (ADD)
                    {next_carry, next_result} = {1'b0, A} + {1'b0, B}; // Adiciona A e B, considerando o carry
                end
                4'b0001: begin      // Operação de subtração (SUB)
                    next_result = A - B;  // Subtrai B de A
                    next_carry  = 1'b0;   // Não há carry em uma subtração
                end
                4'b0010: begin      // Operação de multiplicação (MUL)
                    next_result = A * B;  // Multiplica A e B
                    next_carry  = 1'b0;   // Não há carry em uma multiplicação
                end
                4'b0011: begin      // Operação de divisão (DIV)
                    // Se B não for zero, realiza a divisão. Caso contrário, retorna '1' (indicando erro)
                    next_result = (B != '0) ? A / B : '1;
                    next_carry  = 1'b0;   // Não há carry em uma divisão
                end
                default: begin
                    next_result = '0;   // Caso padrão, resultado igual a zero
                    next_carry  = '0;   // Carry igual a zero
                end
            endcase
        end
    end

    // Registrador de saída: sincroniza os valores com o clock
    always_ff @(posedge clock) begin
        // Se reset estiver ativo, zera os valores de saída
        if (reset) begin
            ULA_Out  <= '0;     // Zera o resultado
            CarryOut <= '0;     // Zera o carry
        end else begin
            ULA_Out  <= next_result; // Atualiza o resultado com o valor calculado
            CarryOut <= next_carry;  // Atualiza o carry com o valor calculado
        end
    end

endmodule
