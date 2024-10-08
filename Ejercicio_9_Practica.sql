WITH inf_numero_log AS(
  SELECT detail.calls_ivr_id
     , MAX(CASE 
       WHEN detail.step_name = 'CUSTOMERINFOBYPHONE.TX' AND detail.step_result = 'OK' THEN 1
       ELSE 0
       END) AS info_by_phone_lg
   FROM `keepcoding.ivr_detail` detail
   GROUP BY detail.calls_ivr_id
)

SELECT *
FROM inf_numero_log