{{ config(
    materialized='table',
    schema='core',
    alias='dim_products'
) }}

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
from {{ ref('stg_products') }}