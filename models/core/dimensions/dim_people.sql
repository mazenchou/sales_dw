{{ config(
    materialized='table',
    schema='core',
    alias='dim_people'
) }}

with stg_people as (
    select * from {{ ref('stg_people') }}
),

dim_people as (
    select
        person_sk,
        user_id,
        load_timestamp,
        dbt_invocation_id
    from stg_people
)

select * from dim_people