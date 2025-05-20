-- name: CreateHotelBookingCategory :one
insert into hotel_booking_categories (title,title_ar,status)
values($1, $2, $3) returning *;

-- name: UpdateHotelBookingCategory :one 
update hotel_booking_categories
set 
	title=$2,
	title_ar=$3,
	status=$4
where 
	id=$1 AND status!=6
returning *;
 
-- name: GetHotelBookingCategories :many
select * 
from 
	hotel_booking_categories
WHERE 
	status!=6
ORDER BY id 
LIMIT $1
OFFSET $2;
 
 
-- name: GetHotelBookingCategory :one
select * 
from 
	hotel_booking_categories 
where 
	id=$1 AND status!=6;
 
-- name: UpdateHotelBookingCategoryStatus :one
update hotel_booking_categories
set
status=$1
where id=$2
returning *;

-- name: GetNumberOfHotelBookingCategories :one
SELECT COUNT(id)
FROM hotel_booking_categories
WHERE status!=6;