
-- name: CreateXMLURL :one
INSERT INTO xml_url (
url,
company_id,
status,
created_at,
updated_at,
contact_email
)VALUES (
    $1, $2, $3,$4, $5, $6 
) RETURNING *;

-- name: GetXMLURL :one
SELECT 
	sqlc.embed(xml_url),
	companies.company_name,
	companies.company_type
FROM xml_url 
JOIN companies on companies.id= xml_url.company_id
WHERE xml_url.id = $1;

-- name: GetAllXMLURLl :many
SELECT 
	sqlc.embed(xml_url) ,
	companies.company_name
FROM xml_url
JOIN companies on companies.id= xml_url.company_id
ORDER BY xml_url.updated_at DESC
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: UpdateXMLURL :one
UPDATE xml_url
SET  
url = $2,
company_id = $3,
status = $4,
created_at = $5,
updated_at = $6,
contact_email = $7
Where id = $1
RETURNING *;

-- name: DeleteXMLURL :exec
DELETE FROM xml_url
Where id = $1;

-- name: GetCountAllXmlFeedUrls :one
SELECT COUNT(*) FROM xml_url;

-- name: UpdateLastUpdate :exec
UPDATE xml_url
SET last_update = $2
WHERE id = $1;

-- name: GetAllActiveXMLUrls :many
SELECT * FROM xml_url
WHERE status = 1;

-- name: UpdateXMLUrlLastReport :one
UPDATE xml_url SET last_report = $1 
WHERE id = $2
RETURNING *;