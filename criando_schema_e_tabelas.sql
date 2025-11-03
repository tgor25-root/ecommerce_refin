-- --- SCRIPT DE CRIAÇÃO (DDL) PARA MYSQL ---
USE ecommerce_desafio;

-- 1. Tabela Cliente
CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    endereco VARCHAR(255),
    tipo_cliente ENUM('PF', 'PJ') NOT NULL, -- Mais_eficiente que CHAR no MySQL
    cpf CHAR(11) UNIQUE,
    cnpj CHAR(14) UNIQUE,
    -- Adicionando a restrição CHECK (Suportada no MySQL 8.0.16+)
    CONSTRAINT chk_tipo_cliente CHECK (
        (tipo_cliente = 'PF' AND cpf IS NOT NULL AND cnpj IS NULL) OR
        (tipo_cliente = 'PJ' AND cnpj IS NOT NULL AND cpf IS NULL)
    )
);

-- 2. Tabela Produto
CREATE TABLE Produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    categoria VARCHAR(100) NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL
);

-- 3. Tabela Pedido
CREATE TABLE Pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente_fk INT NOT NULL,
    data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_pedido VARCHAR(50) NOT NULL DEFAULT 'Em processamento',
    frete DECIMAL(10, 2) DEFAULT 0.00,
    status_entrega VARCHAR(50) DEFAULT 'Pendente',
    codigo_rastreio VARCHAR(100),
    FOREIGN KEY (id_cliente_fk) REFERENCES Cliente(id_cliente)
);

-- 4. Tabela Pagamento
CREATE TABLE Pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido_fk INT NOT NULL,
    forma_pagamento ENUM('Boleto', 'Cartão de Crédito', 'Pix', 'Dois Cartões') NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'Pendente',
    FOREIGN KEY (id_pedido_fk) REFERENCES Pedido(id_pedido)
);

-- 5. Tabela Estoque (Estoque próprio)
CREATE TABLE Estoque (
    id_estoque INT AUTO_INCREMENT PRIMARY KEY,
    id_produto_fk INT NOT NULL,
    localizacao VARCHAR(100),
    quantidade INT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_produto_fk) REFERENCES Produto(id_produto)
);

-- 6. Tabela Fornecedor
CREATE TABLE Fornecedor (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(255) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL,
    contato VARCHAR(100)
);

-- 7. Tabela Vendedor (Terceiros - Marketplace)
CREATE TABLE Vendedor (
    id_vendedor INT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(255) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL,
    localizacao VARCHAR(255)
);

-- --- Tabelas de Relacionamento N:M ---

-- 8. Tabela ItemPedido
CREATE TABLE ItemPedido (
    id_pedido_fk INT NOT NULL,
    id_produto_fk INT NOT NULL,
    quantidade INT NOT NULL,
    preco_na_data DECIMAL(10, 2) NOT NULL, -- Preço no momento da compra
    PRIMARY KEY (id_pedido_fk, id_produto_fk),
    FOREIGN KEY (id_pedido_fk) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_produto_fk) REFERENCES Produto(id_produto)
);

-- 9. Tabela Produto_Fornecedor
CREATE TABLE Produto_Fornecedor (
    id_produto_fk INT NOT NULL,
    id_fornecedor_fk INT NOT NULL,
    PRIMARY KEY (id_produto_fk, id_fornecedor_fk),
    FOREIGN KEY (id_produto_fk) REFERENCES Produto(id_produto),
    FOREIGN KEY (id_fornecedor_fk) REFERENCES Fornecedor(id_fornecedor)
);

-- 10. Tabela Produto_Vendedor
CREATE TABLE Produto_Vendedor (
    id_produto_fk INT NOT NULL,
    id_vendedor_fk INT NOT NULL,
    quantidade_estoque INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id_produto_fk, id_vendedor_fk),
    FOREIGN KEY (id_produto_fk) REFERENCES Produto(id_produto),
    FOREIGN KEY (id_vendedor_fk) REFERENCES Vendedor(id_vendedor)
);