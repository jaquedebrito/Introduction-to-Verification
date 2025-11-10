# Atividade 3 - Técnicas Avançadas de Verificação
# Activity 3 - Advanced Verification Techniques

[Português](#português) | [English](#english)

---

## Português

### Objetivo

Explorar técnicas avançadas de verificação de sistemas digitais, incluindo:
- Métodos de verificação funcional
- Introdução a verificação formal
- Estratégias de verificação
- Planejamento de verificação

### Conteúdo

Esta atividade aborda os conceitos e estratégias fundamentais para verificação de sistemas digitais:

#### Métodos de Verificação

**Verificação Funcional:**
- Verificação baseada em simulação
- Checa se o modelo HDL atende aos requisitos da especificação
- Usa testbenches para validar comportamento
- Análise de cobertura
- Comparação entre implementação (DUV) e especificação

**Verificação Formal:**
- Representação matemática do problema
- Provadores de teorema
- Verificação por equivalência
- Trabalha com circuitos combinacionais e sequenciais
- Minimiza complexidade da verificação

#### Metodologias de Verificação

**Planos de Verificação:**
- Especificar o que será verificado
- Detalhar como será verificado
- Definir metodologia a ser trabalhada

**UVM (Universal Verification Methodology):**
- Aspecto de destaque na verificação moderna
- Reuso de componentes HDL
- Construção de elementos reutilizáveis
- Banco de testes reutilizáveis

#### Elementos do Testbench UVM

```
Hierarquia UVM:
├── Environment (env)
│   ├── Scoreboard
│   ├── Agent
│   │   ├── Monitor
│   │   ├── Sequencer
│   │   └── Driver
│   └── Interface
└── DUT (Design Under Test)
```

**Componentes principais:**
- **Environment (env):** Ambiente de verificação completo
- **Scoreboard:** Verifica correção dos resultados
- **Agent:** Agrupa driver, monitor e sequencer
- **Monitor:** Observa sinais do DUT
- **Sequencer:** Gerencia sequências de teste
- **Driver:** Aplica estímulos ao DUT
- **Interface:** Conecta testbench ao DUT
- **DUT:** Design Under Test (projeto sendo verificado)

### Arquivos

- `Ativididade_Introdução_Verificação.pdf` - Material didático principal
- `CI_IntroducaoVerificacao_AtividadePratica_03.pdf` - Especificação da atividade

### Tópicos Abordados

1. **Estratégias de Verificação**
   - Como escolher entre verificação funcional e formal
   - Quando usar cada método
   - Possibilidade de combinar ambas abordagens

2. **Verificação Funcional**
   - Implementação de testbenches
   - Análise de cobertura
   - Comparação de resultados

3. **Verificação Formal**
   - Provadores de teorema
   - Verificação por equivalência
   - Redução de complexidade

4. **UVM e Reuso**
   - Componentes reutilizáveis
   - Estrutura hierárquica
   - Melhores práticas

### Conceitos-Chave

- **DUV (Design Under Verification):** O design sendo verificado
- **Cobertura:** Medida de quanto do design foi testado
- **Reuso:** Capacidade de usar componentes em diferentes projetos
- **Metodologia:** Abordagem sistemática para verificação

---

## English

### Objective

Explore advanced digital system verification techniques, including:
- Functional verification methods
- Introduction to formal verification
- Verification strategies
- Verification planning

### Content

This activity covers fundamental concepts and strategies for digital system verification:

#### Verification Methods

**Functional Verification:**
- Simulation-based verification
- Checks if HDL model meets specification requirements
- Uses testbenches to validate behavior
- Coverage analysis
- Comparison between implementation (DUV) and specification

**Formal Verification:**
- Mathematical representation of the problem
- Theorem provers
- Equivalence checking
- Works with combinational and sequential circuits
- Minimizes verification complexity

#### Verification Methodologies

**Verification Plans:**
- Specify what will be verified
- Detail how it will be verified
- Define methodology to be used

**UVM (Universal Verification Methodology):**
- Highlight of modern verification
- Reuse of HDL components
- Construction of reusable elements
- Reusable test benches

#### UVM Testbench Elements

```
UVM Hierarchy:
├── Environment (env)
│   ├── Scoreboard
│   ├── Agent
│   │   ├── Monitor
│   │   ├── Sequencer
│   │   └── Driver
│   └── Interface
└── DUT (Design Under Test)
```

**Main Components:**
- **Environment (env):** Complete verification environment
- **Scoreboard:** Verifies result correctness
- **Agent:** Groups driver, monitor, and sequencer
- **Monitor:** Observes DUT signals
- **Sequencer:** Manages test sequences
- **Driver:** Applies stimuli to DUT
- **Interface:** Connects testbench to DUT
- **DUT:** Design Under Test

### Files

- `Ativididade_Introdução_Verificação.pdf` - Main educational material
- `CI_IntroducaoVerificacao_AtividadePratica_03.pdf` - Activity specification

### Topics Covered

1. **Verification Strategies**
   - How to choose between functional and formal verification
   - When to use each method
   - Possibility of combining both approaches

2. **Functional Verification**
   - Testbench implementation
   - Coverage analysis
   - Result comparison

3. **Formal Verification**
   - Theorem provers
   - Equivalence checking
   - Complexity reduction

4. **UVM and Reuse**
   - Reusable components
   - Hierarchical structure
   - Best practices

### Key Concepts

- **DUV (Design Under Verification):** The design being verified
- **Coverage:** Measure of how much of the design was tested
- **Reuse:** Ability to use components in different projects
- **Methodology:** Systematic approach to verification
