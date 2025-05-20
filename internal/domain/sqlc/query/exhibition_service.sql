-- name: CreateExhibitionService :one
INSERT INTO exhibition_services (
    ref_no,
    service_name,
    image_url,
    created_at,
    updated_at, 
    exhibitions_id
) VALUES (
    $1,
    $2,
    $3,
    $4,
    $5, 
    $6
)RETURNING *;
 
 
-- name: GetAllExhibitionServices :many
SELECT exhibition_services.id, exhibition_services.ref_no, exhibition_services.service_name, exhibition_services.image_url, exhibition_services.created_at, exhibition_services.updated_at, exhibition_services.exhibitions_id,exhibitions.title AS "exhibition name"
FROM exhibition_services
INNER JOIN exhibitions 
ON exhibition_services.exhibitions_id = exhibitions.id AND exhibitions.event_status !=5
ORDER BY exhibition_services.updated_at DESC,exhibition_services.id DESC 
LIMIT $1 
OFFSET $2;
 
-- name: GetNumberOfAllExhibitionsServices :many
SELECT COUNT(es.id)::bigint
FROM exhibition_services es
INNER JOIN exhibitions 
ON exhibitions.id = es.exhibitions_id AND exhibitions.event_status !=5;
 
-- name: GetExhibitionServiceByID :one
SELECT es.id, es.ref_no, es.service_name, es.image_url, es.created_at, es.updated_at, es.exhibitions_id
FROM exhibition_services es
INNER JOIN exhibitions 
ON exhibitions.id = es.exhibitions_id AND exhibitions.event_status !=5 
WHERE es.id = $1;
 
 
-- name: UpdateExhibitionServiceByID :one
UPDATE exhibition_services
SET 
    ref_no = $2,
    service_name = $3,
    image_url = $4,
    updated_at = $5, 
    exhibitions_id=$6
WHERE
    id = $1
RETURNING *;
 
-- name: DeleteExhibitionServiceByID :exec 
DELETE FROM exhibition_services
WHERE id = $1;