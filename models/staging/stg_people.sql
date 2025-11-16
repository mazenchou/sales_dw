{{ config(
    materialized='table',
    schema='staging',
    alias='people'
) }}

with source as (
    select * from {{ ref('people-100') }}
),

renamed as (
    select
        -- Surrogate key
        {{ dbt_utils.generate_surrogate_key(['`User Id`']) }} as person_sk,
        
        -- Business key only
        `User Id` as user_id,
        
        -- Metadata
        current_timestamp() as load_timestamp,
        '{{ invocation_id }}' as dbt_invocation_id
        
    from source
)

select * from renamed