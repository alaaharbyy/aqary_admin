-- name: CreateAqaryGuide :exec
INSERT INTO
    aqary_guide (
        guide_type,
        guide_content,
        guide_content_ar,
        created_by,
        created_at,
        updated_at,
        status,
        slug
    )
VALUES
    ($1, $2, $3, $4, $5, $6,$7,$8);


-- name: GetSingleAqaryGuide :one 
SELECT * FROM aqary_guide WHERE id=$1 AND status!=6; 

-- name: GetAllAqaryGuides :many 
SELECT * FROM aqary_guide 
WHERE status= @status::BIGINT
ORDER BY updated_at DESC
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetNumberOfAqaryGuides :one 
SELECT COUNT(*) FROM aqary_guide 
WHERE status= @status::BIGINT;

-- name: UpdateAqaryGuide :exec
UPDATE aqary_guide
SET
    guide_type =  $1,
    guide_content = $2,
    guide_content_ar = $3,
    updated_at = $4,
    slug= $5
WHERE
    id = $6 AND status != 6;



-- name: ChangeStatusAqaryGuide :exec
UPDATE 
    aqary_guide
SET 
    status=$2
    -- updated_at=$3
WHERE 
    id=$1;



    
