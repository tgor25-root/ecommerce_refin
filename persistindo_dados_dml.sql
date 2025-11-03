-- --- SCRIPT DE INSERÇÃO (DML) PARA MYSQL ---
USE ecommerce_desafio;

-- Inserindo Clientes (1 PF, 1 PJ)
INSERT INTO Cliente (nome, email, telefone, endereco, tipo_cliente, cpf, cnpj) VALUES
('João Silva', 'joao.silva@email.com', '11988887777', 'Rua A, 123, São Paulo', 'PF', '11122233344', NULL),
('Tech Solutions Ltda', 'contato@techsolutions.com', '1144445555', 'Av. B, 456, São Paulo', 'PJ', NULL, '12345678000199'),
('Maria Oliveira', 'maria.o@email.com', '21977776666', 'Rua C, 789, Rio de Janeiro', 'PF', '55566677788', NULL);

-- Inserindo Produtos
INSERT INTO Produto (nome, descricao, categoria, preco_unitario) VALUES
('Notebook Gamer', 'Notebook com placa de vídeo dedicada', 'Informática', 4500.00),
('Smartphone Top de Linha', 'Smartphone com 256GB', 'Celulares', 3200.00),
('Cadeira de Escritório', 'Cadeira ergonômica', 'Móveis', 800.00),
('Monitor Ultrawide', 'Monitor 34 polegadas', 'Informática', 2200.00),
('Fone Bluetooth', 'Fone com cancelamento de ruído', 'Acessórios', 350.00);

-- Inserindo Fornecedores
INSERT INTO Fornecedor (razao_social, cnpj, contato) VALUES
('Eletrônicos Brasil S.A.', '11111111000111', 'comercial@eletronicosbr.com'),
('Móveis Conforto Ltda', '22222222000122', 'vendas@moveisconforto.com');

-- Inserindo Vendedores (Marketplace)
INSERT INTO Vendedor (razao_social, cnpj, localizacao) VALUES
('Tech Imports', '33333333000133', 'Curitiba, PR'),
('Casa & Cia', '44444444000144', 'Belo Horizonte, MG'),
('Eletrônicos Brasil S.A.', '11111111000111', 'São Paulo, SP'); -- Mesmo CNPJ do Fornecedor

-- Relação Produto_Fornecedor
INSERT INTO Produto_Fornecedor (id_produto_fk, id_fornecedor_fk) VALUES
(1, 1), (2, 1), (3, 2);

-- Relação Produto_Vendedor
INSERT INTO Produto_Vendedor (id_produto_fk, id_vendedor_fk, quantidade_estoque) VALUES
(1, 1, 10), (4, 1, 5), (3, 2, 50), (5, 3, 100);

-- Inserindo Pedidos
INSERT INTO Pedido (id_cliente_fk, data_pedido, status_pedido, frete, status_entrega, codigo_rastreio) VALUES
(1, '2025-10-28 10:30:00', 'Enviado', 25.50, 'Em trânsito', 'BR123456789PY'),
(2, '2025-10-29 14:12:00', 'Em processamento', 0.00, 'Pendente', NULL),
(1, '2025-10-30 08:45:00', 'Pago', 15.00, 'Aguardando Envio', NULL),
(3, '2025-10-30 11:05:00', 'Em processamento', 30.00, 'Pendente', NULL);

-- Inserindo Itens dos Pedidos
INSERT INTO ItemPedido (id_pedido_fk, id_produto_fk, quantidade, preco_na_data) VALUES
(1, 1, 1, 4500.00), -- Pedido 1: 1x Notebook
(2, 3, 2, 800.00),  -- Pedido 2: 2x Cadeira
(2, 4, 1, 2200.00), -- Pedido 2: 1x Monitor
(3, 2, 1, 3200.00), -- Pedido 3: 1x Smartphone
(3, 5, 2, 350.00);  -- Pedido 3: 2x Fone Bluetooth

-- Inserindo Pagamentos (Pedido 2 com pagamento dividido)
INSERT INTO Pagamento (id_pedido_fk, forma_pagamento, valor, status) VALUES
(1, 'Cartão de Crédito', 4525.50, 'Aprovado'),
(2, 'Pix', 1000.00, 'Aprovado'),
(2, 'Boleto', 2800.00, 'Aprovado'), -- (2*800 + 2200) = 3800
(3, 'Cartão de Crédito', 3915.00, 'Aprovado'), -- (3200 + 2*350 + 15 frete)
(4, 'Boleto', 0.00, 'Pendente'); -- Pedido ainda não pago