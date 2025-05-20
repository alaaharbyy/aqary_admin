-- name: CreateExpertise :one
INSERT INTO expertise (title, title_ar, description, status)
VALUES ($1, $2, $3, $4)
RETURNING id;


-- name: UpdateExpertise :one
UPDATE expertise
SET
    title_ar = COALESCE($2, title_ar),
    description = COALESCE($3, description),
    updated_at = COALESCE($4, updated_at)
WHERE id = $1
RETURNING id;


-- name: UpdateExpertiseStatus :one
UPDATE expertise
SET
    status = COALESCE($2, status),
    deleted_at = COALESCE($3, deleted_at),
    updated_at = COALESCE($4, updated_at)
WHERE id = $1
RETURNING id;

 
-- name: GetAllExpertise :many
SELECT
    sqlc.embed(expertise)
FROM expertise
WHERE status = @status::bigint
AND(
    CASE WHEN @search::varchar IS NULL OR @search::varchar = '' THEN
        TRUE
    ELSE
        expertise.title ILIKE '%' || @search::varchar || '%'
        OR expertise.title_ar ILIKE '%' || @search::varchar || '%'
        OR expertise.description ILIKE '%' || @search::varchar || '%'
    END)
ORDER BY
    CASE
        WHEN @status::bigint = @deleted_status::bigint THEN deleted_at
        ELSE updated_at
    END DESC
LIMIT sqlc.narg('limit') OFFSET sqlc.narg('offset');
 
-- name: GetExpertiseCount :one
SELECT COUNT(*)
FROM expertise
WHERE status = @status::bigint
AND(
    CASE WHEN @search::varchar IS NULL OR @search::varchar = '' THEN
        TRUE
    ELSE
        expertise.title ILIKE '%' || @search::varchar || '%'
        OR expertise.title_ar ILIKE '%' || @search::varchar || '%'
        OR expertise.description ILIKE '%' || @search::varchar || '%'
    END);
 
-- name: GetExpertise :one
SELECT sqlc.embed(expertise) FROM expertise
WHERE id = $1;

-- name: ExitingExpertise :one
SELECT EXISTS (
    SELECT 1
    FROM expertise
    WHERE title = $1 and status!= @deleted_status::bigint
) AS exists;

-- name: ExitingExpertiseByStatus :one
SELECT EXISTS (
    SELECT 1
    FROM expertise
    WHERE title = $1 and status= @status::bigint
) AS exists;

 

----------------- company_user_expertise

-- name: CreateCompanyUserExpertise :one
INSERT INTO company_user_expertise (expertise_id, company_user_id)
VALUES ($1, $2)
RETURNING id;

-- name: CheckExitingompanyUserExpertise :one 
SELECT id FROM company_user_expertise 
where expertise_id=$1 AND company_user_id=$2;

-- name: GetCompanyUserExpertise :many
SELECT 
    company_user_expertise.id,
    expertise.id as expertise_id,
    expertise.title,
    expertise.title_ar
FROM company_user_expertise
JOIN expertise ON company_user_expertise.expertise_id = expertise.id  
WHERE company_user_expertise.company_user_id = $1 AND expertise.status!=6
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetCompanyUserExpertiseCount :one
SELECT COUNT(expertise.id) 
FROM company_user_expertise
JOIN expertise ON company_user_expertise.expertise_id = expertise.id
WHERE company_user_expertise.company_user_id = $1  AND expertise.status!=6;

-- name: GetSingleCompanyUserExpertise :one
SELECT 
    company_user_expertise.id,
    expertise.id as expertise_id,
    expertise.title,
    expertise.title_ar
FROM company_user_expertise
JOIN expertise ON company_user_expertise.expertise_id = expertise.id
WHERE company_user_expertise.id = $1;

-- name: DeleteCompanyUserExpertise :exec
DELETE FROM company_user_expertise
WHERE company_user_expertise.id = $1;

-- name: BulkDeleteCompanyUserExpertise :exec
DELETE FROM company_user_expertise
where expertise_id= any(@expertise_ids::bigint[]) AND company_user_id=$1;

