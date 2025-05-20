

-- name: CreateInternationalContent :one
INSERT INTO international_content (
    ref_no,
    section_name,
    content,
    created_by
)VALUES (
    $1, $2, $3, $4
) RETURNING *;



-- name: GetAllInternationalContent :many
SELECT * FROM international_content;



-- name: GetInternationalContentById :one
SELECT * FROM international_content
WHERE id = $1 ;



-- name: UpdateInternationalContent :one
UPDATE international_content
SET  ref_no = $2,
    section_name = $3,
    content = $4
WHERE id = $1 RETURNING *;



-- name: DeleteInternationalContent :exec
DELETE FROM international_content
WHERE id = $1;

