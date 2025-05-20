-- name: GetAllProjectUnitReviews :many
select
ur.*,
u.username,
u.email,
pp.property,
pp.projects_id,
pp.id as properties_id,
un.id as units_id
from project_properties pp 
join units un on un.properties_id=pp.id
join units_reviews ur on ur.units_id=un.id
JOIN users u on u.id=ur.reviewer
where pp.users_id=$3
order by ur.id DESC
LIMIT $1 OFFSET $2;
 
-- name: GetCountProjectUnitReviews :one

select
count(*)
from project_properties pp 
join units un on un.properties_id=pp.id
join units_reviews ur on ur.units_id=un.id
where pp.users_id=$1;