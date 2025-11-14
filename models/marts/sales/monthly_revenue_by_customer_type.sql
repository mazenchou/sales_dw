{{ config(
    materialized='table',
    schema='marts_sales'
) }}

select
    date_trunc(order_date, month) as order_month,
    c.customer_type,
    count(distinct f.customer_sk) as active_customers,
    sum(f.quantity) as total_items_sold,
    sum(f.amount) as total_revenue

from {{ ref('fct_orders') }} f
join {{ ref('dim_customers') }} c
    on f.customer_sk = c.customer_sk

group by 1, 2