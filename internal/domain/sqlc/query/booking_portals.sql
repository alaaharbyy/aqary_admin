-- name: CreateBookingPortal :one
INSERT INTO booking_portals (
portal_name, 
portal_url, 
portal_logo, 
status
)
VALUES ($1, $2, $3, $4) RETURNING *;
 
 
-- name: UpdateBookingPortal :one 
UPDATE booking_portals 
SET
portal_name = $1, 
portal_url = $2, 
portal_logo = $3,
updated_at = $4,
status = $5
WHERE id = $6 RETURNING *;
 
-- name: GetBookingPortal :one
SELECT * From booking_portals WHERE id = $1 and status != 6 ;
 
-- name: GetAllBookingPortal :many
SELECT * From booking_portals  WHERE status != 6 ORDER BY id DESC LIMIT $1 OFFSET $2;

-- name: GetBookingPortalByID :one
SELECT * FROM booking_portals WHERE id = $1 and status != 6 ;

-- name: DeleteBookingPortal :exec
DELETE From booking_portals WHERE id = $1;

-- name: UpdateBookingPortalStatus :one
UPDATE booking_portals 
SET
status=$2 
WHERE id =$1
RETURNING *;

-- name: GetAllBookingPortalWithoutPg :many
SELECT * From booking_portals WHERE status != 6  Order by Id DESC;

-- name: GetCountBookingPortal :many
SELECT count(*) From booking_portals WHERE status != 6;


-- name: GetBookingPortalsbByName :many
select * from booking_portals where portal_name ILIKE $1 OR portal_url ILIKE $2;