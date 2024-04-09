{{
    config(
        materialized='incremental',
        alias='stg_dim_dates',
        schema=var('silver_schema'),
        unique_key='date_id',
        incremental_strategy='delete+insert'


    )
}}

select
    date_id,
    "date",
    "day",
    "month",
    "year",
    'weekday",
    get_date() as created_at
from {{ var('bronze_schema') }}.ext_dates

