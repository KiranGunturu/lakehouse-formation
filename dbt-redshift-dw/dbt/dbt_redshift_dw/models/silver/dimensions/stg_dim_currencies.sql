{{
    config(
        materialized='incremental',
        alias='stg_dim_currencies',
        schema=var('silver_schema'),
        unique_key='currency_id',
        incremental_strategy='delete+insert'


    )
}}

select
    currency_id,
    currency_code,
    currency_name,
    getdate() as created_at
from {{ var('bronze_schema') }}.ext_currencies

