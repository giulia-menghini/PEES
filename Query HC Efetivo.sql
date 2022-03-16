WITH Novos_Clientes AS

(
SELECT
    dt_affiliation_date AS Data,
    str_affiliator_vendor_email AS Email_do_Vendedor,
    COUNT(DISTINCT str_afiliacoes_consideradas) AS Novos_Clientes
FROM `ctra-comercial-1554819299431.core_apurations.basic_hunter_portfolio_2022_02_28`
WHERE 1=1
    AND str_affiliator_vendor_sales_force_name = 'FRANQUIA'
    AND dt_reference = '2022-02-28'
    AND dt_affiliation_date BETWEEN '2022-02-01' AND '2022-02-28'
GROUP BY
    dt_affiliation_date,
    str_affiliator_vendor_email
),

Qualificacoes AS
(
    SELECT
        Data,
        Email_do_Vendedor,
        SUM(Qualificacoes) AS Qualificacoes
    FROM
        `ctra-comercial-1554819299431.metabase_call_de_vendas.consolidado_qualificacoes`
    WHERE 1=1
        AND Subcanal = 'FRANQUIA'
        AND Data BETWEEN '2022-02-01' AND '2022-02-28'
    GROUP BY 
        Data,
        Email_do_Vendedor
),

Propostas AS
(
    SELECT
        Data,
        Agente,
        COUNT(*) AS Propostas,
    FROM
        `ctra-comercial-1554819299431.metabase_planejamento_central.analitico_propostas`
    WHERE 1=1
        AND Subcanal = 'FRANQUIA'
        AND Data BETWEEN '2022-02-01' AND '2022-02-28'
    GROUP BY
        Data,
        Agente
),

Novos_Ativos AS

(SELECT
    dt_activation_date AS Data,
    str_affiliator_vendor_email AS Email_do_Vendedor,
    COUNT(DISTINCT str_afiliacoes_consideradas) AS Novos_Ativos
FROM `ctra-comercial-1554819299431.core_apurations.basic_hunter_portfolio_2022_02_28`
WHERE 1=1
    AND str_affiliator_vendor_sales_force_name = 'FRANQUIA'
    AND dt_reference = '2022-02-28'
    AND dt_activation_date BETWEEN '2022-02-01' AND '2022-02-28'
GROUP BY
    dt_activation_date,
    str_affiliator_vendor_email),

Estoque AS

(SELECT
    str_affiliator_vendor_email AS Email_do_Vendedor,
    COUNT(DISTINCT str_afiliacoes_consideradas) AS Estoque
FROM
  `ctra-comercial-1554819299431.core_apurations.basic_hunter_portfolio_2022_02_28`
WHERE 1=1
    AND LAST_DAY(dt_affiliation_date) = '2022-02-28'
    AND dt_activation_date IS NULL
    AND str_affiliator_vendor_sales_force_name = 'FRANQUIA'
    AND dt_reference = '2022-02-28'
GROUP BY
    Email_do_Vendedor

),

Geral AS

(
SELECT
    H.Data,
    H.Grupo_1,
    H.Grupo_2,
    H.Grupo_3,
    H.Email_do_Vendedor,
    H.Funcao_Maturidade,
    IF(H.Safra_do_Vendedor = 'M0', 1, 0) AS M0,
    IF(H.Safra_do_Vendedor = 'M1', 1, 0) AS M1,
    IF(H.Safra_do_Vendedor = 'M2+', 1, 0) AS M2,
    H.Status,
    H.Ativo,
	IF(H.Status = 'Não está mais no time', 1, 0) AS TurnOver,
    H.Tarefas_Finalizadas,
    IF(Qualificacoes.Qualificacoes IS NULL, 0, Qualificacoes.Qualificacoes) AS Qualificacoes,
    IF(Propostas.Propostas IS NULL, 0, Propostas.Propostas) AS Propostas,
    IF(Novos_Clientes.Novos_Clientes IS NULL, 0, Novos_Clientes.Novos_Clientes) AS Novos_Clientes,
    IF(Novos_Ativos.Novos_Ativos IS NULL, 0, Novos_Ativos.Novos_Ativos) AS Novos_Ativos,
    IF(Estoque.Estoque IS NULL, 0, Estoque.Estoque) AS Estoque,
    CASE WHEN (Tarefas_Finalizadas = 0
        AND Qualificacoes.Qualificacoes IS NULL
        AND Propostas.Propostas IS NULL
        AND Novos_Clientes.Novos_Clientes IS NULL)
    THEN 0
    ELSE 1
    END AS HC_Comercial
FROM
    `ctra-comercial-1554819299431.metabase_planejamento_central.analitico_headcount` H
LEFT JOIN
    Qualificacoes ON H.Email_do_Vendedor = Qualificacoes.Email_do_Vendedor AND H.Data = Qualificacoes.Data
LEFT JOIN
    Propostas ON H.Email_do_Vendedor = Propostas.Agente AND H.Data = Propostas.Data
LEFT JOIN
    Novos_Clientes ON H.Email_do_Vendedor = Novos_Clientes.Email_do_Vendedor AND H.Data = Novos_Clientes.Data
LEFT JOIN
    Novos_Ativos ON H.Email_do_Vendedor = Novos_Ativos.Email_do_Vendedor AND H.Data = Novos_Ativos.Data
LEFT JOIN
    Estoque ON H.Email_do_Vendedor = Estoque.Email_do_Vendedor AND H.Data = '2022-02-01'
WHERE 1=1
    AND H.Data BETWEEN '2022-02-01' AND '2022-02-28'
    AND H.Subcanal = 'FRANQUIA'
)


SELECT
    Geral.Data,
    Geral.Grupo_1,
    Geral.Grupo_2,
    Geral.Grupo_3,
    Geral.Email_do_Vendedor,
    SUM(Ativo) AS Ativo,
    SUM(M0) AS Agentes_M0,
    SUM(M1) AS Agentes_M1,
    SUM(M2) AS Agentes_M2,
    SUM(TurnOver) AS TurnOver,
    SUM(Tarefas_Finalizadas) AS Tarefas_Finalizadas,
    SUM(Qualificacoes) AS Qualificacoes,
    SUM(Propostas) AS Propostas,
    SUM(Geral.Novos_Clientes) AS Novos_Clientes,
    SUM(Geral.Novos_Ativos) AS Novos_Ativos,
    SUM(Geral.Estoque) AS Estoque,
    SUM(HC_Comercial) AS HC_Comercial,
    m.Novos_Clientes AS Meta_NC,
    m.Novos_Clientes_MTD AS Meta_NC_MTD,
    m.Novos_Ativos AS Meta_NA,
    m.Novos_Ativos_MTD AS Meta_NA_MTD
FROM Geral
LEFT JOIN `ctra-comercial-1554819299431.metabase_planejamento_central.desdobramento_de_metas_metas_dia_a_dia_v2` m
    ON Geral.Grupo_3 = m.Grupo_3 AND Geral.Data = m.Data
GROUP BY
    Geral.Data,
    Geral.Grupo_1,
    Geral.Grupo_2,
    Geral.Grupo_3,
    Geral.Email_do_Vendedor,
    m.Novos_Clientes,
    m.Novos_Clientes_MTD,
    m.Novos_Ativos,
    m.Novos_Ativos_MTD
