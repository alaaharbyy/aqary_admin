-- name: CreateAqaryPropertyAdsMedia :one
INSERT INTO aqary_property_ads_media (aqary_property_ads,media_type,media_url,is_deleted)
VALUES ($1,$2,$3,false) RETURNING *;
-- name: UpdateAqaryPropertyAdsMedia :one
UPDATE aqary_property_ads_media SET aqary_property_ads = $2, media_type = $3, media_url=$4, is_deleted = $5 WHERE id = $1 RETURNING *;
-- name: GetAllAqaryPropertyAdsMedia :many
SELECT * FROM aqary_property_ads_media WHERE is_deleted = $3 LIMIT $1 OFFSET $2;
-- name: GetAqaryPropertyAdsMediaByID :one
SELECT * FROM aqary_property_ads_media WHERE id = $1 AND is_deleted = $2;
-- name: GetAqaryPropertyAdsMediaByAds :many
SELECT * FROM aqary_property_ads_media WHERE aqary_property_ads = $3 AND is_deleted = $4 LIMIT $1 OFFSET $2;
-- name: DeleteAqaryPropertyAdsMedia :one
DELETE FROM aqary_property_ads_media WHERE id = $1 RETURNING *;
-- name: DeleteAqaryPropertyAdsMediaByAdID :many
DELETE FROM aqary_property_ads_media WHERE aqary_property_ads = $1 RETURNING *;
 
-- name: AqaryPropertyAdsMediaDeleteStatusUpdate :one
UPDATE aqary_property_ads_media SET is_deleted = $2 WHERE id = $1 RETURNING *;