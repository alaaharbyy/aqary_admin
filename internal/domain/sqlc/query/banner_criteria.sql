-- name: CreateBannerCriteria :one
INSERT INTO "banner_criteria" (
    "banner_type_id",
    "banner_name_id",
    "banners_id"
) VALUES (
    $1, $2, $3
)
RETURNING *;


-- name: GetBannerCriteria :one
SELECT * FROM "banner_criteria"
WHERE "id" = $1;


-- name: ListBannerCriteria :many
SELECT * FROM "banner_criteria"
ORDER BY "id" DESC
LIMIT $1 OFFSET $2;

-- name: UpdateBannerCriteria :exec
UPDATE "banner_criteria"
SET
    "banner_type_id" = $2,
    "banner_name_id" = $3,
    "banners_id" = $4
WHERE "id" = $1;

-- name: DeleteBannerCriteria :exec
DELETE FROM "banner_criteria"
WHERE "id" = $1;
