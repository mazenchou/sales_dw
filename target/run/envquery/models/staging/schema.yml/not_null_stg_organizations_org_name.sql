
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select org_name
from `dotted-hulling-477021-d2`.`dbt_test_staging`.`orgs`
where org_name is null



  
  
      
    ) dbt_internal_test