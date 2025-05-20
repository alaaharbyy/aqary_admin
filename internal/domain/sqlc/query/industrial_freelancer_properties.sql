-- name: CreateIndustrialFreelancerProperty :one
INSERT INTO industrial_freelancer_properties (
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
    freelancers_id,
    is_show_owner_info,
    property,
    countries_id,
    ref_no,
    developer_company_name,
    sub_developer_company_name,
    category,
    investment,
    contract_start_datetime,
    contract_end_datetime,
    amount,
    unit_types,
    users_id,
    property_name,
    owner_users_id
)VALUES (
     $1 ,$2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30
) RETURNING *;

 
-- name: GetIndustrialFreelancerProperty :one
SELECT * FROM industrial_freelancer_properties 
WHERE id = $1 LIMIT $1;

-- name: GetAllIndustrialFreelancerProperty :many
SELECT * FROM industrial_freelancer_properties
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateIndustrialFreelancerProperty :one
UPDATE industrial_freelancer_properties
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
    freelancers_id = $16,
    is_show_owner_info = $17,
    property = $18,
    countries_id = $19,
    ref_no = $20,
    developer_company_name = $21,
    sub_developer_company_name = $22,
    category = $23,
    investment = $24,
    contract_start_datetime = $25,
    contract_end_datetime = $26,
    amount = $27,
    unit_types = $28,
    users_id = $29,
    property_name = $30,
    owner_users_id = $31
Where id = $1
RETURNING *;


-- name: DeleteIndustrialFreelancerProperty :exec
DELETE FROM industrial_freelancer_properties
Where id = $1;


-- name: UpdateIndustrialFreelancerPropertyVerifyStatus :one
UPDATE industrial_freelancer_properties SET is_verified = $2 WHERE id = $1 RETURNING *;


-- name: UpdateIndustrialFreelancerPropertyStatus :one
UPDATE industrial_freelancer_properties SET status = $2 WHERE id = $1 RETURNING *;

