-- name: CreateExhibitionCollaborator :one
INSERT INTO exhibition_collaborators (
    collaborator_type,
    exhibitions_id,
    company_name,
    company_website,
    company_logo,
    cover_image,
    booth_no,
    is_deleted,
    created_at
) VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9
)RETURNING *;
 
 
-- name: GetExhibitionCollaboratorByID :one 
SELECT exhibition_collaborators.*
FROM exhibition_collaborators
INNER JOIN exhibitions 
ON exhibitions.id = exhibition_collaborators.exhibitions_id AND exhibitions.event_status !=5 
WHERE exhibition_collaborators.id =$1 AND is_deleted!=true;
 
 
-- name: GetAllExhibitionCollaborators :many
SELECT ec.id, ec.collaborator_type, ec.exhibitions_id, ec.company_name, ec.company_website, ec.company_logo, ec.cover_image, ec.is_deleted, ec.created_at, ec.booth_no
FROM exhibition_collaborators ec
INNER JOIN exhibitions
ON exhibitions.id = ec.exhibitions_id AND exhibitions.event_status !=5
WHERE is_deleted!=true AND collaborator_type = $3
ORDER BY ec.id DESC 
LIMIT $1 
OFFSET $2;
 
-- name: GetNumberOfExhibitionCollaborators :one
SELECT COUNT(exhibition_collaborators.id) 
FROM exhibition_collaborators 
INNER JOIN exhibitions 
ON exhibition_collaborators.exhibitions_id =  exhibitions.id AND exhibitions.event_status!=5
WHERE is_deleted!=true AND collaborator_type=$1;
 
 
-- name: UpdateExhibitionCollaboratorByID :one
UPDATE exhibition_collaborators
SET 
    collaborator_type = $2,
    exhibitions_id = $3,
    company_name = $4,
    company_website = $5,
    company_logo = $6,
    cover_image = $7,
    booth_no=$8
WHERE
    id = $1 AND is_deleted!=true 
RETURNING *;
 
 
-- name: DeleteExhibitionCollaboratorByID :exec
UPDATE  exhibition_collaborators 
SET is_deleted =true 
WHERE id=$1 AND is_deleted!=true
RETURNING id;

-- name: DeleteExhibitionByID :exec 
UPDATE exhibitions AS e
SET event_status = 5
WHERE e.id = $1 AND e.event_status != 5
RETURNING id;