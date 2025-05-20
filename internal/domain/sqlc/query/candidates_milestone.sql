-- name: CreateCandidateMilstone :one
INSERT INTO candidates_milestone (
    candidates_id,
    application_status,
    status_date
    ) VALUES ($1,$2,$3) 
    returning *;

-- name: GetAllCandidateMilstonesByCandId :many
select * from candidates_milestone where candidates_id=$1;
 
-- name: GetCandidateMilstoneById :one
select * from candidates_milestone where id=$1;