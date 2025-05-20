-- name: GetAllActiveNewsLetterSubscribers :many
 
SELECT  
	ns.*,
	u.username,
	u.email
FROM newsletter_subscribers ns
JOIN users u ON ns.subscriber=u.id
WHERE ns.is_active=TRUE 
ORDER BY ns.id DESC
LIMIT $1
OFFSET $2;
 
-- name: GetNewsLetterSubscribersCount :one
 
SELECT  
	COUNT(*) 
FROM newsletter_subscribers 
WHERE is_active=TRUE;