CREATE DATABASE vetcare_db;
\c vetcare_db; -- Comando do PostgreSQL para conectar (use `USE vetcare_db;` no MySQL)

-- Table: CLIENTE
CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    email VARCHAR(100)
);

-- Table: PET
CREATE TABLE pet (
    id_pet SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    especie VARCHAR(30) NOT NULL,
    raca VARCHAR(30),
    data_nascimento DATE,
    CONSTRAINT fk_pet_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

-- Table: VETERINARIO
CREATE TABLE veterinario (
    id_veterinario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    crmv VARCHAR(20) UNIQUE NOT NULL,
    especialidade VARCHAR(50)
);

-- Table: CONSULTA
CREATE TABLE consulta (
    id_consulta SERIAL PRIMARY KEY,
    id_pet INT NOT NULL,
    id_veterinario INT NOT NULL,
    data_consulta TIMESTAMP NOT NULL,
    diagnostico TEXT,
    valor DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_consulta_pet FOREIGN KEY (id_pet) REFERENCES pet(id_pet),
    CONSTRAINT fk_consulta_vet FOREIGN KEY (id_veterinario) REFERENCES veterinario(id_veterinario)
);

-- Table: MEDICAMENTO
CREATE TABLE medicamento (
    id_medicamento SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    dosagem_padrao VARCHAR(50)
);

-- Table: PRESCRICAO
CREATE TABLE prescricao (
    id_consulta INT NOT NULL,
    id_medicamento INT NOT NULL,
    posologia VARCHAR(200) NOT NULL,
    PRIMARY KEY (id_consulta, id_medicamento),
    CONSTRAINT fk_prescricao_consulta FOREIGN KEY (id_consulta) REFERENCES consulta(id_consulta) ON DELETE CASCADE,
    CONSTRAINT fk_prescricao_medicamento FOREIGN KEY (id_medicamento) REFERENCES medicamento(id_medicamento)
);

-- Table: PRODUTO
CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL
);

-- Table: VENDA
CREATE TABLE venda (
    id_venda SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_venda TIMESTAMP NOT NULL,
    valor_total DECIMAL(10,2) DEFAULT 0.00,
    CONSTRAINT fk_venda_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- Table: ITEM_VENDA
CREATE TABLE item_venda (
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_venda, id_produto),
    CONSTRAINT fk_item_venda_venda FOREIGN KEY (id_venda) REFERENCES venda(id_venda) ON DELETE CASCADE,
    CONSTRAINT fk_item_venda_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);