{{
    config(
        materialized='incremental',
        alias='dim_channels',
        schema=var('gold_schema'),
        unique_key='channel_id',
        incremental_stragey='delete+insert'
    )
}}

SELECT
    channel_id,
    channel_name,
    created_at
FROM
    {{ ref('stg_dim_channels') }}

{% if is_incremental() %}
    WHERE created_at > (SELECT MAX(created_at) FROM {{ this}})
{% endif %}