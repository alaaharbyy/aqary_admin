-- name: CreateHotelRoom :one
INSERT INTO hotel_rooms (
    ref_no,
    posted_hotel_id,
    room_types_id,
    room_number,
    title,
    title_ar,
    description,
    description_ar,
    price_night,
    is_booked,
    created_at,
    updated_at,
    max_pax,
    bedrooms,
    common_bathroom,
    private_bathroom,
    status
)
VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16,$17
) RETURNING *;
 
 
-- name: UpdateHotelRoom :one
UPDATE hotel_rooms
SET
    ref_no = $1,
    posted_hotel_id = $2,
    room_types_id = $3,
    room_number = $4,
    title = $5,
    title_ar = $6,
    description = $7,
    description_ar = $8,
    price_night = $9,
    is_booked = $10,
    created_at = $11,
    updated_at = $12,
    max_pax = $13,
    bedrooms = $14,
    common_bathroom = $15,
    private_bathroom = $16,
    status=$17
WHERE
    id = $18
RETURNING *;
 
-- name: GetAllHotelRooms :many
SELECT 
    hr.id,
    hr.ref_no,
    hr.title,
    hr.price_night,
    hr.room_types_id,
    hr.room_number,
    hr.title_ar,
    hr.description,
    hr.description_ar,
    hr.is_booked,
    hr.created_at,
    hr.updated_at,
    hr.max_pax,
    hr.bedrooms,
    hr.common_bathroom,
    hr.private_bathroom,
    hr.status,
    room_types.title AS room_type,
    states.state,
    cities.city,
    communities.community,
    sub_communities.sub_community,
    CASE 
        WHEN hr.is_booked = true THEN 'BOOKED'
        ELSE 'AVAILABLE'
    END AS status
FROM 
    hotel_rooms AS hr
INNER JOIN 
    posted_hotel_bookings AS phb ON hr.posted_hotel_id = phb.id
INNER JOIN 
    room_types ON hr.room_types_id = room_types.id
INNER JOIN 
    states ON phb.states_id = states.id
INNER JOIN 
    cities ON phb.cities_id = cities.id
INNER JOIN 
    communities ON phb.community_id = communities.id
INNER JOIN 
    sub_communities on phb.subcommunity_id = sub_communities.id
WHERE
	hr.status!=6
ORDER BY 
    hr.id
LIMIT $1
OFFSET $2;

-- name: GetNumberOfHotelRooms :one
SELECT COUNT(id) 
FROM hotel_rooms 
WHERE status!=6;
 
-- name: GetHotelRoomByID :one
SELECT * FROM hotel_rooms WHERE id=$1;

-- name: GetSingleHotelRoom :one
SELECT 
    hr.id,
    hr.ref_no,
    hr.posted_hotel_id,
    hr.room_types_id,
    hr.room_number,
    hr.title,
    hr.title_ar,
    hr.description,
    hr.description_ar,
    hr.price_night,
    hr.is_booked,
    hr.created_at,
    hr.updated_at,
    hr.max_pax,
    hr.bedrooms,
    hr.common_bathroom,
    hr.private_bathroom,
    hr.status,
    phb.title AS hotel_booking_title,
    room_types.title AS room_type
FROM 
    hotel_rooms AS hr 
INNER JOIN 
    posted_hotel_bookings AS phb ON hr.posted_hotel_id = phb.id
INNER JOIN 
    room_types ON hr.room_types_id = room_types.id
WHERE 
    hr.id = $1;

-- name: UpdateHotelRoomStatus :one
UPDATE hotel_rooms
SET
  status=$1
WHERE
    id = $2
RETURNING *;