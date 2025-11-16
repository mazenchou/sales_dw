{{ config(
    materialized='table',
    schema='core',
    alias='fct_orders'
) }}

with base_combos as (
    select
        c.customer_sk,
        p.product_sk,
        o.organization_sk,
        pe.person_sk,
        l.lead_sk,
        c.subscription_date,
        p.price
    from {{ ref('dim_customers') }} c
    cross join {{ ref('dim_products') }} p
    left join {{ ref('dim_organizations') }} o
        on c.customer_type != 'Individual' 
        and lower(trim(c.customer_type)) = lower(trim(o.org_name))
    left join {{ ref('dim_people') }} pe
        on mod(abs(farm_fingerprint(concat(c.customer_sk, p.product_sk))), 10) = 0
    left join {{ ref('dim_leads') }} l
        on mod(abs(farm_fingerprint(concat(c.customer_sk, p.product_sk))), 8) = 0
    where c.subscription_date is not null
      and p.price > 0
      and p.availability_status in ('In Stock', 'Limited Stock')
),

sampled as (
    select *,
        mod(abs(farm_fingerprint(concat(customer_sk, product_sk))), 5) as bucket
    from base_combos
),

-- Add a unique row number for each combination
with_row_number as (
    select *,
        row_number() over (order by customer_sk, product_sk, subscription_date) as rn
    from sampled
    where bucket = 0
)

select
    {{ dbt_utils.generate_surrogate_key([
        'customer_sk',
        'product_sk',
        'subscription_date',
        'bucket',
        'rn'  
    ]) }} as order_item_key,

    customer_sk,
    product_sk,
    organization_sk,
    person_sk,
    lead_sk,

    -- Generate order date within 1 year of subscription
    date_add(
        subscription_date,
        interval cast(floor(bucket * 73) as int64) day
    ) as order_date,

    1 + mod(bucket, 3) as quantity,
    price * (1 + mod(bucket, 3)) as amount,

    current_timestamp() as load_timestamp

from with_row_number