-- name: CreatePromotionType :one
INSERT INTO promotion_types (
    types,
    status,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3, $4
) RETURNING *;

-- name: GetPromotionType :one
SELECT * FROM promotion_types 
WHERE id = $1 LIMIT $1;




-- name: GetAllPromotionTypeWithoutPagination :many
SELECT * FROM promotion_types
ORDER BY id;
 
-- name: GetAllPromotionType :many
SELECT * FROM promotion_types
ORDER BY created_at DESC
LIMIT $1
OFFSET $2;

-- name: UpdatePromotionType :one
UPDATE promotion_types
SET  types = $2,
    status = $3,
    created_at = $4,
    updated_at = $5
Where id = $1
RETURNING *;


-- name: DeletePromotionType :exec
DELETE FROM promotion_types
Where id = $1;

-- name: GetAllPromotionTypeByIds :many
SELECT * FROM promotion_types
WHERE id = ANY($1::bigint[]);

-- name: GetCountPromotionType :one
SELECT COUNT(*) FROM promotion_types;

-- name: GetPromotionTypeIdByType :one
SELECT id FROM promotion_types WHERE types = $1 LIMIT 1;