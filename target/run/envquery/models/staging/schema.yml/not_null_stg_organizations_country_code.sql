
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select country_code
from `dotted-hulling-477021-d2`.`dbt_test_staging`.`orgs`
where country_code is null



  
  
      
    ) dbt_internal_test