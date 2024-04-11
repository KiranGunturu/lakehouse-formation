SELECT
    account_id,
    account_type
FROM {{ ref('dim_accounts')}}
WHERE account_type not in ('Savings', 'Checking', 'Investment', 'Loan')
