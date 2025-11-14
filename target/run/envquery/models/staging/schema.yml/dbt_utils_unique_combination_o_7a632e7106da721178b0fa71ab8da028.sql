
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  





with validation_errors as (

    select
        organization_id
    from `dotted-hulling-477021-d2`.`dbt_test_staging`.`orgs`
    group by organization_id
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test