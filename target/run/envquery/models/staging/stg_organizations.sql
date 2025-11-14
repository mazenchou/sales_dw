
  
    

    create or replace table `dotted-hulling-477021-d2`.`dbt_test_staging`.`orgs`
      
    
    

    
    OPTIONS()
    as (
      

with source as (
    select * from `dotted-hulling-477021-d2`.`dbt_test_staging`.`organizations-100`  -- ← confirm your seed name!
),

renamed as (
    select
        -- Surrogate key (handle potential duplicates via composite)
        to_hex(md5(cast(coalesce(cast(`Organization Id` as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(Name as string), '_dbt_utils_surrogate_key_null_') as string))) as organization_sk,

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
        'ee6e5a77-04a9-491a-b476-ab30f93ae528' as dbt_invocation_id
    from source
)

select * from renamed
    );
  