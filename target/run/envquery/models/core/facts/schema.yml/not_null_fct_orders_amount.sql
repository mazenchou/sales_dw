
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select amount
from `dotted-hulling-477021-d2`.`dbt_test_core`.`fct_orders`
where amount is null



  
  
      
    ) dbt_internal_test