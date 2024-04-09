{{
    config(
        materialized='table',
        alias='stg_fact_investments',
        schema=var('silver_schema'),
        unique_key='investment_id',
        incremental_stragey='delete+insert',
        primary_key='investment_id',
        sort_key='investment_id',
        distribution='even'
    )
}}

SELECT
    investment_id,
    date_id,
    investment_type_id,
    location_id,
    account_id,
    currency_id,
    investment_amount,
    investment_return,
    getdate() as created_at
FROM
    {{ var('bronze_schema') }}.ext_fact_investments