-- name: CreateExhibitionClient :one
INSERT INTO exhibition_clients (
    exhibitions_id,
    ref_no,
    client_name,
    website,
    logo_url,
    added_by,
    created_at, 
   client_email
) VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7, 
    $8
)RETURNING *;
 
-- name: GetAllExhibitionClients :many
SELECT exhibition_clients.id, exhibition_clients.exhibitions_id, exhibition_clients.ref_no, exhibition_clients.client_name, exhibition_clients.client_email, exhibition_clients.website, exhibition_clients.logo_url, exhibition_clients.created_at, exhibition_clients.added_by,exhibitions.title AS "exhibition name"
FROM exhibition_clients
INNER JOIN exhibitions 
ON exhibitions.id = exhibition_clients.exhibitions_id AND exhibitions.event_status !=5
ORDER BY exhibition_clients.id DESC
LIMIT $1
OFFSET $2;
 
-- name: GetNumberOfExhibitionClients :one
SELECT COUNT(exhibition_clients.id) 
FROM exhibition_clients
INNER JOIN exhibitions 
ON exhibitions.id = exhibition_clients.exhibitions_id AND exhibitions.event_status !=5;
 
-- name: GetExhibitionClientByID :one
SELECT exhibition_clients.*
FROM exhibition_clients
INNER JOIN exhibitions 
ON exhibitions.id = exhibition_clients.exhibitions_id AND exhibitions.event_status !=5 
WHERE exhibition_clients.id = $1;
 
-- name: UpdateExhibitionClientByID :one
UPDATE exhibition_clients
SET 
    exhibitions_id = $2,
    ref_no = $3,
    client_name = $4,
    website = $5,
    logo_url = $6, 
    client_email=$7
WHERE
    id = $1
RETURNING *;
 
-- name: DeleteExhibitionClientByID :exec
DELETE FROM exhibition_clients
WHERE id = $1;