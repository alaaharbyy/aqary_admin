 
-- name: GetAllWebportals :many
SELECT * FROM webportals ORDER BY created_at DESC;

-- name: GetAllWebportalsForPublishWebportalByIds :many
SELECT id,portal_name,portal_logo_url FROM webportals
WHERE id = ANY($1::bigint[])
ORDER BY ARRAY_POSITION($1::bigint[], id);

-- Create a new webportal
-- name: CreateWebportal :one
INSERT INTO webportals (
    portal_name, contact_person, portal_url, portal_subscription, publish_status,
    description, is_favorite, xml_structure, xml_file_url, portal_logo_url, created_by
)
VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11
)
RETURNING *;

-- Get a webportal by ID
-- name: GetWebportalByID :one
SELECT * FROM webportals
WHERE id = $1;

-- Update a webportal
-- name: UpdateWebportal :one
UPDATE webportals
SET portal_name = $2, contact_person = $3, portal_url = $4, portal_subscription = $5,
    publish_status = $6, description = $7, is_favorite = $8, xml_structure = $9,
    xml_file_url = $10, portal_logo_url = $11
WHERE id = $1
RETURNING *;

-- Delete a webportal
-- name: DeleteWebportal :exec
DELETE FROM webportals
WHERE id = $1;


-- name: GetAllWebportal :many
WITH total_count_cte AS (
    SELECT COUNT(*) AS total_count
    FROM "webportals"
)
SELECT *,
      (SELECT total_count FROM total_count_cte) AS total_count
FROM webportals
--  Where  created_by =  $3
ORDER BY created_at DESC LIMIT COALESCE(NULLIF($1, 0), NULL) OFFSET COALESCE(NULLIF($2, 0), 0);


-- name: GetAllWebportalWithoutPagination :many
SELECT * FROM webportals
Where  created_by =  $1
ORDER BY created_at DESC;


-- name: CountAllWebportal :one
SELECT Count(*) FROM webportals
Where  created_by =  $1;


-- -- name: GetAllWebportalWithPublishStatus :many
-- SELECT DISTINCT ON (w.id)
-- 	w.*,
-- 	CASE WHEN pl.webportal_id IS NULL THEN
-- 		false
-- 	ELSE
-- 		true
-- 	END AS publish_status,
-- 	CASE WHEN @check_for = 'unit' THEN
-- 		CASE WHEN pl.is_unit = @is_unit
-- 			AND pl.unit_id = @unit_id
-- 			AND pl.unit_category = @unit_category THEN
-- 			'Unit query executed'
-- 		ELSE
-- 			'No matching condition'
-- 		END
-- 	WHEN @check_for = 'property' THEN
-- 		CASE WHEN pl.is_property = @is_property
-- 			AND pl.property_key = @property_key
-- 			AND pl.property_id = @property_id
-- 			AND(pl.is_unit IS NULL
-- 				OR pl.is_unit IS FALSE) THEN
-- 			'Property query executed'
-- 		ELSE
-- 			'No matching condition'
-- 		END
-- 	WHEN @check_for = 'project_with_phase' THEN
-- 		CASE WHEN pl.is_project = @is_project
-- 			AND pl.phase_id = @phase_id
-- 			AND pl.project_id = @project_id
-- 			AND(pl.is_property IS NULL
-- 				OR pl.is_property IS FALSE)
-- 			AND(pl.is_unit IS NULL
-- 				OR pl.is_unit IS FALSE) THEN
-- 			'Project with phase query executed'
-- 		ELSE
-- 			'No matching condition'
-- 		END
-- 	WHEN @check_for = 'project_without_phase' THEN
-- 		CASE WHEN pl.is_project = @is_project
-- 			AND pl.phase_id IS NULL
-- 			AND pl.project_id = @project_id
-- 			AND(pl.is_property IS NULL
-- 				OR pl.is_property IS FALSE)
-- 			AND(pl.is_unit IS NULL
-- 				OR pl.is_unit IS FALSE) THEN
-- 			'Project without phase query executed'
-- 		ELSE
-- 			'No matching condition'
-- 		END
-- 	ELSE
-- 		'Invalid check_for parameter'
-- 	END AS query_executed
-- FROM
-- 	webportals w
-- 	LEFT JOIN publish_listing pl ON w.id = pl.webportal_id
-- 		AND((@check_for = 'unit'
-- 			AND pl.is_unit = @is_unit
-- 			AND pl.unit_id = @unit_id
-- 			AND pl.unit_category = @unit_category)
-- 		OR(@check_for = 'property'
-- 			AND pl.is_property = @is_property
-- 			AND pl.property_key = @property_key
-- 			AND pl.property_id = @property_id
-- 			AND(pl.is_unit IS NULL
-- 				OR pl.is_unit IS FALSE))
-- 		OR(@check_for = 'project_with_phase'
-- 			AND pl.is_project = @is_project
-- 			AND pl.phase_id = @phase_id
-- 			AND pl.project_id = @project_id
-- 			AND(pl.is_property IS NULL
-- 				OR pl.is_property IS FALSE)
-- 			AND(pl.is_unit IS NULL
-- 				OR pl.is_unit IS FALSE))
-- 		OR(@check_for = 'project_without_phase'
-- 			AND pl.is_project = @is_project
-- 			AND pl.phase_id IS NULL
-- 			AND pl.project_id = @project_id
-- 			AND(pl.is_property IS NULL
-- 				OR pl.is_property IS FALSE)
-- 			AND(pl.is_unit IS NULL
-- 				OR pl.is_unit IS FALSE)))
-- WHERE
-- 	w.created_by = @user_id;