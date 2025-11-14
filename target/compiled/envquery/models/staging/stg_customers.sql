

with source as (
    select * from `dotted-hulling-477021-d2`.`dbt_test_staging`.`customers_100`
),

renamed as (
    select
        -- ✅ Use raw column name (with backticks) in surrogate_key
        to_hex(md5(cast(coalesce(cast(`Customer Id` as string), '_dbt_utils_surrogate_key_null_') as string))) as customer_sk,

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
        'ee6e5a77-04a9-491a-b476-ab30f93ae528' as dbt_invocation_id
    from source
)

select * from renamed