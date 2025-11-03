--Query 1 (Simples): Recuperar todos os produtos da categoria 'Informática'.

--Cláusulas: SELECT, WHERE.

SELECT nome, descricao, preco_unitario
FROM Produto
WHERE categoria = 'Informática';

------------------------------------------------------------------------------------
--Query 2 (Desafio): Quantos pedidos foram feitos por cada cliente?

--Cláusulas: SELECT, JOIN, GROUP BY, ORDER BY.

SELECT
    c.nome,
    COUNT(p.id_pedido) AS total_pedidos
FROM Cliente c
LEFT JOIN Pedido p ON c.id_cliente = p.id_cliente_fk
GROUP BY c.id_cliente
ORDER BY total_pedidos DESC;

-------------------------------------------------------------------------------------
--Query 3 (Desafio): Algum vendedor também é fornecedor?

--Cláusulas: SELECT, JOIN (INNER JOIN).

SELECT
    v.razao_social AS nome_vendedor,
    f.razao_social AS nome_fornecedor,
    v.cnpj
FROM Vendedor v
INNER JOIN Fornecedor f ON v.cnpj = f.cnpj;

--------------------------------------------------------------------------------------------------
--Query 4 (Desafio): Qual o valor total de cada pedido (somando os itens) e o nome do cliente?

--Cláusulas: SELECT, JOIN, GROUP BY, Atributo Derivado (SUM).

SELECT
    p.id_pedido,
    c.nome AS cliente,
    -- Atributo Derivado (Cálculo)
    SUM(ip.quantidade * ip.preco_na_data) AS valor_total_itens
FROM Pedido p
JOIN Cliente c ON p.id_cliente_fk = c.id_cliente
JOIN ItemPedido ip ON p.id_pedido = ip.id_pedido_fk
GROUP BY p.id_pedido, c.nome;

--------------------------------------------------------------------------------------------------
--Query 5 (Complexa): Quais clientes compraram mais de R$ 4.000,00 e tiveram o pagamento 'Aprovado'?

--Cláusulas: SELECT, JOIN (múltiplos), WHERE, GROUP BY, HAVING.

SELECT
    c.nome,
    SUM(pa.valor) AS total_gasto_aprovado
FROM Cliente c
JOIN Pedido p ON c.id_cliente = p.id_cliente_fk
JOIN Pagamento pa ON p.id_pedido = pa.id_pedido_fk
WHERE
    pa.status = 'Aprovado'
GROUP BY
    c.id_cliente, c.nome
HAVING -- Filtro PÓS-agrupamento
    SUM(pa.valor) > 4000;
	
------------------------------------------------------------------------------------------------------------------------
--Query 6 (Complexa): Mostrar o nome do produto e o nome do vendedor (terceiro) que o vende, ordenado por nome de produto.

--Cláusulas: SELECT, JOIN (múltiplos), ORDER BY.

SELECT
    p.nome AS produto,
    p.categoria,
    v.razao_social AS vendedor,
    pv.quantidade_estoque
FROM Produto p
JOIN Produto_Vendedor pv ON p.id_produto = pv.id_produto_fk
JOIN Vendedor v ON pv.id_vendedor_fk = v.id_vendedor
ORDER BY p.nome;
---------------------------------------------------------------------------------------------------------------------------
--Query 7 (Complexa): Listar todos os pedidos e, caso tenham sido pagos, mostrar a forma de pagamento.

--Cláusulas: SELECT, LEFT JOIN, ORDER BY.

SELECT
    p.id_pedido,
    p.data_pedido,
    p.status_pedido,
    c.nome AS cliente,
    -- Expressão para atributo derivado
    IF(pa.forma_pagamento IS NULL, 'Pagamento Pendente', pa.forma_pagamento) AS forma_pagamento
FROM Pedido p
JOIN Cliente c ON p.id_cliente_fk = c.id_cliente
LEFT JOIN Pagamento pa ON p.id_pedido = pa.id_pedido_fk
ORDER BY p.data_pedido DESC;