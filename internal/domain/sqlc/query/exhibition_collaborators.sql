

-- name: GetNumbersOfExhibitionCollaboratorsByType :many 

SELECT collaborator_type,COUNT(id)

FROM exhibition_collaborators 

WHERE exhibitions_id=$1 AND is_deleted=false

GROUP BY 

	collaborator_type;

