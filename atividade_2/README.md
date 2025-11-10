# Atividade 2 - Testbenches Auto-Verificáveis
# Activity 2 - Self-Checking Testbenches

[Português](#português) | [English](#english)

---

## Português

### Objetivo

Desenvolver testbenches auto-verificáveis (self-checking) em SystemVerilog, expandindo os conceitos da Atividade 1 com:
- Comparação automática de resultados
- Uso de asserções
- Múltiplas técnicas de verificação
- Testbenches mais robustos

### Exercícios

#### Exercício 1
**Descrição:** Testbench básico com geração de estímulos.
- Design com portas AND e OR (entradas negadas)
- Testbench gera estímulos para todas as combinações
- Observação de saída: 0 quando todas as entradas são 1
- **Status:** ✅ Sem erros na execução

#### Exercício 2
**Descrição:** Testbench auto-verificável.
- Mesmo design do Exercício 1
- Testbench compara automaticamente saída com resultado esperado
- Reporta erros quando saída não corresponde
- **Status:** ✅ Sem erros na execução

#### Exercício 3
**Descrição:** Verificação baseada em vetores de teste.
- Mesmo design base
- Usa registradores de 32 bits
- Testa array de vetores de 4 bits
- Verificação automática de cada vetor
- **Status:** ✅ Sem erros na execução

#### Exercício 4
**Descrição:** Exemplo com erro para demonstrar detecção.
- Design intencional com erro
- Operação esperada (OR) não corresponde à implementada
- Demonstra eficácia da verificação automática
- **Status:** ⚠️ Erro detectado corretamente (demonstração)

### Arquivos SystemVerilog

- `atividade_2.sv` - Design principal
- `exercicio.sv` - Implementação alternativa
- `exercicio_4.sv` - Design com erro intencional
- `exercicio_1_tb.sv` - Testbench básico
- `exercicio_2_tb.sv` - Testbench auto-verificável
- `exercicio_3_tb.sv` - Testbench com vetores
- `exercicio_4_tb.sv` - Testbench para detectar erro

### Documentação

- `Explicação` - Descrição detalhada de cada exercício
- `exercicio_*.png` - Capturas de tela dos resultados

### Como Executar

```bash
# Exercício 1
xrun -sv atividade_2.sv exercicio_1_tb.sv

# Exercício 2 (auto-verificável)
xrun -sv atividade_2.sv exercicio_2_tb.sv

# Exercício 3 (vetores de teste)
xrun -sv atividade_2.sv exercicio_3_tb.sv

# Exercício 4 (detecção de erro)
xrun -sv exercicio_4.sv exercicio_4_tb.sv
```

### Conceitos Aprendidos

1. Testbenches auto-verificáveis (self-checking)
2. Comparação automática de resultados
3. Reportagem de erros
4. Uso efetivo de vetores de teste
5. Diferentes padrões de estímulo
6. Detecção automática de falhas

### Diferenças da Atividade 1

- **Atividade 1:** Verificação manual/visual
- **Atividade 2:** Verificação automática com comparação de resultados
- **Atividade 2:** Reportagem clara de passes/falhas
- **Atividade 2:** Testbenches mais robustos e reutilizáveis

---

## English

### Objective

Develop self-checking testbenches in SystemVerilog, expanding Activity 1 concepts with:
- Automatic result comparison
- Use of assertions
- Multiple verification techniques
- More robust testbenches

### Exercises

#### Exercise 1
**Description:** Basic testbench with stimulus generation.
- Design with AND and OR gates (negated inputs)
- Testbench generates stimuli for all combinations
- Output observation: 0 when all inputs are 1
- **Status:** ✅ No execution errors

#### Exercise 2
**Description:** Self-checking testbench.
- Same design as Exercise 1
- Testbench automatically compares output with expected result
- Reports errors when output doesn't match
- **Status:** ✅ No execution errors

#### Exercise 3
**Description:** Test vector-based verification.
- Same base design
- Uses 32-bit registers
- Tests array of 4-bit vectors
- Automatic verification of each vector
- **Status:** ✅ No execution errors

#### Exercise 4
**Description:** Example with error to demonstrate detection.
- Intentional design error
- Expected operation (OR) doesn't match implementation
- Demonstrates effectiveness of automatic verification
- **Status:** ⚠️ Error correctly detected (demonstration)

### SystemVerilog Files

- `atividade_2.sv` - Main design
- `exercicio.sv` - Alternative implementation
- `exercicio_4.sv` - Design with intentional error
- `exercicio_1_tb.sv` - Basic testbench
- `exercicio_2_tb.sv` - Self-checking testbench
- `exercicio_3_tb.sv` - Test vector testbench
- `exercicio_4_tb.sv` - Error detection testbench

### Documentation

- `Explicação` - Detailed description of each exercise
- `exercicio_*.png` - Screenshots of results

### How to Run

```bash
# Exercise 1
xrun -sv atividade_2.sv exercicio_1_tb.sv

# Exercise 2 (self-checking)
xrun -sv atividade_2.sv exercicio_2_tb.sv

# Exercise 3 (test vectors)
xrun -sv atividade_2.sv exercicio_3_tb.sv

# Exercise 4 (error detection)
xrun -sv exercicio_4.sv exercicio_4_tb.sv
```

### Concepts Learned

1. Self-checking testbenches
2. Automatic result comparison
3. Error reporting
4. Effective use of test vectors
5. Different stimulus patterns
6. Automatic failure detection

### Differences from Activity 1

- **Activity 1:** Manual/visual verification
- **Activity 2:** Automatic verification with result comparison
- **Activity 2:** Clear pass/fail reporting
- **Activity 2:** More robust and reusable testbenches
