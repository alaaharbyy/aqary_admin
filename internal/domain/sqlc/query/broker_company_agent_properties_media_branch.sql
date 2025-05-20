
-- name: CreateBrokerCompanyAgentPropertyBranchMedia :one
INSERT INTO broker_company_agent_properties_media_branch (
    image_url,
    image360_url,
    video_url,
    panaroma_url,
    main_media_section,
    broker_company_agent_properties_branch_id,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING *;

-- name: GetBrokerCompanyAgentPropertyBranchMedia :one
SELECT * FROM broker_company_agent_properties_media_branch 
WHERE id = $1 LIMIT $1;


-- name: GetAllBrokerCompanyAgentPropertyBranchMedia :many
SELECT * FROM broker_company_agent_properties_media_branch
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateBrokerCompanyAgentPropertyBranchMedia :one
UPDATE broker_company_agent_properties_media_branch
SET   image_url = $2,
    image360_url = $3,
    video_url = $4,
    panaroma_url = $5,
    main_media_section = $6,
    broker_company_agent_properties_branch_id = $7,
    created_at = $8,
    updated_at = $9
Where id = $1
RETURNING *;


-- name: DeleteBrokerCompanyAgentPropertyBranchMedia :exec
DELETE FROM broker_company_agent_properties_media_branch
Where id = $1;

-- name: GetAllBrokerCompanyAgentPropertyBranchMediaById :many
Select * from broker_company_agent_properties_media_branch 
WHERE broker_company_agent_properties_branch_id = $1;



-- name: GetBranchBrokerCompanyAgentPropertyMediaByPropertyIdAndMediaSection :one
SELECT 
 id,image_url,image360_url,video_url,panaroma_url,
 main_media_section,broker_company_agent_properties_branch_id,
 created_at,updated_at,is_branch 
FROM
 broker_company_agent_properties_media_branch 
WHERE 
 broker_company_agent_properties_branch_id = $1 
AND
  main_media_section = $2;


-- name: GetAllBrokerCompanyAgentBranchPropertiesMainMediaSectionById :many
With x As (
 SELECT  main_media_section FROM broker_company_agent_properties_media_branch
 WHERE broker_company_agent_properties_branch_id  = $1
) SELECT * From x;

-- name: GetAllBrokerCompanyAgentBranchPropertiesByMainMediaSectionAndId :one
with x As (
 SELECT * FROM broker_company_agent_properties_media_branch
 WHERE main_media_section = $2 AND broker_company_agent_properties_branch_id = $1
) SELECT * From x; 