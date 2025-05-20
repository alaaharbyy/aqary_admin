-- name: CreateAqaryProjectAdsMedia :one
INSERT INTO aqary_project_ads_media (aqary_project_ads,media_type,media_url,is_deleted)
VALUES ($1,$2,$3,false) RETURNING *;
-- name: UpdateAqaryProjectAdsMedia :one
UPDATE aqary_project_ads_media SET aqary_project_ads = $2, media_type = $3, media_url=$4, is_deleted = $5 WHERE id = $1 RETURNING *;
-- name: GetAllAqaryProjectAdsMedia :many
SELECT * FROM aqary_project_ads_media WHERE is_deleted = $3 LIMIT $1 OFFSET $2;
-- name: GetAqaryProjectAdsMediaByID :one
SELECT * FROM aqary_project_ads_media WHERE id = $1 AND is_deleted = $2;
-- name: GetAqaryProjectAdsMediaByAd :many
SELECT * FROM aqary_project_ads_media WHERE aqary_project_ads = $3 AND is_deleted = $4 LIMIT $1 OFFSET $2;
-- name: DeleteAqaryProjectAdsMedia :one
DELETE FROM aqary_project_ads_media WHERE id = $1 RETURNING *;
-- name: DeleteAqaryProjectAdsMediaByPostID :many
DELETE FROM aqary_project_ads_media WHERE aqary_project_ads = $1 RETURNING *;
 
-- name: AqaryProjectAdsMediaDeleteStatusUpdate :one
UPDATE aqary_project_ads_media SET is_deleted = $2 WHERE id = $1 RETURNING *;