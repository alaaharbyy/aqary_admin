-- name: CreateBookingActivity :one
INSERT INTO booking_activities
(company_types_id, companies_id, is_branch, booking_type, activity_type, activity_date, ref_activity_id, module_name, file_url, portal_url, users_id)
VALUES 
($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11) RETURNING *;
 
-- name: UpdateBookingActivity :one
UPDATE booking_activities
SET
    company_types_id = $2,
    companies_id = $3,
    is_branch = $4,
    booking_type = $5,
    activity_type = $6,
    activity_date = $7,
    ref_activity_id = $8,
    module_name = $9,
    file_url = $10,
    portal_url = $11,
    users_id = $12
WHERE
    id = $1
RETURNING *;

-- name: GetBookingActivityByRefIdAndModuleName :one
SELECT
*
FROM
    booking_activities
WHERE
     ref_activity_id = $1 and module_name=$2;

-- name: GetBookingCategoryActivityId :one
SELECT id
FROM 
	booking_activities 
WHERE 
	ref_activity_id = $1 AND module_name = 'Hotel Booking Category';