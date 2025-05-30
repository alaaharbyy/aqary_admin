// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: newsletter_subscribers.sql

package sqlc

import (
	"context"
)

const createNewsLetterSubscribers = `-- name: CreateNewsLetterSubscribers :exec
INSERT INTO
    newsletter_subscribers(email, is_subscribed, company_id)
VALUES($1,$2,$3)
`

type CreateNewsLetterSubscribersParams struct {
	Email        string `json:"email"`
	IsSubscribed bool   `json:"is_subscribed"`
	CompanyID    int64  `json:"company_id"`
}

func (q *Queries) CreateNewsLetterSubscribers(ctx context.Context, arg CreateNewsLetterSubscribersParams) error {
	_, err := q.db.Exec(ctx, createNewsLetterSubscribers, arg.Email, arg.IsSubscribed, arg.CompanyID)
	return err
}
