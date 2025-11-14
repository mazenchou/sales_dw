{{ config(
    materialized='table',
    schema='staging',
    alias='clients',
    tags=['staging']
) }}

with source as (
    select * from {{ ref('customers_100') }}
),

renamed as (
    select
        -- ✅ Use raw column name (with backticks) in surrogate_key
        {{ dbt_utils.generate_surrogate_key(['`Customer Id`']) }} as customer_sk,

        cast(Index as int64) as customer_index,
        `Customer Id` as customer_id,
        trim(initcap(`First Name`)) as first_name,
        trim(initcap(`Last Name`)) as last_name,
        nullif(trim(Company), '') as company,
        trim(initcap(City)) as city,
        upper(trim(Country)) as country_code,
        coalesce(
            nullif(trim(`Phone 1`), ''),
            nullif(trim(`Phone 2`), '')
        ) as main_phone,
        lower(trim(Email)) as email,
        safe_cast(`Subscription Date` as date) as subscription_date,
        nullif(trim(Website), '') as website,
        current_timestamp() as load_timestamp,
        '{{ invocation_id }}' as dbt_invocation_id
    from source
)

select * from renamed