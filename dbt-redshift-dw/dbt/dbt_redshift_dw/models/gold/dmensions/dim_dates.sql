{{
    config(
        materialized='incremental',
        alias='dim_dates',
        schema=var('gold_schema'),
        unique_key='date_id',
        incremental_stragey='delete+insert'
    )
}}

SELECT
    date_id,
    "date",
    "day",
    "month",
    "year",
    weekday,
    created_at
FROM
    {{ ref('stg_dim_dates') }}

{% if is_incremental() %}
    WHERE created_at > (SELECT MAX(created_at) FROM {{ this}})
{% endif %}