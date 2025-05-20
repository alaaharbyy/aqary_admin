-- name: CreateLanguage :one
INSERT INTO all_languages (
    language,
    created_at,
    updated_at,
    code,
    flag
)VALUES (
    $1, $2, $3, $4, $5
) RETURNING *;

-- name: GetLanguage :one
SELECT * FROM all_languages 
WHERE id = $1 LIMIT $1;

-- name: GetLanguageByLanguage :one
SELECT * FROM all_languages
Where language ILIKE $1;

-- name: GetAllLanguage :many
SELECT * FROM all_languages
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: GetAllLanguageWithoutPagination :many
SELECT * FROM all_languages
ORDER BY id;

-- name: UpdateLanguage :one
UPDATE all_languages
SET language = $2,
    created_at = $3,
    updated_at = $4,
    code = $5,
    flag = $6
Where id = $1
RETURNING *;


-- name: DeleteLanguage :exec
DELETE FROM all_languages
Where id = $1;


-- name: GetAllLanguagesByIds :many
SELECT * FROM all_languages WHERE all_languages.id = ANY($1::bigint[]);

-- name: GetLanguageNameById :one
SELECT
    id AS language_id,
    language
FROM
    all_languages
WHERE
    id = $1;