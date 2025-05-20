-- name: CreateReviewTerm :one 
INSERT INTO review_terms (
    entity_type_id, 
    review_term,
    review_term_ar, 
    status, 
    created_at, 
    updated_at 
)
SELECT 
    $1, 
    $2, 
    $3, 
    $4, 
    $5, 
    $6
FROM 
    entity_type WHERE id=$1 RETURNING id;

-- name: UpdateReviewTerm :one 
UPDATE 
    review_terms
SET 
    entity_type_id= COALESCE(sqlc.narg('entity_type_id'),entity_type_id), 
    review_term= COALESCE(sqlc.narg('review_term'),review_term), 
    review_term_ar=COALESCE(sqlc.narg('review_term_ar'),review_term_ar), 
    updated_at= $2
WHERE review_terms.id=$1 AND status= @active_status::BIGINT
AND (
    sqlc.narg('entity_type_id') = entity_type_id 
    OR sqlc.narg('entity_type_id') IS NULL 
    OR EXISTS (SELECT 1 FROM entity_type WHERE id= sqlc.narg('entity_type_id'))
) RETURNING id;



-- name: GetReviewTermByID :one 
SELECT review_terms.*,entity_type.name FROM review_terms 
INNER JOIN entity_type ON entity_type.id=review_terms.entity_type_id
WHERE review_terms.id= $1 AND status= @active_status::BIGINT;

-- name: GetAllReviewTerms :many 
SELECT review_terms.*,entity_type.name FROM review_terms 
INNER JOIN entity_type ON entity_type.id=review_terms.entity_type_id
WHERE status= @status::BIGINT 
ORDER BY review_terms.updated_at DESC
LIMIT sqlc.narg('limit') OFFSET sqlc.narg('offset');

-- name: GetNumberOfReviewTerms :one 
SELECT COUNT(*) FROM review_terms WHERE status= @status::BIGINT; 

-- name: DeleteRestoreReviewTerm :one 
UPDATE review_terms
SET 
    status= @status::BIGINT, 
    updated_at= $2
WHERE 
    id= $1 RETURNING id;
