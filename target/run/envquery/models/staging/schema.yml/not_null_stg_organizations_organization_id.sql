
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select organization_id
from `dotted-hulling-477021-d2`.`dbt_test_staging`.`orgs`
where organization_id is null



  
  
      
    ) dbt_internal_test