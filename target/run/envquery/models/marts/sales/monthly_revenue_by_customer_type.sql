
  
    

    create or replace table `dotted-hulling-477021-d2`.`dbt_test_marts_sales`.`monthly_revenue_by_customer_type`
      
    
    

    
    OPTIONS()
    as (
      

select
    date_trunc(order_date, month) as order_month,
    c.customer_type,
    count(distinct f.customer_sk) as active_customers,
    sum(f.quantity) as total_items_sold,
    sum(f.amount) as total_revenue

from `dotted-hulling-477021-d2`.`dbt_test_core`.`fct_orders` f
join `dotted-hulling-477021-d2`.`dbt_test_core`.`dim_customers` c
    on f.customer_sk = c.customer_sk

group by 1, 2
    );
  