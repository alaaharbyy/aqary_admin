-- name: CreatePostedHotelBooking :one
INSERT INTO posted_hotel_bookings (
    ref_no,
    company_types_id,
    is_branch,
    company_id,
    title,
    title_ar,
    countries_id,
    states_id,
    cities_id,
    community_id,
    subcommunity_id,
    lat,
    lng,
    ranking,
    no_of_rooms,
    facilities,
    amenities,
    views,
    created_at,
    updated_at,
    properties_id,
    is_property_branch,
    unit_id,
    posted_by,
    booking_categories_id,
    description,
    description_ar,
    booking_expiration,
    free_parking,
    free_breakfast,
    buffet_dinner,
    pay_at_property,
    pets_allowed,
    self_check_in,
    status,
    is_property
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
    $11, $12, $13, $14, $15, $16, $17, $18, $19, $20,
    $21, $22, $23, $24, $25, $26, $27, $28, $29, $30,
    $31, $32, $33, $34, $35,$36
) RETURNING *;
 
 
-- name: UpdatePostedHotelBooking :one
UPDATE posted_hotel_bookings
SET
    ref_no = $1,
    company_types_id = $2,
    is_branch = $3,
    company_id = $4,
    title = $5,
    title_ar = $6,
    countries_id = $7,
    states_id = $8,
    cities_id = $9,
    community_id = $10,
    subcommunity_id = $11,
    lat = $12,
    lng = $13,
    ranking = $14,
    no_of_rooms = $15,
    facilities = $16,
    amenities = $17,
    views = $18,
    created_at = $19,
    updated_at = $20,
    properties_id = $21,
    is_property_branch = $22,
    unit_id = $23,
    posted_by = $24,
    booking_categories_id = $25,
    description = $26,
    description_ar = $27,
    booking_expiration = $28,
    free_parking = $29,
    free_breakfast = $30,
    buffet_dinner = $31,
    pay_at_property = $32,
    pets_allowed = $33,
    self_check_in = $34,
    status = $35,
    is_property=$36
WHERE
    id = $37
RETURNING *;
 
-- name: GetPostedHotelBookingByID :one
select * from posted_hotel_bookings where id = $1;
 
-- name: GetAllPostedHotelBookings :many
select * from posted_hotel_bookings 
Limit $1
Offset $2;

-- name: UpdatePostedHotelBookingStatus :one
UPDATE posted_hotel_bookings
SET
    status = $2
WHERE
    id = $1
RETURNING *;

-- name: UpdatePostedHotelBookingRanking :one
UPDATE posted_hotel_bookings
SET
ranking= $2
WHERE id = $1
RETURNING *;

-- name: UpdateHolidayHomeRanking :one
UPDATE holiday_home
SET
    ranking= $2
WHERE
    id = $1
RETURNING *;