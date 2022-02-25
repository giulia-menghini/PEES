
WITH TMP AS (

SELECT
    ---- Informações do cliente

    payerName,
    name,
    payerDocument,
    status,
    DATE(EXTRACT(YEAR FROM signedAt), EXTRACT(MONTH FROM signedAt), EXTRACT(DAY FROM signedAt)) as signedAt,
    DATE(EXTRACT(YEAR FROM startsAt), EXTRACT(MONTH FROM startsAt), EXTRACT(DAY FROM startsAt)) as startsAt,
    productName,
    agentEmail,
    subcanal_carteira__c,
    grupo1_carteira__c,
    grupo2_carteira__c,
    grupo3_carteira__c,

    ---- Informações valores

    capital/100 as capital,
    premium/100 as premium,

    ROW_NUMBER() OVER (PARTITION BY payerdocument ORDER BY updatedAt DESC) as rwnumb
    
FROM `dataplatform-prd.vitta.contracts` seg
LEFT JOIN (SELECT 
               cnpj_limpo__c,
               name,
               subcanal_carteira__c,
               grupo1_carteira__c,
               grupo2_carteira__c,
               grupo3_carteira__c,
               ROW_NUMBER() OVER (PARTITION BY cnpj_limpo__c ORDER BY airflow_metadata__execution_date DESC) as rw
            FROM `dataplatform-prd.sop_salesforce.account`
            ) SF 
                ON seg.payerDocument = SF.cnpj_limpo__c AND SF.rw = 1
WHERE 1=1
    AND signedAt <= '2022-01-31'
    AND status = 'ACTIVE'
    AND SF.subcanal_carteira__c = 'FRANQUIA'

)

SELECT
    *
FROM TMP
WHERE TMP.rwnumb = 1
