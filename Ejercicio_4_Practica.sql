SELECT calls.ivr_id
      , CASE 
          WHEN vdn_label LIKE 'ATC%' THEN 'FRONT'
          WHEN vdn_label LIKE 'TECH%' THEN 'TECH'
          WHEN vdn_label LIKE 'ABSORPTION' THEN 'ABSORPTION'
          ELSE 'RESTO'
        END AS vdn_aggregation
FROM `keepcoding.ivr_calls` calls
