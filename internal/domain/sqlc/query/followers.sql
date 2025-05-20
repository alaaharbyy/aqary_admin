-- name: GetAllFollowers :many
SELECT u.id,
        p.first_name,
       cu.company_id,
    --    cu.company_type,
    --    cu.is_branch,
       ct.title AS company_type_title,
    ct.title_ar AS company_type_title_ar,
       (
           SELECT COUNT(*)
           FROM social_connections sc
           WHERE sc.user_id = u.id
       ) AS total_social_connections
FROM followers f
JOIN users u ON f.followers_id = u.id
JOIN profiles p ON u.profiles_id = p.id
LEFT JOIN company_users cu ON u.id = cu.users_id
LEFT JOIN company_types ct ON cu.company_type = ct.id
WHERE f.user_id = $1 LIMIT $2 OFFSET $3;

-- name: GetAllFollowing :many
SELECT u.id,
        p.first_name,
       cu.company_id,
    --    cu.company_type,
    --    cu.is_branch,
       ct.title AS company_type_title,
    ct.title_ar AS company_type_title_ar,
       (
           SELECT COUNT(*)
           FROM social_connections sc
           WHERE sc.user_id = u.id
       ) AS total_social_connections
FROM followers f
JOIN users u ON f.user_id = u.id
JOIN profiles p ON u.profiles_id = p.id
LEFT JOIN company_users cu ON u.id = cu.users_id
LEFT JOIN company_types ct ON cu.company_type = ct.id
WHERE f.followers_id = $1 LIMIT $2 OFFSET $3;

-- name: GetCountAllFollowers :one
SELECT COUNT(*) AS follower_count
FROM followers
WHERE followers.followers_id = $1 LIMIT 1;

-- name: GetCountAllFollowing :one
SELECT COUNT(*) AS following_count
FROM followers
WHERE followers.user_id = $1 LIMIT 1;


-- name: GetSingleFollower :one
select * from followers where user_id = $1 AND followers_id = $2 LIMIT 1;

-- name: CreateFollower :one
INSERT INTO followers (user_id, followers_id, follow_date) VALUES ($1, $2, $3) RETURNING *;


-- name: DeleteFollowerByUserAndFollowersID :exec
DELETE FROM followers
WHERE user_id = $1
AND followers_id = $2;
 
 
-- name: DeleteFollowerByID :exec
DELETE FROM followers
WHERE id = $1;
 
 
-- name: DeleteFollowersByUserId :exec
DELETE FROM followers
WHERE user_id = $1;
 
 
-- name: DeleteFollowingByFollowersId :exec
DELETE FROM followers
WHERE followers_id = $1;