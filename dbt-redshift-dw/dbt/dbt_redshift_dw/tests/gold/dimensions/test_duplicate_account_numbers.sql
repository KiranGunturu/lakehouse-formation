SELECT account_number
FROM {{ ref('dim_accounts') }}
GROUP BY account_number
HAVING COUNT(*) > 1
