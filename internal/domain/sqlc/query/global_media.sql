-- name: CreateGlobalMedia :one
INSERT INTO global_media(
    file_urls, 
    gallery_type,
    gallery_type_ar,
    media_type,
    entity_id,
    entity_type_id
) VALUES (
    $1, 
    $2, 
    $3, 
    $4, 
    $5,
    $6
)RETURNING *;



-- name: UpdateGlobalMedia :one
Update global_media 
SET 
	file_urls=$1, 
	updated_at=$2 
WHERE 
	entity_type_id=$3 AND entity_id=$4 AND media_type=$5 AND gallery_type=$6
RETURNING *; 

-- name: GetGlobalMediaById :one
select * from global_media 
where id = $1; 




-- name: GetGlobalMedia :one	
WITH status_calculation AS (
     SELECT CASE  @entity_type::BIGINT
               WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = @entity_id::BIGINT)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = @entity_id::BIGINT)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = @entity_id::BIGINT)
            --    WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = @entity_id::BIGINT)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = @entity_id::BIGINT)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = @entity_id::BIGINT)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = @entity_id::BIGINT)
            --    WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = @entity_id::BIGINT)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = @entity_id::BIGINT)
            --    WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = @entity_id::BIGINT)
            --    WHEN 11 THEN (SELECT 1 FROM services WHERE services.id = @entity_id::BIGINT)
            --    WHEN 16 THEN (SELECT 1 FROM publish_listing WHERE publish_listing.id = @entity_id::BIGINT)
            --    WHEN 17 THEN (SELECT 1 FROM company_activities WHERE company_activities.id = @entity_id::BIGINT)
               WHEN 18 THEN (SELECT 1 FROM company_profiles WHERE company_profiles.id = @entity_id::BIGINT)
               WHEN 19 THEN (SELECT 1 FROM company_profiles_projects WHERE company_profiles_projects.id = @entity_id::BIGINT)
               WHEN 20 THEN (SELECT 1 FROM company_profiles_phases WHERE company_profiles_phases.id = @entity_id::BIGINT)
               WHEN 21 THEN (SELECT 1 FROM community_guidelines WHERE community_guidelines.id = @entity_id::BIGINT)
              WHEN 24 THEN (SELECT 1 FROM company_activities_detail WHERE company_activities_detail.id = @entity_id::BIGINT)
               ELSE 0::BIGINT
           END AS status
)
SELECT 
    COALESCE(global_media.id, 0) AS "media_id",
    COALESCE(global_media.file_urls, ARRAY[]::VARCHAR[]) AS "file_urls",
    COALESCE(global_media.entity_id, 0) AS "entity_id",
    COALESCE(status_calculation.status,-1::BIGINT) AS "status"
FROM 
    status_calculation 
LEFT JOIN 
    global_media ON 
        global_media.entity_type_id =  @entity_type::BIGINT 
        AND global_media.entity_id = @entity_id::BIGINT 
        AND global_media.media_type = $1
        AND global_media.gallery_type = $2
        AND status_calculation.status NOT IN (-1,0,6);



-- name: GetGlobalMediaWithoutMediaType :many	
WITH status_calculation AS (
     SELECT CASE  @entity_type::BIGINT
               WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = @entity_id::BIGINT)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = @entity_id::BIGINT)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = @entity_id::BIGINT)
            --    WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = @entity_id::BIGINT)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = @entity_id::BIGINT)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = @entity_id::BIGINT)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = @entity_id::BIGINT)
            --    WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = @entity_id::BIGINT)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = @entity_id::BIGINT)
            --    WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = @entity_id::BIGINT)
            --    WHEN 11 THEN (SELECT 1 FROM services WHERE services.id = @entity_id::BIGINT)
            --    WHEN 16 THEN (SELECT 1 FROM publish_listing WHERE publish_listing.id = @entity_id::BIGINT)
            --    WHEN 17 THEN (SELECT 1 FROM company_activities WHERE company_activities.id = @entity_id::BIGINT)

               ELSE 0::BIGINT
           END AS status
)
SELECT 
    COALESCE(global_media.id, 0) AS "media_id",
    COALESCE(global_media.file_urls, ARRAY[]::VARCHAR[]) AS "file_urls",
    COALESCE(global_media.entity_id, 0) AS "entity_id",
    COALESCE(status_calculation.status,-1::BIGINT) AS "status"
FROM 
    status_calculation 
LEFT JOIN 
    global_media ON 
        global_media.entity_type_id =  @entity_type::BIGINT 
        AND global_media.entity_id = @entity_id::BIGINT 
        AND global_media.gallery_type = $1
        AND status_calculation.status NOT IN (-1,0,6);


-- name: GetEntityIdGlobalMedia :many
SELECT global_media.id AS "global_media_id",global_media.media_type,global_media.gallery_type,global_media.gallery_type_ar, global_media.entity_id AS "entity_id" , global_media.entity_type_id AS "entity_type_id" ,global_media.created_at,global_media.updated_at,global_media.file_urls
FROM 
	global_media
WHERE 
	global_media.entity_id= @entity_id::BIGINT AND global_media.entity_type_id= @entity_type::BIGINT AND
	COALESCE((SELECT CASE  @entity_type::BIGINT
               WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = @entity_id::BIGINT)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = @entity_id::BIGINT)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = @entity_id::BIGINT)
            --    WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = @entity_id::BIGINT)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = @entity_id::BIGINT)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = @entity_id::BIGINT)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = @entity_id::BIGINT)
            --    WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = @entity_id::BIGINT)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = @entity_id::BIGINT)
            --    WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = @entity_id::BIGINT)
            --    WHEN 11 THEN (SELECT 1 FROM services WHERE services.id = @entity_id::BIGINT)
            --    WHEN 16 THEN (SELECT 1 FROM publish_listing WHERE publish_listing.id = @entity_id::BIGINT)
            --    WHEN 17 THEN (SELECT 1 FROM company_activities WHERE company_activities.id = @entity_id::BIGINT)
               WHEN 18 THEN (SELECT 1 FROM company_profiles WHERE company_profiles.id = @entity_id::BIGINT)
               WHEN 19 THEN (SELECT 1 FROM company_profiles_projects WHERE company_profiles_projects.id = @entity_id::BIGINT)
               WHEN 20 THEN (SELECT 1 FROM company_profiles_phases WHERE company_profiles_phases.id = @entity_id::BIGINT)
               WHEN 21 THEN (SELECT 1 FROM community_guidelines WHERE community_guidelines.id = @entity_id::BIGINT)
               WHEN 24 THEN (SELECT 1 FROM company_activities_detail WHERE company_activities_detail.id = @entity_id::BIGINT)
               ELSE 0::BIGINT
           END),6::BIGINT) NOT IN(0,6)
ORDER BY 
	global_media.updated_at DESC
LIMIT $1 
OFFSET $2;


-- name: GetNumberOfEntityIdGlobalMedia :one
SELECT COUNT(*) 
FROM 
	global_media 
WHERE 
	entity_id= @entity_id::BIGINT AND entity_type_id= @entity_type::BIGINT;




-- name: DeleteEntityGlobalMediaByURL :one 
UPDATE global_media 
SET 
	file_urls = array_remove(file_urls, @file_url::VARCHAR),
	updated_at=$1 
WHERE 
	global_media.id= @media_id AND @file_url::VARCHAR = ANY(file_urls) AND 
	COALESCE((SELECT CASE  global_media.entity_type_id::BIGINT
               WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = global_media.entity_id::BIGINT)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = global_media.entity_id::BIGINT)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = global_media.entity_id::BIGINT)
               --WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = global_media.entity_id::BIGINT)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = global_media.entity_id::BIGINT)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = global_media.entity_id::BIGINT)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = global_media.entity_id::BIGINT)
               --WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = global_media.entity_id::BIGINT)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = global_media.entity_id::BIGINT)
               --WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = global_media.entity_id::BIGINT)
               --WHEN 11 THEN (SELECT 1 FROM services WHERE services.id = global_media.entity_id::BIGINT)
               --WHEN 16 THEN (SELECT 1 FROM publish_listing WHERE publish_listing.id = global_media.entity_id::BIGINT)
               --WHEN 17 THEN (SELECT 1 FROM company_activities WHERE company_activities.id = @entity_id::BIGINT)
                 WHEN 18 THEN (SELECT 1 FROM company_profiles WHERE company_profiles.id = global_media.entity_id::BIGINT)
               WHEN 19 THEN (SELECT 1 FROM company_profiles_projects WHERE company_profiles_projects.id = global_media.entity_id::BIGINT)
               WHEN 20 THEN (SELECT 1 FROM company_profiles_phases WHERE company_profiles_phases.id = global_media.entity_id::BIGINT)
               WHEN 21 THEN (SELECT 1 FROM community_guidelines WHERE community_guidelines.id = @entity_id::BIGINT)
               WHEN 24 THEN (SELECT 1 FROM company_activities_detail WHERE company_activities_detail.id = @entity_id::BIGINT)
               ELSE 0::BIGINT
           END),6::BIGINT) NOT IN (0,6)
RETURNING *;


-- name: DeleteEntityGlobalMedia :exec 
DELETE FROM global_media WHERE id=$1;



-- name: DeleteEntityGlobalMediaByMediaId :one 
DELETE FROM global_media WHERE global_media.id =$1 AND 
COALESCE((SELECT CASE  global_media.entity_type_id::BIGINT
               WHEN 1 THEN (SELECT projects.status::BIGINT FROM projects WHERE projects.id = global_media.entity_id::BIGINT)
               WHEN 2 THEN (SELECT phases.status::BIGINT FROM phases WHERE phases.id = global_media.entity_id::BIGINT)
               WHEN 3 THEN (SELECT property.status::BIGINT FROM property WHERE property.id = global_media.entity_id::BIGINT)
               --WHEN 4 THEN (SELECT exhibitions.event_status::BIGINT FROM exhibitions WHERE exhibitions.id = global_media.entity_id::BIGINT)
               WHEN 5 THEN (SELECT units.status::BIGINT FROM units WHERE units.id = global_media.entity_id::BIGINT)
               WHEN 6 THEN (SELECT companies.status::BIGINT FROM companies WHERE companies.id = global_media.entity_id::BIGINT)
               WHEN 7 THEN (SELECT 1 FROM profiles WHERE profiles.id = global_media.entity_id::BIGINT)
              -- WHEN 8 THEN (SELECT freelancers.status::BIGINT FROM freelancers WHERE freelancers.id = global_media.entity_id::BIGINT)
               WHEN 9 THEN (SELECT users.status::BIGINT FROM users WHERE users.id = global_media.entity_id::BIGINT)
               --WHEN 10 THEN (SELECT holiday_home.status::BIGINT FROM holiday_home WHERE holiday_home.id = global_media.entity_id::BIGINT)
               --WHEN 11 THEN (SELECT 1 FROM services WHERE services.id =global_media.entity_id::BIGINT)
               --WHEN 16 THEN (SELECT 1 FROM publish_listing WHERE publish_listing.id =global_media.entity_id::BIGINT)
                --WHEN 17 THEN (SELECT 1 FROM company_activities WHERE company_activities.id = global_media.entity_id::BIGINT)
                 WHEN 18 THEN (SELECT 1 FROM company_profiles WHERE company_profiles.id = global_media.entity_id::BIGINT)
               WHEN 19 THEN (SELECT 1 FROM company_profiles_projects WHERE company_profiles_projects.id = global_media.entity_id::BIGINT)
               WHEN 20 THEN (SELECT 1 FROM company_profiles_phases WHERE company_profiles_phases.id = global_media.entity_id::BIGINT)
               WHEN 21 THEN (SELECT 1 FROM community_guidelines WHERE community_guidelines.id = global_media.entity_id::BIGINT)
               WHEN 24 THEN (SELECT 1 FROM company_activities_detail WHERE company_activities_detail.id = global_media.entity_id::BIGINT)
               ELSE 0::BIGINT
           END),6::BIGINT) NOT IN (0,6)
RETURNING global_media.file_urls;

-- name: GetFileUrlFromGlobalMedia :one
select file_urls from global_media  where media_type = $1 and entity_type_id=$2 and gallery_type=$3 and entity_id=$4;

-- name: GetFileUrlFromGlobalMediaMultiple :many
select file_urls, media_type from global_media  where entity_type_id=$1 and gallery_type=$2 and entity_id=$3 AND media_type=$4;

-- name: CheckIfFileURLAlreadyExists :one
SELECT EXISTS (
    SELECT 1
    FROM global_media
    WHERE $1::VARCHAR = ANY(global_media.file_urls) AND 
    global_media.id != $2 AND global_media.gallery_type = $3 and global_media.media_type= $4
) AS string_exists;


-- name: GetSumOfGlobalMediaByEntity :one
SELECT
	COALESCE(SUM(array_length(file_urls, 1)),0)::INTEGER AS media_sum
FROM
    global_media
WHERE entity_type_id = $1 and entity_id = $2;

-- name: GetAllParentCategoryFroImport :many
SELECT
    DISTINCT global_media.gallery_type,global_media.gallery_type_ar,
    entity_id AS parent_id, entity_type_id as parent_type_id
FROM 
    global_media
WHERE entity_type_id = $1 and entity_id = $2;


-- name: GetAllParentMediaTypeForImport :many
SELECT DISTINCT global_media.media_type AS media_type_id, entity_type_id, entity_id
FROM global_media
WHERE global_media.gallery_type = $1 AND global_media.entity_type_id = $2 AND global_media.entity_id = $3;

-- name: DeleteXMLGlobalMedia :exec
DELETE FROM global_media
WHERE entity_type_id = $1
  AND entity_id = ANY(@entity_ids::bigint[]);

-- -- name: InsertGlobalMediaInBulk :many
-- INSERT INTO global_media(
--     file_urls, 
--     gallery_type, 
--     media_type, 
--     entity_id, 
--     entity_type_id, 
--     created_at, 
--     updated_at
-- )VALUES(
--    unnest(@file_urls::varchar[][]),
--    unnest(@gallery_type::varchar[]),
--    unnest(@media_type::BIGINT[]),
--    unnest(@entity_id::BIGINT[]),
--    unnest(@entity_type_id::BIGINT[]),
--   unnest(@created_at::timestamptz[]),
--    unnest(@updated_at::timestamptz[])
-- )RETURNING *;