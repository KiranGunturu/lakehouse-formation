{{
    config(
        materialized='incremental',
        alias='stg_dim_investment_types',
        schema=var('silver_schema'),
        unique_key='investment_type_id',
        incremental_strategy='delete+insert'


    )
}}

select
    investment_type_id,
    investment_type_name,
    getdate() as created_at
from {{ var('bronze_schema') }}.ext_investment_types

