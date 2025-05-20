
-- name: CreateBrokerCompanyAgentPropertyMedia :one
INSERT INTO broker_company_agent_properties_media (
    image_url,
    image360_url,
    video_url,
    panaroma_url,
    main_media_section,
    broker_company_agent_properties_id,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING *;

-- name: GetBrokerCompanyAgentPropertyMedia :one
SELECT * FROM broker_company_agent_properties_media 
WHERE id = $1 LIMIT $1;


-- name: GetAllBrokerCompanyAgentPropertyMedia :many
SELECT * FROM broker_company_agent_properties_media
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateBrokerCompanyAgentPropertyMedia :one
UPDATE broker_company_agent_properties_media
SET   image_url = $2,
    image360_url = $3,
    video_url = $4,
    panaroma_url = $5,
    main_media_section = $6,
    broker_company_agent_properties_id = $7,
    created_at = $8,
    updated_at = $9
Where id = $1
RETURNING *;


-- name: DeleteBrokerCompanyAgentPropertyMedia :exec
DELETE FROM broker_company_agent_properties_media
Where id = $1;

-- name: GetAllBrokerCompanyAgentPropertyMediaById :many
Select * from broker_company_agent_properties_media 
WHERE broker_company_agent_properties_id = $1;

-- name: GetBrokerCompanyAgentPropertyMediaByPropertyIdAndMediaSection :one
SELECT * FROM broker_company_agent_properties_media 
WHERE broker_company_agent_properties_id = $1 AND main_media_section = $2  LIMIT 1;


-- name: GetAllBrokerCompanyAgentPropertiesMainMediaSectionById :many
With x As (
 SELECT  main_media_section FROM broker_company_agent_properties_media
 WHERE broker_company_agent_properties_id = $1
) SELECT * From x; 



-- name: GetAllBrokerCompanyAgentPropertiesByMainMediaSectionAndId :one
with x As (
 SELECT * FROM broker_company_agent_properties_media
 WHERE main_media_section = $2 AND broker_company_agent_properties_id = $1
) SELECT * From x; 