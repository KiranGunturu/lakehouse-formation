{{
    config(
        materialized='incremental',
        alias='stg_dim_account',
        schema=var('silver_schema'),
        unique_key='account_id',
        incremental_strategy='delete+insert'


    )
}}