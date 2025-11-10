# Atividade 1 - Conceitos Básicos de Testbench
# Activity 1 - Basic Testbench Concepts

[Português](#português) | [English](#english)

---

## Português

### Objetivo

Introduzir os conceitos fundamentais de testbench em SystemVerilog, incluindo:
- Estrutura básica de um testbench
- Geração de estímulos
- Observação de resultados
- Diferentes técnicas de verificação

### Exercícios

#### Exercício 1
**Descrição:** Implementação básica com portas lógicas AND e OR.
- Design com duas portas AND (com entradas negadas) e uma porta OR
- Testbench gera estímulos testando todas as combinações possíveis
- Saída é 0 apenas quando todas as entradas são 1
- **Status:** ✅ Sem erros na execução

#### Exercício 2
**Descrição:** Mesmo design do Exercício 1, mas com verificação de saída.
- Testbench compara a saída com o resultado esperado
- Introduz conceito de self-checking testbench
- **Status:** ✅ Sem erros na execução

#### Exercício 3
**Descrição:** Verificação usando vetores de teste.
- Mesmo design do Exercício 1
- Testbench utiliza array de vetores de teste (registradores de 32 bits)
- Testa vetores de 4 bits
- **Status:** ✅ Sem erros na execução

#### Exercício 4
**Descrição:** Exercício com erro intencional para demonstrar verificação.
- Resultado esperado falha
- Operação esperada seria OR, mas a executada não corresponde
- Demonstra a importância de verificação adequada
- **Status:** ⚠️ Falha esperada (erro intencional para aprendizado)

### Arquivos

- `CI_IntroducaoVerificacao_AtividadePratica_01.pdf` - Especificação da atividade
- `Explicação` - Notas sobre cada exercício
- `exercicio_*.png` - Capturas de tela dos resultados

### Como Executar

```bash
# Exemplo usando Cadence Xcelium
xrun -sv exercicio_1.sv exercicio_1_tb.sv

# Ou usando outro simulador compatível
# modelsim/vsim -sv exercicio_1.sv exercicio_1_tb.sv
```

### Conceitos Aprendidos

1. Estrutura básica de um módulo testbench
2. Geração de estímulos sequenciais
3. Verificação manual vs. automática
4. Uso de vetores de teste
5. Identificação de erros através de verificação

---

## English

### Objective

Introduce fundamental SystemVerilog testbench concepts, including:
- Basic testbench structure
- Stimulus generation
- Result observation
- Different verification techniques

### Exercises

#### Exercise 1
**Description:** Basic implementation with AND and OR logic gates.
- Design with two AND gates (with negated inputs) and one OR gate
- Testbench generates stimuli testing all possible combinations
- Output is 0 only when all inputs are 1
- **Status:** ✅ No execution errors

#### Exercise 2
**Description:** Same design as Exercise 1, but with output verification.
- Testbench compares output with expected result
- Introduces self-checking testbench concept
- **Status:** ✅ No execution errors

#### Exercise 3
**Description:** Verification using test vectors.
- Same design as Exercise 1
- Testbench uses array of test vectors (32-bit registers)
- Tests 4-bit vectors
- **Status:** ✅ No execution errors

#### Exercise 4
**Description:** Exercise with intentional error to demonstrate verification.
- Expected result fails
- Expected operation would be OR, but executed one doesn't match
- Demonstrates importance of proper verification
- **Status:** ⚠️ Expected failure (intentional error for learning)

### Files

- `CI_IntroducaoVerificacao_AtividadePratica_01.pdf` - Activity specification
- `Explicação` - Notes about each exercise
- `exercicio_*.png` - Screenshots of results

### How to Run

```bash
# Example using Cadence Xcelium
xrun -sv exercicio_1.sv exercicio_1_tb.sv

# Or using another compatible simulator
# modelsim/vsim -sv exercicio_1.sv exercicio_1_tb.sv
```

### Concepts Learned

1. Basic testbench module structure
2. Sequential stimulus generation
3. Manual vs. automatic verification
4. Use of test vectors
5. Error identification through verification
