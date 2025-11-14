
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select employee_count
from `dotted-hulling-477021-d2`.`dbt_test_staging`.`orgs`
where employee_count is null



  
  
      
    ) dbt_internal_test