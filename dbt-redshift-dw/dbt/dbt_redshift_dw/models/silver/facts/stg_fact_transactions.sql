{{
    config(
        materialized='table',
        alias='stg_fact_transactions',
        schema=var('silver_schema'),
        unique_key='transaction_id',
        incremental_stragey='delete+insert',
        primary_key='transaction_id',
        sort_key='transaction_id',
        distribution='even'
    )
}}

SELECT
    transaction_id,
    date_id,
    transaction_type_id,
    channel_id,
    location_id,
    account_id,
    currency_id,
    transaction_amount,
    transaction_status,
    getdate() as created_at
FROM
    {{ var('bronze_schema') }}.ext_fact_transactions