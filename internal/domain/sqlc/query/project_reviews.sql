-- name: GetAllProjectRating :many
SELECT 
COUNT(project_reviews.id) OVER() AS total_count,
	project_reviews.id,
	project_reviews.ref_no,
	projects.project_name,
	project_reviews.project_clean,
	project_reviews.project_location,
	project_reviews.project_facilities,
	project_reviews.project_securities,
	project_reviews.description,
	users.email,
	(profiles.first_name ||' '|| profiles.last_name)::varchar AS user_name,
	users.phone_number,
	project_reviews.review_date,
	project_reviews.title,
	project_reviews.proof_images
FROM project_reviews 
INNER JOIN projects ON project_reviews.projects_id = projects.id
INNER JOIN users ON project_reviews.reviewer = users.id
INNER JOIN profiles ON users.id= profiles.users_id
WHERE project_reviews.projects_id = $3 AND project_reviews.is_project = TRUE
ORDER BY project_reviews.id DESC
LIMIT $1 OFFSET $2;

-- -- name: UpdateProjectRatingIsVerified :one
-- UPDATE project_reviews 
-- SET is_verified=$2
-- WHERE id=$1
-- RETURNING *;

-- -- name: GetCounterNumberProjectRating :one
-- SELECT COUNT(id)
-- FROM project_reviews 
-- WHERE projects_id=$1 AND is_project=$2;

-- name: GetProjectReviews :many
SELECT  
    p.id as projects_id,
    p.project_name,
    pr.id as reviews_id,
    pr.ref_no,
    pr.project_clean,
    pr.project_location,
    pr.project_facilities,
    pr.project_securities,
    pr.description as review,
    pr.reviewer,
    u.email,
    u.username
FROM 
    projects p 
JOIN 
    project_reviews pr ON pr.projects_id=p.id
JOIN 
    users u ON u.id=pr.reviewer
WHERE 
    p.users_id=$3 AND p.status!=6
LIMIT $1 OFFSET $2;

-- name: GetCountProjectReviews :one
select  
count (*)
from projects p 
join project_reviews pr on pr.projects_id=p.id
where p.users_id=$1 AND p.status!=6;