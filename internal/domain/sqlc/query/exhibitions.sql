

-- name: GetNumberOfExhibitionsAfterFiltration :one 
SELECT COUNT(id) FROM exhibitions WHERE countries_id =$1 AND (event_status=$2 OR event_status =$3);



-- name: GetAllExhibitionCountries :many 
SELECT COUNT(exhibitions.id) , countries.id,countries.country
FROM exhibitions 
INNER JOIN countries 
	ON exhibitions.countries_id = countries.id 
WHERE exhibitions.event_status=2 OR exhibitions.event_status=3
GROUP BY countries.id;



-- name: GetSingleExhibition :one 
SELECT * FROM exhibitions WHERE id = $1 AND event_status !=5;



-- name: DoesExhibitionExist :one 
SELECT id FROM exhibitions WHERE id = $1 AND event_status !=5;



-- name: GetNumberOfAllLocalExhibitions :one
SELECT 
	COUNT(id) 
FROM 
	exhibitions  
WHERE 
	event_status!=5 AND countries_id = 1;



-- name: GetNumberOfAllInternationalExhibitions :one
SELECT 
	COUNT(id) 
FROM 
	exhibitions  
WHERE 
	event_status!=5 AND countries_id != 1;



-- name: GetAllExhibitionsWithoutPagination :many
SELECT id,ref_no,title,event_logo_url,is_verified,exhibition_type,exhibition_category,updated_at
FROM 
	exhibitions
WHERE 
	event_status !=5
ORDER BY updated_at DESC;

