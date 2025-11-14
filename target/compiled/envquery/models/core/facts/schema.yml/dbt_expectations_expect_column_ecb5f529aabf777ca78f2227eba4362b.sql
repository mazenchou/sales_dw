






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and amount >= 1 and amount <= 1000
)
 as expression


    from `dotted-hulling-477021-d2`.`dbt_test_core`.`fct_orders`
    

),
validation_errors as (

    select
        *
    from
        grouped_expression
    where
        not(expression = true)

)

select *
from validation_errors







