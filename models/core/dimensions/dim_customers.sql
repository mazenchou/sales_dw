{{ config(
    materialized='table',
    schema='core',
    alias='dim_customers'
) }}

select
    customer_sk,
    customer_id,
    first_name,
    last_name,
    coalesce(company, 'Individual') as customer_type,
    city,
    country_code,
    main_phone,
    email,
    subscription_date,
    load_timestamp
from {{ ref('stg_customers') }}