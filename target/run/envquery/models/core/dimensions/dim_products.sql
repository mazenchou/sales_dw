
  
    

    create or replace table `dotted-hulling-477021-d2`.`dbt_test_core`.`dim_products`
      
    
    

    
    OPTIONS()
    as (
      

select
    product_sk,
    product_id,
    product_name,
    description,
    brand,
    category,
    price,
    currency,
    stock_qty,
    ean,
    color,
    size,
    availability_status,
    load_timestamp
from `dotted-hulling-477021-d2`.`dbt_test_staging`.`products`
    );
  