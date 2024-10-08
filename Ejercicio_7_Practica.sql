WITH identificacion_billing_account AS(
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

SELECT calls_ivr_id
     , COALESCE(billing_account_id_valido, billing_account_unknown) AS billing_account_id
FROM identificacion_billing_account