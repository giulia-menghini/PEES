SELECT 
DATE(EXTRACT(YEAR FROM dtm_signed), EXTRACT(MONTH FROM dtm_signed), EXTRACT(DAY FROM dtm_signed)) AS dtm_signed,
str_status,
str_client_document, 
str_client_name, 
str_hub_name,
str_product_name,
str_user_email
FROM `ctra-comercial-1554819299431.sales_analytics.tb_new_insurance_contract` 
WHERE dtm_signed >= '2022-03-01' AND dtm_signed <= '2022-04-01'
AND str_user_email like '%@querostone.com.br'
