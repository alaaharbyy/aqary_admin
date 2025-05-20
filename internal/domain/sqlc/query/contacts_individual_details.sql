-- name: GetSingleContactIndividualDetails :one
select * from contacts_individual_details where contacts_id = $1;