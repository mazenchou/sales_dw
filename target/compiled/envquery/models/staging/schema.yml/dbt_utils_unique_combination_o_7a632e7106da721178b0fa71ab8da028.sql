





with validation_errors as (

    select
        organization_id
    from `dotted-hulling-477021-d2`.`dbt_test_staging`.`orgs`
    group by organization_id
    having count(*) > 1

)

select *
from validation_errors


