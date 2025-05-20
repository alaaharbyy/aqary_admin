-- name: GetProfession :one
SELECT * FROM professions WHERE id = $1 LIMIT 1;

-- name: GetProfessionDummy :one
UPDATE professions SET title = COALESCE(sqlc.narg(n_title), title), title_ar = COALESCE(sqlc.narg(n_title_ar), title_ar) where id = $1 RETURNING *;

