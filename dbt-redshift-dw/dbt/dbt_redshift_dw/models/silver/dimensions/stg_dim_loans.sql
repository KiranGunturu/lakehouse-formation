{{
    config(
        materialized='incremental',
        alias='stg_dim_loans',
        schema=var('silver_schema'),
        unique_key='loan_id',
        incremental_strategy='delete+insert'


    )
}}

select
    loan_id,
    loan_type,
    loan_amount,
    interest_rate,
    get_date() as created_at
from {{ var('bronze_schema') }}.ext_loans

