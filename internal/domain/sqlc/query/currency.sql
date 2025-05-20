-- name: CreateCurrency :one
INSERT INTO currency (
    currency,
    code,
    flag
)VALUES (
    $1, $2, $3
) RETURNING *;

-- name: CreateCurrencyNew :one
INSERT INTO currency (
    currency,
    code,
    flag,
    currency_rate,
    updated_at,
    updated_by,
    created_at,
    status
)VALUES (
    $1, $2, $3, $4, $5, $6, $7,$8
) RETURNING *;

-- name: GetCurrency :one
SELECT * FROM currency 
WHERE id = $1 LIMIT $1;

-- name: GetCurrencyNew :one
SELECT * FROM currency 
WHERE id = $1 LIMIT 1;


-- name: GetCurrencyByCurrencyNew :one
SELECT * FROM currency 
WHERE currency = $1 AND status !=6
LIMIT 1;

-- name: GetCurrencyByCurrency :one
SELECT * FROM currency 
WHERE currency = $2 LIMIT $1;


-- name: GetCurrencyByCode :one
SELECT * FROM currency 
WHERE LOWER(TRIM(code)) = LOWER(TRIM(@code::text)) AND status !=6 ;


-- name: GetAllCurrency :many
SELECT * FROM currency
WHERE status = 2
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: GetAllCurrencyNew :many
SELECT * FROM currency
where status!=6
ORDER BY updated_at desc
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetAllCurrencyNewCount :one
SELECT count(*) FROM currency
where status!=6;

-- name: GetDeletedCurrencies :many
SELECT * FROM currency
where status=6
ORDER BY updated_at desc
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetDeletedCurrenciesCount :one
SELECT count(*) FROM currency
where status=6;


-- name: UpdateCurrency :one
UPDATE currency
SET currency = $2,
    code = $3,
    flag = $4,
    status=$5,
    updated_by=$6,
    updated_at = now()

Where id = $1
RETURNING *;

-- name: DeleteCurrency :exec
DELETE FROM currency
Where id = $1;

-- name: UpdateCurrencyRateByCode :exec
UPDATE currency
SET currency_rate = $1,
updated_at = now()
WHERE code = $2;

-- name: UpdateCurrencyStatus :one
UPDATE currency
SET status = $1,
    updated_by=$3,
    deleted_at=$4,
    updated_at = now()
WHERE id = $2
RETURNING *;