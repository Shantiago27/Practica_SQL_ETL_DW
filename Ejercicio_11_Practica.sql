WITH llamadas_repetidas AS(
     SELECT 
     CAST(detail.calls_ivr_id AS STRING) AS calls_ivr_id   
   , detail.calls_phone_number
   , detail.calls_start_date

   , LAG (detail.calls_start_date) OVER(
    PARTITION BY detail.calls_phone_number ORDER BY detail.calls_start_date
   ) AS prev_call_date
   , LEAD (detail.calls_start_date) OVER(
    PARTITION BY detail.calls_phone_number ORDER BY detail.calls_start_date
   ) AS next_call_date
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

SELECT calls_ivr_id, repeated_phone_24H, cause_recall_phone_24H
FROM flag
WHERE row_num=1