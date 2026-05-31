-- ============================================================
-- BASE CONTOSO (MICROSOFT)



-- Qual o total de receita (SalesAmount) gerado por cada canal de venda (ChannelKey)?

SELECT
    ChannelKey,
    SUM(SalesAmount) AS ReceitaTotal
FROM
    FactSales
GROUP BY
    ChannelKey
ORDER BY
    ReceitaTotal DESC


-- Quais são os 10 produtos mais vendidos em quantidade (SalesQuantity)?

SELECT TOP(10)
    ProductKey,
    SUM(SalesQuantity) AS TotalQuantidade
FROM
    FactSales
GROUP BY
    ProductKey
ORDER BY
    TotalQuantidade DESC



-- Qual a receita total por ano?

SELECT
    LEFT(CAST(DateKey AS VARCHAR), 4) AS Ano,
    SUM(SalesAmount) AS ReceitaTotal
FROM
    FactSales
GROUP BY
    LEFT(CAST(DateKey AS VARCHAR), 4)
ORDER BY
    Ano


-- ============================================================
-- BLOCO 2 - JOIN
-- ============================================================



-- Qual a receita total por categoria de produto?

SELECT
    pc.ProductCategoryName  AS Categoria,
    SUM(fs.SalesAmount)     AS ReceitaTotal
FROM
    FactSales fs
INNER JOIN DimProduct dp
    ON fs.ProductKey = dp.ProductKey
INNER JOIN DimProductSubcategory ps
    ON dp.ProductSubcategoryKey = ps.ProductSubcategoryKey
INNER JOIN DimProductCategory pc
    ON ps.ProductCategoryKey = pc.ProductCategoryKey
GROUP BY
    pc.ProductCategoryName
ORDER BY
    ReceitaTotal DESC



-- Qual a receita total por continente?
SELECT
    dg.ContinentName    AS Continente,
    SUM(fs.SalesAmount) AS ReceitaTotal
FROM
    FactSales fs
INNER JOIN DimStore ds
    ON fs.StoreKey = ds.StoreKey
INNER JOIN DimGeography dg
    ON ds.GeographyKey = dg.GeographyKey
GROUP BY
    dg.ContinentName
ORDER BY
    ReceitaTotal DESC


-- Quais lojas estão ativas (Status = 'On') e em qual país estão localizadas?

SELECT
    ds.StoreName,
    ds.Status,
    dg.RegionCountryName AS Pais
FROM DimStore ds
INNER JOIN DimGeography dg
    ON ds.GeographyKey = dg.GeographyKey
WHERE ds.Status = 'On'
ORDER BY
    dg.RegionCountryName





-- Quais produtos geraram mais de R$100.000 em receita total?

SELECT
    dp.ProductName,
    SUM(fs.SalesAmount) AS ReceitaTotal
FROM
    FactSales fs
INNER JOIN DimProduct dp
    ON fs.ProductKey = dp.ProductKey
GROUP BY
    dp.ProductName
HAVING
    SUM(fs.SalesAmount) > 100000
ORDER BY
    ReceitaTotal DESC



-- Quais categorias de produto têm média de preço unitário (UnitPrice) acima de $500?

SELECT
    pc.ProductCategoryName  AS Categoria,
    AVG(dp.UnitPrice)       AS MediaPreco
FROM
    DimProduct dp
INNER JOIN DimProductSubcategory ps
    ON dp.ProductSubcategoryKey = ps.ProductSubcategoryKey
INNER JOIN DimProductCategory pc
    ON ps.ProductCategoryKey = pc.ProductCategoryKey
GROUP BY
    pc.ProductCategoryName
HAVING
    AVG(dp.UnitPrice) > 500
ORDER BY
    MediaPreco DESC





-- Quais são os 5 clientes que mais compraram em valor total?

WITH ReceitaPorCliente AS (
    SELECT
        CustomerKey,
        SUM(SalesAmount) AS TotalComprado
    FROM
        FactOnlineSales
    GROUP BY
        CustomerKey
)
SELECT TOP(5)
    dc.FirstName + ' ' + dc.LastName AS Cliente,
    r.TotalComprado
FROM
    ReceitaPorCliente r
INNER JOIN DimCustomer dc
    ON r.CustomerKey = dc.CustomerKey
ORDER BY
    r.TotalComprado DESC


-- Qual o ticket médio por loja?

WITH MetricasPorLoja AS (
    SELECT
        StoreKey,
        SUM(SalesAmount) AS ReceitaTotal,
        COUNT(*)         AS NumTransacoes -- COUNT(*) conta todas as linhas (transações)
    FROM
        FactSales
    GROUP BY
        StoreKey
)
SELECT
    ds.StoreName,
    m.ReceitaTotal,
    m.NumTransacoes,
    m.ReceitaTotal / NULLIF(m.NumTransacoes, 0) AS TicketMedio
FROM
    MetricasPorLoja m
INNER JOIN DimStore ds
    ON m.StoreKey = ds.StoreKey
ORDER BY
    TicketMedio DESC



-- Quais lojas estão acima da média geral de receita?

WITH ReceitaPorLoja AS (
    SELECT
        StoreKey,
        SUM(SalesAmount) AS ReceitaTotal
    FROM
        FactSales
    GROUP BY
        StoreKey
),
MediaGeral AS (
    SELECT
        AVG(ReceitaTotal) AS Media
    FROM
        ReceitaPorLoja -- usa o resultado da primeira CTE
)
SELECT
    ds.StoreName,
    r.ReceitaTotal,
    mg.Media       AS MediaGeral
FROM
    ReceitaPorLoja r
INNER JOIN DimStore ds
    ON r.StoreKey = ds.StoreKey
CROSS JOIN MediaGeral mg  -- CROSS JOIN traz o valor único da média para cada linha
WHERE
    r.ReceitaTotal > mg.Media
ORDER BY
    r.ReceitaTotal DESC


-- Ranking de receita por categoria de produto, do maior para o menor

WITH ReceitaPorCategoria AS (
    SELECT
        pc.ProductCategoryName  AS Categoria,
        SUM(fs.SalesAmount)     AS ReceitaTotal
    FROM
        FactSales fs
    INNER JOIN DimProduct dp
        ON fs.ProductKey = dp.ProductKey
    INNER JOIN DimProductSubcategory ps
        ON dp.ProductSubcategoryKey = ps.ProductSubcategoryKey
    INNER JOIN DimProductCategory pc
        ON ps.ProductCategoryKey = pc.ProductCategoryKey
    GROUP BY
        pc.ProductCategoryName
)
SELECT
    Categoria,
    ReceitaTotal,
    RANK() OVER (ORDER BY ReceitaTotal DESC) AS Ranking -- numera do maior para o menor
FROM
    ReceitaPorCategoria
ORDER BY
    Ranking

