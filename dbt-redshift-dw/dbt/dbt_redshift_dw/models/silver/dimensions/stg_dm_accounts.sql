{{
    config(
        materialized='incremental',
        alias='stg_dim_accounts',
        schema=var('silver_schema'),
        unique_key='account_id',
        incremental_strategy='delete+insert'


    )
}}

select
    account_id,
    customer_id,
    account_number,
    account_type,
    account_balance,
    credit_score,
    get_date() as created_at
from {{ var('bronze_schema') }}.ext_accounts