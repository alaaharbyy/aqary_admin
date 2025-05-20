-- name: UpdateExhibitionQueryByID :one
UPDATE exhibition_queries
SET 
    response = $2,
    responded_by = $3
WHERE
    id = $1 RETURNING *;

-- name: GetAllExhibitionQueries :many
SELECT id, ref_no, exhibitions_id, firstname, lastname, mobile, email, subject, description, response, responded_by, created_at
FROM exhibition_queries
ORDER BY id DESC 
LIMIT $1 
OFFSET $2;
 
 
-- name: GetNumberOfExhibitionQueries :one 
SELECT COUNT(id) 
FROM exhibition_queries;
 
 
-- name: DeleteExhibitionQueryByID :exec
DELETE FROM exhibition_queries
WHERE id = $1;