-- name: CreateHolidayPackInclusion :one
INSERT INTO holiday_package_inclusions (
    title,
    title_ar,
    icon_url,
    status,
    holiday_home_type
    )
VALUES ($1, $2, $3, $4, $5)
RETURNING *;
 
-- name: UpdateHolidayPackInclusion :one
UPDATE holiday_package_inclusions 
SET
    title = $2,
    title_ar = $3,
    icon_url = $4,
    status = $5,
    holiday_home_type = $6
WHERE id = $1
RETURNING *;

-- name: GetAllPackInclusion :many
SELECT * FROM holiday_package_inclusions order by id DESC;
 
-- name: GetAllPackInclusionbyId :one
SELECT * FROM holiday_package_inclusions where id = $1;
 
-- name: GetAllPackInclusionbyTitle :many
SELECT * FROM holiday_package_inclusions where title like $1 ;

-- name: DeletePackInclusion :exec
DELETE FROM holiday_package_inclusions where id = $1;

-- name: GetAllPackInclusionWithpag :many
SELECT * FROM holiday_package_inclusions  ORDER BY id DESC LIMIT $1 OFFSET $2;

-- name: GetAllPackInclusionWithpagByType :many
SELECT * FROM holiday_package_inclusions WHERE holiday_home_type = $3 ORDER BY id DESC LIMIT $1 OFFSET $2;
 
-- name: GetAllPackInclusionByType :many
SELECT * FROM holiday_package_inclusions WHERE holiday_home_type = $1 order by id DESC;

-- name: GetCountPackInclusion :many
SELECT count(*) FROM holiday_package_inclusions;

-- name: GetCountPackInclusionByType :many
SELECT count(*) FROM holiday_package_inclusions WHERE holiday_home_type = $1;