{{ config(
    materialized='table',
    schema='staging',
    alias='leads'
) }}

with source as (
    select * from {{ ref('leads-100') }}
),

renamed as (
    select
        -- Surrogate key
        {{ dbt_utils.generate_surrogate_key(['Index', '`Account Id`']) }} as lead_sk,
        
        -- Business key only
        `Account Id` as account_id,
        
        -- Metadata
        current_timestamp() as load_timestamp,
        '{{ invocation_id }}' as dbt_invocation_id
        
    from source
)

select * from renamed