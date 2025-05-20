-- name: GetConnectionWithStatus :many
WITH x AS (
SELECT 
sc.id,
	sc.requested_by as "user_id",
	'from' as "direction",
    p.first_name,
    cu.company_id,
    --    cu.company_type,
    --    cu.is_branch,
    ct.title AS company_type_title,
    ct.title_ar AS company_type_title_ar,
    sc.request_date,
    (
        SELECT COUNT(*)
        FROM social_connections sc
        WHERE (sc.requested_by = u.id OR sc.user_id = u.id)
        AND sc.connection_status_id = 2
    ) AS total_social_connections
FROM social_connections sc
JOIN users u ON sc.requested_by = u.id
JOIN profiles p ON u.profiles_id = p.id
LEFT JOIN company_users cu ON u.id = cu.users_id
LEFT JOIN company_types ct ON cu.company_type = ct.id
WHERE 
-- sc.user_id = $1
-- AND
 sc.connection_status_id = $1
UNION 
SELECT 
sc.id,
	-- sc.user_id as "user_id",
	'to' as "direction",
    p.first_name,
    cu.company_id,
       cu.company_type,
       cu.is_branch,
    ct.title AS company_type_title,
    ct.title_ar AS company_type_title_ar,
    sc.request_date,
    (
        SELECT COUNT(*)
        FROM social_connections sc
        WHERE 
        -- (sc.requested_by = u.id OR sc.user_id = u.id) AND
         sc.connection_status_id = 2
    ) AS total_social_connections
FROM social_connections sc
-- JOIN users u ON sc.user_id = u.id
JOIN profiles p ON u.profiles_id = p.id
LEFT JOIN company_users cu ON u.id = cu.users_id
LEFT JOIN company_types ct ON cu.company_type = ct.id
WHERE sc.requested_by = $1
AND sc.connection_status_id = $2) SELECT * FROM x LIMIT $3 OFFSET $4;

-- name: GetConnectionWithNotStatus :many
WITH x AS (
SELECT 
	sc.requested_by as "id",
    p.first_name,
    cu.company_id,
    --    cu.company_type,
    --    cu.is_branch,
    ct.title AS company_type_title,
    ct.title_ar AS company_type_title_ar,
    sc.request_date,
    (
        SELECT COUNT(*)
        FROM social_connections sc
        WHERE 
        -- (sc.requested_by = u.id OR sc.user_id = u.id) AND 
        sc.connection_status_id = 2
    ) AS total_social_connections
FROM social_connections sc
JOIN users u ON sc.requested_by = u.id
JOIN profiles p ON u.profiles_id = p.id
LEFT JOIN company_users cu ON u.id = cu.users_id
LEFT JOIN company_types ct ON cu.company_type = ct.id
WHERE 
-- sc.user_id = $1 AND
 sc.connection_status_id != $1
UNION 
SELECT 
	-- sc.user_id as "id",
    p.first_name,
    cu.company_id,
       cu.company_type,
       cu.is_branch,
    ct.title AS company_type_title,
    ct.title_ar AS company_type_title_ar,
    sc.request_date,
    (
        SELECT COUNT(*)
        FROM social_connections sc
        WHERE 
        -- (sc.requested_by = u.id OR sc.user_id = u.id) AND
         sc.connection_status_id = 2
    ) AS total_social_connections
FROM social_connections sc
-- JOIN users u ON sc.user_id = u.id
JOIN profiles p ON u.profiles_id = p.id
LEFT JOIN company_users cu ON u.id = cu.users_id
LEFT JOIN company_types ct ON cu.company_type = ct.id
WHERE sc.requested_by = $1
AND sc.connection_status_id != $2) SELECT * FROM x LIMIT $3 OFFSET $4;

-- name: GetCountConnectionWithNotStatus :one
SELECT 
COUNT (*)
FROM social_connections sc
WHERE 
-- (sc.user_id = $1 OR sc.requested_by = $1) AND
 sc.connection_status_id != $1;

-- name: GetCountConnectionWithStatus :one
SELECT 
COUNT (*)
FROM social_connections sc
WHERE
--  (sc.user_id = $1 OR sc.requested_by = $1) AND
  sc.connection_status_id = $1;


-- name: UpdateSocialConnectionStatus :one
UPDATE social_connections SET connection_status_id = $1, updated_at = $2, remarks = $3 WHERE 
-- user_id = $4 AND
 requested_by = $4
 RETURNING *;

-- name: GetSingleSocialConnection :one
-- SELECT *
-- FROM social_connections
-- WHERE 
--     ("user_id" = $1 AND "requested_by" = $2)
--     OR
--     ("user_id" = $2 AND "requested_by" = $1) LIMIT 1;

-- name: GetSingleOtherSocialConnection :one
-- SELECT *
-- FROM social_connections AS sc1
-- INNER JOIN social_connections AS sc2 ON sc1.requested_by = sc2.user_id
-- WHERE 
--     (sc1.user_id = $1 AND sc2.requested_by = $2)
--     OR
--     (sc1.user_id = $2 AND sc2.requested_by = $1) LIMIT 1;

-- name: CreateSocialConnection :one
INSERT INTO social_connections (
    -- user_id,
    requested_by,
    request_date,
    connection_status_id,
    remarks
) VALUES (
    $1, $2, $3, $4
)
RETURNING *;
 
-- name: UpdateSocialConnection :one
UPDATE social_connections
SET
    connection_status_id = $2,
    updated_at = $3
WHERE
    id = $1
RETURNING *;
 
-- name: UpdateSocialConnectionByUserIdAndRequestedBy :one
UPDATE social_connections
SET
    connection_status_id = $3,
    updated_at = $2
WHERE
    -- user_id = $1 AND 
    requested_by = $1
RETURNING *;

-- name: GetCountConnectionWithNotStatusRequestedBy :one
SELECT 
COUNT (*)
FROM social_connections sc
WHERE sc.requested_by = $1
AND sc.connection_status_id != $2;

-- name: GetCountConnectionWithNotStatusUser :one
SELECT 
COUNT (*)
FROM social_connections sc
WHERE 
-- sc.user_id = $1 AND
 sc.connection_status_id != $1;

-- name: GetCountConnectionWithStatusRequestedBy :one
SELECT 
COUNT (*)
FROM social_connections sc
WHERE sc.requested_by = $1
AND sc.connection_status_id = $2;

-- name: GetCountConnectionWithStatusUser :one
SELECT 
COUNT (*)
FROM social_connections sc
WHERE 
-- sc.user_id = $1 AND
 sc.connection_status_id = $1;


-- name: GetConnectionWithStatusRequesteBy :many
SELECT 
	-- sc.user_id as "id",
    p.first_name,
    cu.company_id,
    --    cu.company_type,
    --    cu.is_branch,
    ct.title AS company_type_title,
    ct.title_ar AS company_type_title_ar,
    sc.request_date,
    (
        SELECT COUNT(*)
        FROM social_connections sc
        WHERE 
        -- (sc.requested_by = u.id OR sc.user_id = u.id) AND
         sc.connection_status_id = 2
    ) AS total_social_connections
FROM social_connections sc
-- JOIN users u ON sc.user_id = u.id
JOIN profiles p ON u.profiles_id = p.id
LEFT JOIN company_users cu ON u.id = cu.users_id
LEFT JOIN company_types ct ON cu.company_type = ct.id
WHERE sc.requested_by = $1
AND sc.connection_status_id = $2 LIMIT $3 OFFSET $4;

-- name: GetConnectionWithStatusUser :many
SELECT 
	sc.requested_by as "id",
    p.first_name,
    cu.company_id,
    --    cu.company_type,
    --    cu.is_branch,
    ct.title AS company_type_title,
    ct.title_ar AS company_type_title_ar,
    sc.request_date,
    (
        SELECT COUNT(*)
        FROM social_connections sc
        WHERE 
        -- (sc.requested_by = u.id OR sc.user_id = u.id) AND 
        sc.connection_status_id = 2
    ) AS total_social_connections
FROM social_connections sc
JOIN users u ON sc.requested_by = u.id
JOIN profiles p ON u.profiles_id = p.id
LEFT JOIN company_users cu ON u.id = cu.users_id
LEFT JOIN company_types ct ON cu.company_type = ct.id
WHERE 
-- sc.user_id = $1 AND
 sc.connection_status_id = $1 LIMIT $2 OFFSET $3;

-- -- name: GetSingleOneWaySocialConnection :one
-- SELECT *
-- FROM social_connections
-- WHERE 
--     ("user_id" = $1 AND "requested_by" = $2) LIMIT 1;

-- name: DeleteSocialConnectionByUserIdAndRequesteBy :exec
DELETE FROM social_connections WHERE connection_status_id = $1 
-- AND user_id = $2 
AND requested_by = $2;

-- name: DeleteSocialConnectionByID :exec
DELETE FROM social_connections WHERE id = $1;