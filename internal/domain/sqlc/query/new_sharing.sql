-- Project search queries
-- name: SearchSharedProjects :many
SELECT DISTINCT 
    p.*,
    s.sharing_type,
    s.country_id,
    c.company_name
FROM sharing s
JOIN projects p ON p.id = s.entity_id
LEFT JOIN companies c ON p.developer_companies_id = c.id
WHERE s.entity_type_id = 1
    AND (
        CASE 
            WHEN @created_by::bigint > 0 THEN s.created_by = @created_by
            WHEN @user_id::bigint > 0 THEN s.shared_to = @user_id
            ELSE true
        END
    )
    AND (
        p.project_name ILIKE @query
        OR p.ref_number ILIKE @query
        OR c.company_name ILIKE @query
    )
LIMIT $1
OFFSET $2;

-- Phase search queries
-- name: SearchSharedPhases :many
SELECT DISTINCT 
    ph.*,
    p.project_name,
    p.ref_number,
    s.sharing_type,
    s.country_id,
    c.company_name
FROM sharing s
JOIN phases ph ON ph.id = s.entity_id
JOIN projects p ON ph.projects_id = p.id
LEFT JOIN companies c ON p.developer_companies_id = c.id
WHERE s.entity_type_id = 2
    AND (
        CASE 
            WHEN @created_by::bigint > 0 THEN s.created_by = @created_by
            WHEN @user_id::bigint > 0 THEN s.shared_to = @user_id
            ELSE true
        END
    )
    AND (
        ph.phase_name ILIKE @query
        OR p.project_name ILIKE @query
        OR p.ref_number ILIKE @query
        OR c.company_name ILIKE @query
    )
LIMIT $1
OFFSET $2;

-- Property search queries
-- name: SearchSharedProperties :many
SELECT DISTINCT 
    pv.*,
    p.project_name,
    p.ref_number,
    ph.phase_name,
    s.sharing_type,
    s.country_id,
    c.company_name,
    prop.property_name,
    prop.property_title,
    prop.description
FROM sharing s
JOIN property_versions pv ON pv.id = s.entity_id
JOIN property prop ON prop.id = pv.property_id
LEFT JOIN projects p ON prop.entity_id = p.id AND prop.entity_type_id = 1
LEFT JOIN phases ph ON prop.entity_id = ph.id AND prop.entity_type_id = 2
LEFT JOIN companies c ON p.developer_companies_id = c.id
WHERE s.entity_type_id = 3
    AND (
        CASE 
            WHEN @created_by::bigint > 0 THEN s.created_by = @created_by
            WHEN @user_id::bigint > 0 THEN s.shared_to = @user_id
            ELSE true
        END
    )
    AND (
        prop.property_name ILIKE @query
        OR prop.property_title ILIKE @query
        OR p.project_name ILIKE @query
        OR p.ref_number ILIKE @query
        OR ph.phase_name ILIKE @query
        OR c.company_name ILIKE @query
    )
LIMIT $1
OFFSET $2;

-- Unit search queries
-- name: SearchSharedUnits :many
SELECT DISTINCT 
    uv.*,
    u.unit_no,
    u.unit_title,
    u.description,
    p.project_name,
    p.ref_number,
    ph.phase_name,
    prop.property_name,
    s.sharing_type,
    s.country_id,
    c.company_name
FROM sharing s
JOIN unit_versions uv ON uv.id = s.entity_id
JOIN units u ON u.id = uv.unit_id
LEFT JOIN property prop ON u.entity_id = prop.id 
    AND u.entity_type_id = 3
LEFT JOIN projects p ON (
    (u.entity_type_id = 1 AND u.entity_id = p.id) OR
    (prop.entity_type_id = 1 AND prop.entity_id = p.id)
)
LEFT JOIN phases ph ON (
    (u.entity_type_id = 2 AND u.entity_id = ph.id) OR
    (prop.entity_type_id = 2 AND prop.entity_id = ph.id)
)
LEFT JOIN companies c ON p.developer_companies_id = c.id
WHERE s.entity_type_id = 5
    AND (
        CASE 
            WHEN @created_by::bigint > 0 THEN s.created_by = @created_by
            WHEN @user_id::bigint > 0 THEN s.shared_to = @user_id
            ELSE true
        END
    )
    AND (
        u.unit_no ILIKE @query
        OR u.unit_title ILIKE @query
        OR prop.property_name ILIKE @query
        OR p.project_name ILIKE @query
        OR p.ref_number ILIKE @query
        OR ph.phase_name ILIKE @query
        OR c.company_name ILIKE @query
    )
LIMIT $1
OFFSET $2;

-- Global search across all entities
-- name: SearchAllShared :many
SELECT DISTINCT 
    s.id,
    s.entity_type_id,
    s.entity_id,
    s.sharing_type,
    s.country_id,
    COALESCE(p.project_name, '') as project_name,
    COALESCE(p.ref_number, '') as ref_number,
    COALESCE(ph.phase_name, '') as phase_name,
    COALESCE(prop.property_name, '') as property_name,
    COALESCE(u.unit_no, '') as unit_no,
    COALESCE(u.unit_title, '') as unit_title,
    c.company_name
FROM sharing s
LEFT JOIN projects p ON s.entity_type_id = 1 AND s.entity_id = p.id
LEFT JOIN phases ph ON s.entity_type_id = 2 AND s.entity_id = ph.id
LEFT JOIN property_versions pv ON s.entity_type_id = 3 AND s.entity_id = pv.id
LEFT JOIN property prop ON pv.property_id = prop.id
LEFT JOIN unit_versions uv ON s.entity_type_id = 5 AND s.entity_id = uv.id
LEFT JOIN units u ON uv.unit_id = u.id
LEFT JOIN companies c ON p.developer_companies_id = c.id
WHERE (
    CASE 
        WHEN @created_by::bigint > 0 THEN s.created_by = @created_by
        WHEN @user_id::bigint > 0 THEN s.shared_to = @user_id
        ELSE true
    END
)
AND (
    COALESCE(p.project_name, '') ILIKE @query
    OR COALESCE(p.ref_number, '') ILIKE @query
    OR COALESCE(ph.phase_name, '') ILIKE @query
    OR COALESCE(prop.property_name, '') ILIKE @query
    OR COALESCE(u.unit_no, '') ILIKE @query
    OR COALESCE(u.unit_title, '') ILIKE @query
    OR COALESCE(c.company_name, '') ILIKE @query
)
LIMIT $1
OFFSET $2;

-- Utility query for pagination
-- name: GetSearchTotalCount :one
SELECT COUNT(DISTINCT s.id)
FROM sharing s
WHERE s.entity_type_id = @entity_type_id::bigint
    AND (
        CASE 
            WHEN @created_by::bigint > 0 THEN s.created_by = @created_by
            WHEN @user_id::bigint > 0 THEN s.shared_to = @user_id
            ELSE true
        END
    );


-- name: GetSharedEntities :many
SELECT 
se.id AS sharing_entity_id,
projects.id AS project_id,
projects.project_name AS project_name,
phases.id AS phase_id,
phases.phase_name AS phase_name,
property.id AS property_id,
CASE WHEN @entity_type::bigint = 15 THEN property_versions.title ELSE property.property_name END::VARCHAR AS property_name,
units.id AS unit_id,
units.unit_title AS unit_title,
unit_versions.id AS unit_version_id,
unit_versions.title AS unit_version_title
FROM sharing_entities se
INNER JOIN sharing ON sharing.id = se.sharing_id
LEFT JOIN unit_versions ON unit_versions.id = se.entity_id AND @entity_type::bigint = 14 -- when unit version
LEFT JOIN property_versions ON property_versions.id = se.entity_id AND @entity_type::bigint = 15 -- when property version
LEFT JOIN units ON units.id = unit_versions.unit_id AND @entity_type::bigint = 14 -- when unit version
LEFT JOIN property ON
(CASE
	WHEN  @entity_type::bigint = 15 THEN property.id = property_versions.property_id  -- when property version
	WHEN @entity_type::bigint = 14 THEN property.id = units.entity_id AND units.id = unit_versions.unit_id  -- when unit version
END)
LEFT JOIN phases ON phases.id = property.entity_id AND property.entity_type_id = 2 -- if phase property
LEFT JOIN projects ON 
(CASE 
	WHEN property.entity_type_id = 1 THEN property.entity_id = projects.id 
	WHEN property.entity_type_id = 2 THEN property.entity_id = phases.id AND projects.id = phases.projects_id
END)
WHERE se.entity_type= @entity_type::bigint AND sharing.id = @sharing_id::bigint AND 
CASE WHEN @entity_type::bigint = 15 THEN TRUE ELSE se.property_id = @property_id::bigint END
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');
-- SELECT DISTINCT
--     sqlc.embed(se),
--     projects.id,
--     projects.project_name,

--     COALESCE(ph.id,0)::BIGINT as phase_id,
--     COALESCE(ph.phase_name,'')::VARCHAR as phase_name,


--     COALESCE(p.id,0)::BIGINT as property_id,
--     COALESCE(p.property_name,'')::VARCHAR as property_names,

--     COALESCE(units.id,0)::BIGINT as unit_id, 
--     COALESCE(units.unit_title,'')::VARCHAR as unit_title

-- FROM sharing_entities AS se
-- JOIN sharing ON sharing.id=se.sharing_id
-- JOIN projects ON projects.id=sharing.entity_id and sharing.entity_type_id= @project_entity::bigint
-- LEFT join phases AS ph ON 
-- 	(CASE 
--             WHEN se.entity_type = @phase_entity::BIGINT AND se.phase_id is null and se.property_id is null THEN ph.id = se.entity_id 
--             WHEN se.entity_type =  @property_entity::bigint and se.property_id is null and se.phase_id is not null THEN ph.id = se.phase_id 
--         END)
-- LEFT join property AS p ON 
-- 	(CASE 
--             WHEN se.entity_type = @property_entity::BIGINT AND se.property_id is null and se.phase_id is not null THEN p.id = se.entity_id 
--             WHEN se.entity_type = @unit_entity::bigint and se.property_id is not null and se.phase_id is null THEN p.id = se.property_id 
--         END) 
-- LEFT JOIN units on units.id=se.entity_id and se.entity_type= @unit_entity::bigint
-- WHERE 
--     se.sharing_id= @sharing_id::bigint
-- AND
-- 	se.entity_type= @entity_type_id::bigint 
-- AND 
-- 	(case when @phase_id::bigint= 0 then true else se.phase_id= @phase_id end )
-- AND 
-- 	(case when @property_id::bigint= 0 then true else se.property_id= @property_id end )
-- LIMIT sqlc.narg('limit')
-- OFFSET sqlc.narg('offset');

-- name: GetSharedEntitiesCounts :one
SELECT COUNT(se.id)
FROM sharing_entities se
INNER JOIN sharing ON sharing.id = se.sharing_id
LEFT JOIN unit_versions ON unit_versions.id = se.entity_id AND @entity_type::bigint = 14 -- when unit version
LEFT JOIN property_versions ON property_versions.id = se.entity_id AND @entity_type::bigint = 15 -- when property version
LEFT JOIN units ON units.id = unit_versions.unit_id AND @entity_type::bigint = 14 -- when unit version
LEFT JOIN property ON
(CASE
	WHEN  @entity_type::bigint = 15 THEN property.id = property_versions.property_id  -- when property version
	WHEN @entity_type::bigint = 14 THEN property.id = units.entity_id AND units.id = unit_versions.unit_id  -- when unit version
END)
LEFT JOIN phases ON phases.id = property.entity_id AND property.entity_type_id = 2 -- if phase property
LEFT JOIN projects ON 
(CASE 
	WHEN property.entity_type_id = 1 THEN property.entity_id = projects.id 
	WHEN property.entity_type_id = 2 THEN property.entity_id = phases.id AND projects.id = phases.projects_id
END)
WHERE se.entity_type= @entity_type::bigint AND sharing.id = @sharing_id::bigint AND 
CASE WHEN @entity_type::bigint = 15 THEN TRUE ELSE se.property_id = @property_id::bigint END;
-- SELECT
--    count(se.id)
-- FROM sharing_entities AS se
-- JOIN sharing ON sharing.id=se.sharing_id
-- JOIN projects ON projects.id=sharing.entity_id and sharing.entity_type_id= @project_entity::bigint
-- LEFT join phases AS ph ON 
-- 	(CASE 
--             WHEN se.entity_type = @phase_entity::BIGINT AND se.phase_id is null and se.property_id is null THEN ph.id = se.entity_id 
--             WHEN se.entity_type =  @property_entity::bigint and se.property_id is null and se.phase_id is not null THEN ph.id = se.phase_id 
--         END)
-- LEFT join property AS p ON 
-- 	(CASE 
--             WHEN se.entity_type = @property_entity::BIGINT AND se.property_id is null and se.phase_id is not null THEN p.id = se.entity_id 
--             WHEN se.entity_type = @unit_entity::bigint and se.property_id is not null and se.phase_id is null THEN p.id = se.property_id 
--         END) 
-- LEFT JOIN units on units.id=se.entity_id and se.entity_type= @unit_entity::bigint
-- WHERE 
--     se.sharing_id= @sharing_id::bigint
-- AND
-- 	se.entity_type= @entity_type_id::bigint 
-- AND 
-- 	(case when @phase_id::bigint= 0 then true else se.phase_id= @phase_id end )
-- AND 
-- 	(case when @property_id::bigint= 0 then true else se.property_id= @property_id end )
-- ;


-- name: CheckSharingBySharedTo :one
SELECT sqlc.embed(sharing) FROM sharing 
WHERE id= $1 AND shared_to= $2;