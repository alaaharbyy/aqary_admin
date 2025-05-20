-- name: CreateCountry :one
INSERT INTO countries (
    country,
    flag,
    alpha2_code,
    alpha3_code,
    country_code
)VALUES (
    $1, $2, $3, $4, $5
) RETURNING *;


-- name: GetCountryByName :one
SELECT * FROM countries 
WHERE country ILIKE $1 LIMIT 1;

-- name: GetCountry :one
SELECT * FROM countries 
WHERE id = $1 LIMIT $1;

-- name: GetCountries :many
SELECT * FROM countries
WHERE status= @active_status::BIGINT
ORDER BY id;

-- name: UpdateCountry :one
UPDATE countries
SET country = $2,
  flag = $3,
  alpha2_code = $4,
  alpha3_code = $5,
  country_code = $6
Where id = $1
RETURNING *;


-- name: DeleteCountry :exec
DELETE FROM countries
Where id = $1;


-- name: GetDefaultSettingsByCountryID :one
SELECT 
  countries.id,
  countries.country,
  countries.flag,
  countries.default_settings,
  coalesce(base_currency.flag::varchar,'')::varchar as base_currency_icon,
  coalesce(base_currency.code::varchar,'')::varchar as base_currency_code,
  coalesce(default_currency.flag::varchar,'')::varchar as default_currency_icon,
  coalesce(default_currency.code::varchar,'')::varchar as default_currency_code
FROM countries
LEFT JOIN currency AS base_currency on base_currency.id= (countries.default_settings->>'base_currency')::bigint
LEFT JOIN currency AS default_currency on default_currency.id= (countries.default_settings->>'default_currency')::bigint
WHERE countries.id= $1 limit 1;