-- name: UpdateSingleContactDocumentContactID :one
UPDATE contacts_document SET contacts_id = $1 WHERE id = $2 RETURNING *;

-- name: UpdateMultipleContactDocumentConactID :one
UPDATE contacts_document SET contacts_id = $1 WHERE id = ANY($2::bigint[]) RETURNING *;

-- name: GetSingleDocument :one
SELECT id, contacts_id, document_category_id,title,expiry_date,is_private,document_url, created_at 
FROM contacts_document WHERE contacts_id = $1;

-- name: GetAllDocumentsByContactsID :many
select id, contacts_id ,document_category_id,title,expiry_date,
    is_private,
    document_url,
    created_at
from contacts_document where contacts_id = $1;

-- name: DeleteContactDocument :exec
DELETE FROM contacts_document WHERE id = $1;

-- name: GetConctactsOtherContactByContactsID :many
select id, contacts_id, relationship,other_contacts_id,date_added
from contacts_other_contact where contacts_id = $1;

-- name: GetCountAllContactsDocuments :one
SELECT COUNT(*) FROM contacts_document WHERE contacts_id = $1;

-- name: GetAllContactsDocumentCategories :many
SELECT id, title,title_ar FROM document_categories where parent_category_id is null;

-- name: GetAllContactsDocumentSubCategories :many
select id, title,title_ar from document_categories where parent_category_id = $1;