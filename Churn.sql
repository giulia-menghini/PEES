SELECT
    dt_alfa,
    dt_reference,
    str_afiliacoes_consideradas,
    str_fantasy_name,
    str_sub_channel,
    str_group_1,
    str_group_2,
    str_group_3,
    IF(flo_m0_tpv > 1, 1, 0) AS Base_Ativa_M0,
    IF(flo_m1_tpv > 1, 1, 0) AS Base_Ativa_M1,
    IF(flo_m2_tpv > 1, 1, 0) AS Base_Ativa_M2,
    IF(flo_m3_tpv > 1, 1, 0) AS Base_Ativa_M3,
    IF(flo_m4_tpv > 1, 1, 0) AS Base_Ativa_M4,
    IF(flo_m5_tpv > 1, 1, 0) AS Base_Ativa_M5,
    IF(flo_m6_tpv > 1, 1, 0) AS Base_Ativa_M6,
    IF(flo_rolling_30_60_tpv > 1, 1, 0) AS Base_Ativa_M1R30,
    IF(flo_rolling_30_tpv > 1, 1, 0) AS Base_Ativa_M0R30,

    CASE
        WHEN flo_rolling_30_60_tpv > 1 AND flo_rolling_30_tpv < 1 THEN 1
        ELSE 0
    END AS Churn_Rolling30D,

    CASE
        WHEN flo_m1_tpv > 1 AND flo_m0_tpv < 1 THEN 1
        ELSE 0
    END AS Churn_M0,

    CASE
        WHEN flo_m2_tpv > 1 AND flo_m1_tpv < 1 THEN 1
        ELSE 0
    END AS Churn_M1,

    CASE
        WHEN flo_m3_tpv > 1 AND flo_m2_tpv < 1 THEN 1
        ELSE 0
    END AS Churn_M2,

    CASE
        WHEN flo_m4_tpv > 1 AND flo_m3_tpv < 1 THEN 1
        ELSE 0
    END AS Churn_M3,

    CASE
        WHEN flo_m5_tpv > 1 AND flo_m4_tpv < 1 THEN 1
        ELSE 0
    END AS Churn_M4,

    CASE
        WHEN flo_m6_tpv > 1 AND flo_m5_tpv < 1 THEN 1
        ELSE 0
    END AS Churn_M5

FROM `ctra-comercial-1554819299431.core_apurations.basic_full_portfolio_2022_01_31`
WHERE 1=1
    AND dt_reference = '2022-01-31'
    AND str_sub_channel = 'FRANQUIA'
