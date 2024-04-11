WITH current_records AS (
    SELECT
        currency_id,
        COUNT(*) AS record_count
    FROM {{ ref('dim_currency') }}
    GROUP BY currency_id
)

SELECT currency_id
FROM current_records
WHERE record_count > 1
