-- name: CreateCareerSpecialization :one
INSERT INTO specialization (title, title_ar)
VALUES ($1, $2)
RETURNING *;
 
-- name: GetCareerSpecializationByTitle :one
SELECT * FROM specialization where title=$1;
 
-- name: GetCareerSpecializationById :one
SELECT * FROM specialization where id=$1;
 
-- name: GetAllSpecialization :many
SELECT id, title, title_ar FROM specialization 
ORDER BY id DESC;
 
-- name: UpdateCareerSpecialization :one
UPDATE specialization
SET title = $1, title_ar = $2
WHERE id = $3
RETURNING *;

-- name: GetAllSpecializations :many
SELECT * FROM specialization;