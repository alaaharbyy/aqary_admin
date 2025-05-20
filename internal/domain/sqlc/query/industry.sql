-- name: GetIndustry :one
SELECT * FROM industry WHERE id = $1 LIMIT 1;