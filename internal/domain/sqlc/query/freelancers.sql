-- name: CreateFreelancer :one
INSERT INTO freelancers (
    profiles_id,
    users_id,
    about,
    about_arabic,
    nationalities,
    brn,
    br_file,
    facebook_profile_url,
    instagram_profile_url,
    linkedin_profile_url,
    twitter_profile_url,
    youtube,
    status,
    noc_file,
    noc_expiry_date,
    created_at,
    updated_at,
    freelancers_companies
)VALUES (
    $1 ,$2, $3, $4, $5,$6,$7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18
) RETURNING *;


-- name: GetFreelancer :one
SELECT * FROM freelancers 
WHERE id = $1 LIMIT $1;


-- name: GetAllFreelancer :many
SELECT * FROM freelancers
ORDER BY id
LIMIT $1
OFFSET $2;



-- name: UpdateFreelancer :one
UPDATE freelancers
SET profiles_id = $2,
    users_id = $3,
    about = $4,
    about_arabic = $5,
    nationalities = $6,
    brn = $7,
    br_file = $8,
    facebook_profile_url = $9,
    instagram_profile_url = $10,
    linkedin_profile_url = $11,
    twitter_profile_url = $12,
    youtube = $13,
    status = $14,
    noc_file = $15,
    noc_expiry_date = $16,
    created_at = $17,
    updated_at = $18,
    freelancers_companies = $19
Where id = $1
RETURNING *;


-- name: DeleteFreelancer :exec
DELETE FROM freelancers
Where id = $1;

 