# Projeto de Banco de Dados: Clínica Veterinaria
## Parte 1: Concepção, Contextualização, Modelagem e Normalização

---

## 1. Domínio do Banco de Dados

**Domínio Escolhido:** Gestão de Clínica Veterinária e Petshop (*VetCare*).

---

## 2. Contextualização

### A Empresa
A **VetCare** é uma clínica veterinária integrada a um petshop de médio porte. Suas operações englobam atendimentos médicos, agendamento de consultas, aplicação de vacinas, venda de produtos e procedimentos estéticos (banho e tosa).

### Problemas Enfrentados sem um SGBD Relacional
* **Redundância e Inconsistência de Dados:** Cadastros de tutores e pets duplicados em papéis e planilhas desconectadas.
* **Perda de Histórico Médico:** Prontuários e vacinas aplicadas ficavam dispersos, dificultando diagnósticos precisos.
* **Falta de Integridade Referencial:** Vendas e agendamentos eram registrados para clientes ou veterinários inexistentes no sistema.
* **Concorrência e Acesso Simultâneo:** Edições simultâneas nas mesmas planilhas por recepcionistas e médicos geravam perda frequente de informações.
* **Dificuldade Analítica:** Impossibilidade de cruzar relatórios de faturamento, consultas por veterinário e controle de estoque em tempo real.

---

## 3. A Proposta de Melhoria — Solução com SGBD Relacional

A implantação de um **SGBD Relacional (PostgreSQL / MySQL)** visa centralizar e proteger a operação da clínica, garantindo:
* **Integridade de Dados:** Validação via Chaves Primárias (`PRIMARY KEY`) e Chaves Estrangeiras (`FOREIGN KEY`).
* **Concorrência Segura:** Controle transacional robusto (Propriedades ACID).
* **Histórico Único e Centralizado:** Acompanhamento completo da vida do pet (consultas, exames, prescrições e compras).
* **Escalabilidade e Desempenho:** Estrutura otimizada por meio da Normalização de Dados.

---

## 4. Modelagem Lógica do Banco de Dados

### Diagrama de Relacionamentos (Representação Lógica)

[CLIENTE] (1) ------ (0..N) [PET]
(1)                         (1)
|                           |
(0..N)                      (0..N)
[VENDA]                   [CONSULTA] (0..N) ---- (1) [VETERINARIO]
(1)                         (1)
|                           |
(1..N)                      (0..N)
[ITEM_VENDA]              [PRESCRICAO]
(N)                         (N)
|                           |
(1)                         (1)
[PRODUTO]                   [MEDICAMENTO]


## 4. Aplicação das Formas Normais

### 1ª Forma Normal (1FN) — Atomicidade e Eliminação de Repetições
* **Conceito:** Cada coluna deve conter valores atômicos (indivisíveis) e não deve haver listas/grupos repetidos na mesma célula.
* **Aplicação Prática:** Eliminou-se a prática de salvar múltiplos pets ou múltiplos telefones em um único campo concatenado. Os pets foram isolados na tabela `pet`, vinculados ao tutor via `id_cliente`.

### 2ª Forma Normal (2FN) — Dependência Funcional Total
* **Conceito:** Estar na 1FN e garantir que todo atributo não-chave dependa de **toda** a chave primária (aplicável a chaves compostas).
* **Aplicação Prática:** Nas tabelas com PK composta (`item_venda` e `prescricao`), os campos adicionais dependem da combinação dos dois IDs. Por exemplo, em `item_venda`, a `quantidade` depende do par (`id_venda`, `id_produto`), e não de apenas um deles.

### 3ª Forma Normal (3FN) — Eliminação de Dependências Transitivas
* **Conceito:** Estar na 2FN e garantir que nenhum atributo não-chave dependa de outro atributo não-chave.
* **Aplicação Prática:** Na tabela `consulta`, armazena-se apenas o `id_veterinario`. Atributos como `nome` ou `especialidade` do médico não ficam na tabela `consulta`, pois dependeriam do veterinário e não do ID da consulta.

### 4ª Forma Normal (4FN) — Eliminação de Dependências Multivaloradas Independentes
* **Conceito:** Estar na 3FN e não conter duas ou mais relações "muitos-para-muitos" independentes em uma mesma entidade.
* **Aplicação Prática:** Um veterinário pode ter múltiplas especialidades e atender em múltiplos horários. Para evitar combinações cartesianas e redundâncias, essas entidades seriam tratadas em tabelas independentes conectadas por chaves estrangeiras.
