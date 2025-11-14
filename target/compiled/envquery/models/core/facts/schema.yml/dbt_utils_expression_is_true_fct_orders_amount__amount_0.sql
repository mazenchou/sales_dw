



select
    1
from `dotted-hulling-477021-d2`.`dbt_test_core`.`fct_orders`

where not(amount amount > 0)

