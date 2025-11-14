
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with child as (
    select organization_sk as from_field
    from `dotted-hulling-477021-d2`.`dbt_test_core`.`dim_organizations`
    where organization_sk is not null
),

parent as (
    select organization_sk as to_field
    from `dotted-hulling-477021-d2`.`dbt_test_staging`.`orgs`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  
  
      
    ) dbt_internal_test