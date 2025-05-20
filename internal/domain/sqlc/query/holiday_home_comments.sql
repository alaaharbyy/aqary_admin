-- name: CreateHolidayHomeComments :one
INSERT INTO holiday_home_comments (
    parent_comment,
    holiday_home_id,
    users_id,
    comment_date,
    comment,
    reaction_type_id,
    reacted_by,
    status
)VALUES (
      $1 ,$2, $3, $4, $5, $6, $7, $8
) RETURNING *;


-- name: GetHolidayHomeComments :one
SELECT * FROM holiday_home_comments
WHERE id = $1 and status != 6 LIMIT 1;

-- name: GetAllHolidayHomeComments :many
SELECT * FROM holiday_home_comments WHERE status != 6
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateHolidayHomeComments :one
UPDATE holiday_home_comments
SET  parent_comment = $2,
     holiday_home_id = $3,
     users_id = $4,
     comment_date = $5,
     comment = $6,
     reaction_type_id = $7,
     reacted_by = $8,
     status= $9
WHERE id = $1
RETURNING *;


-- name: DeleteHolidayHomeComments :exec
DELETE FROM holiday_home_comments
Where id = $1;

-- name: GetAllCountHolidayHomeComments :one
SELECT COUNT(*) FROM holiday_home_comments Where status != 6;