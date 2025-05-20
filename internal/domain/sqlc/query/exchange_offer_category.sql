-- name: CreateExchangeOfferCategory :one
INSERT INTO exchange_offer_category (
   title,
   ref_id
)VALUES (
    $1, $2
) RETURNING *;

-- name: GetExchangeOfferCategory :one
SELECT * FROM exchange_offer_category
WHERE id = $1 LIMIT 1;


-- name: GetAllExchangeOfferCategory :many
SELECT * FROM exchange_offer_category
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateExchangeOfferCategory :one
UPDATE exchange_offer_category
SET title = $2,
   ref_id = $3
Where id = $1
RETURNING *;

-- name: DeleteExchangeOfferCategory :exec
DELETE FROM exchange_offer_category
Where id = $1;



-- name: GetCountAllOfferCategories :one
SELECT Count(*) FROM exchange_offer_category;