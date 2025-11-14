{{ config(
    materialized='table',
    schema='core',
    alias='dim_organizations'
) }}

select
    organization_sk,
    organization_id,
    org_name,
    website,
    country_code,
    description,
    founded_year,
    industry,
    employee_count,
    load_timestamp
from {{ ref('stg_organizations') }}