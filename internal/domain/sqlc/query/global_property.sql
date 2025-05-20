-- name: GetGlobalPropertiesByStatusID :many
SELECT property.*,property_versions.ref_no,ph.phase_name, ph1.phase_name, pr.project_name,pr1.project_name, addresses.full_address, global_property_type.type AS property_type
FROM property
LEFT JOIN global_property_type ON property.property_type_id = global_property_type.id
INNER JOIN addresses ON property.addresses_id = addresses.id 
INNER JOIN countries ON addresses.countries_id = countries.id  
INNER JOIN states ON addresses.states_id = states.id   
INNER JOIN cities ON addresses.cities_id = cities.id
INNER JOIN companies ON property.company_id = companies.id 
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
LEFT JOIN property_versions ON property_versions.property_id = property.id
LEFT JOIN phases ph ON ph.id = property.entity_id and property.entity_type_id = 2
LEFT JOIN projects pr ON pr.id=ph.projects_id
LEFT JOIN projects pr1 ON pr1.id= property.entity_id and property.entity_type_id = 1
LEFT JOIN phases ph1 ON ph1.projects_id =pr.id
WHERE
-- SEARCH CRITERIA
    (CASE WHEN @search = '%%' THEN TRUE 
    ELSE 
        property.property_name % @search OR 
        property.property_title % @search OR
        countries.country % @search OR 
        global_property_type."type" % @search OR 
        states."state" % @search OR 
        cities.city % @search OR 
        companies.company_name % @search 
        -- sub_communities.sub_community % @search
    END )
    AND property.status = @status::bigint
    AND (CASE WHEN @entity_Id::bigint = 0 THEN (property.entity_type_id = ANY(@entity_type_id::bigint[])) ELSE (property.entity_id = @entity_Id::bigint AND property.entity_type_id  = ANY(@entity_type_id::bigint[] ))   END)
    AND (CASE WHEN @usage::bigint = 0 THEN true ELSE global_property_type.usage = @usage::bigint END)
    -- AND (CASE WHEN @company_id::bigint = 0 THEN property.user_id = @user_id::bigint ELSE property.company_id = @company_id::bigint END)
      AND CASE WHEN @is_admin::BOOLEAN = true THEN true ELSE (
        @is_company_user != true
        OR (
            (@company_branch != false OR property.company_id = @company_id::bigint)
            AND (@company_branch != true OR property.company_id = @company_id::bigint)
        )
    ) END
    -- Location filters
    AND (@country_id::bigint = 0 OR addresses.countries_id = @country_id::bigint)
    -- AND (@state_id::bigint = 0 OR addresses.states_id = @state_id::bigint)
    AND (@city_id::bigint = 0 OR addresses.cities_id = @city_id::bigint)
    AND (@community_id::bigint = 0 OR addresses.communities_id = @community_id::bigint)
    AND (@sub_community_id::bigint = 0 OR addresses.sub_communities_id = @sub_community_id::bigint)
GROUP BY property.id, global_property_type.type, addresses.full_address,property_versions.id, pr.id, ph.id, ph1.id, pr1.id
ORDER BY property.updated_at DESC
LIMIT $1 OFFSET $2;

-- name: GetGlobalPropertiesCountByStatusID :one
SELECT COUNT(property.*)
FROM property
LEFT JOIN global_property_type ON property.property_type_id = global_property_type.id
INNER JOIN addresses ON property.addresses_id = addresses.id 
INNER JOIN countries ON addresses.countries_id = countries.id  
INNER JOIN states ON addresses.states_id = states.id   
INNER JOIN cities ON addresses.cities_id = cities.id
INNER JOIN companies ON property.company_id = companies.id 
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
WHERE
-- SEARCH CRITERIA
    (CASE WHEN @search = '%%' THEN TRUE 
    ELSE 
        property.property_name % @search OR 
        property.property_title % @search OR
        countries.country % @search OR 
        global_property_type."type" % @search OR 
        states."state" % @search OR 
        cities.city % @search OR 
        companies.company_name % @search 
        -- sub_communities.sub_community % @search
    END )
    AND property.status = @status::bigint
    AND (CASE WHEN @entity_Id::bigint = 0 THEN (property.entity_type_id = ANY(@entity_type_id::bigint[])) ELSE (property.entity_id = @entity_Id::bigint AND property.entity_type_id  = ANY(@entity_type_id::bigint[] ))   END)
    AND (CASE WHEN @usage::bigint = 0 THEN true ELSE global_property_type.usage = @usage::bigint END)
    -- AND (CASE WHEN @company_id::bigint = 0 THEN property.user_id = @user_id::bigint ELSE property.company_id = @company_id::bigint END)
      AND CASE WHEN @is_admin::BOOLEAN = true THEN true ELSE (
        @is_company_user != true
        OR (
            (@company_branch != false OR property.company_id = @company_id::bigint)
            AND (@company_branch != true OR property.company_id = @company_id::bigint)
        )
    ) END
    -- Location filters
    AND (@country_id::bigint = 0 OR addresses.countries_id = @country_id::bigint)
    -- AND (@state_id::bigint = 0 OR addresses.states_id = @state_id::bigint)
    AND (@city_id::bigint = 0 OR addresses.cities_id = @city_id::bigint)
    AND (@community_id::bigint = 0 OR addresses.communities_id = @community_id::bigint)
    AND (@sub_community_id::bigint = 0 OR addresses.sub_communities_id = @sub_community_id::bigint);


-- name: GetProjectPropertyCount :one
select count(*) from property where entity_id= $1 and entity_type_id =1 and status!=6;


-- name: GetPhasePropertyCount :one
select count(*) from property where entity_id= $1 and entity_type_id =2 and status!=6;

-- name: CreateNewProperty :one
INSERT INTO property (
    company_id,
    property_type_id, 
    property_title, 
    property_title_arabic, 
    is_verified, 
    addresses_id, 
    entity_type_id,
    entity_id,
    status,
    is_show_owner_info,
    property_name, 
    description, 
    description_arabic,
    owner_users_id,
    user_id,
    from_xml,
    facts,
    updated_by,
    notes,
    notes_ar,
	is_public_note,
    is_project_property,
    unit_type_id
) VALUES (
    $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,
    $14,$15,$16,$17,$18,$19,$20,$21,$22,$23
)RETURNING *;
 
-- name: CreatePropertyVersion :one
INSERT INTO property_versions (
title,
title_arabic,
description,
description_arabic,
property_id,
property_rank,
facts,
updated_by,
agent_id,
ref_no,
is_main,
is_verified,
exclusive,
start_date,
end_date,
category,
refreshed_at
) VALUES (
    $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17
)RETURNING *;
 
-- name: CreatePropertyAgents :one
INSERT INTO property_agents (
property_id,
agent_id,
note,
assignment_date
) VALUES (
    $1,$2,$3,$4
)RETURNING *;

-- name: GetGlobalUnitByStatusID :many
SELECT units.*, addresses.full_address,
unit_versions.ref_no AS unit_ref_no, 
unit_versions."type" AS unit_category, 
unit_versions.title,
property.property_name AS property_name
FROM  unit_versions
LEFT JOIN units ON unit_versions.unit_id = units.id
INNER JOIN property ON units.entity_Id = property.id
INNER JOIN addresses ON units.addresses_id = addresses.id 
INNER JOIN countries ON addresses.countries_id = countries.id  
INNER JOIN states ON addresses.states_id = states.id   
INNER JOIN cities ON addresses.cities_id = cities.id
INNER JOIN companies ON units.company_id = companies.id
WHERE 
-- SEARCH CRITERIA
    (@search = '%%' OR 
        unit_versions.title % @search OR 
        unit_versions.title_arabic % @search OR 
        countries.country % @search OR 
        states."state" % @search OR 
        cities.city % @search OR 
        companies.company_name % @search OR
        property.property_name % @search 
    )
AND unit_versions.status = @status::bigint
AND (CASE WHEN @entity_type_id::bigint = 0 THEN units.entity_Id IS NULL ELSE units.entity_type_id = @entity_type_id::bigint   END)
AND (CASE WHEN @company_id::bigint = 0 THEN units.created_by = @user_id::bigint ELSE units.company_id = @company_id::bigint END)
GROUP BY units.id, unit_versions.ref_no, unit_versions."type", unit_versions.title, property.property_name
ORDER BY units.id
LIMIT $1 OFFSET $2;

-- name: GetGlobalUnitCountByStatusID :one
SELECT COUNT(units.id)
FROM  unit_versions
LEFT JOIN units ON unit_versions.unit_id = units.id
INNER JOIN property ON units.entity_Id = property.id
INNER JOIN addresses ON units.addresses_id = addresses.id 
INNER JOIN countries ON addresses.countries_id = countries.id  
INNER JOIN states ON addresses.states_id = states.id   
INNER JOIN cities ON addresses.cities_id = cities.id
INNER JOIN companies ON units.company_id = companies.id
WHERE 
-- SEARCH CRITERIA
    (@search = '%%' OR 
        unit_versions.title % @search OR 
        unit_versions.title_arabic % @search OR 
        countries.country % @search OR 
        states."state" % @search OR 
        cities.city % @search OR 
        companies.company_name % @search OR
        property.property_name % @search 
    )
AND unit_versions.status = @status::bigint
AND (CASE WHEN @entity_type_id::bigint = 0 THEN units.entity_Id IS NULL ELSE units.entity_type_id = @entity_type_id::bigint  END)
AND (CASE WHEN @company_id::bigint = 0 THEN units.created_by = @user_id::bigint ELSE units.company_id = @company_id::bigint END)
GROUP BY units.id
ORDER BY units.id;

-- name: GetUnitTypeVariationByStatusID :many
SELECT unit_type_variation.*,unit_type.type,unit_type.type_ar,property.property_name
FROM unit_type_variation
INNER JOIN unit_type ON unit_type.id = unit_type_variation.unit_type_id
INNER JOIN property ON property.id = unit_type_variation.property_id
WHERE 
-- SEARCH CRITERIA
    (@search = '%%' OR 
        unit_type_variation.title % @search OR 
        unit_type_variation.title_ar % @search OR 
        unit_type_variation.description % @search OR 
        unit_type_variation.ref_no % @search
    )
    AND unit_type_variation.status = @status::bigint
    AND CASE WHEN @property_id::bigint = 0 THEN true ELSE unit_type_variation.property_id = @property_id::bigint END
ORDER BY unit_type_variation.updated_at desc
LIMIT $1 OFFSET $2;

-- name: GetUnitTypeVariationCountByStatusID :one
SELECT COUNT(unit_type_variation.id)
FROM unit_type_variation
INNER JOIN unit_type ON unit_type.id = unit_type_variation.unit_type_id
INNER JOIN property ON property.id = unit_type_variation.property_id
WHERE 
-- SEARCH CRITERIA
    (@search = '%%' OR 
        unit_type_variation.title % @search OR 
        unit_type_variation.title_ar % @search OR 
        unit_type_variation.description % @search OR 
        unit_type_variation.ref_no % @search
    )
AND unit_type_variation.status = @status::bigint
AND CASE WHEN @property_id::bigint = 0 THEN true ELSE unit_type_variation.property_id = @property_id::bigint END;

-- name: GetUnitTypeVariationByID :one
SELECT unit_type_variation.*, unit_type.type AS unit_type_name, unit_type.type_ar AS unit_type_name_ar
FROM unit_type_variation
inner join unit_type on unit_type_variation.unit_type_id = unit_type.id
WHERE  unit_type_variation.id = @id::bigint
AND unit_type_variation.status != 6
LIMIT 1;


-- name: DeleteUnitTypeVariationsById :exec
UPDATE unit_type_variation
SET status = 6,
updated_at=now()
WHERE unit_type_variation.id = @id::bigint;

-- name: RestoreUnitTypeVariationsById :exec
UPDATE unit_type_variation
SET status = 1,
updated_at=now()
WHERE unit_type_variation.id = @id::bigint;

-- name: GetGlobalPropertyById :one
SELECT *
FROM property
WHERE property.id = @id::bigint
LIMIT 1;

-- name: GetCompanyUserCountByUserAndCompany :one
SELECT COUNT(company_users.id)
FROM company_users
WHERE company_users.users_id = @id::bigint
AND company_users.company_id = @companyID::bigint
GROUP BY company_users.id
ORDER BY company_users.id;

-- name: UpdateGlobalProperty :one
UPDATE property
SET company_id = $1,
    property_type_id= $2,
    property_title = $3,
    property_title_arabic = $4,
    is_verified = $5,
    addresses_id = $7,
    status = $8,
    entity_type_id = $9,
    entity_id = $10,
    is_show_owner_info = $11,
    facts = $12,
    user_id = $13,
    property_name = $14,
    description = $15,
    description_arabic = $16,
    owner_users_id = $17,
    from_xml = $18,
    updated_by = $19,
    notes = $20,
    notes_ar= $21,
    is_public_note = $22,
    is_project_property = $23,
    unit_type_id = $24
WHERE id = $6
RETURNING *;

-- name: UpdatePropertyVersion :one
UPDATE property_versions
SET title = $1,
    title_arabic= $2,
    description = $3,
    description_arabic = $4,
    property_id = $5,
    property_rank = $6,
    facts = $7,
    updated_at = $8,
    updated_by = $9,
    status = $10,
    agent_id = $11,
    ref_no = $12,
    category = $13,
    has_gallery = $14,
    has_plans = $15,
    is_main = $16,
    is_verified = $17,
    exclusive = $18,
    start_date = $19,
    end_date = $20
WHERE id = $21
RETURNING *;


-- name: GetPropertyByPropertyId :one
select * from property where id = $1 and status != 6;

-- name: UpdateGlobalPropertyStatus :one
UPDATE property
SET status = $1,
	updated_by = $2,
 	updated_at = Now()
WHERE id = $3
RETURNING *;

-- name: UpdatePropertyVersionStatus :one
UPDATE property_versions
SET status = $1,
	updated_by = $2,
 	updated_at = Now()    
WHERE id = $3
RETURNING *;



-- name: CreateUnitTypeVariation :one
INSERT INTO unit_type_variation (
    description,
    description_ar,
    min_area, 
    max_area, 
    min_price, 
    max_price, 
    parking,
    balcony, 
    bedrooms,
    bathroom,
    property_id,
    title,
    title_ar,
    ref_no,
    image_url, 
    status, 
    unit_type_id  
) VALUES (
    $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16, $17
)RETURNING *;



-- name: UpdateUnitTypeVariation :one
UPDATE unit_type_variation
SET
    description= $1,
    description_ar= $2,
    min_area= $3,
    max_area= $4, 
    min_price= $5,
    max_price= $6, 
    parking= $7,
    balcony= $8,
    bedrooms= $9,
    bathroom= $10,
    property_id= $11,
    title= $12,
    title_ar= $13, 
    unit_type_id= $14,
    updated_at=$15,
    image_url=$16
WHERE id= $17
RETURNING *;


-- name: GetUnitTypeVariationById :one
SELECT * from unit_type_variation where id=$1 and status!=6;


-- name: GetProperties :many
Select p.*,pv.ref_no, pv.category,pv.facts,
COALESCE(CAST(pq.quality_score AS FLOAT), 0.0) AS quality_score  from property p
LEFT JOIN (SELECT DISTINCT ON (property_id)property_id,ref_no, category, facts
    FROM property_versions
    ORDER BY property_id, created_at DESC  
) pv ON p.id = pv.property_id
LEFT JOIN addresses a on p.addresses_id = a.id
LEFT JOIN property_quality_score pq on pq.property_id = p.id
WHERE CASE @is_local::BOOLEAN
   WHEN true THEN (a.countries_id = 1)
   WHEN false THEN (a.countries_id != 1)
END
AND p.status !=6 AND p.entity_type_id!=1 AND p.entity_type_id!=2 AND p.is_project_property IS FALSE
ORDER BY p.id desc
LIMIT $1 OFFSET $2;

-- name: GetPropertiesCount :one
Select count(p.*) from property p 
LEFT JOIN (SELECT DISTINCT ON (property_id)property_id,ref_no, category
    FROM property_versions
    ORDER BY property_id, created_at DESC  
) pv ON p.id = pv.property_id
LEFT JOIN addresses a on p.addresses_id = a.id
LEFT JOIN property_quality_score pq on pq.property_id = p.id
WHERE CASE @is_local::BOOLEAN
   WHEN true THEN (a.countries_id = 1)
   WHEN false THEN (a.countries_id != 1)
END
AND p.status !=6 AND p.entity_type_id!=1 AND p.entity_type_id!=2 AND p.is_project_property IS FALSE;

-- name: GetPropertyVersionsLocal :many
select pv.*,p.*,COALESCE(CAST(pq.quality_score AS FLOAT), 0.0) AS quality_score from property_versions pv
inner join property p on pv.property_id =p.id
LEFT JOIN addresses a on p.addresses_id = a.id
LEFT JOIN property_quality_score pq on pq.property_id = p.id
WHERE a.countries_id = $3
AND
     (
        @company_id::BIGINT = 0 
        OR c.id = @company_id::BIGINT
        AND cu.company_id = @company_id::BIGINT
    )
    AND 
    (
        @agent_id::BIGINT = 0 
        OR pv.agent_id = @agent_id::BIGINT
    )
AND p.status !=6 AND p.entity_type_id!=1 AND p.entity_type_id!=2 AND p.is_project_property IS FALSE AND pv.status!=6
ORDER BY p.id desc
LIMIT $1 OFFSET $2;

-- name: GetPropertyVersionsInternational :many
select pv.*,p.*,COALESCE(CAST(pq.quality_score AS FLOAT), 0.0) AS quality_score from property_versions pv
inner join property p on pv.property_id =p.id
LEFT JOIN addresses a on p.addresses_id = a.id
LEFT JOIN property_quality_score pq on pq.property_id = p.id
WHERE a.countries_id != $3
AND
     (
        @company_id::BIGINT = 0 
        OR c.id = @company_id::BIGINT
        AND cu.company_id = @company_id::BIGINT
    )
    AND 
    (
        @agent_id::BIGINT = 0 
        OR pv.agent_id = @agent_id::BIGINT
    )
AND p.status !=6 AND p.entity_type_id!=1 AND p.entity_type_id!=2 AND p.is_project_property IS FALSE AND pv.status!=6
ORDER BY p.id desc
LIMIT $1 OFFSET $2;


-- name: GetPropertiesVersionsCountLocal :one
select count(pv.*) from property_versions pv 
inner join property p on pv.property_id =p.id
LEFT JOIN addresses a on p.addresses_id = a.id
LEFT JOIN property_quality_score pq on pq.property_id = p.id
WHERE a.countries_id = $1
AND
     (
        @company_id::BIGINT = 0 
        OR c.id = @company_id::BIGINT
        AND cu.company_id = @company_id::BIGINT
    )
    AND 
    (
        @agent_id::BIGINT = 0 
        OR pv.agent_id = @agent_id::BIGINT
    )
AND p.status !=6 AND p.entity_type_id!=1 AND p.entity_type_id!=2 AND p.is_project_property IS FALSE AND pv.status!=6;

-- name: GetPropertyVersions :many
select pv.*,p.*,COALESCE(CAST(pq.quality_score AS FLOAT), 0.0) AS quality_score from property_versions pv
inner join property p on pv.property_id =p.id
inner join global_property_type gp on p.property_type_id =gp.id
LEFT JOIN addresses a on p.addresses_id = a.id
LEFT JOIN property_quality_score pq on pq.property_id = p.id
WHERE CASE @is_local::BOOLEAN
   WHEN true THEN (a.countries_id = 1)
   WHEN false THEN (a.countries_id != 1)
END
AND CASE WHEN @usage= 0 THEN true ELSE gp."usage" = @usage END
AND CASE WHEN @life_style= 0 THEN true ELSE (pv.facts->'life_style')::bigint = @life_style END
AND p.status !=6 AND p.entity_type_id!=1 AND p.entity_type_id!=2 AND p.is_project_property IS FALSE AND pv.status!=6
ORDER BY p.id desc
LIMIT $1 OFFSET $2;


-- name: GetPropertiesVersionsCount :one
select count(pv.*) from property_versions pv 
inner join property p on pv.property_id =p.id
inner join global_property_type gp on p.property_type_id =gp.id
LEFT JOIN addresses a on p.addresses_id = a.id
LEFT JOIN property_quality_score pq on pq.property_id = p.id
WHERE CASE @is_local::BOOLEAN
   WHEN true THEN (a.countries_id = 1)
   WHEN false THEN (a.countries_id != 1)
END
AND CASE WHEN @usage= 0 THEN true ELSE gp."usage" = @usage END
AND CASE WHEN @life_style= 0 THEN true ELSE (pv.facts->'life_style')::bigint = @life_style END
AND p.status !=6 AND p.entity_type_id!=1 AND p.entity_type_id!=2 AND p.is_project_property IS FALSE AND pv.status!=6;

-- name: GetPropertiesVersionsCountInternational :one
select count(pv.*) from property_versions pv 
inner join property p on pv.property_id =p.id
LEFT JOIN addresses a on p.addresses_id = a.id
LEFT JOIN property_quality_score pq on pq.property_id = p.id
WHERE a.countries_id != $1
AND
     (
        @company_id::BIGINT = 0 
        OR c.id = @company_id::BIGINT
        AND cu.company_id = @company_id::BIGINT
    )
    AND 
    (
        @agent_id::BIGINT = 0 
        OR pv.agent_id = @agent_id::BIGINT
    )
AND p.status !=6 AND p.entity_type_id!=1 AND p.entity_type_id!=2 AND p.is_project_property IS FALSE AND pv.status!=6;

-- name: GetSinglePropertyVersionsById :one
SELECT
    pv.*,
    p.*,
    jsonb_agg(distinct 
        jsonb_build_object(
            'id', unit_type.id, 
            'type', unit_type."type",
            'type_ar', unit_type.type_ar

        )
    ) AS unit_type_obj,
    sqlc.embed(countries),
    COALESCE(states.id, 0) AS state_id,
    COALESCE(states.state, '') AS state_name,
    COALESCE(states.countries_id, 0) AS state_countries_id,
    COALESCE(states.created_at, '1970-01-01'::timestamp) AS state_created_at,
    COALESCE(states.updated_at, '1970-01-01'::timestamp) AS state_updated_at,
    COALESCE(states.lat, 0.0) AS state_lat,
    COALESCE(states.lng, 0.0) AS state_lng,
    
    COALESCE(cities.id, 0) AS city_id,
    COALESCE(cities.city, '') AS city_name,
    COALESCE(cities.states_id, 0) AS city_states_id,
    COALESCE(cities.created_at, '1970-01-01'::timestamp) AS city_created_at,
    COALESCE(cities.updated_at, '1970-01-01'::timestamp) AS city_updated_at,
    COALESCE(cities.lat, 0.0) AS city_lat,
    COALESCE(cities.lng, 0.0) AS city_lng,
    COALESCE(communities.id,0) AS community_id,
    COALESCE(communities.community,'') AS community,
    COALESCE(sub_communities.id,0) AS sub_communities_id,
    COALESCE(sub_communities.sub_community,'') AS sub_communities,
    locations.id AS location_id,
    locations.lat AS location_lat,
    locations.lng AS location_lng,
    jsonb_agg(distinct 
        jsonb_build_object(
            'id', facilities_amenities.id, 
            'icon_url', facilities_amenities.icon_url, 
            'title', facilities_amenities.title,
            'title_ar', facilities_amenities.title_ar,
            'type', facilities_amenities.type,
            'category', categories.category
            -- 'category', jsonb_build_object(    -- Add category as a nested JSON object
            --     'name', categories.category
            -- )
        )
    ) AS facilities_amenities_obj,
    jsonb_agg(distinct 
        jsonb_build_object(
            'id', v.id,
            'title', v.title,
            'title_ar', v.title_ar
        )
    ) AS views,
    companies.company_name,
    global_property_type."type",
    global_property_type.property_type_facts
FROM property_versions pv 
INNER JOIN property p on p.id =pv.property_id
INNER JOIN addresses ON addresses.id = p.addresses_id
INNER JOIN countries ON countries.id = addresses.countries_id
LEFT JOIN states ON states.id = addresses.states_id
LEFT JOIN cities ON cities.id = addresses.cities_id
LEFT JOIN communities ON communities.id = addresses.communities_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
LEFT JOIN locations ON locations.id = addresses.locations_id
INNER JOIN companies ON companies.id = p.company_id
INNER JOIN global_property_type ON global_property_type.id = p.property_type_id
LEFT JOIN unit_type ON unit_type.id = ANY(p.unit_type_id)
LEFT JOIN facilities_amenities_entity AS fe ON fe.entity_type_id = 3 AND fe.entity_id = p.id
LEFT JOIN facilities_amenities ON facilities_amenities.id = fe.facility_amenity_id
LEFT JOIN categories ON categories.id = facilities_amenities.categories  -- Join with category table
LEFT JOIN LATERAL jsonb_array_elements_text(p.facts->'views') AS view_id ON TRUE -- Extract view IDs
LEFT JOIN views v ON view_id::int = v.id -- Join with views table
WHERE pv.id = $1 AND pv.status!=6 AND p.status != 6
GROUP BY p.id,pv.id,countries.id, states.id, cities.id, communities.id, sub_communities.id, locations.id, companies.id, global_property_type.id;

-- name: GetSinglePropertyById :one
SELECT
    property.*,
    jsonb_agg(distinct 
        jsonb_build_object(
            'id', unit_type.id, 
            'type', unit_type."type",
            'type_ar', unit_type.type_ar

        )
    ) AS unit_type_obj,
    sqlc.embed(countries),
     COALESCE(states.id, 0) AS state_id,
    COALESCE(states.state, '') AS state_name,
    COALESCE(states.countries_id, 0) AS state_countries_id,
    COALESCE(states.created_at, '1970-01-01'::timestamp) AS state_created_at,
    COALESCE(states.updated_at, '1970-01-01'::timestamp) AS state_updated_at,
    COALESCE(states.lat, 0.0) AS state_lat,
    COALESCE(states.lng, 0.0) AS state_lng,
    
    COALESCE(cities.id, 0) AS city_id,
    COALESCE(cities.city, '') AS city_name,
    COALESCE(cities.states_id, 0) AS city_states_id,
    COALESCE(cities.created_at, '1970-01-01'::timestamp) AS city_created_at,
    COALESCE(cities.updated_at, '1970-01-01'::timestamp) AS city_updated_at,
    COALESCE(cities.lat, 0.0) AS city_lat,
    COALESCE(cities.lng, 0.0) AS city_lng,
    COALESCE(communities.id,0) AS community_id,
COALESCE(communities.community,'') AS community,
COALESCE(sub_communities.id,0) AS sub_communities_id,
COALESCE(sub_communities.sub_community,'') AS sub_communities,
    locations.id AS location_id,
    locations.lat AS location_lat,
    locations.lng AS location_lng,
    jsonb_agg(distinct 
        jsonb_build_object(
            'id', facilities_amenities.id, 
            'icon_url', facilities_amenities.icon_url, 
            'title', facilities_amenities.title,
            'title_ar', facilities_amenities.title_ar,
            'type', facilities_amenities.type,
            'category', categories.category
            -- 'category', jsonb_build_object(    -- Add category as a nested JSON object
            --     'name', categories.category
            -- )
        )
    ) AS facilities_amenities_obj,
    jsonb_agg(distinct 
        jsonb_build_object(
            'id', v.id,
            'title', v.title,
            'title_ar', v.title_ar
        )
    ) AS views,
    companies.company_name,
    global_property_type."type",
    global_property_type.property_type_facts
FROM property
INNER JOIN addresses ON addresses.id = property.addresses_id
INNER JOIN countries ON countries.id = addresses.countries_id
LEFT JOIN states ON states.id = addresses.states_id
LEFT JOIN cities ON cities.id = addresses.cities_id
LEFT JOIN communities ON communities.id = addresses.communities_id
LEFT JOIN sub_communities ON sub_communities.id = addresses.sub_communities_id
LEFT JOIN locations ON locations.id = addresses.locations_id
INNER JOIN companies ON companies.id = property.company_id
INNER JOIN global_property_type ON global_property_type.id = property.property_type_id
LEFT JOIN unit_type ON unit_type.id = ANY(property.unit_type_id)
LEFT JOIN facilities_amenities_entity AS fe ON fe.entity_type_id = 3 AND fe.entity_id = property.id
LEFT JOIN facilities_amenities ON facilities_amenities.id = fe.facility_amenity_id
LEFT JOIN categories ON categories.id = facilities_amenities.categories  -- Join with category table
LEFT JOIN LATERAL jsonb_array_elements_text(property.facts->'views') AS view_id ON TRUE -- Extract view IDs
LEFT JOIN views v ON view_id::int = v.id -- Join with views table
WHERE property.id = $1 AND property.status != 6
GROUP BY property.id, countries.id, states.id, cities.id, communities.id, sub_communities.id, locations.id, companies.id, global_property_type.id;


-- name: RestorePropertyByID :one
UPDATE property
SET status = 1
WHERE property.id = @id::bigint
AND property.status = 6
RETURNING *;

-- name: UpdatePropertyRank :one
UPDATE property_versions
SET property_rank = $1
WHERE property_versions.id = @id::bigint
RETURNING *;

-- name: GetUnitTypesVariation :many
select * from unit_type_variation u
where u.property_id = $1 and u.unit_type_id = $2 and u.status != 6
and case when @bedrooms::varchar = ''::varchar then true else u.bedrooms = @bedrooms::varchar  end;


-- -- name: GetFacilityAmenityByPropertyID :many
-- SELECT 
-- ca.category AS category,
--     -- Group type 1 (Facility) into a JSON array
--     jsonb_agg(
--         jsonb_build_object(
--             'id', facilities_amenities.id,
--             'label', facilities_amenities.title,
--             'icon', facilities_amenities.icon_url,
--             'category', ca.category,
--             'created_at', facilities_amenities.created_at
--         )
--         ORDER BY facilities_amenities.created_at
--     ) FILTER (WHERE facilities_amenities.type = 1) AS facilities,
--     -- Group type 2 (Amenity) into a JSON array
--     jsonb_agg(
--         jsonb_build_object(
--             'id', facilities_amenities.id,
--             'label', facilities_amenities.title,
--             'icon', facilities_amenities.icon_url,
--             'category', ca.category,
--             'created_at', facilities_amenities.created_at
--         )
--         ORDER BY facilities_amenities.created_at
--     ) FILTER (WHERE facilities_amenities.type = 2) AS amenities
-- FROM property p
-- LEFT JOIN facilities_amenities_entity fe ON fe.entity_type_id = 3 AND fe.entity_id = p.id
-- LEFT JOIN facilities_amenities ON facilities_amenities.id = fe.facility_amenity_id
-- LEFT JOIN categories ca ON ca.id = facilities_amenities.categories
-- WHERE p.id = $1
-- GROUP BY p.id, facilities_amenities.id,ca.category;

-- name: GetFacilityAmenityByPropertyID :many
select ca.category AS category,
    -- Group type 1 (Facility) into a JSON array
    jsonb_agg(
        jsonb_build_object(
            'id', facilities_amenities.id,
            'type', facilities_amenities.type,
            'title', facilities_amenities.title,
            'icon_url', facilities_amenities.icon_url,
            'category', ca.category,
            'created_at', facilities_amenities.created_at
        )
        ORDER BY facilities_amenities.created_at
    ) FILTER (WHERE facilities_amenities.type = $2) AS facilities_amenity
 from property p
LEFT JOIN facilities_amenities_entity AS fe ON fe.entity_type_id = 3 AND fe.entity_id = p.id
LEFT JOIN facilities_amenities ON facilities_amenities.id = fe.facility_amenity_id
LEFT JOIN categories ca ON ca.id = facilities_amenities.categories
where p.id = $1 and facilities_amenities."type"= $2
GROUP BY p.id,ca.id;

-- name: GetGlobalPropertyByUsage :many
select * from global_property_type where usage = $1;

-- name: GetAllGlobalProperty :many
select id, 
CASE 
  WHEN @lang::varchar = 'ar' THEN COALESCE(type_ar,"type")
  ELSE COALESCE("type", '') 
END::varchar AS "type",
code, property_type_facts, "usage", created_at, updated_at, status, icon, is_project
from global_property_type where is_project =$1
and status = @active_status::BIGINT;

-- -- name: GetAllGlobalPropertyByEntity :one
-- select * from property where entity_id = $1 and entity_type_id = $2; 

-- name: GetPropertyVersionsByPropertyId :many
select * from property_versions where property_id=$1 
AND
     (
        @company_id::BIGINT = 0 
        OR c.id = @company_id::BIGINT
        AND cu.company_id = @company_id::BIGINT
    )
    AND 
    (
        @agent_id::BIGINT = 0 
        OR pv.agent_id = @agent_id::BIGINT
    );

-- name: GetPropertyVersionsByPropertyIdOld :one
select * from property_versions where property_id=$1 
ORDER BY created_at asc
LIMIT 1 ;

-- name: GetAllUnitTypes :one
select * from unit_type where id = $1;


-- name: GetPropertyVersionsByVerionId :one
select * from property_versions
INNER JOIN property ON property.id = property_versions.property_id
Where property_versions.id=$1;



-- name: GetPropertyVersionByID :one
select * from property_versions
INNER JOIN property ON property_versions.property_id = property.id
where property_versions.property_id=$1;



-- name: GetPublishByEntityIDsByEntityType :one
SELECT * FROM publish_listing 
WHERE
CASE WHEN @created_by::bigint=0 THEN true ELSE publish_listing.created_by = @created_by::bigint END
AND publish_listing.entity_type_id = @entity_type_id  AND  publish_listing.entity_Id = @entity_Id   LIMIT 1;


-- name: GetCountPropertyVersionsByPropertyId :one
select count(*) from property_versions where property_id=$1;


-- name: GetFacilitiesAmenitiesByEntity :many
select 
ca.category,
jsonb_agg(
        jsonb_build_object(
			'id', fa.id,
            'title', 
            CASE WHEN @lang::varchar = 'ar' THEN COALESCE(fa.title_ar,fa.title)
            ELSE COALESCE(fa.title, '') END,            
            'icon_url', fa.icon_url,
            'type', fa.type::bigint,
            'created_at', fa.created_at
        )
        ORDER BY fa.created_at
    ) AS fac_ame
from facilities_amenities_entity fae inner join facilities_amenities fa
on fae.facility_amenity_id = fa.id
inner join categories ca on fa.categories = ca.id
where fae.entity_type_id = $1 and fae.entity_id = $2
and fa.type=$3
GROUP BY ca.category
ORDER BY ca.category;

-- name: GetProjectPropertiesForList :many
Select p.*, pv.*, pr.project_name,gpt.type AS property_type_name,
   refresh_schedules.next_run_at AS next_run_at
from property p 
INNER JOIN property_versions pv ON pv.property_id = p.id 
LEFT JOIN refresh_schedules ON refresh_schedules.entity_type_id= @property_version_entity_type::BIGINT AND refresh_schedules.entity_id= pv.id AND refresh_schedules.status not in (5,6)
LEFT JOIN projects pr ON p.entity_id = pr.id
LEFT JOIN global_property_type gpt ON p.property_type_id = gpt.id
WHERE p.status !=6 AND pv.status !=6 AND p.entity_type_id = $4 AND pr.id = $3
ORDER BY p.id desc
LIMIT $1 OFFSET $2;

-- name: GetProjectPropertiesForListPhase :many
Select p.*,pv.*, pr.project_name,ph.phase_name,gpt.type AS property_type_name,
    refresh_schedules.next_run_at AS next_run_at
from property p 
LEFT JOIN phases ph  ON p.entity_id = ph.id
LEFT JOIN projects pr ON ph.projects_id = pr.id
INNER JOIN property_versions pv ON pv.property_id = p.id
LEFT JOIN global_property_type gpt ON p.property_type_id = gpt.id
LEFT JOIN refresh_schedules ON refresh_schedules.entity_type_id= @property_version_entity_type::BIGINT AND refresh_schedules.entity_id= pv.id AND refresh_schedules.status not in (5,6)
WHERE p.status !=6 AND p.entity_type_id = 2  AND ph.id = $3
ORDER BY p.id desc
LIMIT $1 OFFSET $2; 

-- name: GetCountProjectPropertiesForList :one
Select count(pv.*) from property p 
INNER JOIN property_versions pv ON pv.property_id = p.id 
LEFT JOIN projects pr ON p.entity_id = pr.id
LEFT JOIN global_property_type gpt ON p.property_type_id = gpt.id
WHERE p.status !=6 AND pv.status !=6 AND p.entity_type_id = 1 AND pr.id = $1;

-- name: GetCountProjectPropertiesForListPhase :one
Select count(p.*) from property p 
LEFT JOIN phases ph  ON p.entity_id = ph.id
LEFT JOIN projects pr ON ph.projects_id = pr.id
INNER JOIN property_versions pv ON pv.property_id = p.id
LEFT JOIN global_property_type gpt ON p.property_type_id = gpt.id
WHERE p.status !=6 AND p.entity_type_id = 2  AND ph.id = $1;  


-- name: GetPhaseByProjectId :one
select * from phases where projects_id = $1;

-- name: GetAddToForPropertyVersion :one
WITH category_flags AS (
    SELECT 
        MAX(CASE WHEN pv.category = 1 THEN 1 ELSE 0 END) AS has_sale,
        MAX(CASE WHEN pv.category = 2 THEN 1 ELSE 0 END) AS has_rent
    FROM 
        property p
    INNER JOIN 
        property_versions pv ON pv.property_id = p.id
    WHERE 
        p.id = $1
)
SELECT 
    CASE 
        WHEN has_sale = 1 AND has_rent = 1 THEN NULL -- Both exist, return nothing
        WHEN has_rent = 1 THEN 'sale'              -- Rent exists, return sale
        WHEN has_sale = 1 THEN 'rent'              -- Sale exists, return rent
    END AS result
FROM 
    category_flags;

-- name: GetAllPropertiesVersionByCountry :many
Select pv.*,p.property_name,p.from_xml,p.is_verified,p.status,p.property_type_id,p.owner_users_id,
p.addresses_id, gp."type",
COALESCE(CAST(pq.quality_score AS FLOAT), 0.0) AS quality_score ,
refresh_schedules.next_run_at AS next_run_at
FROM property p
INNER JOIN property_versions pv ON pv.property_id = p.id
LEFT JOIN global_property_type gp ON gp.id = p.property_type_id
LEFT JOIN addresses a ON p.addresses_id = a.id
LEFT JOIN property_quality_score pq ON pq.property_id = p.id
LEFT JOIN companies c ON p.company_id = c.id
LEFT JOIN company_users cu ON cu.users_id = pv.agent_id
LEFT JOIN countries co ON a.countries_id = co.id
LEFT JOIN states ON a.states_id = states.id   
LEFT JOIN cities ON a.cities_id = cities.id
LEFT JOIN sub_communities ON sub_communities.id = a.sub_communities_id
LEFT JOIN refresh_schedules ON refresh_schedules.entity_type_id= @property_version_entity_type::BIGINT AND refresh_schedules.entity_id= pv.id AND refresh_schedules.status not in (5,6)
WHERE 
     (
        @company_id::BIGINT = 0 
        OR c.id = @company_id::BIGINT
        AND cu.company_id = @company_id::BIGINT
    )
    AND 
    (
        @agent_id::BIGINT = 0 
        OR pv.agent_id = @agent_id::BIGINT
    )	 
AND (case when @status::bigint=0 then p.status not in (5,6) and pv.status not in (5,6) else pv.status= @status::bigint end)
AND p.entity_type_id != 1 AND
gp.usage = ANY(@usage::bigint[])
AND (CASE WHEN @life_style::bigint= 0 THEN true ELSE (pv.facts->'life_style')::bigint = @life_style END)
AND (CASE 
    WHEN @country_id::bigint = 0 THEN true 
    WHEN @is_local::bool IS NULL THEN true 
    WHEN @is_local::bool = true THEN a.countries_id = @country_id::bigint 
    ELSE a.countries_id != @country_id::bigint 
    END)
AND (CASE WHEN $3::varchar = '%%' THEN TRUE 
    ELSE 
        p.property_name ILIKE '%'||$3||'%' OR 
        p.property_title ILIKE '%'||$3||'%' OR
        co.country ILIKE '%'||$3||'%' OR 
        gp."type" ILIKE '%'||$3||'%' OR 
        states."state" ILIKE '%'||$3||'%' OR 
        cities.city ILIKE '%'||$3||'%' OR 
        sub_communities.sub_community ILIKE '%'||$3||'%' OR 
        pv.ref_no ILIKE $3 END)
GROUP BY p.id,pv.id,gp.id,pq.quality_score, next_run_at
ORDER BY pv.created_at DESC
LIMIT $1 OFFSET $2; 

-- name: GetAllPropertiesVersionByStatus :many
Select pv.*,p.property_name,p.is_verified,p.status,p.property_type_id,p.user_id,
p.addresses_id, gp."type"from property p 
INNER JOIN property_versions pv ON pv.property_id=p.id 
LEFT JOIN global_property_type gp ON gp.id = p.property_type_id
LEFT JOIN addresses a on p.addresses_id = a.id
LEFT JOIN companies c ON p.company_id = c.id
LEFT JOIN company_users cu ON cu.users_id = pv.agent_id
AND p.status =$3
WHERE 
     (
        @company_id::BIGINT = 0 
        OR c.id = @company_id::BIGINT
        AND cu.company_id = @company_id::BIGINT
    )
    AND 
    (
        @agent_id::BIGINT = 0 
        OR pv.agent_id = @agent_id::BIGINT
    )	
GROUP BY p.id,pv.id,gp.id
ORDER BY pv.created_at ASC
LIMIT $1 OFFSET $2; 

-- name: GetCountPropertiesVersionByStatus :one
Select count(pv.*) from property p 
INNER JOIN property_versions pv ON pv.property_id=p.id 
JOIN global_property_type gp ON gp.id = p.property_type_id
LEFT JOIN addresses a on p.addresses_id = a.id
LEFT JOIN companies c ON p.company_id = c.id
LEFT JOIN company_users cu ON cu.users_id = pv.agent_id
AND p.status =  $1
WHERE 
     (
        @company_id::BIGINT = 0 
        OR c.id = @company_id::BIGINT
        AND cu.company_id = @company_id::BIGINT
    )
    AND 
    (
        @agent_id::BIGINT = 0 
        OR pv.agent_id = @agent_id::BIGINT
    );

-- name: GetCountAllPropertiesVersionByCountry :one
Select count(pv.*) from property p 
INNER JOIN property_versions pv ON pv.property_id = p.id
JOIN global_property_type gp ON gp.id = p.property_type_id
LEFT JOIN addresses a ON p.addresses_id = a.id
LEFT JOIN property_quality_score pq ON pq.property_id = p.id
LEFT JOIN companies c ON p.company_id = c.id
LEFT JOIN company_users cu ON cu.users_id = pv.agent_id
LEFT JOIN countries co ON a.countries_id = co.id
LEFT JOIN states ON a.states_id = states.id   
LEFT JOIN cities ON a.cities_id = cities.id
LEFT JOIN sub_communities ON sub_communities.id = a.sub_communities_id
WHERE 
     (
        @company_id::BIGINT = 0 
        OR c.id = @company_id::BIGINT
        AND cu.company_id = @company_id::BIGINT
    )
    AND 
    (
        @agent_id::BIGINT = 0 
        OR pv.agent_id = @agent_id::BIGINT
    )	 
AND (case when @status::bigint=0 then p.status not in (5,6) and pv.status not in (5,6) else pv.status= @status::bigint end)
AND p.entity_type_id != 1 AND
gp.usage = ANY(@usage::bigint[])
AND CASE WHEN @life_style::bigint= 0 THEN true ELSE (pv.facts->'life_style')::bigint = @life_style END
AND (CASE 
    WHEN @country_id::bigint = 0 THEN true 
    WHEN @is_local::bool IS NULL THEN true 
    WHEN @is_local::bool = true THEN a.countries_id = @country_id::bigint 
    ELSE a.countries_id != @country_id::bigint 
    END)
AND (CASE WHEN $1::varchar = '%%' THEN TRUE 
    ELSE 
        p.property_name ILIKE '%'||$1||'%'  OR 
        p.property_title ILIKE '%'||$1||'%' OR
        co.country ILIKE '%'||$1||'%' OR 
        gp."type" ILIKE '%'||$1||'%' OR 
        states."state" ILIKE '%'||$1||'%' OR 
        cities.city ILIKE '%'||$1||'%' OR 
        sub_communities.sub_community ILIKE '%'||$1||'%' OR 
        pv.ref_no ILIKE $1 END)
;


-- name: GetUnitTypesForUsageByPropertyID :many
select * from global_property_type where "usage" =
(select global_property_type."usage" from property inner JOIN global_property_type 
ON property.property_type_id = global_property_type.id
where property.id = $1);


-- name: GetUnitTypesByUsage :many
select * from unit_type where "usage" = (select global_property_type."usage" from property inner JOIN global_property_type 
ON property.property_type_id = global_property_type.id
where property.id = $1);

-- name: GetUnitTypesByPropertyType :many
select ut.* from property_type_unit_type pt
inner join global_property_type gp on pt.property_type_id = gp.id
inner join  unit_type ut on  pt.unit_type_id = ut.id where gp.id = $1;

-- name: GetDealPropertyVersion :one
select is_hotdeal from  property_versions where id = $1;

-- name: UpdateDealPropertyVersion :exec
update property_versions set is_hotdeal = $1 where id = $2;

-- name: GetDealUnitVersion :one
select is_hotdeal from  unit_versions where id = $1;

-- name: UpdateDealUnitVersion :exec
update unit_versions set is_hotdeal = $1 where id = $2;

-- name: GetUnitTypes :many
select * from unit_type where status=1;

-- name: GetUnitTypeById :one
select type from unit_type where id = $1;

-- -- name: GetUnitTypesByPropertyType :many
-- select u.id,u.type from property_type_unit_type ut 
-- inner join global_property_type p on ut.property_type_id = p.id
-- inner join unit_type u on u.id=ut.unit_type_id
-- where p.id = $1;


-- name: GetUnitTypesByPropertyID :many
SELECT 
    unit_type.id,
    unit_type.code,
    unit_type.facts,
    unit_type.usage,
    unit_type.created_at,
    unit_type.updated_at,
    unit_type.status,
    unit_type.icon,
    CASE 
        WHEN @lang::varchar = 'ar' THEN COALESCE(unit_type.type_ar,unit_type."type")
    ELSE COALESCE(unit_type."type", '') END::varchar AS "type"
FROM property p
INNER JOIN unit_type 
    ON unit_type.id = ANY(p.unit_type_id)
WHERE p.id = $1;

-- name: GetOwnerByName :many
SELECT 
    CONCAT(profiles.first_name, ' ', profiles.last_name)::varchar AS full_name, 
    users.id
FROM users
INNER JOIN profiles ON profiles.users_id = users.id
WHERE CONCAT(profiles.first_name, ' ', profiles.last_name) ilike  $1 
  AND users.user_types_id = 3 and users.status  != 5 and users.status != 6;

-- name: GetOwnerByPhone :many
SELECT  CONCAT(profiles.first_name, ' ', profiles.last_name)::varchar AS full_name, users.id, users.username
FROM users
INNER JOIN profiles ON profiles.users_id = users.id
WHERE users.phone_number ilike $1 and users.user_types_id = 3 and users.status  != 5 and users.status != 6;

-- name: GetAllFreelanceAgents :many
select u.id, CONCAT(first_name,' ',last_name)::varchar AS agent_name from users u
INNER JOIN profiles ON profiles.users_id = u.id where u.user_types_id= 4;


-- name: GetAllAgents :many
-- SELECT u.id, u.username
-- FROM users u
-- WHERE 
--     ($1 = 11 AND u.user_types_id = 2 AND u.username like $2)
-- OR 
--     ($1 != 11 AND u.id IN (
--         SELECT cu.users_id
--         FROM company_users cu
--         WHERE cu.company_id = (
--             SELECT c.id
--             FROM users u
--             INNER JOIN companies c ON c.users_id = u.id
--             WHERE u.id = $1 AND u.user_types_id = 1 AND u.username like $2
--         )
--     ));
SELECT u.id, CONCAT(first_name,' ',last_name)::varchar AS agent_name
FROM users u
INNER JOIN profiles ON profiles.users_id = u.id
LEFT JOIN company_users cu ON @is_company_user::boolean = true AND cu.company_id = @active_company::bigint  -- company id if the visited user is company user or company admin
WHERE u.user_types_id = 2 
AND CASE WHEN @is_company_user::boolean = false THEN cu.users_id IS NULL ELSE cu.users_id = u.id END
AND  (@search::varchar = '%%'::varchar OR CONCAT(first_name,' ', last_name)::varchar ILIKE @search::varchar)
AND u.status NOT IN (5,6)
ORDER BY u.id;

-- name: GetAllCompanyAgents :many
SELECT u.id, CONCAT(first_name,' ',last_name)::varchar AS agent_name
FROM users u
INNER JOIN profiles ON profiles.users_id = u.id
LEFT JOIN company_users cu ON @is_company_user::boolean = true AND cu.users_id = u.id::bigint  -- company id if the visited user is company user or company admin
WHERE u.user_types_id = 2 
AND CASE WHEN @is_company_user::boolean = false THEN cu.users_id IS NULL ELSE cu.company_id = @active_company END
AND u.status NOT IN (5,6)
ORDER BY u.id;

-- name: GetAllPropertiesByUsageandName :many
SELECT distinct property.id, property.property_name, gp.type,is_project_property
FROM property
INNER JOIN property_versions pv ON pv.property_id = property.id
LEFT JOIN company_users cu ON cu.users_id = pv.agent_id
LEFT JOIN companies c ON property.company_id = c.id
INNER JOIN global_property_type gp ON gp.id = property.property_type_id
WHERE 
     (
       case when @company_id::BIGINT = 0 then true else
        ( 
        c.id = @company_id::BIGINT
        -- OR 
        -- cu.company_id =@company_id::BIGINT 
        ) end
    )
    AND 
      (
        @agent_id::BIGINT = 0 
        OR pv.agent_id = @agent_id::BIGINT
      )	 
    AND  property.property_name LIKE '%' || $1 || '%';
------ used for xml
-- name: CheckIfPropertyExistsByRefNo :one
SELECT EXISTS (
    SELECT 1
    FROM property
    INNER JOIN property_versions 
        ON property_versions.property_id = property.id 
        AND property_versions.is_main IS TRUE
    WHERE property_versions.ref_no = $1
)::boolean AS is_property_exist;

------ used for xml
-- name: GetPropertyByRefNo :one
SELECT property.id, company_id, property_type_id, unit_type_id, property_title, property_title_arabic, property.is_verified, addresses_id, entity_type_id, entity_id, property.status, is_show_owner_info, property_name, property.description, property.description_arabic, owner_users_id, user_id, property.updated_by, from_xml, property.facts, notes, property.created_at, property.updated_at, notes_ar, is_public_note, is_project_property, property.exclusive, property.start_date, property.end_date, property_versions.id, title, views_count, title_arabic, property_versions.description, property_versions.description_arabic, property_versions.property_rank, property_id, property_versions.facts, property_versions.created_at, property_versions.updated_at, property_versions.updated_by, property_versions.status, agent_id, ref_no, category, has_gallery, has_plans, is_main, property_versions.is_verified, property_versions.exclusive, property_versions.start_date, property_versions.end_date, slug, is_hotdeal, refreshed_at
FROM property
INNER JOIN property_versions 
    ON property_versions.property_id = property.id 
    AND property_versions.is_main IS TRUE
WHERE property_versions.ref_no = $1;



-- name: UpdateXMLGlobalProperty :one
UPDATE property
SET company_id = $1,
    property_type_id= $2,
    property_title = $3,
    property_title_arabic = $4,
    facts = $5,
    property_name = $6,
    description = $7,
    description_arabic = $8,
    updated_by = $9,
    status = $11,
    entity_type_id = $12,
    is_project_property = $13
WHERE id = $10
RETURNING *;

-- name: UpdateXMLPropertyVersion :one
UPDATE property_versions
SET title = $1,
    title_arabic= $2,
    description = $3,
    description_arabic = $4,
    facts = $5,
    updated_at = $6,
    updated_by = $7,
    agent_id = $8,
    ref_no = $9,
    category = $10,
    status = $12
WHERE id = $11
RETURNING *;


-- name: GetAllPropertyVersionsIdS :many 
SELECT id from property_versions;


-- name: UpdatePropertyVersionCounterView :exec
UPDATE property_versions
SET 
    views_count=views_count+$2 
WHERE
    id=$1;


-- name: UpdatePropertyVersionsStatusForAgent :exec
UPDATE
    property_versions
SET
    status = @status::BIGINT
WHERE
    agent_id = @agent_id::BIGINT;