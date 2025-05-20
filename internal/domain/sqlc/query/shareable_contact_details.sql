-- name: GetSingleContactShareableDetails :one 
select * from shareable_contact_details where contacts_id = $1;