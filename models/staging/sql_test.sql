select product_id, count(*) as count
from {{ ref('stg_products') }}
group by product_id
having count(*) > 1;