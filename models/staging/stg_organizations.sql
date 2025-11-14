{{ config(
    materialized='table',
    schema='staging',
    alias='orgs'
) }}

with source as (
    select * from {{ ref('organizations-100') }}  -- ← confirm your seed name!
),

renamed as (
    select
        -- Surrogate key (handle potential duplicates via composite)
        {{ dbt_utils.generate_surrogate_key([
            '`Organization Id`',
            'Name'
        ]) }} as organization_sk,

        `Organization Id` as organization_id,
        trim(initcap(Name)) as org_name,
        nullif(trim(Website), '') as website,
        upper(trim(Country)) as country_code,
        nullif(trim(Description), '') as description,

        -- Safe cast numeric fields — NO TRIM()
        safe_cast(Founded as int64) as founded_year,
        trim(initcap(Industry)) as industry,
        safe_cast(`Number of employees` as int64) as employee_count,

        -- Metadata
        current_timestamp() as load_timestamp,
        '{{ invocation_id }}' as dbt_invocation_id
    from source
)

select * from renamed