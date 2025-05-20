-- name: CreateHolidayHomeCategory :one
INSERT INTO holiday_home_categories (
    holiday_home_type,
    title,
    title_ar,
    status
)VALUES (
     $1, $2, $3, $4
) RETURNING *;

-- name: GetHolidayHomeCategory :one
SELECT * FROM holiday_home_categories
WHERE id = $1 AND status != 6 LIMIT 1;


-- name: GetAllHolidayHomeCategory :many
select * from holiday_home_categories Where status != 6 order by id DESC;

-- name: UpdateHolidayHomeCategory :one
UPDATE holiday_home_categories
SET   holiday_home_type = $2,
      title = $3,
      title_ar = $4,
      status = $5
WHERE id = $1
RETURNING *;


-- name: DeleteHolidayHomeCategory :exec
DELETE FROM holiday_home_categories
Where id = $1;

-- name: GetAllCountHolidayHomeCategory :one
SELECT COUNT(*) FROM holiday_home_categories Where status != 6;

-- name: GetHolidayHomeCategoryByHolidayType :many
SELECT * FROM holiday_home_categories
WHERE holiday_home_type= $1 AND status != 6;
 
-- name: GetAllCountHolidayHomeCategoryByHolidayType :one
SELECT COUNT(*) FROM holiday_home_categories WHERE holiday_home_type= $1 AND status != 6;

-- name: GetAllHolidayHomeCategoryWithpg :many
select * from holiday_home_categories Where status != 6
ORDER BY id DESC
Limit $1
Offset $2;