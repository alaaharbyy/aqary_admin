-- name: CreateServicesCompany :one
INSERT INTO services_companies (
    company_name,
    description,
    logo_url,
    addresses_id,
    email,
    phone_number,
    whatsapp_number,
    commercial_license_no,
    commercial_license_file_url,
    commercial_license_expiry,
    is_verified, 
    website_url,
    cover_image_url,
    tag_line,
    vat_no,
    vat_status,
    vat_file_url,
    facebook_profile_url,
    instagram_profile_url,
    twitter_profile_url,
    no_of_employees,
    users_id,
    linkedin_profile_url,
    company_rank,
    status,
    country_id,
    company_type,
    is_branch,
    created_at,
    updated_at,
    ref_no,
    commercial_license_registration_date,
    commercial_license_issue_date,
    extra_license_nos,
    extra_license_files,
    extra_license_names,
    extra_license_issue_date,
    extra_license_expiry_date,
    license_dcci_no,
    register_no,
    other_social_media,
    youtube_profile_url,
    bank_account_details_id,
    created_by
)VALUES (
    $1 ,$2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, 
    $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33, $34, $35, $36 , $37, $38, $39, $40, $41, $42, $43, $44
) RETURNING *;

-- name: GetServicesCompany :one
SELECT * FROM services_companies 
WHERE id = $1 LIMIT 1;

-- name: GetCountServicesCompany :one
SELECT COUNT(*) FROM services_companies LIMIT 1;

-- -- name: GetCountServicesCompanyByMainServiceId :one
-- SELECT COUNT(*) FROM services_companies Where main_services_id = $1  LIMIT 1;

-- name: GetAllServicesCompanyByCountry :many
SELECT * FROM services_companies  
WHERE country_id = $3  AND status != 6   LIMIT $1 OFFSET $2;


-- -- name: GetAllServicesCompanyByMainServiceId :many
-- SELECT * FROM services_companies  
-- WHERE main_services_id = $3 LIMIT $1 OFFSET $2;

-- name: GetAllServicesCompanyByRank :many
SELECT * FROM services_companies  
WHERE company_rank = $3 LIMIT $1 OFFSET $2;


-- name: GetAllServicesCompanyByStatus :many
SELECT * FROM services_companies  
WHERE status = $3 LIMIT $1 OFFSET $2;

-- name: GetAllServicesCompanyByCountryByNotEqual :many
SELECT * FROM services_companies  
WHERE country_id != $3    LIMIT $1 OFFSET $2;

-- name: GetServicesCompanyByName :one
SELECT * FROM services_companies 
WHERE company_name ILIKE $1 LIMIT 1;

-- name: GetAllServicesCompany :many
SELECT * FROM services_companies
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateServicesCompany :one
UPDATE services_companies
SET    company_name = $2,
    description =$3,
    logo_url =$4,
    addresses_id =$5,
    email =$6,
    phone_number =$7,
    whatsapp_number =$8,
    commercial_license_no =$9,
    commercial_license_file_url = $10,
    commercial_license_expiry = $11,
    is_verified =$12,
    website_url =$13,
    cover_image_url = $14,
    tag_line =$15,
    vat_no =$16,
    vat_status =$17,
    vat_file_url =$18,
    facebook_profile_url =$19,
    instagram_profile_url =$20,
    twitter_profile_url= $21,
    no_of_employees = $22,
    users_id = $23,
    linkedin_profile_url = $24,
    bank_account_details_id = $25,
    company_rank = $26,
    status = $27,
    country_id = $28,
    company_type = $29,
    is_branch = $30,
    created_at = $31,
    updated_at = $32,
    ref_no = $33,
    commercial_license_registration_date = $34,
    commercial_license_issue_date = $35,
    extra_license_nos = $36,
    extra_license_files = $37,
    extra_license_names = $38,
    extra_license_issue_date = $39,
    extra_license_expiry_date = $40,
    license_dcci_no = $41,
    register_no = $42,
    other_social_media = $43,
    youtube_profile_url = $44,
    created_by = $45
Where id = $1
RETURNING *;


-- name: DeleteServicesCompany :exec
DELETE FROM services_companies
Where id = $1;


-- -- name: GetServiceCompanySubscriptionById :one
-- SELECT services_subscription_id FROM services_companies 
-- WHERE id = $1;







 




-- name: GetServiceCompanyDocs :one
SELECT logo_url, commercial_license_file_url,
  cover_image_url, 
  vat_file_url 
FROM services_companies Where id = $1 LIMIT 1;


-- -- name: GetServiceCompanyByServiceSubscriptionId :one
-- SELECT * from services_companies
-- WHERE services_subscription_id = $1 LIMIT 1;


-- -- name: UpdateServiceCompanyMainService :one
-- UPDATE services_companies
-- SET main_services_id = $2
-- Where id = $1
-- RETURNING *;

-- name: UpdateServiceCompanyRank :one
UPDATE services_companies 
SET company_rank=$2 
Where id =$1 
RETURNING *;


-- name: UpdateServiceCompanyStatus :one
UPDATE services_companies 
SET status=$2 
Where id =$1 
RETURNING *;

-- name: GetServiceCompanyByCommercialLicNo :one
SELECT * FROM services_companies 
WHERE commercial_license_no ILIKE $1 LIMIT 1;

-- name: GetServiceCompanyForGraph :one 
SELECT id,
	company_name, 
	description, 
	logo_url, 
	cover_image_url, 
	is_verified, 
	commercial_license_no
FROM 
	services_companies 
WHERE 
	id=$1 
LIMIT 1;



-- name: GetAllLocalExhibitions :many
SELECT 
	ex.id,
	ex.ref_no,
	ex.title,
	c.country, 
	states.state,
	cities.city, 
	communities.community, 
	sub_communities.sub_community,
	ex.specific_address AS "address",
	ex.start_date,
	ex.end_date, 
	ex.event_banner_url AS "banner",
	ex.event_logo_url,
	ex.event_status,
	CASE 
		WHEN ex.hosted_company_type=3 AND ex.is_host_branch =false THEN( 
																		select company_name
																		FROM
																	    	services_companies 	
																	    WHERE 
																	    	id=ex.hosted_by_id AND status!=6
																	  )::VARCHAR  
		 WHEN ex.hosted_company_type=3 AND ex.is_host_branch =true THEN( 
																		select company_name
																		FROM
																	    	service_company_branches 	
																	    WHERE 
																	    	id=ex.hosted_by_id AND status!=6
																	  )::VARCHAR
	    WHEN ex.hosted_company_type=2 AND ex.is_host_branch =false THEN( 
																		select company_name
																		FROM
																	    	developer_companies 	
																	    WHERE 
																	    	id=ex.hosted_by_id AND status!=6
																	  )::VARCHAR  
		 WHEN ex.hosted_company_type=2 AND ex.is_host_branch =true THEN( 
																		select company_name
																		FROM
																	    	developer_company_branches 	
																	    WHERE 
																	    	id=ex.hosted_by_id AND status!=6
																	  )::VARCHAR
	    WHEN ex.hosted_company_type=4 AND ex.is_host_branch =false THEN( 
																		select company_name
																		FROM
																	    	product_companies 	
																	    WHERE 
																	    	id=ex.hosted_by_id AND status!=6
																	  )::VARCHAR  
	    WHEN ex.hosted_company_type=4 AND ex.is_host_branch =true THEN( 
																		select company_name
																		FROM
																	    	product_companies_branches 	
																	    WHERE 
																	    	id=ex.hosted_by_id AND status!=6
																	  )::VARCHAR  
	END AS "hosted by"
FROM 
	exhibitions ex 
INNER JOIN 
	countries c 
			 ON c.id=ex.countries_id 
INNER JOIN 
    cities
    		ON cities.id = ex.cities_id
INNER JOIN 
	communities 
			ON communities.id = ex.community_id
INNER JOIN 
	sub_communities 
			ON sub_communities.id = ex.sub_communities_id 
INNER JOIN 
	states
		ON states.id = ex.states_id
WHERE ex.event_status !=5 AND c.id = 1
ORDER BY ex.updated_at DESC, ex.id DESC
LIMIT $1 OFFSET $2;



-- name: GetAllInternationalExhibitions :many
SELECT 
	ex.id,
	ex.ref_no,
	ex.title,
	c.country, 
	states.state,
	cities.city, 
	communities.community, 
	sub_communities.sub_community,
	ex.specific_address AS "address",
	ex.start_date,
	ex.end_date, 
	ex.event_banner_url AS "banner",
	ex.event_logo_url,
	ex.event_status,
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
INNER JOIN 
    cities
    		ON cities.id = ex.cities_id
INNER JOIN 
	communities 
			ON communities.id = ex.community_id
INNER JOIN 
	sub_communities 
			ON sub_communities.id = ex.sub_communities_id 
INNER JOIN 
	states
		ON states.id = ex.states_id
WHERE ex.event_status !=5 AND c.id != 1
ORDER BY ex.updated_at DESC , ex.id DESC
LIMIT $1 
OFFSET $2;

