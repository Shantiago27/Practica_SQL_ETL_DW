DROP TABLE IF EXISTS `keepcoding.ivr_summary`;

CREATE TABLE keepcoding.ivr_summary AS 
 
WITH vdn AS(
   SELECT
      calls.ivr_id
       , CASE 
             WHEN calls.vdn_label LIKE 'ATC%' THEN 'FRONT'
             WHEN calls.vdn_label LIKE 'TECH%' THEN 'TECH'
             WHEN calls.vdn_label LIKE 'ABSORPTION' THEN 'ABSORPTION'
             ELSE 'RESTO'
         END AS vdn_aggregation
   FROM `keepcoding.ivr_calls` calls
    )

   , identificacion_documento AS(
  SELECT
     detail.calls_ivr_id
  , MAX(CASE
    WHEN detail.document_type ='DNI' THEN 'DNI'
    WHEN detail.document_type ='PASSPORT' THEN 'PASSPORT'
    ELSE NULL
    END) AS document_type
  , MAX(CASE
    WHEN detail.document_type = 'DNI' OR detail.document_type= 'PASSPORT' THEN detail.document_identification
    ELSE NULL
    END) AS document_identification
  FROM `keepcoding.ivr_detail` detail
  GROUP BY detail.calls_ivr_id
   )
   , identificacion_llamada AS(
   SELECT
         detail.calls_ivr_id
         , MAX(detail.calls_phone_number) AS customer_phone
   FROM `keepcoding.ivr_detail` detail
   WHERE detail.calls_phone_number IS NOT NULL
   GROUP BY detail.calls_ivr_id
   )

   , identificacion_billing_account AS(
      SELECT
        detail.calls_ivr_id
      , ARRAY_AGG(CASE
        WHEN detail.billing_account_id <> 'UNKNOWN'THEN detail.billing_account_id
        ELSE NULL
        END IGNORE NULLS LIMIT 1) [SAFE_OFFSET(0)] AS billing_account_id_valido
      , MAX(CASE
        WHEN detail.billing_account_id = 'UNKNOWN' THEN 'UNKNOWN'
        ELSE NULL
        END) AS billing_account_unknown
      FROM `keepcoding.ivr_detail` detail
      GROUP BY detail.calls_ivr_id
      )

    , masiva_logica AS(
      SELECT detail.calls_ivr_id
         , MAX(CASE 
            WHEN detail.module_name = 'AVERIA_MASIVA' THEN 1
            ELSE 0
            END) AS masiva_lg
         FROM `keepcoding.ivr_detail` detail
         GROUP BY detail.calls_ivr_id
      )

    , inf_numero_log AS(
      SELECT detail.calls_ivr_id
         , MAX(CASE 
            WHEN detail.step_name = 'CUSTOMERINFOBYPHONE.TX' AND detail.step_result = 'OK' THEN 1
            ELSE 0
            END) AS info_by_phone_lg
         FROM `keepcoding.ivr_detail` detail
         GROUP BY detail.calls_ivr_id
      )

    , inf_by_dni_log AS(
      SELECT detail.calls_ivr_id
         , MAX(CASE 
            WHEN detail.step_name = 'CUSTOMERINFOBYDNI.TX' AND detail.step_result = 'OK' THEN 1
            ELSE 0
            END) AS info_by_dni_lg
         FROM `keepcoding.ivr_detail` detail
         GROUP BY detail.calls_ivr_id
      )

   , llamadas_repetidas AS(
     SELECT 
        CAST(detail.calls_ivr_id AS STRING) AS calls_ivr_id   
      , detail.calls_phone_number
      , detail.calls_start_date
      , LAG (detail.calls_start_date) OVER(PARTITION BY detail.calls_phone_number ORDER BY detail.calls_start_date) AS prev_call_date
      , LEAD (detail.calls_start_date) OVER(PARTITION BY detail.calls_phone_number ORDER BY detail.calls_start_date) AS next_call_date
   FROM `keepcoding.ivr_detail` detail
   )
 , flag AS(
   SELECT 
      CAST(calls_ivr_id AS FLOAT64) AS calls_ivr_id
    , calls_phone_number
    , calls_start_date
    , CASE 
         WHEN prev_call_date IS NOT NULL 
         AND TIMESTAMP_DIFF(calls_start_date, prev_call_date, HOUR) <=24 THEN 1
         ELSE 0
      END AS repeated_phone_24H
    , CASE 
         WHEN next_call_date IS NOT NULL 
         AND TIMESTAMP_DIFF(next_call_date, calls_start_date, HOUR) <=24 THEN 1
         ELSE 0
      END AS cause_recall_phone_24H  
    , ROW_NUMBER() OVER (PARTITION BY calls_ivr_id ORDER BY calls_start_date) AS row_num
   FROM `llamadas_repetidas`
)


SELECT DISTINCT
     detail.calls_ivr_id AS ivr_id
   , detail.calls_phone_number AS phone_number
   , detail.calls_ivr_result AS ivr_result
   , vdn.vdn_aggregation AS vdn_aggregation
   , detail.calls_start_date AS start_date
   , detail.calls_end_date AS end_date
   , detail.calls_total_duration AS total_duration
   , detail.calls_customer_segment AS customer_segment
   , detail.calls_ivr_language AS ivr_languaje
   , detail.calls_steps_module AS steps_module
   , detail.calls_module_aggregation AS module_aggregation
   , identificacion_documento.document_type AS document_type
   , identificacion_documento.document_identification AS document_identification
   , identificacion_llamada.customer_phone AS customer_phone
   , COALESCE(billing_account_id_valido, billing_account_unknown) AS billing_account_id
   , masiva_logica.masiva_lg AS masiva_lg
   , inf_numero_log.info_by_phone_lg AS info_by_phone_lg
   , inf_by_dni_log.info_by_dni_lg AS info_by_dni_lg
   , flag.repeated_phone_24H AS repeated_phone_24H
   , flag.cause_recall_phone_24H AS cause_recall_phone_24H
   FROM `keepcoding.ivr_detail` detail

JOIN vdn
  ON detail.calls_ivr_id = vdn.ivr_id

JOIN identificacion_documento
  ON detail.calls_ivr_id = identificacion_documento.calls_ivr_id 

JOIN identificacion_llamada
  ON detail.calls_ivr_id = identificacion_llamada.calls_ivr_id

JOIN identificacion_billing_account
  ON detail.calls_ivr_id = identificacion_billing_account.calls_ivr_id

JOIN masiva_logica
  ON detail.calls_ivr_id = masiva_logica.calls_ivr_id

JOIN inf_numero_log
  ON detail.calls_ivr_id = inf_numero_log.calls_ivr_id

JOIN inf_by_dni_log
  ON detail.calls_ivr_id = inf_by_dni_log.calls_ivr_id

JOIN flag
  ON detail.calls_ivr_id = flag.calls_ivr_id
WHERE flag.row_num=1;
