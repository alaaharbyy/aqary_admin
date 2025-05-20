-- name: CreateHolidayHomePromo :one
INSERT INTO holiday_home_promo (
    holiday_home_id,
    booking_portal_id,
    ref_no,
    promo_code,
    promo_start,
    promo_end,
    price,
    status,
	holiday_home_portals_id
)VALUES (
      $1 ,$2, $3, $4, $5, $6, $7, $8, $9
) RETURNING *;


-- name: GetHolidayHomePromo :one
SELECT * FROM holiday_home_promo
WHERE id = $1 and status != 6 ORDER BY updated_at LIMIT 1;

-- name: GetAllHolidayHomePromo :many
SELECT * FROM holiday_home_promo WHERE status != 6
ORDER BY updated_at DESC
LIMIT $1
OFFSET $2;

-- name: UpdateHolidayHomePromo :one
UPDATE holiday_home_promo
SET  holiday_home_id = $1,
    booking_portal_id = $2,
    ref_no = $3,
    promo_code = $4,
    promo_start = $5,
    promo_end = $6,
    price = $7,
    status = $8,
    updated_at = $9,
	holiday_home_portals_id = $10
WHERE id = $11
RETURNING *;


-- name: DeleteHolidayHomePromo :exec
DELETE FROM holiday_home_promo
Where id = $1;

-- name: GetAllCountHolidayHomePromo :one
SELECT COUNT(*) FROM holiday_home_promo WHERE status != 6;

-- name: GetAllHolidayHomePromobyHolidayId :many
SELECT * FROM holiday_home_promo WHERE status != 6
and holiday_home_id= $3
LIMIT $1
OFFSET $2;

-- name: GetAllHolidayPromoByHolidayIdandBk :many
SELECT * FROM holiday_home_promo
WHERE holiday_home_id = $1 and booking_portal_id = $2 
LIMIT $3 OFFSET $4;
 
-- name: GetAllHolidayPromoByHolidayId :many
SELECT * FROM holiday_home_promo
WHERE holiday_home_id = $1 
LIMIT $2 OFFSET $3;
 
-- name: GetAllHolidayPromoByBkId :many
SELECT * FROM holiday_home_promo
WHERE  booking_portal_id = $1
LIMIT $2 OFFSET $3;
 
-- name: GetAllHolidayPromoByHolidaysId :many
SELECT * FROM holiday_home_promo
WHERE holiday_home_id = $1;
 
-- name: GetAllHolidayPromoByBookId :many
SELECT * FROM holiday_home_promo
WHERE  booking_portal_id = $1;

-- name: GetAllCountHolidayPromoByHolidayIdandBk :one
SELECT COUNT(*) FROM holiday_home_promo WHERE holiday_home_id = $1 and holiday_home_portals_id= $2 ;

-- name: UpdateHolidayHomePromoStatus :one
UPDATE holiday_home_promo
SET   
 status = $1,
 updated_at = $2
WHERE id = $3
RETURNING *;

-- name: GetAllHolidayPromoByHolidayIdandHolidayBk :many
SELECT * FROM holiday_home_promo
WHERE holiday_home_id = $1 and holiday_home_portals_id = $2 
ORDER BY updated_at
LIMIT $3 OFFSET $4;
 
-- name: GetAllHolidayPromoByHolidayBkId :many
SELECT * FROM holiday_home_promo
WHERE  holiday_home_portals_id = $1
LIMIT $2 OFFSET $3;
 
-- name: GetAllHolidayPromoByHolidayPortId :many
SELECT * FROM holiday_home_promo
WHERE  holiday_home_portals_id = $1;