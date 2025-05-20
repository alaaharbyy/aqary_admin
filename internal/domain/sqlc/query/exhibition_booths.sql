-- name: GetNumberOfExhibitionBooths :one
SELECT COUNT(exhibition_booths.id) FROM exhibition_booths
INNER JOIN exhibitions 
ON exhibitions.id = exhibition_booths.exhibitions_id AND exhibitions.event_status !=5 ;


SELECT COUNT(id) FROM exhibition_booths;


-- name: GetExhibitionBoothByExhibitionId :many
SELECT * 
FROM 
	exhibition_booths
WHERE 
	exhibitions_id=$1;

