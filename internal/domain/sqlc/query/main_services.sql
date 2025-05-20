-- -- name: CreateMainServices :one
-- INSERT INTO main_services (
--     title,  
--     description,
--     icon_url,
--     image_url ,
--    description_ar,
--    created_at,
--    updated_at,
--    tag_id,
--    status
-- )VALUES (
--     $1, $2, $3,$4, $5,$6,$7,$8,$9
-- ) RETURNING *;


-- -- name: GetMainServices :one
-- SELECT * FROM main_services 
-- WHERE id = $1 LIMIT 1;

-- -- name: GetMainServicesByName :one
-- SELECT * FROM main_services 
-- WHERE title = $2 LIMIT $1;


-- -- -- name: GetMainServicesByCompanyId :many
-- -- SELECT * FROM main_services 
-- -- WHERE company_types_id = $3 AND (status!= 5 AND status != 6) LIMIT $1 OFFSET $2;

-- -- -- name: GetCountMainServicesByCompanyId :one
-- -- SELECT COUNT(*) FROM main_services 
-- -- WHERE company_types_id = $1 AND (status!= 5 AND status != 6);

-- -- -- name: GetMainServicesByCompanyIdWithoutPagination :many
-- -- SELECT * FROM main_services 
-- -- WHERE company_types_id = $1 AND (status !=5 AND status!=6);
 
-- -- name: GetAllMainServices :many
-- SELECT * FROM main_services 
-- WHERE (status != 5 AND status != 6)
-- ORDER BY updated_at DESC
-- LIMIT $1
-- OFFSET $2;

-- -- name: UpdateMainServices :one
-- UPDATE main_services
-- SET  title = $2,  
--     description = $3,
--     icon_url  = $4,
--     image_url = $5,
--     updated_at = $6,
--    description_ar=$7,
--    status = $8,
--    tag_id=$9
-- Where id = $1
-- RETURNING *;


-- -- name: DeleteMainServices :exec
-- DELETE FROM main_services
-- Where id = $1;


-- -- name: GetCountMainServices :one
-- SELECT COUNT(*) FROM main_services WHERE (status != 5 AND status != 6);


-- -- name: GetAllMainServiceWithoutPagination :many
-- SELECT * FROM main_services;


-- -- name: DeleteFromMainServiceByIds :exec
-- DELETE FROM main_services WHERE id = ANY($1::bigint[]);


-- -- -- name: GetMainServicesByCompanyIdOnlyIds :many
-- -- SELECT id FROM main_services 
-- -- WHERE company_types_id = $1;

-- -- name: UpdateMainServiceStatus :one
-- UPDATE main_services
-- SET  status = $2  
-- Where id = $1
-- RETURNING *;

-- -- name: GetAllMainServicesAndServices :many
-- SELECT 
-- 	main_services.id AS main_services_id,
-- 	main_services.title AS main_services,
-- 	services.id AS services_id,
-- 	services.title AS services 
-- FROM main_services
-- INNER JOIN services ON services.main_services_id = main_services.id AND (services.status != 5 AND services.status != 6)
-- WHERE main_services.status != 5 AND main_services.status != 6
-- ORDER BY main_services_id DESC, services_id DESC;