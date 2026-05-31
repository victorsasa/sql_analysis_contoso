# Análise de Vendas — Contoso (Microsoft)

Projeto de análise exploratória utilizando SQL Server sobre a base de dados
Contoso da Microsoft. O objetivo é responder perguntas de negócio sobre
receita, produtos, lojas e clientes.

## Perguntas respondidas

**Receita e canais**
- Receita total por canal de venda
- Receita total por ano
- Receita total por continente

**Produtos**
- Top 10 produtos por quantidade vendida
- Produtos com receita acima de $100.000
- Categorias com preço médio acima de $500
- Ranking de receita por categoria

**Lojas**
- Lojas ativas por país
- Ticket médio por loja
- Lojas acima da média geral de receita

**Clientes**
- Top 5 clientes por valor total comprado

## Resultados selecionados

- **Canal com maior receita:** Canal 1 — R$ 6,9 bilhões
- **Categoria líder:** Home Appliances — R$ 3,9 bilhões (49% da receita total)
- **Produto líder:** Proseware Projector 1080p DLP86 White — R$ 51,9 milhões
- **Ranking de categorias:** Home Appliances → Computers → Cameras → TV and Video

## Técnicas utilizadas
- Agregações (SUM, COUNT, AVG)
- JOINs (INNER JOIN entre até 4 tabelas)
- GROUP BY + HAVING
- CTEs simples e encadeadas
- Window Function (RANK)
- NULLIF para tratamento de divisão por zero

## Base de dados
Contoso Retail DW — base pública da Microsoft para demonstração de analytics.
Nota: ChannelKey em FactSales não possui tabela de dimensão correspondente
na versão utilizada.

## Ferramentas
SQL Server · SSMS
