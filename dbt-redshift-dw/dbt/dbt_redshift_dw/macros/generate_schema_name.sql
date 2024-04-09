{% macro generate_schema_name(schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if schema_name is none -%}
        {{ default_schema}}
    {%- else -%}
        {{ schema_name | trim }}
    {%- endif %}

{%- endmacro %}