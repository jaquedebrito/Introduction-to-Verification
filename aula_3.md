# Aula 3 - Estratégias e Metodologias de Verificação
# Lesson 3 - Verification Strategies and Methodologies

[Português](#português) | [English](#english)

---

## Português

### Equipes de Verificação

- Tratar de forma separada as equipes de design e verificação
- Independência entre desenvolvimento e verificação

### Estratégias e Métodos

**Questões fundamentais:**
- Qual estratégia/método deve ser utilizada?
- Verificação Funcional ou Formal?
- Qual a diferença desses métodos?
- É possível decidir utilizar as duas?

### Verificação Formal

**Características:**
- Representação matemática do problema
- Minimizar a complexidade da verificação
- Provadores de teorema
- Abordagem por equivalência
- Trabalha com aspectos de circuitos combinacionais ou sequenciais

**Vantagens:**
- Prova matemática de correção
- Exaustiva por natureza
- Identifica todos os casos possíveis

### Verificação Funcional

**Objetivo:**
- Checar se o modelo elaborado em HDL atende aos requisitos da especificação

**Metodologias para verificação funcional:**

1. **Implementar o testbench**
   - Verifica se o que foi implementado (o design) está correto
   
2. **Análise de cobertura**
   - Compara a implementação do DUV (Design Under Verification)
   - Verifica se as saídas correspondem ao esperado

### Planos de Verificação

**Etapas:**
1. Especificar o que será verificado
2. Detalhar como será verificado
3. Definir o que e como será verificado
4. Definir a metodologia a ser trabalhada

### UVM (Universal Verification Methodology)

**Aspecto de destaque:**
- Reuso de componentes HDL
- Construção dos elementos que compõem a metodologia UVM
- Banco de testes que são reutilizáveis

### Elementos que Compõem o Testbench

**Hierarquia UVM:**

```
Testbench
├── Environment (env)
│   ├── Scoreboard
│   ├── Agent
│   │   ├── Monitor
│   │   ├── Sequencer
│   │   └── Driver
│   └── Interface
└── DUT (Design Under Test)
```

**Componentes:**
- **Environment (env)** - Ambiente de verificação completo
- **Scoreboard** - Verifica correção dos resultados
- **Agent** - Agrupa componentes relacionados
- **Monitor** - Observa sinais do DUT
- **Sequencer** - Gerencia sequências de teste
- **Driver** - Aplica estímulos ao DUT
- **Interface** - Conecta testbench ao DUT
- **DUT** - Design Under Test (design sendo testado)

---

## English

### Verification Teams

- Treat design and verification teams separately
- Independence between development and verification

### Strategies and Methods

**Fundamental questions:**
- Which strategy/method should be used?
- Functional or Formal verification?
- What is the difference between these methods?
- Is it possible to use both?

### Formal Verification

**Characteristics:**
- Mathematical representation of the problem
- Minimize verification complexity
- Theorem provers
- Equivalence checking approach
- Works with combinational or sequential circuit aspects

**Advantages:**
- Mathematical proof of correctness
- Exhaustive by nature
- Identifies all possible cases

### Functional Verification

**Objective:**
- Check if the HDL model meets specification requirements

**Methodologies for functional verification:**

1. **Implement the testbench**
   - Verifies if what was implemented (the design) is correct
   
2. **Coverage analysis**
   - Compares the DUV (Design Under Verification) implementation
   - Verifies if outputs match expected results

### Verification Plans

**Steps:**
1. Specify what will be verified
2. Detail how it will be verified
3. Define what and how will be verified
4. Define the methodology to be used

### UVM (Universal Verification Methodology)

**Highlight aspect:**
- HDL component reuse
- Construction of elements that compose UVM methodology
- Reusable test benches

### Elements that Compose the Testbench

**UVM Hierarchy:**

```
Testbench
├── Environment (env)
│   ├── Scoreboard
│   ├── Agent
│   │   ├── Monitor
│   │   ├── Sequencer
│   │   └── Driver
│   └── Interface
└── DUT (Design Under Test)
```

**Components:**
- **Environment (env)** - Complete verification environment
- **Scoreboard** - Verifies result correctness
- **Agent** - Groups related components
- **Monitor** - Observes DUT signals
- **Sequencer** - Manages test sequences
- **Driver** - Applies stimuli to DUT
- **Interface** - Connects testbench to DUT
- **DUT** - Design Under Test
