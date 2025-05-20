-- name: CreateCompanyActivityDetail :one
INSERT INTO company_activities_detail(
    company_id,
    activity_id,
    title,
    description,
    status,
    created_by,
    created_at,
    updated_at
) VALUES($1,$2,$3,$4,$5,$6,$7,$8)RETURNING *;


-- name: UpdateCompanyActivityDetail :exec
UPDATE company_activities_detail
SET
    title=$2,
    description=$3,
    updated_at=$4
WHERE id=$1;

-- name: UpdateCompanyActivityDetailStatus :exec
UPDATE company_activities_detail
SET
    status=$2,
    updated_at=$3
WHERE id=$1;

-- name: GetCompanyActivityDetails :many
SELECT
   ca.id as activity_id,cad.id, ca.activity_name, cad.description, p.first_name, p.last_name, cad.updated_at, cad.title
FROM
  companies c
JOIN
  company_activities ca
ON
  ca.id = ANY(c.company_activities_id)
left join
company_activities_detail cad on cad.activity_id  = ca.id and cad.company_id = $1 AND cad.status = 2
left join profiles p on p.users_id  = cad.created_by
where c.id = $1
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');
 

-- name: GetCompanyActivityDetailsCount :one
SELECT 
    count(ca.*)
FROM
  companies c
JOIN
  company_activities ca
ON
  ca.id = ANY(c.company_activities_id)
left join
company_activities_detail cad on cad.activity_id  = ca.id and cad.company_id = @company_id AND cad.status = 2
left join profiles p on p.users_id  = cad.created_by
where c.id = @company_id::bigint;


-- name: GetCompanyActivityDetail :one
SELECT
  ca.id as activity_id,cad.id, ca.activity_name, cad.description, p.first_name, p.last_name, cad.updated_at, cad.title
FROM company_activities_detail cad
JOIN
  company_activities ca
  ON
  ca.id = cad.activity_id 
left join profiles p on p.users_id  = cad.created_by
where cad.activity_id  = $1 and cad.company_id  = $2;

-- name: GetSingleCompanyActivityDetail :one
SELECT
  ca.id AS activity_id,
  cad.id,
  ca.activity_name,
  cad.description,
  p.first_name,
  p.last_name,
  cad.updated_at,
  cad.title
FROM companies c
LEFT JOIN company_activities ca
  ON ca.id = ANY(c.company_activities_id)
LEFT JOIN company_activities_detail cad
  ON cad.activity_id = ca.id AND cad.company_id = c.id AND cad.status = 2
LEFT JOIN profiles p
  ON p.users_id = cad.created_by
WHERE c.id = $1 AND ca.id = @activity_id::bigint;