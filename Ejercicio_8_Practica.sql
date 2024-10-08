WITH masiva_logica AS(
  SELECT detail.calls_ivr_id
     , MAX(CASE 
       WHEN detail.module_name = 'AVERIA_MASIVA' THEN 1
       ELSE 0
       END) AS masiva_lg
   FROM `keepcoding.ivr_detail` detail
   GROUP BY detail.calls_ivr_id
)

SELECT *
FROM masiva_logica
