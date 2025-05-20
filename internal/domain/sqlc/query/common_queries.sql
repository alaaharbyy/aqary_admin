


 


-- name: GetCompanyByStatus :many
With x As (
   SELECT id, company_name, company_type, logo_url, commercial_license_no, email, phone_number, status, company_rank, is_branch, addresses_id, users_id FROM broker_companies  WHERE  broker_companies.status = $3 
   UNION ALL
   SELECT id, company_name, company_type, logo_url, commercial_license_no, email, phone_number, status, company_rank, is_branch, addresses_id, users_id FROM broker_companies_branches WHERE  broker_companies_branches.status = $3
   UNION ALL
   SELECT  id, company_name, company_type, logo_url, commercial_license_no, email, phone_number, status, company_rank, is_branch, addresses_id,  users_id FROM developer_companies WHERE  developer_companies.status = $3
   UNION ALL
   SELECT  id, company_name, company_type, logo_url, commercial_license_no, email, phone_number, status, company_rank, is_branch, addresses_id,  users_id FROM developer_company_branches WHERE  developer_company_branches.status = $3
   UNION ALL
   SELECT  id, company_name, company_type, logo_url, commercial_license_no, email, phone_number, status, company_rank, is_branch,  addresses_id,  users_id FROM services_companies WHERE  services_companies.status = $3
   UNION ALL
   SELECT  id, company_name, company_type, logo_url, commercial_license_no, email, phone_number, status, company_rank, is_branch, addresses_id,  users_id FROM service_company_branches WHERE  service_company_branches.status = $3
) SELECT * FROM x  ORDER BY id  LIMIT $1 OFFSET $2;


-- name: GetCountCompanyByStatus :one
With x As (
   SELECT id   FROM broker_companies  WHERE  broker_companies.status = $1
   UNION ALL
   SELECT id   FROM broker_companies_branches  WHERE  broker_companies_branches.status = $1
   UNION ALL
   SELECT  id   FROM developer_companies WHERE  developer_companies.status = $1
   UNION ALL
   SELECT  id   FROM developer_company_branches WHERE  developer_company_branches.status = $1
   UNION ALL
   SELECT  id   FROM services_companies WHERE  services_companies.status = $1
   UNION ALL
   SELECT  id   FROM service_company_branches WHERE  service_company_branches.status = $1
    
) SELECT COUNT(*) FROM x;




-- name: GetCompanyByRank :many
With x As (
   SELECT id, company_name, company_type, logo_url, commercial_license_no, email, phone_number, status, company_rank, is_branch, addresses_id,  users_id FROM broker_companies  WHERE  broker_companies.company_rank = $3 
   UNION ALL
   SELECT id, company_name, company_type, logo_url, commercial_license_no, email, phone_number, status, company_rank, is_branch, addresses_id,  users_id FROM broker_companies_branches WHERE  broker_companies_branches.company_rank = $3
   UNION ALL
   SELECT  id, company_name, company_type, logo_url, commercial_license_no, email, phone_number, status, company_rank, is_branch, addresses_id,  users_id FROM developer_companies WHERE  developer_companies.company_rank = $3
   UNION ALL
   SELECT  id, company_name, company_type, logo_url, commercial_license_no, email, phone_number, status, company_rank, is_branch, addresses_id,  users_id FROM developer_company_branches WHERE  developer_company_branches.company_rank = $3
   UNION ALL
   SELECT  id, company_name, company_type, logo_url, commercial_license_no, email, phone_number, status, company_rank, is_branch,  addresses_id,  users_id FROM services_companies WHERE  services_companies.company_rank = $3
   UNION ALL
   SELECT  id, company_name, company_type, logo_url, commercial_license_no, email, phone_number, status, company_rank, is_branch, addresses_id,  users_id FROM service_company_branches WHERE  service_company_branches.company_rank = $3
    
) SELECT * FROM x  ORDER BY id  LIMIT $1 OFFSET $2;


-- name: GetCountCompanyByRank :one
With x As (
   SELECT id  FROM broker_companies  WHERE  broker_companies.company_rank = $1
   UNION ALL
   SELECT id  FROM broker_companies_branches  WHERE  broker_companies_branches.company_rank = $1
   UNION ALL
   SELECT  id   FROM developer_companies WHERE  developer_companies.company_rank = $1
   UNION ALL
   SELECT  id   FROM developer_company_branches WHERE  developer_company_branches.company_rank = $1
   UNION ALL
   SELECT  id   FROM services_companies WHERE  services_companies.company_rank = $1
   UNION ALL
   SELECT  id   FROM service_company_branches WHERE  service_company_branches.company_rank = $1
) SELECT COUNT(*) FROM x;


-- name: GetCompanyByUserId :one
SELECT 
    'broker_companies' AS table_name,
    bc.id,
    bc.company_type,
    bc.is_branch,
    bc.company_name,
    bc.is_verified,
    bc.no_of_employees,
    bc.email,
    a.countries_id,
    a.states_id,
    a.cities_id,
    a.communities_id,
    a.sub_communities_id,
    bc.website_url,
    bc.phone_number,
    bc.commercial_license_no,
    l.lat,
    l.lng
FROM 
    broker_companies bc
JOIN 
    addresses a ON bc.addresses_id = a.id
JOIN
    locations l ON a.locations_id= l.id
WHERE 
    bc.users_id = $1
UNION 
SELECT 
    'broker_companies_branches' AS table_name,
    bcb.id,
    bcb.company_type,
    bcb.is_branch,
    bcb.company_name,
    bcb.is_verified,
    bcb.no_of_employees,
    bcb.email,
    a.countries_id,
    a.states_id,
    a.cities_id,
    a.communities_id,
    a.sub_communities_id,
    bcb.website_url,
    bcb.phone_number,
    bcb.commercial_license_no,
    l.lat,
    l.lng
FROM 
    broker_companies_branches bcb
JOIN 
    addresses a ON bcb.addresses_id = a.id
JOIN
    locations l ON a.locations_id = l.id
WHERE 
    bcb.users_id = $1
UNION 
SELECT 
    'developer_companies' AS table_name,
    dc.id,
    dc.company_type,
    dc.is_branch,
    dc.company_name,
    dc.is_verified,
    dc.no_of_employees,
    dc.email,
    a.countries_id,
    a.states_id,
    a.cities_id,
    a.communities_id,
    a.sub_communities_id,
    dc.website_url,
    dc.phone_number,
    dc.commercial_license_no,
    l.lat,
    l.lng
FROM 
    developer_companies dc
JOIN 
    addresses a ON dc.addresses_id = a.id
JOIN
    locations l ON a.locations_id = l.id
WHERE 
    dc.users_id = $1
UNION 
SELECT 
    'developer_company_branches' AS table_name,
    dcb.id,
    dcb.company_type,
    dcb.is_branch,
    dcb.company_name,
    dcb.is_verified,
    dcb.no_of_employees,
    dcb.email,
    a.countries_id,
    a.states_id,
    a.cities_id,
    a.communities_id,
    a.sub_communities_id,
    dcb.website_url,
    dcb.phone_number,
    dcb.commercial_license_no,
    l.lat,
    l.lng
FROM 
    developer_company_branches dcb
JOIN 
    addresses a ON dcb.addresses_id = a.id
JOIN
    locations l ON a.locations_id = l.id
WHERE 
    dcb.users_id = $1
UNION 
SELECT 
    'services_companies' AS table_name,
    sc.id,
    sc.company_type,
    sc.is_branch,
    sc.company_name,
    sc.is_verified,
    sc.no_of_employees,
    sc.email,
    a.countries_id,
    a.states_id,
    a.cities_id,
    a.communities_id,
    a.sub_communities_id,
    sc.website_url,
    sc.phone_number,
    sc.commercial_license_no,
   l.lat,
    l.lng
FROM 
    services_companies sc
JOIN 
    addresses a ON sc.addresses_id = a.id
JOIN
    locations l ON a.locations_id = l.id
WHERE 
    sc.users_id = $1
UNION 
SELECT 
    'service_company_branches' AS table_name,
    scb.id,
    scb.company_type,
    scb.is_branch,
    scb.company_name,
    scb.is_verified,
    scb.no_of_employees,
    scb.email,
   a.countries_id,
    a.states_id,
    a.cities_id,
    a.communities_id,
    a.sub_communities_id,
    scb.website_url,
    scb.phone_number,
    scb.commercial_license_no,
    l.lat,
    l.lng
FROM 
    service_company_branches scb
JOIN 
    addresses a ON scb.addresses_id = a.id
JOIN
    locations l ON a.locations_id = l.id
WHERE 
    scb.users_id = $1
UNION 
SELECT 
    'product_company' AS table_name,
    pc.id,
    pc.company_type,
    pc.is_branch,
    pc.company_name,
    pc.is_verified,
    pc.no_of_employees,
    pc.email,
    a.countries_id,
    a.states_id,
    a.cities_id,
    a.communities_id,
    a.sub_communities_id,
    pc.website_url,
    pc.phone_number,
    pc.commercial_license_no,
    l.lat,
    l.lng
FROM 
    product_companies pc
JOIN 
    addresses a ON pc.addresses_id = a.id
JOIN
    locations l ON a.locations_id = l.id
WHERE 
    pc.users_id = $1
UNION 
SELECT 
    'product_company_branch' AS table_name,
    pcb.id,
    pcb.company_type,
    pcb.is_branch,
    pcb.company_name,
    pcb.is_verified,
    pcb.no_of_employees,
    pcb.email,
    a.countries_id,
    a.states_id,
    a.cities_id,
    a.communities_id,
    a.sub_communities_id,
    pcb.website_url,
    pcb.phone_number,
    pcb.commercial_license_no,
    l.lat,
    l.lng
FROM 
    product_companies_branches pcb
JOIN 
    addresses a ON pcb.addresses_id = a.id
JOIN
    locations l ON a.locations_id = l.id
WHERE 
    pcb.users_id = $1
LIMIT 1;




-- name: GetCompanyAdmin :one
With x AS (
    SELECT users_id FROM broker_companies
    WHERE broker_companies.id = @company_id AND broker_companies.is_branch = @is_branch AND broker_companies.company_type = @company_type
 	UNION ALL
 	SELECT users_id FROM broker_companies_branches
 	Where id = @company_id AND is_branch = @is_branch AND company_type = @company_type  	 	
 	UNION ALL 
 	SELECT users_id FROM developer_companies
 	Where id = @company_id AND is_branch = @is_branch AND company_type = @company_type
 	UNION ALL
 	SELECT users_id  FROM developer_company_branches
 	Where id = @company_id AND is_branch = @is_branch AND company_type = @company_type 	
 	UNION ALL
 	SELECT users_id FROM services_companies
 	Where id = @company_id AND is_branch = @is_branch AND company_type = @company_type
 	UNION ALL
 	SELECT users_id FROM service_company_branches
 	Where id = @company_id AND is_branch = @is_branch AND company_type = @company_type
) SELECT * FROM x;
 