-- name: GetAllReviewsByserviceCompanyID :many
with x as (
select scr.id, p.first_name as "refiewer", scr.review, scr.rating  from services_companies_reviews scr LEFT JOIN users u ON scr.users_id = u.id LEFT JOIN profiles p ON u.profiles_id = p.id where scr.services_companies_id = $1 AND FALSE = $2 AND 1 = $3
UNION
select dcr.id, p.first_name as "refiewer", dcr.review, dcr.rating  from developer_company_reviews dcr LEFT JOIN users u ON dcr.users_id = u.id LEFT JOIN profiles p ON u.profiles_id = p.id where dcr.developer_companies_id = $1 AND FALSE = $2 AND 2 = $3
UNION
select bcr.id, p.first_name as "refiewer", bcr.review, bcr.rating  from broker_company_reviews bcr LEFT JOIN users u ON bcr.users_id = u.id LEFT JOIN profiles p ON u.profiles_id = p.id where bcr.broker_companies_id = $1 AND FALSE = $2 AND 3 = $3
UNION
select sbcr.id, p.first_name as "refiewer", sbcr.review, sbcr.rating  from service_branch_company_reviews sbcr LEFT JOIN users u ON sbcr.users_id = u.id LEFT JOIN profiles p ON u.profiles_id = p.id where sbcr.service_company_branches_id = $1 AND TRUE = $2 AND 1 = $3
UNION
select dbcr.id, p.first_name as "refiewer", dbcr.review, dbcr.rating  from developer_branch_company_reviews dbcr LEFT JOIN users u ON dbcr.users_id = u.id LEFT JOIN profiles p ON u.profiles_id = p.id where dbcr.developer_company_branches_id = $1 AND TRUE = $2 AND 2 = $3
UNION
select bbcr.id, p.first_name as "refiewer", bbcr.review, bbcr.rating  from broker_branch_company_reviews bbcr LEFT JOIN users u ON bbcr.users_id = u.id LEFT JOIN profiles p ON u.profiles_id = p.id where bbcr.broker_companies_branches_id = $1 AND TRUE = $2 AND 3 = $3) SELECT * FROM x LIMIT $4 OFFSET $5;
 
 
-- name: GetCountAllReviewsByserviceCompanyID :one
with x as (
select scr.id, p.first_name as "refiewer", scr.review, scr.rating  from services_companies_reviews scr LEFT JOIN users u ON scr.users_id = u.id LEFT JOIN profiles p ON u.profiles_id = p.id where scr.services_companies_id = $1 AND FALSE = $2 AND 1 = $3
UNION
select dcr.id, p.first_name as "refiewer", dcr.review, dcr.rating  from developer_company_reviews dcr LEFT JOIN users u ON dcr.users_id = u.id LEFT JOIN profiles p ON u.profiles_id = p.id where dcr.developer_companies_id = $1 AND FALSE = $2 AND 2 = $3
UNION
select bcr.id, p.first_name as "refiewer", bcr.review, bcr.rating  from broker_company_reviews bcr LEFT JOIN users u ON bcr.users_id = u.id LEFT JOIN profiles p ON u.profiles_id = p.id where bcr.broker_companies_id = $1 AND FALSE = $2 AND 3 = $3
UNION
select sbcr.id, p.first_name as "refiewer", sbcr.review, sbcr.rating  from service_branch_company_reviews sbcr LEFT JOIN users u ON sbcr.users_id = u.id LEFT JOIN profiles p ON u.profiles_id = p.id where sbcr.service_company_branches_id = $1 AND TRUE = $2 AND 1 = $3
UNION
select dbcr.id, p.first_name as "refiewer", dbcr.review, dbcr.rating  from developer_branch_company_reviews dbcr LEFT JOIN users u ON dbcr.users_id = u.id LEFT JOIN profiles p ON u.profiles_id = p.id where dbcr.developer_company_branches_id = $1 AND TRUE = $2 AND 2 = $3
UNION
select bbcr.id, p.first_name as "refiewer", bbcr.review, bbcr.rating  from broker_branch_company_reviews bbcr LEFT JOIN users u ON bbcr.users_id = u.id LEFT JOIN profiles p ON u.profiles_id = p.id where bbcr.broker_companies_branches_id = $1 AND TRUE = $2 AND 3 = $3) SELECT count(*) FROM x ;