WITH inf_by_dni_log AS(
  SELECT detail.calls_ivr_id
     , MAX(CASE 
       WHEN detail.step_name = 'CUSTOMERINFOBYDNI.TX' AND detail.step_result = 'OK' THEN 1
       ELSE 0
       END) AS info_by_dni_lg
   FROM `keepcoding.ivr_detail` detail
   GROUP BY detail.calls_ivr_id
)

SELECT *
FROM inf_by_dni_log
