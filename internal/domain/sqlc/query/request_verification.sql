-- name: CreateRequestType :one
INSERT INTO "requests_type" ("type", "status", "created_at", "updated_at")
VALUES ($1, $2, now(), $3)
RETURNING "id", "type", "status", "created_at", "updated_at";

-- name: GetRequestTypeByID :one
SELECT "id", "type", "status", "created_at", "updated_at"
FROM "requests_type"
WHERE "id" = $1;


-- name: ListRequestTypes :many
WITH total_count_cte AS (
    SELECT COUNT(*) AS total_count
    FROM "requests_type"
)
SELECT 
    rt."id",
    rt."type",
    rt."status",
    rt."created_at",
    rt."updated_at",
    (SELECT total_count FROM total_count_cte) AS total_count
FROM "requests_type" rt
ORDER BY rt."created_at" DESC
LIMIT COALESCE(NULLIF($1, 0), NULL) OFFSET COALESCE(NULLIF($2, 0), 0);


-- name: UpdateRequestType :one
UPDATE "requests_type"
SET "type" = $2, "status" = $3, "updated_at" = now()
WHERE "id" = $1
RETURNING "id", "type", "status", "created_at", "updated_at";

-- name: DeleteRequestType :exec
DELETE FROM "requests_type"
WHERE "id" = $1;


-- name: CreateWorkflow :one
INSERT INTO "workflows" ("request_type", "step", "department", "created_at","user_ids")
VALUES ($1, $2, $3, now(),$4)
RETURNING "id", "request_type", "step", "department", "created_at","user_ids";

-- name: GetWorkflowByID :one
SELECT 
    w.id,
    rt.id AS request_type_id,
    rt.type AS request_type,
    d.id AS department_id,
    d.department AS department,
    w.step,
    w.created_at,
    w.user_ids,
    (
        SELECT 
            json_agg(
                json_build_object(
                    'id', users.id,
                    'name', profiles.first_name||' '||profiles.last_name
                )
            )
        FROM users 
        JOIN profiles ON profiles.users_id=users.id
        JOIN LATERAL UNNEST(w.user_ids) AS user_id ON users.id = user_id
    ) AS workflow_users
FROM workflows w
LEFT JOIN requests_type rt ON w.request_type = rt.id
LEFT JOIN department d ON w.department = d.id
WHERE w.id = $1;

-- name: ListWorkflows :many
WITH total_count_cte AS (
    SELECT
        COUNT(*) AS total_count
    FROM
        "workflows"
)
SELECT
    w.id,
    rt.id AS request_type_id,
    rt.type AS request_type,
    d.id AS department_id,
    d.department AS department,
    w.step,
    w.created_at,
    (
        SELECT
            total_count
        FROM
            total_count_cte
    ) AS total_count,
    (
                SELECT
                    jsonb_agg(
                        jsonb_build_object(
                            'id',
                            users.id,
                            'name',
                            profiles.first_name||' '||profiles.last_name
                        )
                    ) AS aqary_management
                FROM
                    users
                INNER JOIN profiles ON profiles.users_id=users.id
                WHERE
                    users.id = ANY(w.user_ids)
    )
FROM
    workflows w
    LEFT JOIN "requests_type" rt ON w.request_type = rt.id
    LEFT JOIN department d ON w.department = d.id
ORDER BY
    w."created_at" DESC
LIMIT
    COALESCE(NULLIF($1, 0), NULL) OFFSET COALESCE(NULLIF($2, 0), 0);



-- name: UpdateWorkflow :one
UPDATE "workflows"
SET "request_type" = $2, "step" = $3, "department" = $4, "user_ids" = $5
WHERE "id" = $1
RETURNING "id", "user_ids", "request_type", "step", "department", "created_at" ;


-- name: DeleteWorkflow :exec
DELETE FROM "workflows"
WHERE "id" = $1;




-- name: GetAqaryManagementByDepartment :many
SELECT
    users.id,
    users.username
FROM
    roles
    INNER JOIN users ON users.status != 6
    AND users.user_types_id = @aqary_mangment_id :: BIGINT
    AND users.roles_id = roles.id
    AND (
        @username :: VARCHAR = ''
        OR users.username ILIKE '%' || @username :: VARCHAR || '%'
    )
WHERE
    roles.department_id = @department_id :: BIGINT
ORDER BY
    users.id
LIMIT
    sqlc.narg('limit') OFFSET sqlc.narg('offset');



-- name: GetAqaryManagementDepartment :many
SELECT
   distinct department.id,
    department.department,
    department.department_ar
FROM
    users
    INNER JOIN roles ON roles.id = users.roles_id
    INNER JOIN department ON department.id = roles.department_id
    AND (
        @department :: VARCHAR = ''
        OR department.department ILIKE '%' || @department :: VARCHAR || '%'
        OR department.department_ar ILIKE '%' || @department :: VARCHAR || '%'
    )
WHERE
    users.status != 6
    AND users.user_types_id = @aqary_mangment_id :: BIGINT
ORDER BY
    department.id
LIMIT
    sqlc.narg('limit') OFFSET sqlc.narg('offset');