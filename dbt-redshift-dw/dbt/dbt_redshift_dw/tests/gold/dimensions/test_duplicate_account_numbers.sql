SELECT account_number
FROM {{ ref('dim_account') }}
GROUP BY account_number
HAVING COUNT(*) > 1
