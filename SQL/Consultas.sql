
USE techstore_db;

-- ----------------------------------------------------------------------------
-- CONSULTA 1: Listar produtos e suas respectivas categorias
-- Pergunta: Quais são os produtos cadastrados com o nome de suas categorias?
-- Resposta Esperada: Retorna os 6 produtos com os nomes de suas categorias.
-- ----------------------------------------------------------------------------
SELECT 
    p.nome AS produto, 
    c.nome AS categoria, 
    p.preco_atual
FROM produto p
INNER JOIN categoria c ON p.id_categoria = c.id_categoria;


-- ----------------------------------------------------------------------------
-- CONSULTA 2: Filtro por padrão de texto no nome do cliente (LIKE)
-- Pergunta: Quais clientes possuem a letra 'a' em seu nome?
-- Resposta Esperada: Ana Silva, Carla Souza, Daniel Alves e Eduarda Lima.
-- ----------------------------------------------------------------------------
SELECT * 
FROM cliente 
WHERE nome LIKE '%a%';


-- ----------------------------------------------------------------------------
-- CONSULTA 3: Pedidos realizados em um intervalo de datas (BETWEEN)
-- Pergunta: Quais pedidos foram efetuados na primeira semana de março de 2025?
-- Resposta Esperada: Pedidos com ID 1, 2 e 3.
-- ----------------------------------------------------------------------------
SELECT * 
FROM pedido 
WHERE data_pedido BETWEEN '2025-03-01 00:00:00' AND '2025-03-07 23:59:59';


-- ----------------------------------------------------------------------------
-- CONSULTA 4: Total faturado por pedido (SUM e GROUP BY)
-- Pergunta: Qual é o valor total faturado por cada pedido?
-- Resposta Esperada:
--   Pedido 1: R$ 550.00
--   Pedido 2: R$ 1200.00
--   Pedido 3: R$ 700.00
--   Pedido 4: R$ 600.00
--   Pedido 5: R$ 2300.00
-- ----------------------------------------------------------------------------
SELECT 
    id_pedido, 
    SUM(quantidade * preco_unitario) AS total_pedido
FROM item_pedido
GROUP BY id_pedido;


-- ----------------------------------------------------------------------------
-- CONSULTA 5: Ordenação de produtos do mais caro para o mais barato (ORDER BY)
-- Pergunta: Quais são os produtos da loja ordenados pelo preço decrescente?
-- Resposta Esperada: RTX 4060 (2300.00), Monitor 27 (1200.00), SSD (450.00),
--                    Headset (350.00), Teclado (250.00), Mouse (150.00).
-- ----------------------------------------------------------------------------
SELECT 
    nome, 
    preco_atual 
FROM produto 
ORDER BY preco_atual DESC;


-- ----------------------------------------------------------------------------
-- CONSULTA 6: Produtos com nível de estoque baixo (WHERE)
-- Pergunta: Quais produtos possuem menos de 15 unidades em estoque?
-- Resposta Esperada: Monitor 27 (12 unidades) e Placa de Vídeo RTX 4060 (5 unidades).
-- ----------------------------------------------------------------------------
SELECT 
    nome, 
    quantidade_estoque 
FROM produto 
WHERE quantidade_estoque < 15;


-- ----------------------------------------------------------------------------
-- CONSULTA 7: Detalhamento de compras de pedidos entregues (INNER JOIN múltiplos)
-- Pergunta: Qual o nome do cliente, data do pedido, produto e quantidade dos pedidos entregues?
-- Resposta Esperada: Detalhes dos itens comprados por Ana Silva (Pedido 1) e Bruno Costa (Pedido 2).
-- ----------------------------------------------------------------------------
SELECT 
    c.nome AS cliente, 
    p.data_pedido, 
    pr.nome AS produto, 
    ip.quantidade
FROM pedido p
INNER JOIN cliente c ON p.id_cliente = c.id_cliente
INNER JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
INNER JOIN produto pr ON ip.id_produto = pr.id_produto
WHERE p.status_pedido = 'Entregue';


-- ----------------------------------------------------------------------------
-- CONSULTA 8: Contagem de produtos por categoria (COUNT e GROUP BY)
-- Pergunta: Quantos produtos existem cadastrados em cada categoria?
-- Resposta Esperada: Periféricos (2), Monitores (1), Hardware (1), Áudio (1), Armazenamento (1).
-- ----------------------------------------------------------------------------
SELECT 
    c.nome AS categoria, 
    COUNT(p.id_produto) AS total_produtos
FROM categoria c
LEFT JOIN produto p ON c.id_categoria = p.id_categoria
GROUP BY c.id_categoria, c.nome;


-- ----------------------------------------------------------------------------
-- CONSULTA 9: Média de preço do catálogo (AVG e ROUND)
-- Pergunta: Qual é o preço médio dos produtos vendidos no site?
-- Resposta Esperada: R$ 783.33.
-- ----------------------------------------------------------------------------
SELECT 
    ROUND(AVG(preco_atual), 2) AS media_preco_catálogo 
FROM produto;


-- ----------------------------------------------------------------------------
-- CONSULTA 10: Clientes de estados específicos (IN)
-- Pergunta: Quais clientes moram na região Sudeste (SP, RJ ou MG)?
-- Resposta Esperada: Ana Silva (SP), Bruno Costa (RJ) e Carla Souza (MG).
-- ----------------------------------------------------------------------------
SELECT 
    c.nome, 
    e.estado, 
    e.cidade 
FROM cliente c
INNER JOIN endereco_cliente e ON c.id_cliente = e.id_cliente
WHERE e.estado IN ('SP', 'RJ', 'MG');


-- ----------------------------------------------------------------------------
-- CONSULTA 11: Clientes de alto valor com filtro no agrupamento (HAVING)
-- Pergunta: Quais clientes acumularam compras de valor superior a R$ 500,00 na loja?
-- Resposta Esperada: Ana Silva (R$ 1150.00), Bruno Costa (R$ 1200.00) e Daniel Alves (R$ 2300.00).
-- ----------------------------------------------------------------------------
SELECT 
    c.nome, 
    SUM(ip.quantidade * ip.preco_unitario) AS total_gasto
FROM cliente c
INNER JOIN pedido p ON c.id_cliente = p.id_cliente
INNER JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
GROUP BY c.id_cliente, c.nome
HAVING total_gasto > 500.00;


-- ----------------------------------------------------------------------------
-- CONSULTA 12: Listar todos os telefones de um determinado cliente
-- Pergunta: Quais são os telefones cadastrados para a cliente "Ana Silva"?
-- Resposta Esperada: (11) 98888-1111 e (11) 3333-1111.
-- ----------------------------------------------------------------------------
SELECT 
    c.nome, 
    t.numero 
FROM cliente c
INNER JOIN telefone_cliente t ON c.id_cliente = t.id_cliente
WHERE c.nome = 'Ana Silva';


-- ----------------------------------------------------------------------------
-- CONSULTA 13: Identificação do produto de maior valor (MAX)
-- Pergunta: Qual o valor do produto mais caro da loja?
-- Resposta Esperada: R$ 2300.00.
-- ----------------------------------------------------------------------------
SELECT 
    MAX(preco_atual) AS produto_mais_caro 
FROM produto;


-- ----------------------------------------------------------------------------
-- CONSULTA 14: Verificação de produtos sem histórico de vendas (LEFT JOIN e IS NULL)
-- Pergunta: Existe algum produto cadastrado que nunca foi comprado?
-- Resposta Esperada: Nenhum registro (pois todos os produtos foram incluídos em ao menos um pedido).
-- ----------------------------------------------------------------------------
SELECT 
    p.nome 
FROM produto p
LEFT JOIN item_pedido ip ON p.id_produto = ip.id_produto
WHERE ip.id_produto IS NULL;


-- ----------------------------------------------------------------------------
-- CONSULTA 15: Pedidos em andamento ou cancelados (OR)
-- Pergunta: Quais pedidos estão nas situações "Processando" ou "Cancelado"?
-- Resposta Esperada: Pedido ID 3 (Processando) e Pedido ID 5 (Cancelado).
-- ----------------------------------------------------------------------------
SELECT 
    id_pedido, 
    status_pedido 
FROM pedido 
WHERE status_pedido = 'Processando' OR status_pedido = 'Cancelado';