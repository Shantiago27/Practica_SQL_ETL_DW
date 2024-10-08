WITH identificacion_documento AS(
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

SELECT *
FROM identificacion_documento