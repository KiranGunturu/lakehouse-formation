{{
    config(
        materialized='incremental',
        alias='stg_dim_transaction_types',
        schema=var('silver_schema'),
        unique_key='transaction_type_id',
        incremental_strategy='delete+insert'


    )
}}

select
    transaction_type_id,
    transaction_type_name,
    get_date() as created_at
from {{ var('bronze_schema') }}.ext_transaction_types

