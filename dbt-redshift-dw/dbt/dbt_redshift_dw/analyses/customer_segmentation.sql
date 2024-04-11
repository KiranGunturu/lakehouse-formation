WITH customer_behaviour as (
    select 
        account_number,
        count(transaction_id) as num_transactions,
        avg(transaction_amount) as avg_transaction_amount
    from {{ ref('fact_transactions')}}
    group by account_number
)

select
    cb.account_number,
    cb.num_transactions,
    cb.avg_transaction_amount,
    case
        when cb.num_transactions > 10 and cb.avg_transaction_amount > 5000 then 'High'
        when cb.num_transactions between 5 and 10 and cb.avg_transaction_amount between 4000 and 5000 then 'Medium'
        ELSE 'Low'
    END as customer_segment
    from customer_behaviour cb
