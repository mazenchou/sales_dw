

with all_values as (

    select
        employee_count as value_field

    from `dotted-hulling-477021-d2`.`dbt_test_staging`.`orgs`
    

),
set_values as (

    select
        cast('1' as string) as value_field
    union all
    select
        cast('2' as string) as value_field
    union all
    select
        cast('5' as string) as value_field
    union all
    select
        cast('10' as string) as value_field
    union all
    select
        cast('50' as string) as value_field
    union all
    select
        cast('100' as string) as value_field
    union all
    select
        cast('500' as string) as value_field
    union all
    select
        cast('1000' as string) as value_field
    union all
    select
        cast('5000' as string) as value_field
    union all
    select
        cast('10000' as string) as value_field
    
    
),
validation_errors as (
    -- values from the model that are not in the set
    select
        v.value_field
    from
        all_values v
        left join
        set_values s on v.value_field = s.value_field
    where
        s.value_field is null

)

select *
from validation_errors

