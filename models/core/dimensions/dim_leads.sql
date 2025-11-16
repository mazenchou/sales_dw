{{ config(
    materialized='table',
    schema='core',
    alias='dim_leads'
) }}

with stg_leads as (
    select * from {{ ref('stg_leads') }}
),

dim_leads as (
    select
        lead_sk,
        account_id,
        load_timestamp,
        dbt_invocation_id
    from stg_leads
)

select * from dim_leads