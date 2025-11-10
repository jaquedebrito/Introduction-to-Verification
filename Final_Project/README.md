# Projeto Final - Verificação de ULA (ALU)
# Final Project - ULA (ALU) Verification

[Português](#português) | [English](#english)

---

## Português

### Visão Geral

Projeto final do curso de Introdução à Verificação, focado na verificação completa de uma **Unidade Lógica e Aritmética (ULA)** simples implementada em SystemVerilog.

**Autora:** Jaqueline Ferreira de Brito  
**Data:** 23/02/2025  
**Versão:** ALU 1.0

### Especificação da ULA

#### Características Principais

- **Tipo:** ULA síncrona com reset ativo alto
- **Latência:** 1 ciclo de clock
- **Entradas:**
  - `clock` - Sinal de clock
  - `reset` - Reset ativo alto
  - `A[7:0]` - Operando A (8 bits)
  - `B[7:0]` - Operando B (8 bits)
  - `ULA_Sel[3:0]` - Seletor de operação (4 bits)
- **Saídas:**
  - `ULA_Out[7:0]` - Resultado da operação (8 bits)
  - `CarryOut` - Sinal de carry

#### Operações Suportadas

| ULA_Sel | Operação | Descrição |
|---------|----------|-----------|
| 4'b0000 | ADD      | Adição (A + B) com carry |
| 4'b0001 | SUB      | Subtração (A - B) |
| 4'b0010 | MUL      | Multiplicação (A * B) |
| 4'b0011 | DIV      | Divisão (A / B), retorna '1 se B=0 |
| default | -        | Saída = 0 |

### Arquivos do Projeto

#### Design
- `ULA.sv` - Implementação da ULA em SystemVerilog

#### Testbenches
- `ULA_simples_tb.sv` - Testbench básico
- `ULA_self_checking_tb.sv` - Testbench auto-verificável
- `ULA_test_vectors_tb.sv` - Testbench baseado em vetores de teste

#### Pacotes e Utilitários
- `testbench_utils_pkg.sv` - Pacote de utilitários para testbench
- `ula_enhanced_pkg.sv` - Pacote com funcionalidades aprimoradas
- `ula_tb_pkg.sv` - Pacote principal do testbench

#### Vetores de Teste
- `ULA_vectors.txt` - Arquivo de vetores de teste
- `createvector.py` - Script Python para gerar vetores de teste

#### Especificações
- `Simple_Arithmetic_and_Logic_Unit_Spec_V1.pdf` - Especificação detalhada da ULA
- `CI_IntroducaoVerificacao_ProjetoFinal.pdf` - Descrição do projeto final
- `Projeto_Final_Introducao_Verificacao.pdf` - Documentação completa do projeto

### Estrutura de Verificação

O projeto implementa três níveis de verificação:

#### 1. Testbench Simples
- Geração básica de estímulos
- Observação visual de resultados
- Útil para depuração inicial

#### 2. Testbench Auto-Verificável (Self-Checking)
- Comparação automática de resultados
- Detecção de erros
- Relatório de passes/falhas

#### 3. Testbench Baseado em Vetores
- Leitura de vetores de arquivo externo
- Verificação sistemática
- Cobertura completa de casos de teste

### Funcionalidades Avançadas

Arquivos na pasta `/files/` incluem implementações aprimoradas:

- `enhanced_coverage.sv` - Análise de cobertura avançada
- `enhanced_error_struct.sv` - Estruturas para gerenciamento de erros
- `enhanced_result_check.sv` - Verificação aprimorada de resultados
- `enhanced_state_monitor.sv` - Monitoramento de estados
- `enhanced_timing_checks.sv` - Verificações de timing
- `ula_self_checking_enhanced_tb.sv` - Testbench auto-verificável aprimorado
- `ula_test_vectors_enhanced_tb.sv` - Testbench de vetores aprimorado
- `implementation_example.sv` - Exemplos de implementação

### Como Executar

#### Usando Cadence Xcelium

```bash
# Testbench simples
xrun -sv ULA.sv ULA_simples_tb.sv

# Testbench auto-verificável
xrun -sv ULA.sv ULA_self_checking_tb.sv

# Testbench com vetores de teste
xrun -sv ULA.sv ULA_test_vectors_tb.sv
```

#### Gerar Vetores de Teste

```bash
python3 createvector.py
```

### Conceitos de Verificação Demonstrados

1. **Testbenches Básicos**
   - Estrutura modular
   - Geração de clock
   - Geração de reset

2. **Self-Checking**
   - Comparação automática
   - Detecção de erros
   - Relatórios formatados

3. **Vetores de Teste**
   - Leitura de arquivo
   - Parsing de dados
   - Verificação sistemática

4. **Cobertura**
   - Cobertura funcional
   - Cobertura de código
   - Análise de cobertura

5. **Monitoramento**
   - Observação de estados
   - Verificação de timing
   - Análise de sinais

### Resultados

Os logs de simulação são salvos em:
- `xrun.log` - Log completo da simulação Xcelium

### Próximos Passos

Para expandir este projeto, considere:

1. Implementar mais operações lógicas (AND, OR, XOR, etc.)
2. Adicionar verificação de overflow
3. Implementar testbench UVM completo
4. Adicionar assertions SystemVerilog
5. Criar testes de corner cases
6. Implementar análise de cobertura formal

---

## English

### Overview

Final project for the Introduction to Verification course, focused on complete verification of a simple **Arithmetic and Logic Unit (ALU)** implemented in SystemVerilog.

**Author:** Jaqueline Ferreira de Brito  
**Date:** 23/02/2025  
**Version:** ALU 1.0

### ULA Specification

#### Main Features

- **Type:** Synchronous ALU with active-high reset
- **Latency:** 1 clock cycle
- **Inputs:**
  - `clock` - Clock signal
  - `reset` - Active-high reset
  - `A[7:0]` - Operand A (8 bits)
  - `B[7:0]` - Operand B (8 bits)
  - `ULA_Sel[3:0]` - Operation selector (4 bits)
- **Outputs:**
  - `ULA_Out[7:0]` - Operation result (8 bits)
  - `CarryOut` - Carry signal

#### Supported Operations

| ULA_Sel | Operation | Description |
|---------|-----------|-------------|
| 4'b0000 | ADD       | Addition (A + B) with carry |
| 4'b0001 | SUB       | Subtraction (A - B) |
| 4'b0010 | MUL       | Multiplication (A * B) |
| 4'b0011 | DIV       | Division (A / B), returns '1 if B=0 |
| default | -         | Output = 0 |

### Project Files

#### Design
- `ULA.sv` - ULA implementation in SystemVerilog

#### Testbenches
- `ULA_simples_tb.sv` - Basic testbench
- `ULA_self_checking_tb.sv` - Self-checking testbench
- `ULA_test_vectors_tb.sv` - Test vector-based testbench

#### Packages and Utilities
- `testbench_utils_pkg.sv` - Testbench utilities package
- `ula_enhanced_pkg.sv` - Enhanced functionalities package
- `ula_tb_pkg.sv` - Main testbench package

#### Test Vectors
- `ULA_vectors.txt` - Test vector file
- `createvector.py` - Python script to generate test vectors

#### Specifications
- `Simple_Arithmetic_and_Logic_Unit_Spec_V1.pdf` - Detailed ULA specification
- `CI_IntroducaoVerificacao_ProjetoFinal.pdf` - Final project description
- `Projeto_Final_Introducao_Verificacao.pdf` - Complete project documentation

### Verification Structure

The project implements three verification levels:

#### 1. Simple Testbench
- Basic stimulus generation
- Visual result observation
- Useful for initial debugging

#### 2. Self-Checking Testbench
- Automatic result comparison
- Error detection
- Pass/fail reporting

#### 3. Vector-Based Testbench
- External file vector reading
- Systematic verification
- Complete test case coverage

### Advanced Features

Files in the `/files/` folder include enhanced implementations:

- `enhanced_coverage.sv` - Advanced coverage analysis
- `enhanced_error_struct.sv` - Error management structures
- `enhanced_result_check.sv` - Enhanced result verification
- `enhanced_state_monitor.sv` - State monitoring
- `enhanced_timing_checks.sv` - Timing checks
- `ula_self_checking_enhanced_tb.sv` - Enhanced self-checking testbench
- `ula_test_vectors_enhanced_tb.sv` - Enhanced vector testbench
- `implementation_example.sv` - Implementation examples

### How to Run

#### Using Cadence Xcelium

```bash
# Simple testbench
xrun -sv ULA.sv ULA_simples_tb.sv

# Self-checking testbench
xrun -sv ULA.sv ULA_self_checking_tb.sv

# Test vector testbench
xrun -sv ULA.sv ULA_test_vectors_tb.sv
```

#### Generate Test Vectors

```bash
python3 createvector.py
```

### Demonstrated Verification Concepts

1. **Basic Testbenches**
   - Modular structure
   - Clock generation
   - Reset generation

2. **Self-Checking**
   - Automatic comparison
   - Error detection
   - Formatted reports

3. **Test Vectors**
   - File reading
   - Data parsing
   - Systematic verification

4. **Coverage**
   - Functional coverage
   - Code coverage
   - Coverage analysis

5. **Monitoring**
   - State observation
   - Timing verification
   - Signal analysis

### Results

Simulation logs are saved in:
- `xrun.log` - Complete Xcelium simulation log

### Next Steps

To expand this project, consider:

1. Implement more logical operations (AND, OR, XOR, etc.)
2. Add overflow verification
3. Implement complete UVM testbench
4. Add SystemVerilog assertions
5. Create corner case tests
6. Implement formal coverage analysis
