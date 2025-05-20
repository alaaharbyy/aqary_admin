-- -- name: GetAllParentJobCategories :many
-- select id, ref_no, parent_category_id, category_name, description, company_types_id, companies_id, is_branch, category_image, created_at, created_by, status, company_name from job_categories where parent_category_id = 0 and status != 5 AND status!=6 order by id desc; 

-- name: GetCategoriesCount :one
select count(*) from job_categories where status != 5 AND status!=6;

-- name: GetJobCategoryByName :one
SELECT * FROM job_categories WHERE category_name=$1 AND status!=6 AND status!=5 Limit 1;	

-- name: GetAllSubCatgories :many
SELECT catg.*,pcatg.category_name as parent_catg_name
from job_categories catg
JOIN job_categories pcatg on pcatg.id= catg.parent_category_id
WHERE catg.parent_category_id=$1 AND catg.status!=5 AND catg.status!=6;

-- name: GetCountAllSubCatgories :one
SELECT COUNT(*) from job_categories WHERE parent_category_id=$1 AND status!=5 AND status!=6;

-- name: SearchSubCatgoriesByTitle :many
SELECT * from job_categories WHERE parent_category_id=$1 AND status!=5 AND status!=6 AND category_name ILIKE '%' || $2 || '%' ;

