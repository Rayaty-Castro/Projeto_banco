-- ==============================================================================
-- CONSULTA UNIFICADA: PAINEL GERAL DE RELATÓRIOS E ANÁLISES (15 EM 1)
-- ==============================================================================

WITH 
-- Consulta 1: Tutores e seus Pets
c1_tutores_pets AS (
    SELECT 
        '1. Tutores e Pets' AS relatorio,
        c.nome || ' (Tutor de: ' || p.nome || ' - ' || p.especie || ' ' || COALESCE(p.raca, '') || ')' AS detalhe,
        NULL::NUMERIC AS valor_metrica
    FROM cliente c
    INNER JOIN pet p ON c.id_cliente = p.id_cliente
),

-- Consulta 2: Atendimentos por especialistas em Felinos
c2_consultas_felinos AS (
    SELECT 
        '2. Atendimento Felinos' AS relatorio,
        'Pet: ' || p.nome || ' | Vet: ' || v.nome || ' | Diag: ' || con.diagnostico AS detalhe,
        con.valor AS valor_metrica
    FROM consulta con
    INNER JOIN pet p ON con.id_pet = p.id_pet
    INNER JOIN veterinario v ON con.id_veterinario = v.id_veterinario
    WHERE v.especialidade = 'Felinos'
),

-- Consulta 3: Prescrições da Consulta ID 3
c3_prescricoes_c3 AS (
    SELECT 
        '3. Prescrição da Consulta 3' AS relatorio,
        'Pet: ' || p.nome || ' | Remédio: ' || m.nome || ' | Posologia: ' || pr.posologia AS detalhe,
        NULL::NUMERIC AS valor_metrica
    FROM prescricao pr
    INNER JOIN consulta c ON pr.id_consulta = c.id_consulta
    INNER JOIN pet p ON c.id_pet = p.id_pet
    INNER JOIN medicamento m ON pr.id_medicamento = m.id_medicamento
    WHERE c.id_consulta = 3
),

-- Consulta 4: Busca por Rações (LIKE)
c4_racoes AS (
    SELECT 
        '4. Busca Produto Ração' AS relatorio,
        'Produto: ' || nome || ' (Estoque: ' || estoque || ')' AS detalhe,
        preco AS valor_metrica
    FROM produto
    WHERE nome LIKE '%Ração%'
),

-- Consulta 5: Consultas com valores entre R$ 150 e R$ 200 (BETWEEN)
c5_consultas_faixa AS (
    SELECT 
        '5. Consultas entre R$150 e R$200' AS relatorio,
        'ID Consulta: ' || id_consulta || ' | Data: ' || TO_CHAR(data_consulta, 'DD/MM/YYYY') AS detalhe,
        valor AS valor_metrica
    FROM consulta
    WHERE valor BETWEEN 150.00 AND 200.00
),

-- Consulta 6: Total Faturado em Consultas (SUM)
c6_faturamento_consultas AS (
    SELECT 
        '6. Faturamento Total Consultas' AS relatorio,
        'Soma total recebida por consultas' AS detalhe,
        SUM(valor) AS valor_metrica
    FROM consulta
),

-- Consulta 7: Média de preço dos produtos com estoque >= 25 (AVG + GROUP BY + HAVING)
c7_media_preco_estoque AS (
    SELECT 
        '7. Média Preço (Estoque >= 25)' AS relatorio,
        'Produtos com faixa de estoque ' || estoque || ' un.' AS detalhe,
        ROUND(AVG(preco), 2) AS valor_metrica
    FROM produto
    GROUP BY estoque
    HAVING estoque >= 25
),

-- Consulta 8: Pets por espécie (COUNT + GROUP BY)
c8_pets_por_especie AS (
    SELECT 
        '8. Quantidade de Pets por Espécie' AS relatorio,
        'Espécie: ' || especie AS detalhe,
        COUNT(*)::NUMERIC AS valor_metrica
    FROM pet
    GROUP BY especie
),

-- Consulta 9: Total faturado em vendas por cliente (SUM + GROUP BY)
c9_vendas_por_cliente AS (
    SELECT 
        '9. Vendas por Cliente' AS relatorio,
        'Cliente: ' || c.nome || ' (Total de compras: ' || COUNT(v.id_venda) || ')' AS detalhe,
        SUM(v.valor_total) AS valor_metrica
    FROM cliente c
    INNER JOIN venda v ON c.id_cliente = v.id_cliente
    GROUP BY c.id_cliente, c.nome
),

-- Consulta 10: Itens da Venda ID 1
c10_itens_venda_1 AS (
    SELECT 
        '10. Itens da Venda #1' AS relatorio,
        'Cliente: ' || c.nome || ' | Item: ' || p.nome || ' (Qtd: ' || iv.quantidade || ')' AS detalhe,
        iv.preco_unitario AS valor_metrica
    FROM venda v
    INNER JOIN cliente c ON v.id_cliente = c.id_cliente
    INNER JOIN item_venda iv ON v.id_venda = iv.id_venda
    INNER JOIN produto p ON iv.id_produto = p.id_produto
    WHERE v.id_venda = 1
),

-- Consulta 11: Clientes sem Compras (LEFT JOIN + IS NULL)
c11_clientes_sem_compras AS (
    SELECT 
        '11. Clientes Sem Compras' AS relatorio,
        'Cliente: ' || c.nome || ' (Email: ' || c.email || ')' AS detalhe,
        NULL::NUMERIC AS valor_metrica
    FROM cliente c
    LEFT JOIN venda v ON c.id_cliente = v.id_cliente
    WHERE v.id_venda IS NULL
),

-- Consulta 12: Atendimentos por Veterinário (LEFT JOIN + COUNT)
c12_atendimentos_vet AS (
    SELECT 
        '12. Atendimentos por Veterinário' AS relatorio,
        'Vet: ' || v.nome AS detalhe,
        COUNT(c.id_consulta)::NUMERIC AS valor_metrica
    FROM veterinario v
    LEFT JOIN consulta c ON v.id_veterinario = c.id_veterinario
    GROUP BY v.id_veterinario, v.nome
),

-- Consulta 13: Produtos com Estoque Baixo (< 30)
c13_estoque_baixo AS (
    SELECT 
        '13. Produtos com Estoque Baixo' AS relatorio,
        'Produto: ' || nome AS detalhe,
        estoque::NUMERIC AS valor_metrica