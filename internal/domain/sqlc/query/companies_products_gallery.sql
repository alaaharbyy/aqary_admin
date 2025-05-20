-- name: CreateCompaniesProductsGallery :one
INSERT INTO companies_products_gallery (
    companies_products_id,
    image_url,
    video_url,
    image360_url
) VALUES (
    $1, $2, $3, $4
) RETURNING *;

-- name: UpdateCompaniesProductsGallery :one
UPDATE companies_products_gallery
SET
    image_url = $2,
    video_url = $3,
    image360_url = $4
WHERE
    id = $1
RETURNING *;

-- name: UpdateCompaniesProductsGalleryByCompaniesId :one
UPDATE companies_products_gallery
SET
    image_url = $2,
    video_url = $3,
    image360_url = $4
WHERE
    companies_products_id = $1
RETURNING *;