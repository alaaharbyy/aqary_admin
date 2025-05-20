-- name: CreateHolidaySchedule :one
INSERT INTO holiday_experience_schedule (
holiday_home_id, 
day_of_week, 
start_time, 
end_time,
pick_up_time
)VALUES ($1, $2, $3, $4, $5) RETURNING *;

-- name: UpdateHolidaySchedule :one
UPDATE holiday_experience_schedule 
SET
holiday_home_id = $1, 
day_of_week = $2, 
start_time = $3, 
end_time = $4,
pick_up_time = $5
WHERE id = $6 RETURNING *;

-- name: GetHolidayScheduleById :one
SELECT * From holiday_experience_schedule WHERE id = $1;
 
-- name: GetHolidayScheduleByDay :one
SELECT * From holiday_experience_schedule WHERE day_of_week = $1;
 
-- name: GetAllHolidaySchedule :many
SELECT * From holiday_experience_schedule LIMIT $1 OFFSET $2;
 
-- name: GetAllHolidaySchedulebyHolidayId :many
SELECT id,
holiday_home_id,
day_of_week,
start_time,
end_time,
pick_up_time
From
    holiday_experience_schedule
WHERE
holiday_home_id= $1
ORDER BY holiday_experience_schedule.id DESC
LIMIT $2
OFFSET $3;

-- name: DeleteHolidayScheduleById :exec
DELETE From holiday_experience_schedule WHERE id = $1;

-- name: GetAllHolidayScheduleById :many
SELECT * From holiday_experience_schedule WHERE id = $3 LIMIT $1 OFFSET $2;

-- name: DeleteHolidayScheduleByHolidayId :one
DELETE From holiday_experience_schedule WHERE holiday_home_id= $1 RETURNING *;

-- name: GetHolidaySchedulebyHolidayId :many
SELECT id,
holiday_home_id,
day_of_week,
start_time,
end_time
From
    holiday_experience_schedule
WHERE
holiday_home_id= $1;