# Introduction to Verification
# Introdução à Verificação

[English](#english) | [Português](#português)

---

## English

### Overview

**Introduction to Verification** is a foundational course that focuses on the verification stage of digital systems design. The course highlights the critical role of verification in ensuring the functionality, reliability, and correctness of hardware before it reaches physical implementation and end users.

### Why Verification Matters

Verification is essential to prevent design errors that can lead to costly failures. Historical cases, such as the Mars Climate Orbiter and the Intel Pentium FDIV bug, show how small mistakes can result in financial loss, reputational damage, and even mission failure. These examples emphasize the importance of verifying every aspect of a system early and thoroughly.

### Course Purpose

The course aims to prepare students to understand and apply verification methods and tools in hardware design. It introduces the steps of the verification process, types of verification, and the use of SystemVerilog as a standard verification language.

### Repository Structure

```
Introduction-to-Verification/
├── atividade_1/          # Activity 1: Basic testbench concepts
├── atividade_2/          # Activity 2: Self-checking testbenches
├── atividade_3/          # Activity 3: Advanced verification techniques
├── Final_Project/        # Final Project: Complete ULA (ALU) verification
├── files/                # Enhanced verification utilities
└── aula_3                # Class 3 notes
```

### Key Topics Covered

- The role of verification in digital system design
- Functional vs. Formal verification methods
- SystemVerilog testbench design patterns
- Self-checking testbenches
- Test vector-based verification
- Coverage analysis
- UVM (Universal Verification Methodology) concepts
- How to plan and execute a complete verification flow
- Hands-on practice with professional EDA tools

### Activities

1. **Activity 1** - Introduction to basic testbench structures and stimulus generation
2. **Activity 2** - Self-checking testbenches with assertions
3. **Activity 3** - Advanced verification techniques
4. **Final Project** - Complete verification of a Simple Arithmetic and Logic Unit (ULA/ALU)

### Final Objective

To train students to identify, plan, and carry out the verification of digital systems, ensuring high-quality, low-risk designs ready for manufacturing or deployment.

### Technologies Used

- SystemVerilog
- Cadence Xcelium (or compatible simulators)
- Python (for test vector generation)

### Getting Started

Each activity folder contains:
- SystemVerilog design files (`.sv`)
- Testbench files (`_tb.sv`)
- Explanatory documentation
- PDF specifications

Refer to individual activity folders for specific instructions.

---

## Português

### Visão Geral

**Introdução à Verificação** é um curso fundamental que foca na etapa de verificação do projeto de sistemas digitais. O curso destaca o papel crítico da verificação para garantir a funcionalidade, confiabilidade e correção do hardware antes que ele alcance a implementação física e os usuários finais.

### Por Que a Verificação É Importante

A verificação é essencial para prevenir erros de projeto que podem levar a falhas custosas. Casos históricos, como o Mars Climate Orbiter e o bug FDIV do Intel Pentium, mostram como pequenos erros podem resultar em perda financeira, danos à reputação e até falha de missão. Esses exemplos enfatizam a importância de verificar cada aspecto de um sistema cedo e completamente.

### Propósito do Curso

O curso visa preparar os alunos para entender e aplicar métodos e ferramentas de verificação no projeto de hardware. Ele introduz as etapas do processo de verificação, tipos de verificação e o uso de SystemVerilog como linguagem padrão de verificação.

### Estrutura do Repositório

```
Introduction-to-Verification/
├── atividade_1/          # Atividade 1: Conceitos básicos de testbench
├── atividade_2/          # Atividade 2: Testbenches auto-verificáveis
├── atividade_3/          # Atividade 3: Técnicas avançadas de verificação
├── Final_Project/        # Projeto Final: Verificação completa de ULA
├── files/                # Utilitários de verificação aprimorados
└── aula_3                # Notas da Aula 3
```

### Tópicos Principais Abordados

- O papel da verificação no projeto de sistemas digitais
- Métodos de verificação funcional vs. formal
- Padrões de projeto de testbench em SystemVerilog
- Testbenches auto-verificáveis
- Verificação baseada em vetores de teste
- Análise de cobertura
- Conceitos de UVM (Universal Verification Methodology)
- Como planejar e executar um fluxo completo de verificação
- Prática com ferramentas profissionais de EDA

### Atividades

1. **Atividade 1** - Introdução às estruturas básicas de testbench e geração de estímulos
2. **Atividade 2** - Testbenches auto-verificáveis com asserções
3. **Atividade 3** - Técnicas avançadas de verificação
4. **Projeto Final** - Verificação completa de uma Unidade Lógica e Aritmética Simples (ULA)

### Objetivo Final

Treinar os alunos para identificar, planejar e executar a verificação de sistemas digitais, garantindo projetos de alta qualidade e baixo risco prontos para fabricação ou implantação.

### Tecnologias Utilizadas

- SystemVerilog
- Cadence Xcelium (ou simuladores compatíveis)
- Python (para geração de vetores de teste)

### Como Começar

Cada pasta de atividade contém:
- Arquivos de design em SystemVerilog (`.sv`)
- Arquivos de testbench (`_tb.sv`)
- Documentação explicativa
- Especificações em PDF

Consulte as pastas individuais de atividades para instruções específicas.

