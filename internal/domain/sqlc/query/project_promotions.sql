-- name: CreateProjectPromotions :one
INSERT INTO project_promotions (
    promotion_types_id,
    description,
    expiry_date,
    status,
    projects_id,
    created_at,
    updated_at, 
    live_status,
    ref_no,
    phases_id,
    is_phase
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11
) RETURNING *;

-- name: GetProjectPromotions :one
SELECT project_promotions.*,
CASE WHEN phases_id IS NULL THEN projects.project_name::VARCHAR ELSE phases.phase_name::VARCHAR END AS project_phase_name,
promotion_types.types AS promotion_type
FROM project_promotions
LEFT JOIN projects ON projects.id = project_promotions.projects_id AND  phases_id IS NULL
LEFT JOIN phases ON phases.id = project_promotions.phases_id
INNER JOIN promotion_types ON promotion_types.id = project_promotions.promotion_types_id
WHERE project_promotions.id = $1 LIMIT 1;


-- name: GetAllProjectPromotions :many
SELECT * FROM project_promotions
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: GetProjectPromotionByProjectAndPhaseID :one
SELECT * FROM project_promotions
WHERE
CASE WHEN projects_id = $1 AND is_phase = FALSE AND phases_id IS NULL THEN TRUE
ELSE is_phase = TRUE AND phases_id = $2 END;

-- name: GetAllProjectPromotionByProjectID :many
SELECT pp.* FROM project_promotions pp
INNER JOIN projects p ON p.id = pp.projects_id 
INNER JOIN addresses a ON a.id = p.addresses_id
WHERE
CASE WHEN projects_id = $3 AND is_phase = FALSE AND phases_id IS NULL THEN TRUE
ELSE is_phase = TRUE AND phases_id = $4 
AND a.countries_id = @country_id::bigint AND CASE WHEN @city_id::bigint = 0 Then true ELSE a.cities_id = @city_id::bigint END AND CASE WHEN @community_id::bigint = 0 THEN true ELSE a.communities_id = @community_id::bigint END
 AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE a.sub_communities_id = @sub_community_id::bigint END
AND pp.status !=5 AND pp.status != 6 END ORDER BY PP.created_at DESC
LIMIT $1 OFFSET $2;


-- name: GetCountAllProjectPromotionByProjectID :one
SELECT COUNT(pp.id) FROM project_promotions pp
INNER JOIN projects p ON p.id = pp.projects_id 
INNER JOIN addresses a ON a.id = p.addresses_id
WHERE
CASE WHEN pp.projects_id = $1 AND pp.is_phase = FALSE AND pp.phases_id IS NULL THEN TRUE
ELSE pp.is_phase = TRUE AND pp.phases_id = $2 END
AND a.countries_id = @country_id::bigint AND CASE WHEN @city_id::bigint = 0 Then true ELSE a.cities_id = @city_id::bigint END 
AND CASE WHEN @community_id::bigint = 0 THEN true ELSE a.communities_id = @community_id::bigint END
AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE a.sub_communities_id = @sub_community_id::bigint END
AND pp.status !=5 AND pp.status != 6;


-- name: GetAllProjectPromotionByProjectIDWithoutPagination :many
SELECT pp.* FROM project_promotions pp
INNER JOIN projects p ON p.id = pp.projects_id 
INNER JOIN addresses a ON a.id = p.addresses_id
WHERE projects_id = $1
-- AND a.countries_id = @country_id::bigint
-- AND CASE WHEN @city_id::bigint = 0 Then true ELSE a.cities_id = @city_id::bigint END
-- AND CASE WHEN @community_id::bigint = 0 THEN true ELSE a.communities_id = @community_id::bigint END
-- AND CASE WHEN @sub_community_id::bigint = 0 THEN true ELSE a.sub_communities_id = @sub_community_id::bigint END
AND pp.status !=5 AND pp.status != 6
ORDER BY PP.created_at DESC;



-- name: UpdateProjectPromotions :one
UPDATE project_promotions
SET    promotion_types_id = $2,
    description = $3,
    expiry_date = $4,
    status = $5,
    projects_id = $6,
    created_at = $7,
    updated_at = $8, 
    live_status = $9,
    ref_no = $10,
    phases_id = $11,
    is_phase = $12
Where id = $1
RETURNING *;

-- name: DeleteProjectPromotions :exec
DELETE FROM project_promotions
Where id = $1;

-- name: UpdateProjectPromotionLiveStatus :one
UPDATE project_promotions
SET live_status = $2
WHERE projects_id = $1
RETURNING *;


-- name: GetCountPromotionsByProjects :one
SELECT COUNT(DISTINCT projects_id) AS project_count FROM project_promotions;



-- name: GetAllProjectsByPromotion :many
SELECT p.* FROM projects p JOIN project_promotions pp ON p.id = pp.projects_id LIMIT $1 OFFSET $2; 

-- name: DeleteAllProjectPromotionsByPromotionTypeId :exec
DELETE FROM project_promotions
Where promotion_types_id = $1; 