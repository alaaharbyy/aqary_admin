-- name: CreateIndustrialOwnerProperty :one
INSERT INTO industrial_owner_properties (
    property_title,
    property_title_arabic,
    description,
    description_arabic,
    is_verified,
    property_rank,
    addresses_id,
    locations_id,
    property_types_id,
    status,
    created_at,
    updated_at,
    facilities_id,
    amenities_id,
    is_show_owner_info,
    property,
    countries_id,
    ref_no,
    category,
    investment,
    contract_start_datetime,
    contract_end_datetime,
    amount,
    unit_types,
    users_id,
    property_name
)VALUES (
     $1 ,$2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26
) RETURNING *;

 
-- name: GetIndustrialOwnerProperty :one
SELECT * FROM industrial_owner_properties 
WHERE id = $1 LIMIT $1;

-- name: GetAllIndustrialOwnerProperty :many
SELECT * FROM industrial_owner_properties
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateIndustrialOwnerProperty :one
UPDATE industrial_owner_properties
SET   property_title = $2,
    property_title_arabic = $3,
    description = $4,
    description_arabic = $5,
    is_verified = $6,
    property_rank = $7,
    addresses_id = $8,
    locations_id = $9,
    property_types_id = $10,
    status = $11,
    created_at = $12,
    updated_at = $13,
    facilities_id = $14,
    amenities_id = $15,
    is_show_owner_info = $16,
    property = $17,
    countries_id = $18,
    ref_no = $19,
    category = $20,
    investment = $21,
    contract_start_datetime = $22,
    contract_end_datetime = $23,
    amount = $24,
    unit_types = $25,
    users_id = $26,
    property_name = $27
Where id = $1
RETURNING *;


-- name: DeleteIndustrialOwnerProperty :exec
DELETE FROM industrial_owner_properties
Where id = $1;

-- name: UpdateIndustrialOwnerPropertyVerifyStatus :one
UPDATE industrial_owner_properties SET is_verified = $2 WHERE id = $1 RETURNING *;


-- name: UpdateIndustrialOwnerPropertyStatus :one
 UPDATE industrial_owner_properties SET status = $2 WHERE id = $1 RETURNING *;

-- name: UpdateIndustrialOwnerPropertyRank :one
UPDATE industrial_owner_properties SET property_rank = $2 WHERE id = $1 RETURNING *;
