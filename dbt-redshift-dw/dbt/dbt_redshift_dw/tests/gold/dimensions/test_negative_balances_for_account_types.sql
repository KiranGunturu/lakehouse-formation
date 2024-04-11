SELECT
    account_id,
    account_type,
    account_balance
FROM {{ ref('dim_account') }}
WHERE
    account_balance < 0
    AND account_type IN ('Savings', 'Checking')
