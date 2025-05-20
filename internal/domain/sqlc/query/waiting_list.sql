-- name: CreateWaitingListRequest :exec
INSERT INTO
    waiting_list(
        name,
        email,
        phone_number,
        country_code,
        company_id,
        section
    )
VALUES($1, $2, $3, $4, $5, $6);