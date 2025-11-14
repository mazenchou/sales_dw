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
        c.subscription_date,
        p.price
    from {{ ref('dim_customers') }} c
    cross join {{ ref('dim_products') }} p
    left join {{ ref('dim_organizations') }} o
        on c.customer_type != 'Individual' 
        and lower(trim(c.customer_type)) = lower(trim(o.org_name))
    where c.subscription_date is not null
      and p.price > 0
      and p.availability_status in ('In Stock', 'Limited Stock')
),

-- ✅ Deterministic sampling: use HASH of keys instead of RAND()
sampled as (
    select *,
        -- Hash-based sampling: ~20% of rows (mod 5 = 0 → ~20%)
        mod(abs(farm_fingerprint(concat(customer_sk, product_sk))), 5) as bucket
    from base_combos
)

select
    {{ dbt_utils.generate_surrogate_key([
        'customer_sk',
        'product_sk',
        'subscription_date',
        'bucket'
    ]) }} as order_item_key,

    customer_sk,
    product_sk,
    organization_sk,

    -- Generate order date within 1 year of subscription
    date_add(
        subscription_date,
        interval cast(floor(bucket * 73) as int64) day  -- spread over 365 days
    ) as order_date,

    1 + mod(bucket, 3) as quantity,  -- 1–3 items
    price * (1 + mod(bucket, 3)) as amount,

    current_timestamp() as load_timestamp

from sampled
where bucket = 0  -- ✅ Deterministic: exactly ~20% of rows