
-- -- name: GetCountDeveloperCompanyProjects :one
-- select count(*) from projects
-- where projects.developer_companies_id = $1 and projects.status != 5 and projects.status != 6;


-- name: FilterDeveloperCompanies :many
WITH 
comp_reviews AS(
	SELECT company_id, 
	ROUND((AVG(customer_service) + AVG(staff_courstesy) + AVG(implementation) + AVG(quality)) / 4.0,2) AS average_rating
	FROM company_review
	GROUP BY company_id
),
project_counts AS(
	SELECT developer_companies_id, COUNT(projects.id) AS project_count
	FROM projects
	GROUP BY developer_companies_id
)

	SELECT 
	sqlc.embed(c),
	COALESCE(comp_reviews.average_rating, 0.0)::float AS average_rating,
	COALESCE(project_counts.project_count,0)::bigint AS project_count
	FROM companies as c
	LEFT JOIN social_connections ON social_connections.requested_by=companies.id
	LEFT JOIN addresses ON c.addresses_id = addresses.id 
	LEFT JOIN cities ON addresses.cities_id = cities.id
	LEFT JOIN communities ON addresses.communities_id = communities.id
	LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
	LEFT JOIN project_counts ON project_counts.developer_companies_id = c.id
	LEFT JOIN comp_reviews ON comp_reviews.company_id = c.id
	WHERE 
	addresses.countries_id = @country_id::bigint
	AND
	(case when @company_id::bigint= 0 then true else social_connections.comapnies_id= @company_id::bigint end)
	-- location
	AND (CASE WHEN @city_id::bigint=0 THEN TRUE ELSE addresses.cities_id= @city_id::bigint END)
    AND (CASE WHEN @community_id::bigint=0 THEN TRUE ELSE addresses.communities_id= @community_id::bigint END)
    AND (CASE WHEN @sub_community::bigint=0 THEN TRUE ELSE addresses.sub_communities_id= @sub_community::bigint END)
    AND (ARRAY_LENGTH(@company_rank::bigint [], 1) IS NULL OR c.company_rank = ANY (@company_rank::bigint []))
	AND (@is_verified::bool IS NULL OR c.is_verified = @is_verified::bool)
    AND (CASE WHEN @search::varchar IS NULL THEN
			TRUE
			ELSE
			c.company_name ILIKE @search::varchar
			OR c.description ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
	END) 
	AND c.status != 5 and c.status != 6 AND company_type = @company_type::bigint
	
	ORDER BY 
	CASE WHEN @sorted_by::int = 1 THEN comp_reviews.average_rating END DESC, -- 1 rating - high to low
	CASE WHEN @sorted_by::int = 2 THEN comp_reviews.average_rating END, -- 2 rating - low to high
	CASE WHEN @sorted_by::int = 3 THEN project_counts.project_count END DESC, -- 3 projects - high to low
	CASE WHEN @sorted_by::int = 4 THEN project_counts.project_count END -- 4 projects - low to high
 LIMIT $1 OFFSET $2;

-- name: FilterBrokerCompanies :many
WITH 
comp_reviews AS(
	SELECT company_id, 
	ROUND((AVG(customer_service) + AVG(staff_courstesy) + AVG(implementation) + AVG(quality)) / 4.0,2) AS average_rating
	FROM company_review
	GROUP BY company_id
),
property_counts AS(
  SELECT developer_companies_id, COUNT(project_properties.id) AS property_count
  FROM project_properties
  GROUP BY developer_companies_id
)

		SELECT 
		sqlc.embed(companies),
		COALESCE(comp_reviews.average_rating, 0.0)::float AS average_rating,
		COALESCE(property_counts.property_count, 0)::bigint AS property_count
		FROM companies
		LEFT JOIN social_connections ON social_connections.requested_by=companies.id
		LEFT JOIN addresses ON companies.addresses_id = addresses.id 
		LEFT JOIN cities ON addresses.cities_id = cities.id
		LEFT JOIN communities ON addresses.communities_id = communities.id
		LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
		LEFT JOIN property_counts ON property_counts.developer_companies_id = companies.id
		LEFT JOIN comp_reviews ON comp_reviews.company_id = companies.id
		WHERE 
		(case when @company_id::bigint= 0 then true else social_connections.comapnies_id= @company_id::bigint end)
		AND
		addresses.countries_id = @country_id::bigint
	-- location
		AND (CASE WHEN @city_id::bigint=0 THEN TRUE ELSE addresses.cities_id= @city_id::bigint END)
	    AND (CASE WHEN @community_id::bigint=0 THEN TRUE ELSE addresses.communities_id= @community_id::bigint END)
	    AND (CASE WHEN @sub_community::bigint=0 THEN TRUE ELSE addresses.sub_communities_id= @sub_community::bigint END)
	    AND (ARRAY_LENGTH(@company_rank::bigint [], 1) IS NULL OR companies.company_rank = ANY (@company_rank::bigint []))
		AND (@is_verified::bool IS NULL OR companies.is_verified = @is_verified::bool)
	    AND (CASE WHEN @search::varchar IS NULL THEN
			TRUE
			ELSE
			companies.company_name ILIKE @search::varchar
			OR companies.description ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
	END) 
	AND companies.status != 5 and companies.status != 6 AND company_type = @company_type::bigint
	
ORDER BY 
	CASE WHEN @sorted_by::int = 1 THEN comp_reviews.average_rating END DESC, -- 1 rating - high to low
	CASE WHEN @sorted_by::int = 2 THEN comp_reviews.average_rating END, -- 2 rating - low to high
	CASE WHEN @sorted_by::int = 3 THEN property_counts.property_count END DESC, -- 3 projects - high to low
	CASE WHEN @sorted_by::int = 4 THEN property_counts.property_count END-- 4 projects - low to high
LIMIT $1 OFFSET $2;

-- name: FilterCountCompanies :one
SELECT 
	count(c)
	FROM companies as c
	LEFT JOIN social_connections ON social_connections.requested_by=c.id
	LEFT JOIN addresses ON c.addresses_id = addresses.id 
	LEFT JOIN cities ON addresses.cities_id = cities.id
	LEFT JOIN communities ON addresses.communities_id = communities.id
	LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
	WHERE 
	(case when @company_id::bigint= 0 then true else social_connections.comapnies_id= @company_id::bigint end)
	AND
	addresses.countries_id = @country_id::bigint
	-- location
	AND (CASE WHEN @city_id::bigint=0 THEN TRUE ELSE addresses.cities_id= @city_id::bigint END)
    AND (CASE WHEN @community_id::bigint=0 THEN TRUE ELSE addresses.communities_id= @community_id::bigint END)
    AND (CASE WHEN @sub_community::bigint=0 THEN TRUE ELSE addresses.sub_communities_id= @sub_community::bigint END)
    AND (ARRAY_LENGTH(@company_rank::bigint [], 1) IS NULL OR c.company_rank = ANY (@company_rank::bigint []))
	AND (@is_verified::bool IS NULL OR c.is_verified = @is_verified::bool)
    AND (CASE WHEN @search::varchar IS NULL THEN
			TRUE
			ELSE
			c.company_name ILIKE @search::varchar
			OR c.description ILIKE @search::varchar
			OR cities.city ILIKE @search::varchar
			OR communities.community ILIKE @search::varchar
			OR sub_communities.sub_community ILIKE @search::varchar
	END) 
	AND c.status != 5 and c.status != 6 AND company_type = @company_type::bigint;
 


-- -- name: GetCountStateCompanies :one
-- select COUNT(companies.id)  from companies
-- LEFT JOIN addresses ON companies.addresses_id = addresses.id 
-- LEFT JOIN states ON addresses.states_id = states.id
-- LEFT JOIN communities ON addresses.communities_id = communities.id
-- LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
-- WHERE 
--            companies.company_type = @company_type::bigint AND
--            addresses.countries_id = @country_id::bigint AND
-- 		   addresses.states_id = @state::bigint
-- 		   AND(ARRAY_LENGTH(@company_rank::bigint [], 1) IS NULL OR companies.company_rank = ANY (@company_rank::bigint []))
-- 	       AND(communities.community ILIKE @community::varchar OR communities.community IS NULL)
-- 	       AND(sub_communities.sub_community ILIKE @sub_community::varchar OR sub_communities.sub_community IS NULL)
-- 	       AND(@is_verified::bool IS null OR companies.is_verified = @is_verified::bool)
-- 		   AND (
--         companies.company_name ILIKE @search::varchar
--         OR companies.description ILIKE @search::varchar
--         OR states.state ILIKE @search::varchar
--         OR communities.community ILIKE @search::varchar
-- 		OR sub_communities.sub_community ILIKE @search::varchar
--     )  and companies.status != 5 AND companies.status != 6;

-- -- name: GetCountCommunityCompanies :one
-- select COUNT(companies.id)  from companies
-- LEFT JOIN addresses ON companies.addresses_id = addresses.id 
-- LEFT JOIN states ON addresses.states_id = states.id
-- LEFT JOIN communities ON addresses.communities_id = communities.id
-- LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
-- WHERE 
--            companies.company_type = @company_type::bigint AND
--            addresses.countries_id = @country_id::bigint AND
-- 		   addresses.communities_id = @communities_id::bigint
-- 		   AND(ARRAY_LENGTH(@company_rank::bigint [], 1) IS NULL OR companies.company_rank = ANY (@company_rank::bigint []))
-- 	       AND(communities.community ILIKE @community::varchar OR communities.community IS NULL)
-- 	       AND(sub_communities.sub_community ILIKE @sub_community::varchar OR sub_communities.sub_community IS NULL)
-- 	       AND(@is_verified::bool IS null OR companies.is_verified = @is_verified::bool)
-- 		   AND (
--         companies.company_name ILIKE @search::varchar
--         OR companies.description ILIKE @search::varchar
--         OR states.state ILIKE @search::varchar
--         OR communities.community ILIKE @search::varchar
-- 		OR sub_communities.sub_community ILIKE @search::varchar
--     )  and companies.status != 5 AND companies.status != 6;


-- -- name: GetCountSubCommunityCompanies :one
-- select COUNT(companies.id)  from companies
-- LEFT JOIN addresses ON companies.addresses_id = addresses.id 
-- LEFT JOIN states ON addresses.states_id = states.id
-- LEFT JOIN communities ON addresses.communities_id = communities.id
-- LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
-- WHERE 
--            companies.company_type = @company_type::bigint AND
--            addresses.countries_id = @country_id::bigint AND
-- 		   addresses.sub_communities_id = @sub_communities_id::bigint
-- 		   AND(ARRAY_LENGTH(@company_rank::bigint [], 1) IS NULL OR companies.company_rank = ANY (@company_rank::bigint []))
-- 	       AND(communities.community ILIKE @community::varchar OR communities.community IS NULL)
-- 	       AND(sub_communities.sub_community ILIKE @sub_community::varchar OR sub_communities.sub_community IS NULL)
-- 	       AND(@is_verified::bool IS null OR companies.is_verified = @is_verified::bool)
-- 		   AND (
--         companies.company_name ILIKE @search::varchar
--         OR companies.description ILIKE @search::varchar
--         OR states.state ILIKE @search::varchar
--         OR communities.community ILIKE @search::varchar
-- 		OR sub_communities.sub_community ILIKE @search::varchar
--     )  and companies.status != 5 AND companies.status != 6;

-- -- name: GetAllDeveloperCompanyReviewByID :many
-- WITH x AS (
-- 	SELECT id, rating, review, profiles_id, status, developer_companies_id, created_at, updated_at, users_id FROM developer_company_reviews
-- 	WHERE developer_companies_id = $3
-- 	AND
-- 	CASE
-- 		WHEN $4 = false THEN true
-- 		ELSE false
-- 	END
-- UNION ALL
-- 	SELECT id, rating, review, profiles_id, status, developer_company_branches_id, created_at, updated_at, users_id 
-- 	FROM developer_branch_company_reviews
-- 	WHERE developer_company_branches_id = $3
-- 	AND
-- 	CASE
-- 		WHEN $4 = true THEN true
-- 		ELSE false
-- 	END
-- )SELECT * FROM x ORDER BY id LIMIT $1 OFFSET $2;

-- -- name: GetCompanyLeadersByCompany :many
-- SELECT
--   id,
--   name,
--   position,
--   description,
--   image_url,
--   is_branch,
--   company_type,
--   company_id,
--   users_id,
--   created_at,
--   updated_at
-- from leaders
-- WHERE
--   company_id = $3 AND company_type = $4 AND is_branch= $5
-- LIMIT $1 OFFSET $2;

-- -- name: GetDeveloperCompanyProjects :many
-- WITH property_types_agg AS (
--     SELECT 
--         projects_id,
--         array_agg(property_type ORDER BY property_type) AS property_types
--     FROM (
--         SELECT 
--             project_properties.projects_id,
--             unnest(COALESCE(project_properties.property_types_id, '{}'::bigint[])) AS property_type
--         FROM 
--             project_properties
--     ) AS unnest_properties
--     GROUP BY 
--         projects_id
-- ),
-- project_properties_agg AS (
--     SELECT
--         projects_id,
--         array_agg(property_types ORDER BY property_types) AS property_types_agg
--     FROM (
--         SELECT
--             project_properties.projects_id,
--             property_types."type" AS property_types
--         FROM
--             project_properties
--         LEFT JOIN
--             property_types ON property_types.id = ANY(project_properties.property_types_id::bigint[])
--     ) AS properties_with_types
--     GROUP BY
--         projects_id
-- )
-- SELECT *
-- FROM
--     projects  
-- LEFT JOIN
--     addresses ON projects.addresses_id = addresses.id
-- LEFT JOIN
--     cities ON addresses.cities_id = cities.id
-- LEFT JOIN
--     communities ON addresses.communities_id = communities.id
-- LEFT JOIN
--     sub_communities ON addresses.sub_communities_id = sub_communities.id
-- LEFT JOIN 
--     property_types_agg ON projects.id = property_types_agg.projects_id
-- LEFT JOIN 
--     project_properties_agg ON projects.id = project_properties_agg.projects_id
-- Where 
--      projects.developer_companies_id = @developer_companies_id::bigint AND
-- 	 cities.city ILIKE @city::varchar AND
--      addresses.countries_id = @country_id::bigint
-- 	 AND(ARRAY_LENGTH(@project_rank::bigint [], 1) IS NULL OR projects.project_rank = ANY (@project_rank::bigint []))
-- 	 AND(communities.community ILIKE @community::varchar OR communities.community IS NULL)
-- 	 AND(sub_communities.sub_community ILIKE @sub_community::varchar OR sub_communities.sub_community IS NULL)
-- 	 AND(@is_verified::bool IS null OR projects.is_verified = @is_verified::bool)
-- 	 AND (
--         projects.project_name ILIKE @search::varchar
--         OR cities.city ILIKE @search::varchar
--         OR communities.community ILIKE @search::varchar
--         OR sub_communities.sub_community ILIKE @search::varchar
--     )
--      AND projects.status != 5 AND projects.status != 6
-- ORDER BY
--   CASE 
--     WHEN @sorted_by::int = 1 THEN projects.status -- all
--   END DESC, 
--   CASE 
--     WHEN @sorted_by::int = 2 THEN 
--       CASE 
--         WHEN projects.status = 2 THEN 1 -- available
--         ELSE 2
--       END
--   END,
--   CASE 
--     WHEN @sorted_by::int = 3 THEN 
--       CASE 
--         WHEN projects.status = 3 THEN 1 -- sold out
--         ELSE 2
--       END
--   END DESC,
--   CASE 
--     WHEN @sorted_by::int = 4 THEN 
--       CASE 
--         WHEN projects.status = 1 THEN 1 -- coming soon
--         ELSE 2
--       END
--   END
-- LIMIT $1 OFFSET $2;


-- -- name: CountDeveloperCompanyProjects :one
-- SELECT count(*)
-- FROM
--     projects  
-- LEFT JOIN
--     addresses ON projects.addresses_id = addresses.id
-- LEFT JOIN
--     cities ON addresses.cities_id = cities.id
-- LEFT JOIN
--     communities ON addresses.communities_id = communities.id
-- LEFT JOIN
--     sub_communities ON addresses.sub_communities_id = sub_communities.id
-- Where 
--      projects.developer_companies_id = @developer_companies_id::bigint AND
-- 	 cities.city ILIKE @city::varchar AND
--      addresses.countries_id = @country_id::bigint
-- 	 AND(ARRAY_LENGTH(@project_rank::bigint [], 1) IS NULL OR projects.project_rank = ANY (@project_rank::bigint []))
-- 	 AND(communities.community ILIKE @community::varchar OR communities.community IS NULL)
-- 	 AND(sub_communities.sub_community ILIKE @sub_community::varchar OR sub_communities.sub_community IS NULL)
-- 	 AND(@is_verified::bool IS null OR projects.is_verified = @is_verified::bool)
-- 	 AND (
--         projects.project_name ILIKE @search::varchar
--         OR cities.city ILIKE @search::varchar
--         OR communities.community ILIKE @search::varchar
--         OR sub_communities.sub_community ILIKE @search::varchar
--     )
--      AND projects.status != 5 AND projects.status != 6;


-- -- name: CountStateDeveloperCompanyProjects :one
-- SELECT count(*)
-- FROM
--     projects  
-- LEFT JOIN
--     addresses ON projects.addresses_id = addresses.id
-- LEFT JOIN
--     cities ON addresses.cities_id = cities.id
-- LEFT JOIN
--     communities ON addresses.communities_id = communities.id
-- LEFT JOIN
--     sub_communities ON addresses.sub_communities_id = sub_communities.id
-- Where 
--      projects.developer_companies_id = @developer_companies_id::bigint AND
-- 	 addresses.countries_id = @country_id::bigint  AND
--      cities.id = @cities_id::bigint
-- 	 AND(ARRAY_LENGTH(@project_rank::bigint [], 1) IS NULL OR projects.project_rank = ANY (@project_rank::bigint []))
-- 	 AND(communities.community ILIKE @community::varchar OR communities.community IS NULL)
-- 	 AND(sub_communities.sub_community ILIKE @sub_community::varchar OR sub_communities.sub_community IS NULL)
-- 	 AND(@is_verified::bool IS null OR projects.is_verified = @is_verified::bool)
-- 	 AND (
--         projects.project_name ILIKE @search::varchar
--         OR cities.city ILIKE @search::varchar
--         OR communities.community ILIKE @search::varchar
--         OR sub_communities.sub_community ILIKE @search::varchar
--     )
--      AND projects.status != 5 AND projects.status != 6;

-- -- name: CountCommunityDeveloperCompanyProjects :one
-- SELECT count(*)
-- FROM
--     projects  
-- LEFT JOIN
--     addresses ON projects.addresses_id = addresses.id
-- LEFT JOIN
--     cities ON addresses.cities_id = cities.id
-- LEFT JOIN
--     communities ON addresses.communities_id = communities.id
-- LEFT JOIN
--     sub_communities ON addresses.sub_communities_id = sub_communities.id
-- Where 
--      projects.developer_companies_id = @developer_companies_id::bigint AND
-- 	--  addresses.cities_id = @cities_id AND
-- 	 addresses.communities_id = @communities_id::bigint
-- 	 AND(ARRAY_LENGTH(@project_rank::bigint [], 1) IS NULL OR projects.project_rank = ANY (@project_rank::bigint []))
-- 	 AND(communities.community ILIKE @community::varchar OR communities.community IS NULL)
-- 	 AND(sub_communities.sub_community ILIKE @sub_community::varchar OR sub_communities.sub_community IS NULL)
-- 	 AND(@is_verified::bool IS null OR projects.is_verified = @is_verified::bool)
-- 	 AND (
--         projects.project_name ILIKE @search::varchar
--         OR cities.city ILIKE @search::varchar
--         OR communities.community ILIKE @search::varchar
--         OR sub_communities.sub_community ILIKE @search::varchar
--     )
--      AND projects.status != 5 AND projects.status != 6;

-- -- name: CountSubCommunityDeveloperCompanyProjects :one
-- SELECT count(*)
-- FROM
--     projects  
-- LEFT JOIN
--     addresses ON projects.addresses_id = addresses.id
-- LEFT JOIN
--     cities ON addresses.cities_id = cities.id
-- LEFT JOIN
--     communities ON addresses.communities_id = communities.id
-- LEFT JOIN
--     sub_communities ON addresses.sub_communities_id = sub_communities.id
-- Where 
--      projects.developer_companies_id = @developer_companies_id::bigint AND
-- 	 addresses.sub_communities_id = @sub_communities_id::bigint
-- 	 AND(ARRAY_LENGTH(@project_rank::bigint [], 1) IS NULL OR projects.project_rank = ANY (@project_rank::bigint []))
-- 	 AND(communities.community ILIKE @community::varchar OR communities.community IS NULL)
-- 	 AND(sub_communities.sub_community ILIKE @sub_community::varchar OR sub_communities.sub_community IS NULL)
-- 	 AND(@is_verified::bool IS null OR projects.is_verified = @is_verified::bool)
-- 	 AND (
--         projects.project_name ILIKE @search::varchar
--         OR cities.city ILIKE @search::varchar
--         OR communities.community ILIKE @search::varchar
--         OR sub_communities.sub_community ILIKE @search::varchar
--     )
--      AND projects.status != 5 AND projects.status != 6;
 
-- -- name: GetCountDeveloperCompanyUsersByCompanyID :one
-- SELECT COUNT(*) FROM company_users WHERE company_id = $1 AND company_type = $2 AND is_branch = $3;

-- -- name: GetAllCompanyUsersByCompanyId :many
-- SELECT
-- 	company_users.id AS company_user_id,
-- 	company_users.designation,
-- 	profiles.id AS profile_id,
-- 	profiles.first_name,
-- 	profiles.last_name,
-- 	profiles.profile_image_url,
-- 	profiles.phone_number,
-- 	users.id AS user_id,
-- 	users.email,
-- 	users.is_verified,
-- 	company_users.company_type,
-- 	company_users.description
-- 	-- -- fetch from the spectific company
-- 	-- CASE WHEN company_users.company_type = 1
-- 	-- 	AND company_users.is_branch = FALSE THEN
-- 	-- 	broker_companies.company_name
-- 	-- WHEN company_users.company_type = 2
-- 	-- 	AND company_users.is_branch = FALSE THEN
-- 	-- 	developer_companies.company_name
-- 	-- WHEN company_users.company_type = 3
-- 	-- 	AND company_users.is_branch = FALSE THEN
-- 	-- 	services_companies.company_name
-- 	-- WHEN company_users.company_type = 1
-- 	-- 	AND company_users.is_branch = TRUE THEN
-- 	-- 	broker_companies_branches.company_name
-- 	-- WHEN company_users.company_type = 2
-- 	-- 	AND company_users.is_branch = TRUE THEN
-- 	-- 	developer_company_branches.company_name
-- 	-- WHEN company_users.company_type = 3
-- 	-- 	AND company_users.is_branch = TRUE THEN
-- 	-- 	service_company_branches.company_name
-- 	-- ELSE
-- 	-- 	NULL
-- 	-- END AS company_name
-- FROM
-- 	company_users
-- 	LEFT JOIN users ON company_users.users_id = users.id
-- 	LEFT JOIN profiles ON profiles.id = users.profiles_id
-- 	LEFT JOIN broker_companies ON company_users.company_type = 1
-- 		AND broker_companies.id = company_users.company_id
-- 	LEFT JOIN developer_companies ON company_users.company_type = 2
-- 		AND developer_companies.id = company_users.company_id
-- 	LEFT JOIN services_companies ON company_users.company_type = 3
-- 		AND services_companies.id = company_users.company_id
-- 	LEFT JOIN broker_companies_branches ON company_users.company_type = 1
-- 		AND broker_companies_branches.id = company_users.company_id
-- 	LEFT JOIN developer_company_branches ON company_users.company_type = 2
-- 		AND developer_company_branches.id = company_users.company_id
-- 	LEFT JOIN service_company_branches ON company_users.company_type = 3
-- 		AND service_company_branches.id = company_users.company_id
-- WHERE
--     company_users.company_id = $3 
-- 	-- AND company_users.company_type = $4 
-- 	AND users.status != 5
-- 	AND users.status != 6
-- ORDER BY
-- 	company_users.id
-- LIMIT $1 OFFSET $2;