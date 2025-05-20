


-- name: CreateSharedDocuments :one
INSERT INTO shared_documents (
    sharing_id,
    category_id,
    subcategory_id,
    file_url,
    status,
    is_allowed,
    created_at,
    updated_at
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
)RETURNING *;


