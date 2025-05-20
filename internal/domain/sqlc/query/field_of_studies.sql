
-- name: CreateFieldOfStudy :one
INSERT INTO field_of_studies (
    title,
    title_ar,
    created_at,
    updated_at
 ) VALUES (
    $1, $2, $3, $4
) RETURNING *;

-- name: GetAllPaginatedFieldsOfStudy :many
SELECT id, title, title_ar FROM field_of_studies 
ORDER BY id DESC
LIMIT $1
OFFSET $2;
 
-- name: GetAllFieldsOfStudy :many
SELECT * FROM field_of_studies;

-- name: GetFieldsOfStudyByTitle :one
SELECT * FROM field_of_studies where title=$1 LIMIT 1;

-- name: GetCountFieldsOfStudy :one
SELECT COUNT(*) FROM field_of_studies;

-- name: GetFieldsOfStudyByID :one
SELECT * FROM field_of_studies where id=$1;