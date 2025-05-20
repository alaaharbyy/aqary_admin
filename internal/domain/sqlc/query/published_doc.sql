-- name: CreatePublishedDoc :one
INSERT INTO  published_doc(
    publish_info_id,
    documents_category_id,
    documents_subcategory_id,
    file_url,
    created_at,
    updated_at,
    projects_id,
    status,
    property_id
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9
) RETURNING *;

-- name: GetAllPublishedDocumentsByProject :many
SELECT published_doc.*,documents_category.category, documents_category.category_ar, documents_subcategory.sub_category, documents_subcategory.sub_category_ar FROM published_doc 
LEFT JOIN documents_category ON documents_category.id = published_doc.documents_category_id 
LEFT JOIN documents_subcategory ON documents_subcategory.id = published_doc.documents_subcategory_id
WHERE projects_id = $1 AND publish_info_id = $2;

-- name: DeletePublishedDocByProject :exec
DELETE FROM published_doc
WHERE projects_id = $1;