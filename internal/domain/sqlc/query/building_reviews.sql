-- name: CreateBuildingReviews :one
INSERT INTO building_reviews (
     property_id,
     property_table,
     reviews,
     maintenance_rating,
     staff_rating,
     gym_rating,
     noise_rating,
     children_rating,
     traffic_rating,
     guest_parking_rating,
     profiles_id,
     status,
     created_at,
     updated_at,
     users_id
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15 
) RETURNING *;
 
-- name: GetBuildingReviews :one
SELECT * FROM building_reviews 
WHERE id = $1 LIMIT $1;

-- name: GetAllBuildingReviews :many
SELECT * FROM building_reviews
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateBuildingReviews :one
UPDATE building_reviews
SET  property_id = $2,
     property_table = $3,
     reviews = $4,
     maintenance_rating = $5,
     staff_rating = $6,
     gym_rating = $7,
     noise_rating = $8,
     children_rating = $9,
     traffic_rating = $10,
     guest_parking_rating = $11,
      profiles_id = $12,
     status = $13,
     created_at = $14,
     updated_at = $15,
     users_id = $16
Where id = $1
RETURNING *;


-- name: DeleteBuildingReviews :exec
DELETE FROM building_reviews
Where id = $1;