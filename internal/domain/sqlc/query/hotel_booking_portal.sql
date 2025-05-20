-- name: CreateHotelBookingPortal :one
INSERT INTO hotel_booking_portal(ref_no, hotel_rooms_id, booking_portals_id, listing_url, price_night, hotel_booking_promo_id, created_at, updated_at, status)
VALUES($1, $2, $3, $4, $5, $6,$7,$8,$9) RETURNING *;
 
 
-- name: UpdateHotelBookingPortal :one
UPDATE hotel_booking_portal
SET ref_no = $2,
    hotel_rooms_id = $3,
    booking_portals_id = $4,
    listing_url = $5,
    price_night = $6,
    hotel_booking_promo_id = $7,
    updated_at = $8,
    status = $9
WHERE id = $1
RETURNING *;
 
-- name: GetAllHotelBookingPortals :many
SELECT * FROM hotel_booking_portal;
 
-- name: GetHotelBookingPortalById :one
SELECT * FROM hotel_booking_portal WHERE id = $1;

-- name: UpdateHotelBookingPortalPriceNight :one
UPDATE 
		hotel_booking_portal 
SET
	price_night =$2
WHERE 
	id=$1
RETURNING *;

-- name: GetHotelBookingPortal :many
SELECT 
	hotel_booking_portal.id,
        hotel_booking_portal.ref_no,
        hotel_booking_portal.hotel_rooms_id,
        hotel_booking_portal.listing_url,
        hotel_booking_portal.hotel_booking_promo_id,
	booking_portals.portal_name,
	booking_portals.portal_url,
	hotel_booking_portal.price_night,
	hotel_booking_portal.status
FROM 
	hotel_booking_portal
INNER JOIN 
		booking_portals ON hotel_booking_portal.booking_portals_id = booking_portals.id
WHERE 
	hotel_booking_portal.status!=6
ORDER BY 
	hotel_booking_portal.id	
LIMIT $1
OFFSET $2;

-- name: GetHotelBookingPortalActionButton :many
SELECT 
	hbp.id,
	hbp.ref_no,
	bp.portal_logo,
	bp.portal_url,
	hbp.price_night
FROM	hotel_booking_portal AS hbp 
INNER JOIN
		  booking_portals AS bp ON hbp.booking_portals_id =  bp.id
WHERE 
	hbp.status!=6
ORDER BY 
		hbp.id 
LIMIT $1
OFFSET $2;

-- name: GetNumberOfHotelBookingPortal :one 
SELECT count(id) 
FROM hotel_booking_portal
WHERE hotel_booking_portal.status!=6;

-- name: UpdateHotelBookingPortalStatus :one
UPDATE hotel_booking_portal
SET status = $2
WHERE id = $1
RETURNING *;