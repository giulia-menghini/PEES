SELECT
    Stonecode,
    Cliente,
    DATE(EXTRACT(YEAR FROM Data_de_Credenciamento), EXTRACT(MONTH FROM Data_de_Credenciamento), EXTRACT(DAY FROM Data_de_Credenciamento)) as Data_de_Credenciamento,
    Email_do_Agente,
    Estrelas,
    Regional,
    Distrito,
    Polo
FROM `ctra-comercial-1554819299431.funil_de_vendas.novos_clientes`
WHERE 1=1
    AND LAST_DAY(DATE(EXTRACT(YEAR FROM Data_de_Credenciamento), EXTRACT(MONTH FROM Data_de_Credenciamento), EXTRACT(DAY FROM Data_de_Credenciamento))) = '2022-02-28'
    AND Subcanal = 'FRANQUIA'
    AND Perfil = 'Comercial - Franquia Polos'

GROUP BY   
    Stonecode,
    Cliente,
    Data_de_Credenciamento,
    Email_do_Agente,
    Estrelas,
    Regional,
    Distrito,
    Polo
