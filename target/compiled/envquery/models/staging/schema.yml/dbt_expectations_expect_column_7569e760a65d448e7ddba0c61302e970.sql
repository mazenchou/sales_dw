






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and founded_year >= 1800 and founded_year <= 2025
)
 as expression


    from `dotted-hulling-477021-d2`.`dbt_test_staging`.`orgs`
    

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







