
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from `dotted-hulling-477021-d2`.`dbt_test_core`.`fct_orders`

where not(amount amount > 0)


  
  
      
    ) dbt_internal_test