-- name: CreateOpenHouse :one
INSERT INTO openhouse(
    ref_no,
    created_by,
    property_id,
    start_date,
    end_date,
    created_at,
    updated_at,
    sessions
) VALUES(
    $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING *;

-- name: GetOpenHouse :one
SELECT openhouse.*, property.property_name 
FROM openhouse
INNER JOIN property ON property.id = openhouse.property_id
WHERE openhouse.id = $1 LIMIT 1;

-- name: CreateTimeSlots :one
INSERT INTO timeslots(
    date,
    start_time,
    end_time,
    status,
    entity_id,
    entity_type_id
    -- openhouse_id
)VALUES(
    $1, $2, $3, $4, $5, $6
) RETURNING *;

-- name: UpdateTimeSlotsByStatus :one
UPDATE timeslots
SET status = $2
WHERE id = $1
RETURNING *;

-- name: GetAvailableTimeSlots :one
SELECT id 
FROM timeslots 
WHERE id = $1 AND status = 1;

-- name: GetAllAvailableTimeSlotsByProjectProperty :many
SELECT timeslots.* 
FROM timeslots 
INNER JOIN openhouse ON timeslots.entity_id = openhouse.id
WHERE openhouse.property_id = $1 AND timeslots.status = 1 
AND timeslots.entity_type_id = 12
ORDER BY timeslots.start_time;

-- name: GetAllTimeSlotsByProjectPropertyId :many
SELECT openhouse.id AS openhouse_id,timeslots.id,date,start_time,end_time,status 
FROM timeslots
INNER JOIN openhouse ON openhouse.id = openhouse_id
WHERE openhouse.property_id = $3
ORDER BY openhouse.start_date ASC
LIMIT $1 OFFSET $2;

-- name: GetCountAllTimeSlotsByProjectPropertyId :one
SELECT COUNT(timeslots.id) 
FROM timeslots
INNER JOIN openhouse ON openhouse.id = openhouse_id
WHERE openhouse.property_id = $1;

-- name: CreateOpenhouseAppointment :one
INSERT INTO appointment(
    -- openhouse_id,
    timeslots_id,
    -- agent_id,
    created_by,
    status,
    client_id,
    remarks,
    created_at,
    updated_at,
    -- appointment_type,
    background_color
)VALUES(
    $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING *;

-- name: GetAllProjectPropertyOHAppointments :many
SELECT 
openhouse.id AS openhouse_id,
appointment.id AS appointment_id,
appointment.status AS appointment_status,
appointment.background_color,
-- appointment.appointment_type,
timeslots.id AS time_slot_id,
timeslots."date",
timeslots.start_time,
timeslots.end_time,
timeslots.status AS time_slot_status,
users.email,
profiles.first_name,
profiles.last_name,
users.phone_number,
profiles.profile_image_url
-- profiles.nic_no
FROM appointment
INNER JOIN openhouse ON openhouse.id = appointment.openhouse_id
INNER JOIN timeslots ON timeslots.id = appointment.timeslots_id
LEFT JOIN users ON users.id = appointment.client_id
LEFT JOIN profiles ON profiles.users_id = users.id
WHERE openhouse.property_id = $1 AND appointment.status != 5
ORDER BY timeslots."date",start_time ASC;

-- name: UpdateOpenhouseAppointmentStatus :one
UPDATE appointment 
SET status = $2
WHERE id = $1
RETURNING *;

-- name: UpdateOpenhouseAppointmentStatusAndRemarks :one
UPDATE appointment 
SET status = $2,
    remarks = $3
WHERE id = $1
RETURNING *;

-- name: UpdateTimeslotsStatusByAppointment :one
UPDATE timeslots
SET status = $2
FROM appointment
WHERE appointment.timeslots_id = timeslots.id AND appointment.id = $1
RETURNING *;

-- name: GetAllOHTimeSlotsAndAppointmentsByProjProp :many
SELECT 
timeslots.id AS time_slot_id,
timeslots."date",
timeslots.start_time,
timeslots.end_time,
timeslots.status AS time_slot_status,
-- timeslots.openhouse_id,
appointment.id AS appointment_id,
appointment.status AS appointment_status,
appointment.background_color,
-- appointment.appointment_type,
users.email,
profiles.first_name,
profiles.last_name,
users.phone_number,
profiles.profile_image_url,
-- profiles.nic_no,
openhouse.id AS open_house_id
FROM timeslots
LEFT JOIN openhouse ON openhouse.id = timeslots.entity_id
LEFT JOIN appointment ON appointment.timeslots_id = timeslots.id AND appointment.status != 5
LEFT JOIN users ON users.id = appointment.client_id
LEFT JOIN profiles ON profiles.users_id = users.id
WHERE openhouse.property_id = $1
AND timeslots.entity_type_id = 12
ORDER BY timeslots.start_time ASC;

-- name: GetAllOpenhouseSessionsByProjProp :many
SELECT openhouse.id,openhouse.sessions FROM openhouse
WHERE property_id = $1;

-- name: GetAllTimeslotsByOpenhouseAndStatus :many
SELECT * FROM timeslots 
WHERE entity_id = $1 AND status = $2 
AND entity_type_id = $3
ORDER BY date ASC;

-- name: GetOpenhouseAppointment :one
SELECT * FROM appointment
WHERE id = $1
LIMIT 1;

-- name: RescheduleOpenhouseAppointment :one
UPDATE appointment 
SET status = $2,
    remarks = $3,
    timeslots_id = $4
WHERE id = $1
RETURNING *;