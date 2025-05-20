-- name: CreateStateGuide :one
INSERT INTO
    state_guide (
         state_id,
        cover_image,
        description,
        status
    )
SELECT
    $1,
    $2,
    $3,
    $4
FROM 
	states WHERE id= $1::BIGINT and status !=6 RETURNING 1;



-- name: GetStateGuides :many
SELECT 
    states.countries_id, countries.country,
	state_guide.id,
	states.state,
	state_guide.cover_image,
	state_guide.description
FROM state_guide
JOIN states ON states.id= state_guide.state_id
JOIN countries ON countries.id = states.countries_id
WHERE state_guide.status= @status::BIGINT
ORDER BY state_guide.updated_at DESC
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');
 
-- name: GetStateGuidesCount :one
SELECT 
	count(state_guide.id)
FROM state_guide
JOIN states ON states.id= state_guide.state_id
JOIN countries ON countries.id = states.countries_id
WHERE state_guide.status= @status::BIGINT;
 

-- name: GetStateGuide :one
SELECT 
    states.countries_id, countries.country,
	state_guide.id,state_id,cover_image,description,states.state
FROM state_guide 
JOIN states ON states.id= state_guide.state_id
JOIN countries ON countries.id = states.countries_id
WHERE state_guide.id=$1;
 
 
-- name: UpdateStateGuide :one
UPDATE
    state_guide
SET
    cover_image = $2,
    description = $3,
    updated_at = $4
WHERE
    state_guide.id = $1
    AND status = @active_status::BIGINT
    RETURNING id;


-- name: GetStateGuideForUpdate :one 
SELECT id,state_id,cover_image,description  FROM state_guide WHERE id=$1 AND status= @active_status::BIGINT;

-- name: UpdateStateGuideStatus :one
UPDATE
    state_guide
SET
    updated_at = $2,
    status = $3,
    deleted_at = $4
WHERE   
    id = $1 RETURNING id;


-- name: ExitingStateGuide :one
SELECT EXISTS (
    SELECT 1
    FROM state_guide
    WHERE state_id = $1 and status!= @deleted_status::bigint
) AS exists;


-- name: ExitingStateGuideByStatus :one
SELECT EXISTS (
    SELECT 1
    FROM state_guide
    WHERE state_id = $1 and status = @status::bigint
) AS exists;
