-- name: AddJobPortal :one
INSERT INTO job_portals
(portal_name,
portal_url,
portal_logo,
created_at,
status,
updated_at
)VALUES($1,$2,$3,$4,$5,$6)
RETURNING *;

-- name: UpdateJobPortal :one
UPDATE job_portals
SET
portal_name=$1,
portal_url=$2,
portal_logo=$3,
updated_at=$4
WHERE id=$5 AND status!=5 AND status!=6
RETURNING *;

-- name: GetAllJobPortals :many
SELECT * FROM job_portals
WHERE status!=5 AND status!=6
ORDER BY updated_at DESC
LIMIT $1
OFFSET $2;
 
-- name: GetSingleJobPortals :one
SELECT * FROM job_portals 
WHERE id=$1;

-- name: GetSingleJobPortalByName :many
SELECT id, portal_name, portal_url, portal_logo, created_at, status, updated_at FROM job_portals
WHERE portal_name=$1;

-- name: UpdateJobPortalStatus :one
UPDATE job_portals
SET
  status=$1
WHERE 
  id=$2
RETURNING *;
 
-- name: GetCountAllJobPortals :one
SELECT COUNT(*) FROM job_portals WHERE status!=5 AND status!=6;
