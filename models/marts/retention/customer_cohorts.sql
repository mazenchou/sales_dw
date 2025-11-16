{{ config(
    materialized='table',
    schema='marts_retention'
) }}

with first_orders as (
    select
        customer_sk,
        min(date_trunc(order_date, month)) as cohort_month
    from {{ ref('fct_orders') }}
    where order_date is not null
    group by 1
),

monthly_activity as (
    select
        customer_sk,
        date_trunc(order_date, month) as activity_month
    from {{ ref('fct_orders') }}
    where order_date is not null
    group by 1, 2
),

cohorts as (
    select
        fo.cohort_month,
        ma.activity_month,
        fo.customer_sk
    from first_orders fo
    inner join monthly_activity ma
        on fo.customer_sk = ma.customer_sk
        and ma.activity_month >= fo.cohort_month
)

select
    cohort_month,
    activity_month,
    date_diff(activity_month, cohort_month, month) as months_since_cohort,
    count(distinct customer_sk) as active_customers,
    round(
        count(distinct customer_sk) * 100.0 /
        first_value(count(distinct customer_sk)) over (
            partition by cohort_month
            order by activity_month
        ),
        1
    ) as retention_rate_pct
from cohorts
group by 1, 2, 3
order by 1, 2