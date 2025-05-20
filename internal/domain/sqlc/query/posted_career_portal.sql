-- name: AddPostedCareerPortal :one
INSERT INTO posted_career_portal
(ref_no,
careers_id,
job_portals_id,
career_url,
expiry_date,
created_at,
status
)VALUES($1,$2,$3,$4,$5,$6,$7)
RETURNING *;
 

-- name: GetAllPostedCareerPortals :many
SELECT pcp.id, pcp.ref_no, pcp.careers_id, pcp.job_portals_id, pcp.career_url, pcp.expiry_date, pcp.created_at, pcp.status,
jp.id as job_portal_id,
jp.portal_url,
jp.portal_logo,
jp.portal_name,
c.id as careers_id,
c.job_title,
c.career_status,
jp.status as job_portals_status
FROM posted_career_portal as pcp
JOIN job_portals as jp on pcp.job_portals_id= jp.id
JOIN careers as c on pcp.careers_id = c.id
WHERE c.career_status!=6 and c.career_status!=5 and pcp.status!=6 and pcp.status!=5 and jp.status!=6 and jp.status!=5
ORDER BY pcp.created_at DESC
LIMIT $1 OFFSET $2;
 
-- name: UpdatePostedCareerPortalStatus :one
UPDATE posted_career_portal
SET
  status=$2
WHERE 
  id=$1
RETURNING *;

-- name: GetSinglePostedCareerPortal :one
SELECT * FROM posted_career_portal WHERE id=$1;

-- name: GetCountPostedCareerPortal :one
SELECT COUNT(*) FROM posted_career_portal pcp
JOIN job_portals as jp on pcp.job_portals_id= jp.id
JOIN careers as c on pcp.careers_id = c.id
WHERE c.career_status!=6 and c.career_status!=5 and pcp.status!=6 and pcp.status!=5 and jp.status!=6 and jp.status!=5;