-- name: CreateHolidayHomePortals :one
INSERT INTO holiday_home_portals (
    ref_no,
    holiday_home_id,
    booking_portals_id,
    listing_url,
    price,
    created_at,
    updated_at
)VALUES (
      $1 ,$2, $3, $4, $5, $6, $7
) RETURNING *;


-- name: GetHolidayHomePortals :one
SELECT * FROM holiday_home_portals
WHERE id = $1 and status !=6 LIMIT 1;

-- name: GetAllHolidayHomePortals :many
SELECT * FROM holiday_home_portals
ORDER BY id  and status !=6
LIMIT $1
OFFSET $2;

-- name: UpdateHolidayHomePortals :one
UPDATE holiday_home_portals
SET  ref_no = $2,
     holiday_home_id = $3,
     booking_portals_id = $4,
     listing_url = $5,
     price = $6,
     created_at = $7,
     updated_at = $8
WHERE id = $1
RETURNING *;


-- name: DeleteHolidayHomePortals :exec
DELETE FROM holiday_home_portals
Where id = $1;

-- name: GetAllCountHolidayHomePortal :one
SELECT COUNT(*) FROM holiday_home_portals WHERE holiday_home_id =$1 and status !=6;

-- name: UpdateHolidayHomePortalsStaus :one
UPDATE holiday_home_portals
SET updated_at = $3,
     status = $2
WHERE id = $1
RETURNING *;

-- name: DeleteHolidayHomePortalsByHolidayId :exec
DELETE FROM holiday_home_portals
Where holiday_home_id= $1;

-- name: GetHolidayHomePortalsByHolidayId :one
SELECT * FROM holiday_home_portals
WHERE holiday_home_id = $1 and status !=6 LIMIT 1;
 
-- name: GetAllHolidayHomePortalsByHolidayId :many
SELECT * FROM holiday_home_portals
WHERE holiday_home_id= $1 and status !=6
LIMIT $2
OFFSET $3;
 
-- name: GetHolidayHomePortalsByRefNo :one
SELECT * FROM holiday_home_portals
WHERE ref_no like $1 and status !=6;
 
-- name: GetHolidayHomePortalsbByBkPorId :one
SELECT * FROM holiday_home_portals
WHERE booking_portals_id = $1 AND
holiday_home_id = $2 and status !=6;
 
-- name: GetHolidayHomePortalsbByBkId :many
SELECT * FROM holiday_home_portals
WHERE booking_portals_id = $1 and status !=6;

-- name: GetAllHolidayHomePortalByHolidayId :many
SELECT * FROM holiday_home_portals
WHERE holiday_home_id= $1 and status !=6 ORDER BY updated_at DESC;

-- name: GetAllCountHolidayHomePortals :one
SELECT COUNT(*) FROM holiday_home_portals WHERE status !=6;