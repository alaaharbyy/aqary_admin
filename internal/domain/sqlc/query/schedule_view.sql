
-- name: CreateScheduleView :one
INSERT INTO schedule_view (
    ref_no,
    created_by,
    owner_id, 
    entity_type_id, 
    entity_id, 
    start_date, 
    end_date,
    interval_time, 
    sessions,
    lat,
    lng
) VALUES (
    $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11
)RETURNING *;

-- name: UpdateScheduleView :one
UPDATE schedule_view
SET owner_id = $1,
    entity_type_id= $2,
    entity_id = $3,
    start_date = $4,
    end_date = $5,
    interval_time = $6,
    sessions = $7,
    updated_at = $8,
    lat = $9,
    lng = $10
WHERE id = $11
RETURNING *;

-- name: GetScheduleViewbyId :one
select * from schedule_view where id =$1;

-- name: GetAllScheduleView :many
select * from schedule_view;

-- name: GetTimeSlotsForEntity :many
SELECT 
sqlc.embed(ts)
FROM 
	timeslots ts
WHERE 
	ts.end_time>now()
AND
	ts.entity_id= $1::BIGINT AND ts.entity_type_id= $2::BIGINT AND
	COALESCE((SELECT CASE  $2::BIGINT
               WHEN 11 THEN (SELECT 1 FROM services WHERE services.id = $1::BIGINT)
               WHEN 14 THEN (SELECT unit_versions.status::BIGINT FROM unit_versions WHERE unit_versions.id = $1::BIGINT)
               WHEN 15 THEN (SELECT property_versions.status::BIGINT FROM property_versions WHERE property_versions.id = $1::BIGINT)
               ELSE 0::BIGINT
           END),6::BIGINT) NOT IN(0,6)
ORDER BY 
	ts.id DESC;

-- name: GetAllScheduleSessionByMonth :many
WITH unnested_sessions AS (
  SELECT
    t.id,
	t.ref_no,
	t.owner_id,
	t.interval_time,
    jsonb_array_elements(t.sessions::jsonb) AS session
  FROM schedule_view t
  WHERE
 (   (DATE_TRUNC('month', @currentDate::timestamp) BETWEEN t.start_date AND t.end_date)
    OR (DATE_TRUNC('month', @currentDate::timestamp) + INTERVAL '1 month' - INTERVAL '1 day' BETWEEN t.start_date AND t.end_date)
    OR (t.start_date BETWEEN DATE_TRUNC('month', @currentDate::timestamp) AND DATE_TRUNC('month', @currentDate::timestamp) + INTERVAL '1 month' - INTERVAL '1 day')
)
    AND t.entity_type_id = @entity_type_id::BIGINT AND t.entity_id = @entity_id::BIGINT
),
parsed_sessions AS (
  SELECT
    id,
	ref_no,
	owner_id,
	interval_time,
    (session->>'Name')::text AS session_name,
    (session->>'StartTime')::timestamp AS start_time,
    (session->>'EndTime')::timestamp AS end_time,
    (session->>'Date')::date AS session_date
  FROM unnested_sessions
)
SELECT
  session_date,
  jsonb_agg(
    jsonb_build_object(
		'schedule_id', id::bigint,
		'owner_id', owner_id::bigint,
		'ref_no', ref_no::text,
		'interval_time', interval_time::bigint,
    'name', session_name,
    'start_time', start_time,
    'end_time', end_time
    )
    ORDER BY start_time
  ) AS sessions
FROM parsed_sessions
GROUP BY session_date
ORDER BY session_date;



-- name: GetAllScheduleViewSessionsByProperty :many
SELECT 
  schedule_view.id, 
  schedule_view.sessions 
FROM schedule_view
INNER JOIN timeslots t ON t.entity_id = schedule_view.id
WHERE 
  schedule_view.entity_type_id = $2 
  AND schedule_view.entity_id = $1;
  -- AND (
  --   DATE_TRUNC('month', $3::timestamp) BETWEEN t.start_time AND t.end_time
  --   OR (DATE_TRUNC('month', $3::timestamp) + INTERVAL '1 month' - INTERVAL '1 day') BETWEEN t.start_time AND t.end_time
  --   OR t.start_time BETWEEN DATE_TRUNC('month', $3::timestamp) AND DATE_TRUNC('month', $3::timestamp) + INTERVAL '1 month' - INTERVAL '1 day'
  -- );


-- name: GetAllScheduleSlotsByWeekly :many
SELECT 
    appointment.id AS appointment_id,
appointment.status AS appointment_status,
appointment.background_color,
users.email,
profiles.first_name,
profiles.last_name,
users.phone_number,
profiles.profile_image_url,
timeslots.date::date,
schedule_view.id,
timeslots.id AS time_slot_id,
timeslots."date",
timeslots.start_time,
timeslots.end_time,
timeslots.status AS time_slot_status,
timeslots.entity_id AS schedule_id
FROM timeslots
INNER JOIN schedule_view ON timeslots.entity_id = schedule_view.id
LEFT JOIN appointment ON appointment.timeslots_id = timeslots.id AND appointment.status != 5
LEFT JOIN users ON users.id = appointment.client_id
LEFT JOIN profiles ON profiles.users_id = users.id
WHERE
timeslots.entity_type_id = 13
AND timeslots.status != 6
AND schedule_view.entity_type_id = @entity_type_id::BIGINT
AND schedule_view.entity_id = @entity_id::BIGINT 
AND DATE_TRUNC('week', timeslots.date) = DATE_TRUNC('week', @currentDate::timestamp)
ORDER BY timeslots.date;


-- name: GetAllScheduleSlotsByWeek :many
SELECT 
timeslots.date::date,
jsonb_agg(
        jsonb_build_object(
            'schedule_id', timeslots.entity_id::bigint,
            'start_time', timeslots.start_time,
            'end_time', timeslots.end_time,
            'status', timeslots.status::bigint
        )
        ORDER BY timeslots.start_time
    ) AS slots
FROM timeslots
INNER JOIN schedule_view ON timeslots.entity_id = schedule_view.id
WHERE
timeslots.entity_type_id = 13
AND timeslots.status != 6
AND schedule_view.entity_type_id = @entity_type_id::BIGINT
AND schedule_view.entity_id = @entity_id::BIGINT 
AND DATE_TRUNC('week', timeslots.date) = DATE_TRUNC('week', @currentDate::timestamp)
GROUP BY timeslots.date
ORDER BY timeslots.date;

-- name: CreateAppointment :one
INSERT INTO appointment (
	created_by,
	status,
    timeslots_id,
    client_id,
    remarks,
    background_color,
    appoinment_type,
    appoinment_app,
    valid_id
) VALUES (
    $1,$2,$3,$4,$5,$6,$7,$8,$9
)RETURNING *;

-- name: UpdateAppointment :one
UPDATE appointment
SET status = $1,
    timeslots_id= $2,
    background_color = $3,
    remarks = $4,
    updated_at = $5,
    appoinment_type = $6,
    appoinment_app = $7,
    valid_id = $8
WHERE id = $9
RETURNING *;


-- name: UpdateAppointmentStatus :one
UPDATE appointment
SET status = $1,
    remarks = $2,
    updated_at = $3
WHERE id = $4
RETURNING *;

-- name: GetAppoinmentbyId :one
select * from appointment where id =$1;

-- name: GetAllAppoinment :many
select * from appointment;

-- name: CreateTimeSlotsForSV :one
INSERT INTO timeslots(
    date,
    start_time,
    end_time,
    status,
    entity_type_id,
    entity_id
)VALUES(
    $1, $2, $3, $4, $5, $6
) RETURNING *;


-- name: GetPropertyLocationByPropertyID :one
SELECT l.lat, l.lng FROM property p
INNER JOIN addresses a on p.addresses_id = a.id
LEFT JOIN locations l ON l.id = a.locations_id
where p.id = $1;


-- name: GetUnitLocationByUnitID :one
SELECT l.lat, l.lng FROM units u
INNER JOIN addresses a on u.addresses_id = a.id
LEFT JOIN locations l ON a.locations_id = l.id
where u.id = $1;