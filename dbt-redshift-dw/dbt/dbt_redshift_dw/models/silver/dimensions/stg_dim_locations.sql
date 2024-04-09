{{
    config(
        materialized='incremental',
        alias='stg_dim_locations',
        schema=var('silver_schema'),
        unique_key='location_id',
        incremental_strategy='delete+insert'


    )
}}

select
    location_id,
    city,
    "state",
    country,
    postal_code,
    getdate() as created_at
from {{ var('bronze_schema') }}.ext_locations

