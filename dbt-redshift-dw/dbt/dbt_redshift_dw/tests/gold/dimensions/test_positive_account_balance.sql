SELECT
    account_id
FROM {{ ref('dim_accounts')}}
WHERE account_balance < 0