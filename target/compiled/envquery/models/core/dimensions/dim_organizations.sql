

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
from `dotted-hulling-477021-d2`.`dbt_test_staging`.`orgs`