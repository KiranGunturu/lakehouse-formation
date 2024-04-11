SELECT
    account_id,
    credit_score
FROM {{ ref('dim_account') }}
WHERE credit_score < 300 OR credit_score > 850
