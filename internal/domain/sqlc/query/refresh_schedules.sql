-- name: CreateRefreshSchedule :one 
INSERT INTO refresh_schedules ( entity_id, entity_type_id, schedule_type, next_run_at,last_run_at, preferred_hour, preferred_minute, week_days, status, created_by ) 
VALUES ( $1, $2, $3, $4, $5, $6, $7, $8, $9,$10) RETURNING id;


-- name: GetRefreshScheduleByID :one 
SELECT * FROM refresh_schedules WHERE id = $1;


-- name: GetExistingRefreshSchedules :many 
SELECT * FROM refresh_schedules WHERE id = ANY(@ids::bigint[]);

-- name: GetRefreshScheduleIdsMap :many 
SELECT entity_id, id,last_run_at FROM refresh_schedules WHERE entity_type_id = $1 AND entity_id = ANY($2::bigint[]);
-- name: CheckExistingRefreshSchedule :one 
WITH existing AS (
  SELECT id, status
  FROM refresh_schedules 
  WHERE entity_id = $1 AND entity_type_id = $2 
  LIMIT 1
)
SELECT 
  COALESCE((SELECT id FROM existing)::bigint, -1)::bigint AS result_id,
  COALESCE((SELECT status FROM existing)::bigint, 0)::bigint AS result_status;

-- name: GetUpcomingSchedules :many 
SELECT sqlc.embed(refresh_schedules) FROM refresh_schedules 
WHERE next_run_at  <= NOW() 
-- AT TIME ZONE 'Asia/Dubai'
ORDER BY next_run_at ASC;


-- name: UpdateRefreshSchedule :exec 
UPDATE refresh_schedules 
SET  
    schedule_type = $2, 
    next_run_at = $3, 
    last_run_at = $4, 
    preferred_hour = $5, 
    preferred_minute = $6, 
    week_days = $7, 
    updated_at = $8,
    status=$9
WHERE id = $1;


-- name: BulkUpdateRefreshSchedule :exec 
UPDATE refresh_schedules 
SET  
    schedule_type = $1, 
    next_run_at = $2, 
    last_run_at = COALESCE(sqlc.narg('last_run_at'),next_run_at), 
    preferred_hour = $3, 
    preferred_minute = $4, 
    week_days = $5, 
    updated_at = $6,
    status=$7
WHERE id = ANY(@ids::bigint[]);


-- name: UpdateScheduleRunTimes :exec 
UPDATE refresh_schedules 
SET next_run_at = $2, last_run_at = $3, updated_at = $4
WHERE id = $1;


-- name: UpdateRefreshScheduleStatus :exec 
UPDATE refresh_schedules 
SET status = $2,
    updated_at = $3
WHERE id = $1;


-- name: GetSchedulesByEntity :many 
SELECT sqlc.embed(refresh_schedules) FROM refresh_schedules 
WHERE entity_id = $1 AND entity_type_id = $2;

-- name: RefreshPropertyVersion :exec
UPDATE property_versions SET refreshed_at = $2 WHERE id = $1 AND status= @available_status::bigint;

-- name: RefreshUnitVersion :exec
UPDATE unit_versions SET refreshed_at = $2 WHERE id = $1 AND status= @available_status::bigint;

-- name: RefreshProject :exec
UPDATE projects SET refreshed_at = $2 WHERE id = $1 AND status= @available_status::bigint;


-- name: BulkUpdatePropertyVersionsRefreshedAt :one
WITH updated AS ( 
  UPDATE property_versions 
  SET refreshed_at = $1 
  WHERE id = ANY(@entity_ids::bigint[]) 
  RETURNING id 
) 
SELECT array_agg(id)::bigint[] AS updated_ids 
FROM updated;

-- name: BulkUpdateUnitVersionsRefreshedAt :one
WITH updated AS ( 
  UPDATE unit_versions 
  SET refreshed_at = $1 
  WHERE id = ANY(@entity_ids::bigint[]) 
  RETURNING id 
) 
SELECT array_agg(id)::bigint[] AS updated_ids 
FROM updated;
-- name: BulkUpdateProjectsRefreshedAt :one 
WITH updated AS ( 
  UPDATE projects 
  SET refreshed_at = $1 
  WHERE id = ANY(@entity_ids::bigint[]) 
  RETURNING id 
) 
SELECT array_agg(id)::bigint[] AS updated_ids 
FROM updated;