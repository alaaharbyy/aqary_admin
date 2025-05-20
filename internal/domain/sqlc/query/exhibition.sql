
 
 
-- name: GetAllExhibition :many
SELECT 
	ex.id,
	ex.ref_no,
	ex.title,
	c.country, 
	ex.specific_address AS "address",
	ex.start_date,
	ex.end_date, 
	ex.event_banner_url AS "banner",
	CASE 
		WHEN ex.hosted_company_type=3 AND ex.is_host_branch =false THEN( 
																		select company_name
																		FROM
																	    	services_companies 	
																	    WHERE 
																	    	id=ex.hosted_by_id AND status!=6
																	  )  
		 WHEN ex.hosted_company_type=3 AND ex.is_host_branch =true THEN( 
																		select company_name
																		FROM
																	    	service_company_branches 	
																	    WHERE 
																	    	id=ex.hosted_by_id AND status!=6
																	  )
	    WHEN ex.hosted_company_type=2 AND ex.is_host_branch =false THEN( 
																		select company_name
																		FROM
																	    	developer_companies 	
																	    WHERE 
																	    	id=ex.hosted_by_id AND status!=6
																	  )  
		 WHEN ex.hosted_company_type=2 AND ex.is_host_branch =true THEN( 
																		select company_name
																		FROM
																	    	developer_company_branches 	
																	    WHERE 
																	    	id=ex.hosted_by_id AND status!=6
																	  )
	    WHEN ex.hosted_company_type=4 AND ex.is_host_branch =false THEN( 
																		select company_name
																		FROM
																	    	product_companies 	
																	    WHERE 
																	    	id=ex.hosted_by_id AND status!=6
																	  )  
	    WHEN ex.hosted_company_type=4 AND ex.is_host_branch =true THEN( 
																		select company_name
																		FROM
																	    	product_companies_branches 	
																	    WHERE 
																	    	id=ex.hosted_by_id AND status!=6
																	  )  
	END AS "hosted by"
FROM 
	exhibitions ex 
INNER JOIN 
	countries c
			 ON c.id=ex.countries_id 
WHERE ex.event_status !=5
ORDER BY ex.id DESC 
LIMIT $1 
OFFSET $2;
 
 
-- name: GetNumberOfAllExhibitions :one
SELECT 
	COUNT(id) 
FROM 
	exhibitions  
WHERE 
	event_status!=5;
 
 
 
 
-- name: ChangeStatusOfExhibitionByID :exec
UPDATE exhibitions 
SET 
	event_status=$2, 
	updated_at=$3 
WHERE
	id=$1; 

-- name: GetExhibitionByID :one
SELECT *
	FROM exhibitions 
WHERE 
	exhibitions.id=$1 AND event_status!=5;

-- name: CreateExhibition :one
INSERT INTO exhibitions (
    ref_no,
    self_hosted,
    hosted_by_id,
    is_host_branch,
    hosted_company_type,
    exhibition_type,
    exhibition_category,
    title,
    start_date,
    end_date,
    countries_id,
    states_id,
    cities_id,
    community_id,
    sub_communities_id,
    specific_address,
    mobile,
    email,
    whatsapp,
    registration_link,
    registration_fees,
    event_banner_url,
    event_logo_url,
    promotion_video,
    description,
    description_ar,
    event_status,
    created_by,
    created_at,
    updated_at,
    facilities,
    is_verified,
    no_of_booths, 
    no_of_floors, 
    location_url, 
    addresses_id
) VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    $10,
    $11,
    $12,
    $13,
    $14,
    $15,
    $16,
    $17,
    $18,
    $19,
    $20,
    $21,
    $22,
    $23,
    $24,
    $25,
    $26,
    $27,
    $28,
    $29,
    $30,
    $31,
    $32,
    $33,
    $34, 
    $35,
    $36
)RETURNING *;

-- name: UpdateExhibitionByID :one
UPDATE exhibitions
SET 
    self_hosted = $1,
    hosted_by_id = $2,
    is_host_branch = $3,  
    exhibition_type = $4, 
    exhibition_category = $5, 
    title = $6, 
    start_date = $7, 
    end_date = $8, 
    countries_id = $9, 
    states_id = $10,
    cities_id = $11, 
    community_id = $12, 
    specific_address = $13, 
    mobile = $14, 
    email = $15, 
    whatsapp = $16, 
    registration_link = $17,
    registration_fees = $18, 
    event_banner_url = $19, 
    event_logo_url = $20, 
    promotion_video = $21, 
    description = $22, 
    description_ar = $23, 
    no_of_booths = $24,
    hosted_company_type = $25,
    facilities = $26,
    sub_communities_id = $27,
    no_of_floors = $28,
    location_url = $29, 
    addresses_id=$30, 
    updated_at=$31
WHERE
    id = $32 AND event_status != 5 
RETURNING *;



-- name: UpdateExhibitionsMedia :one 
UPDATE exhibitions_media
	SET
		media_url=$1,
		updated_at=$2
	WHERE exhibitions_media.id=$3 AND ( select event_status from exhibitions where  exhibitions.id = $4) != 5
RETURNING *;

-- name: GetAllcompaniesForExhibition :many
SELECT id AS company_id,false AS is_branch,3 AS company_type,company_name
FROM services_companies 
WHERE status!=6
UNION 
SELECT id AS company_id,true AS is_branch,3 AS company_type,company_name
FROM service_company_branches  
WHERE status!=6
UNION 
SELECT id AS company_id,false AS is_branch,2 AS company_type,company_name
FROM developer_companies 
WHERE status!=6
UNION
SELECT id AS company_id,true AS is_branch,2 AS company_type,company_name
FROM developer_company_branches
WHERE status!=6 
UNION
SELECT id AS company_id,false AS is_branch,4 AS company_type,company_name
FROM product_companies 
WHERE status!=6 
UNION
SELECT id AS company_id,true AS is_branch,4 AS company_type,company_name
FROM product_companies_branches 
WHERE status!=6;


-- name: CreateExhibitionBooth :one
INSERT INTO exhibition_booths (
	exhibitions_id, 
	floor_no, 
	no_of_booths, 
	interactive_link
) VALUES(
	$1, 
	$2, 
	$3, 
	$4 
)RETURNING *;
 
-- name: UpdateExhibitionBooth :one
UPDATE exhibition_booths 
SET 
	exhibitions_id=$2, 
	floor_no=$3, 
	no_of_booths=$4, 
	interactive_link=$5
WHERE id=$1 
RETURNING *;
 
 
-- name: GetExhibitionBoothById :one
SELECT eb.id, eb.exhibitions_id, eb.floor_no, eb.no_of_booths, eb.interactive_link FROM exhibition_booths eb
INNER JOIN exhibitions 
ON exhibitions.id = eb.exhibitions_id AND exhibitions.event_status !=5 
WHERE eb.id=$1;
 
 
-- name: GetAllExhibitionBooths :many
SELECT eb.id, eb.exhibitions_id, eb.floor_no, eb.no_of_booths, eb.interactive_link FROM exhibition_booths eb
INNER JOIN exhibitions 
ON exhibitions.id = eb.exhibitions_id AND exhibitions.event_status !=5 
ORDER BY eb.id DESC 
LIMIT $1
OFFSET $2;
 
 
-- name: DeleteExhibitionBooth :exec 
DELETE FROM exhibition_booths 
WHERE id=$1;