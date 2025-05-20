-- name: CreateServicesPromotions :one
INSERT INTO service_promotions (
    service,
    promotion_name,
    promotion_name_ar,
    promotion_details,
    promotion_details_ar,
    price,
    tags_id,
    start_date,
    end_date,
    created_by
) VALUES (
    $1,
    $2,
    $3,
    $4,
    $5, 
    $6,
    $7,
    $8,
    $9,
    $10
)
RETURNING *;

-- name: UpdateServicesPromotion :one
UPDATE service_promotions
SET
    service=$2,
    promotion_name=$3,
    promotion_name_ar=$4,
    promotion_details=$5,
    promotion_details_ar=$6,
    price=$7,
    tags_id=$8,
    start_date=$9,
    end_date=$10
WHERE id=$1
RETURNING *;

-- name: GetAllServicesPromotionsByID :many
SELECT 
    sp.id,
    sp.service,
    sp.promotion_name,
    sp.promotion_details,
    sp.promotion_name_ar,
    sp.promotion_details_ar,
    sp.price,
    sp.tags_id,
    sp.start_date,
    sp.end_date,
    sp.created_by,
    sp.created_at,
    sp.updated_at
FROM service_promotions sp;

-- name: GetServicesPromotionsByServiceID :many
SELECT 
    sp.id,
    sp.service,
    sp.promotion_name,
    sp.promotion_details,
    sp.promotion_name_ar,
    sp.promotion_details_ar,
    sp.price,
    sp.tags_id,
    sp.start_date,
    sp.end_date,
    sp.created_by,
    sp.created_at,
    sp.updated_at
FROM service_promotions sp
WHERE sp.service = $1; 

-- name: GetServicesPromotionsByID :one
SELECT 
    sp.id,
    sp.service,
    sp.promotion_name,
    sp.promotion_details,
    sp.promotion_name_ar,
    sp.promotion_details_ar,
    sp.price,
    sp.tags_id,
    sp.start_date,
    sp.end_date,
    sp.created_by,
    sp.created_at,
    sp.updated_at
FROM service_promotions sp
WHERE sp.id = $1; 


-- name: GetServicesPromotionsByStatusID :many
SELECT 
    sp.id,
    sp.service,
    sp.status,
    sp.promotion_name,
    sp.promotion_details,
    sp.promotion_name_ar,
    sp.promotion_details_ar,
    sp.price,
    sp.tags_id,
    sp.start_date,
    sp.end_date,
    sp.created_by,
    sp.created_at,
    sp.updated_at
FROM service_promotions sp
WHERE sp.status = $1; 

-- name: GetPublishServicesPromotions :many
SELECT sp.*,
COUNT(*) OVER() AS total_count 
FROM service_promotions sp
inner join publish_listing pl on pl.entity_id = sp.id and pl.entity_type_id = 11
LIMIT $1 OFFSET $2;

-- name: UpdateServicePromotionStatus :one
UPDATE service_promotions
SET status = $2, 
    updated_at = NOW() 
WHERE id = $1 RETURNING *;  
