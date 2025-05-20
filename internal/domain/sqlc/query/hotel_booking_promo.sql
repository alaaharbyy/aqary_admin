-- name: CreateHotelBookingPromo :one
INSERT INTO hotel_booking_promo(company_types_id, companies_id, is_branch, ref_no, promo_code, promo_start, promo_end, created_at, updated_at,status)
VALUES($1, $2, $3, $4, $5, $6, $7, $8,$9,$10) RETURNING *;
 
 
-- name: UpdateHotelBookingPromo :one
UPDATE hotel_booking_promo
SET company_types_id = $2,
    companies_id = $3,
    is_branch = $4,
    ref_no = $5,
    promo_code = $6,
    promo_start = $7,
    promo_end = $8,
    updated_at = $9,
    status=$10
WHERE id = $1 RETURNING *;
 
 
-- name: GetAllHotelBookingPromos :many
SELECT * FROM hotel_booking_promo;
 
-- name: GetHotelBookingPromoByID :one
SELECT * FROM hotel_booking_promo WHERE id=$1;

-- name: UpdateHotelBookingPromoStatus :one
UPDATE hotel_booking_promo
SET  
   status=$2
WHERE id = $1 RETURNING *;