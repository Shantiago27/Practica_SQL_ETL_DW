WITH identificacion_llamada AS(
  SELECT
        detail.calls_ivr_id
      , MAX(detail.calls_phone_number) AS customer_phone
  FROM `keepcoding.ivr_detail` detail
  WHERE detail.calls_phone_number IS NOT NULL
  GROUP BY detail.calls_ivr_id
)

SELECT *
FROM identificacion_llamada