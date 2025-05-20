-- name: CreateLeadDocument :one
INSERT INTO leads_document (
    leads_id,
    document_category_id,
    is_private,
    title,
    document_url,
    date_added,
    expiry_date,
    description,
    entered_by
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9
) RETURNING *;


-- name: UpdateLeadDocumentDetails :one
UPDATE leads_document
SET
    title = $2,
    document_url = $3,
    document_category_id = $4
WHERE
    id = $1
RETURNING *;


-- name: UpdateLeadDocumentPrivacy :one
UPDATE leads_document
SET
    is_private = $2
WHERE
    id = $1
RETURNING *;

-- name: GetLeadDocumentById :many
SELECT ld.id, ld.document_category_id, dc.category as document_category, ld.title, NOT ld.is_private AS is_public, ld.document_url, ld.date_added, ld.expiry_date, ld.description FROM
    leads_document ld LEFT JOIN documents_category dc on ld.document_category_id = dc.id  
WHERE
    leads_id = $1 LIMIT $2 OFFSET $3;

-- name: GetLeadDocumentsByLeadIdWithPagination :many
SELECT ld.*, dc.category, u.username as "entered_by_username" FROM
    leads_document ld
LEFT JOIN documents_category dc on ld.document_category_id = dc.id
LEFT JOIN users u on ld.entered_by = u.id
WHERE
    ld.leads_id = $1
ORDER BY
    ld.id
LIMIT
    $3
OFFSET
    $2;

-- name: UpdateSingleLeadDocumentLeadID :one
UPDATE leads_document SET leads_id = $1 WHERE id = $2 RETURNING *;

-- name: UpdateMultipleLeadDocumentLeadID :one
UPDATE leads_document SET leads_id = $1 WHERE id = ANY($2::bigint[]) RETURNING *;

-- name: GetCountAllLeadsDocumentsByLeadId :one
SELECT COUNT(*) FROM leads_document WHERE leads_id = $1;

-- name: DeleteLeadDocumentByDocumentId :exec
delete from leads_document where id =  $1;

-- name: GetLeadDocumentByDocumentId :one
select * from leads_document where id = $1;