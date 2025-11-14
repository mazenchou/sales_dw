

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
from `dotted-hulling-477021-d2`.`dbt_test_staging`.`clients`