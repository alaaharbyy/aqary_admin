-- name: GetAllProductBranchReviews :many 
select 
pcb.company_name,
cp.product_name, 
pr.id as reviews_id, pr.ref_no,pr.review_quality,pr.review_price,pr.customer_service,pr.order_experience,pr.description as review,
u.username,u.email,
   COALESCE(
        (
            SELECT
                company_name
            FROM
                services_companies
            WHERE
                users_id = pr.reviewer
            UNION
            SELECT
                company_name
            FROM
                service_company_branches
            WHERE
                users_id = pr.reviewer
            UNION
            SELECT
                company_name
            FROM
                broker_companies_branches
            WHERE
                users_id = pr.reviewer
            UNION
            SELECT
                company_name
            FROM
                broker_companies
            WHERE
                users_id = pr.reviewer
            UNION
            SELECT
                company_name
            FROM
                developer_company_branches
            WHERE
                users_id = pr.reviewer
            UNION
            SELECT
                company_name
            FROM
                developer_companies
            WHERE
                users_id = pr.reviewer
            LIMIT 1
        ), 'no company'
    ) AS reviewer_company
from product_companies_branches pcb 
join companies_products cp on cp.companies_id=pcb.id
join product_reviews pr on pr.companies_products_id=cp.id
join users u on u.id=pr.reviewer
where pcb.id=$1 and cp.is_branch=true
LIMIT $2 OFFSET $3;

-- name: GetProductCompanyBranchForGraph :one 
SELECT id,
	company_name, 
	description, 
	logo_url, 
	cover_image_url, 
	is_verified, 
	commercial_license_no
FROM 
	product_companies_branches 
WHERE 
	id=$1 
LIMIT 1;

