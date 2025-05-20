-- name: GetProjectPropertiesReviews :many
SELECT 
p.project_name,
pp.property_name,
u.email,
u.username,
pr.*
FROM 
project_properties pp
JOIN properties_reviews pr ON pr.projects_id=pp.projects_id AND pr.properties_id=pp.id
JOIN projects p ON pp.projects_id=p.id
JOIN users u ON u.id=pr.reviewer
WHERE pp.users_id=$1
LIMIT $2
OFFSET $3;
 
-- name: GetCountProjectPropertiesReviews :one
SELECT 
COUNT(*)
FROM 
project_properties pp
JOIN properties_reviews pr ON pr.projects_id=pp.projects_id AND pr.properties_id=pp.id
WHERE pp.users_id=$1;
 
