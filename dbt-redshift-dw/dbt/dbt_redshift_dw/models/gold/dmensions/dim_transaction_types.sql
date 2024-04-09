{{
    config(
        materialized='incremental',
        alias='dim_transaction_types',
        schema=var('gold_schema'),
        unique_key='transaction_type_id',
        incremental_stragey='delete+insert'
    )
}}

SELECT
    transaction_type_id,
    INITCAP(transaction_type_name) AS transaction_type_name,
    created_at
FROM
    {{ ref('stg_dim_transaction_types') }}

{% if is_incremental() %}
    WHERE created_at > (SELECT MAX(created_at) FROM {{ this}})
{% endif %}