{{ config(
    materialized='table',
    schema='staging',
    alias='products'
) }}

with source as (
    select * from {{ ref('products-100') }}
),

renamed as (
    select
        -- Surrogate key (hash of business key)
        {{ dbt_utils.generate_surrogate_key([
    '`Internal ID`',
    'Color',
    'Size'
]) }} as product_sk,

        -- Business key
        `Internal ID` as product_id,

        -- Clean text fields (✅ trim + initcap safe for strings)
        trim(initcap(cast(Name as string))) as product_name,
        nullif(trim(cast(Description as string)), '') as description,
        trim(initcap(cast(Brand as string))) as brand,
        trim(initcap(cast(Category as string))) as category,

        -- Numeric/monetary (✅ safe_cast — no trim!)
        safe_cast(Price as numeric) as price,
        upper(trim(cast(Currency as string))) as currency,
        safe_cast(Stock as int64) as stock_qty,

        -- Identifiers & attributes (✅ trim strings only)
        nullif(trim(cast(EAN as string)), '') as ean,
        trim(cast(Color as string)) as color,
        trim(cast(Size as string)) as size,

        -- Standardized status
-- Standardize availability_status based on observed raw values
        case
        when lower(trim(Availability)) in ('in_stock', 'in stock', 'instock', 'available', 'yes', 'true', '1')
            then 'In Stock'

        when lower(trim(Availability)) in ('out_of_stock', 'out of stock', 'oos', 'unavailable', 'no', 'false', '0')
            then 'Out of Stock'

        when lower(trim(Availability)) in ('pre_order', 'preorder', 'pre-order', 'coming soon')
            then 'Pre-order'

        when lower(trim(Availability)) in ('limited_stock', 'limited stock', 'low stock', 'few left')
            then 'Limited Stock'

        when lower(trim(Availability)) in ('backorder', 'back order', 'on backorder')
            then 'Backorder'

        when lower(trim(Availability)) in ('discontinued', 'discontinued.', 'no longer available')
            then 'Discontinued'

        when coalesce(trim(Availability), '') = '' or Availability is null
            then 'Unknown'

        else initcap(trim(Availability))
        end as availability_status,
        -- Metadata
        current_timestamp() as load_timestamp,
        '{{ invocation_id }}' as dbt_invocation_id
    from source
)

select * from renamed