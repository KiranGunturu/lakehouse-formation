{{
    config(
        materialized='incremental',
        alias='stg_dim_channels',
        schema=var('silver_schema'),
        unique_key='channel_id',
        incremental_strategy='delete+insert'


    )
}}

select
    channel_id,
    channel_name,
    get_date() as created_at
from {{ var('bronze_schema') }}.ext_channels