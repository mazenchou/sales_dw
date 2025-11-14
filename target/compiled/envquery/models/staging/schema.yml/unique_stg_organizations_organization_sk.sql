
    
    

with dbt_test__target as (

  select organization_sk as unique_field
  from `dotted-hulling-477021-d2`.`dbt_test_staging`.`orgs`
  where organization_sk is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


