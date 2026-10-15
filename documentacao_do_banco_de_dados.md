# Documentação do Banco de Dados - TechStore

---

## 1. Domínio do Banco de Dados
**Domínio:** Comércio Eletrônico (E-commerce) de Eletrônicos e Acessórios — *TechStore*.

---

## 2. Contextualização
A **TechStore** é uma loja de médio porte que comercializa eletrônicos e periféricos. Sem um Sistema Gerenciador de Banco de Dados Relacional (SGBD), a empresa controlava suas operações através de planilhas eletrônicas descentralizadas e anotações manuais. 

### Problemas enfrentados sem o SGBD:
* **Redundância e Inconsistência:** Registros duplicados de clientes e produtos com preços ou cadastros divergentes entre departamentos.
* **Inexistência de Integridade Referencial:** Pedidos eram vinculados a produtos inexistentes no estoque ou a clientes excluídos acidentalmente.
* **Perda de Histórico:** Alterações de preços atualizavam o valor em vendas passadas, adulterando o histórico financeiro.
* **Problemas de Concorrência e Escala:** Múltiplos vendedores tentando atualizar o estoque simultaneamente geravam sobrescrita de dados (*race conditions*) e vendas sem estoque disponível.

---

## 3. A Proposta de Melhoria
Implementação de um **SGBD Relacional (MySQL / MariaDB / PostgreSQL)** para centralizar as operações.

### Benefícios da Solução:
* **Garantia de Propriedades ACID:** Transações seguras no fluxo de vendas e baixa de estoque.
* **Integridade Referencial (Chaves Estrangeiras):** Impedimento de vendas sem cliente ou produto cadastrado.
* **Controle de Estoque Rígido e Histórico:** Separação do valor atual do produto e do valor praticado no momento do item vendido.
* **Consultas Analíticas Performáticas:** Relatórios integrados sobre ticket médio, produtos mais vendidos e perfil de consumo dos clientes.

---

## 4. Modelagem Lógica do Banco de Dados

### Tabelas, Campos e Tipos

1. **`categoria`**
   * `id_categoria`: `INT` (PK, AUTO_INCREMENT)
   * `nome`: `VARCHAR(50)` (NOT NULL)
   * `descricao`: `VARCHAR(255)`

2. **`cliente`**
   * `id_cliente`: `INT` (PK, AUTO_INCREMENT)
   * `nome`: `VARCHAR(100)` (NOT NULL)
   * `cpf`: `VARCHAR(14)` (NOT NULL, UNIQUE)
   * `email`: `VARCHAR(100)` (NOT NULL, UNIQUE)
   * `data_cadastro`: `DATE` (NOT NULL)

3. **`telefone_cliente`**
   * `id_telefone`: `INT` (PK, AUTO_INCREMENT)
   * `id_cliente`: `INT` (FK -> `cliente.id_cliente`, NOT NULL)
   * `numero`: `VARCHAR(20)` (NOT NULL)

4. **`endereco_cliente`**
   * `id_endereco`: `INT` (PK, AUTO_INCREMENT)
   * `id_cliente`: `INT` (FK -> `cliente.id_cliente`, NOT NULL)
   * `logradouro`: `VARCHAR(150)` (NOT NULL)
   * `cidade`: `VARCHAR(50)` (NOT NULL)
   * `estado`: `CHAR(2)` (NOT NULL)
   * `cep`: `VARCHAR(9)` (NOT NULL)

5. **`produto`**
   * `id_produto`: `INT` (PK, AUTO_INCREMENT)
   * `id_categoria`: `INT` (FK -> `categoria.id_categoria`, NOT NULL)
   * `nome`: `VARCHAR(100)` (NOT NULL)
   * `preco_atual`: `DECIMAL(10,2)` (NOT NULL)
   * `quantidade_estoque`: `INT` (NOT NULL)

6. **`pedido`**
   * `id_pedido`: `INT` (PK, AUTO_INCREMENT)
   * `id_cliente`: `INT` (FK -> `cliente.id_cliente`, NOT NULL)
   * `data_pedido`: `DATETIME` (NOT NULL)
   * `status_pedido`: `VARCHAR(20)` (NOT NULL)

7. **`item_pedido`**
   * `id_pedido`: `INT` (PK composta, FK -> `pedido.id_pedido`, NOT NULL)
   * `id_produto`: `INT` (PK composta, FK -> `produto.id_produto`, NOT NULL)
   * `quantidade`: `INT` (NOT NULL)
   * `preco_unitario`: `DECIMAL(10,2)` (NOT NULL)

---

### Relacionamentos e Cardinalidades

* **`cliente` (1) —— (N) `telefone_cliente`**
  * Um cliente possui 1 ou mais telefones; um telefone pertence a exatamente 1 cliente.
* **`cliente` (1) —— (N) `endereco_cliente`**
  * Um cliente possui 1 ou mais endereços; um endereço pertence a exatamente 1 cliente.
* **`categoria` (1) —— (N) `produto`**
  * Uma categoria possui 0 ou mais produtos; um produto pertence a exatamente 1 categoria.
* **`cliente` (1) —— (N) `pedido`**
  * Um cliente pode fazer 0 ou mais pedidos; um pedido pertence a exatamente 1 cliente.
* **`pedido` (N) —— (M) `produto`**
  * Um pedido contém 1 ou mais produtos; um produto pode estar em 0 ou vários pedidos (resolvido via tabela associativa `item_pedido`).

---

## 5. Aplicação das Formas Normais (FN)

### 1ª Forma Normal (1FN)
* **Regra:** Eliminar atributos multivalorados, compostos e repetitivos. Todos os valores devem ser atômicos.
* **Aplicação:** Os atributos de contato e localização foram retirados da tabela principal do cliente. Foram criadas as tabelas `telefone_cliente` e `endereco_cliente`. O campo de endereço foi decomposto nos atributos atômicos: `logradouro`, `cidade`, `estado` e `cep`.

### 2ª Forma Normal (2FN)
* **Regra:** Estar na 1FN e garantir que todos os atributos não-chave dependam totalmente da chave primária (sem dependência parcial em chaves compostas).
* **Aplicação:** Na tabela associativa `item_pedido` (cuja chave primária é composta por `id_pedido` + `id_produto`), os atributos `quantidade` e `preco_unitario` dependem da combinação inteira da chave. Atributos próprios do produto, como `nome` e `preco_atual`, permanecem exclusivamente na tabela `produto`.

### 3ª Forma Normal (3FN)
* **Regra:** Estar na 2FN e garantir que nenhum atributo não-chave dependa de outro atributo não-chave (eliminação de dependências transitivas).
* **Aplicação:** Inicialmente, os dados da categoria do produto ficavam na tabela `produto` (`id_produto` -> `id_categoria` -> `nome_categoria`). Foi criada a tabela isolada `categoria` para eliminar essa dependência transitiva.

### 4ª Forma Normal (4FN)
* **Regra:** Estar na 3FN e não conter dependências multivaloradas independentes dentro da mesma entidade.
* **Aplicação:** Se armazenássemos múltiplos telefones e múltiplos endereços dentro da mesma tabela de cliente, seriam geradas combinações cartesianas redundantes e desnecessárias. O isolamento de `telefone_cliente` e `endereco_cliente` em tabelas separadas atende rigorosamente à 4FN.

---

# 6 Link do vercel

* https://projetobanco2.vercel.app/
