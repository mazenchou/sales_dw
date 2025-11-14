
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select product_sk
from `dotted-hulling-477021-d2`.`dbt_test_core`.`fct_orders`
where product_sk is null



  
  
      
    ) dbt_internal_test