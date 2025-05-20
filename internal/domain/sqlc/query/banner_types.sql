-- name: CreateBannerType :one
INSERT INTO banner_types
(title,title_ar)VALUES($1,$2) RETURNING *;
 
-- name: UpdateBannerType :one
UPDATE banner_types 
SET
title_ar = $1,
title=$2
WHERE id=$3
RETURNING *;
 
-- name: GetSingleBannerType :one
SELECT * FROM banner_types WHERE id=$1;
 
-- name: GetAllBannerTypes :many
SELECT * FROM banner_types 
LIMIT $1 OFFSET $2;
 
-- name: GetCountBannerTypes :one
SELECT COUNT(*) FROM banner_types;
 
-- name: DeleteBannerType :exec
DELETE FROM banner_types WHERE id=$1;



-- name: GetBannerTargetUrl :one
SELECT target_url 
FROM 
    banners 
WHERE
    id=$1; 