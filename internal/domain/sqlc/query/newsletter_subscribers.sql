-- name: CreateNewsLetterSubscribers :exec
INSERT INTO
    newsletter_subscribers(email, is_subscribed, company_id)
VALUES($1,$2,$3);