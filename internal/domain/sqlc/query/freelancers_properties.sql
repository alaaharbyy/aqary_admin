-- name: CreateFreelancerProperty :one
INSERT INTO freelancers_properties (
    list_of_date,
  list_of_notes,
  property_title,
  property_title_arabic,
  description,
  description_arabic,
  is_verified,
  property_rank,
  addresses_id,
  locations_id, 
  property_types_id,
  profiles_id,
  facilities_id,
  amenities_id,
  status,
  created_at,
  updated_at,
  freelancers_id,
  is_show_owner_info,
  property,
  -- facts_values,
  countries_id,
  ref_no,
  developer_company_name,
  sub_developer_company_name,
  category,
  investment,
  contract_start_datetime,
  contract_end_datetime,
  amount,
  -- ask_price,
  unit_types,
  users_id,
  property_name,
  list_of_agent,
  owner_users_id
)VALUES (
    $1, $2,$3, $4, $5,$6,$7,$8,$9,$10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33, $34
) RETURNING *;


-- name: GetFreelancerProperty :one
SELECT * FROM freelancers_properties 
WHERE id = $1 LIMIT 1;


-- name: GetFreelancerPropertyByName :one
SELECT * FROM freelancers_properties 
WHERE property_title = $2 LIMIT $1;


-- name: GetAllFreelancerProperty :many
SELECT * FROM freelancers_properties
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateFreelancerProperty :one
UPDATE freelancers_properties
SET    property_title = $2,
  property_title_arabic = $3,
  description = $4,
  description_arabic = $5,
  is_verified = $6,
  property_rank = $7,
  addresses_id = $8,
  locations_id = $9, 
  property_types_id = $10,
  profiles_id = $11,
  facilities_id = $12,
  amenities_id = $13,
  status = $14,
  created_at = $15,
  updated_at = $16,
  freelancers_id = $17,
  is_show_owner_info = $18,
  property = $19,
  -- facts_values = $20,
  countries_id = $20,
  ref_no = $21,
  developer_company_name = $22,
  sub_developer_company_name = $23,
  category = $24,
  investment = $25,
  contract_start_datetime = $26,
  contract_end_datetime = $27,
  amount = $28,
  -- ask_price = $29,
  unit_types = $29,
  users_id = $30,
  property_name = $31,
  list_of_date = $32,
  list_of_notes = $33,
  list_of_agent = $34,
  owner_users_id = $35
Where id = $1
RETURNING *;


-- name: DeleteFreelancerProperty :exec
DELETE FROM freelancers_properties
Where id = $1;

-- name: UpdateFreelancerPropertyVerificationById :one
UPDATE freelancers_properties
 SET is_verified=$2
 WHERE id=$1 
 RETURNING *;

-- name: UpdateFreelancerPropertyhubStatus :one 
UPDATE freelancers_properties 
SET status=$2
 Where id=$1
RETURNING *;


-- name: UpdateFreelancerPropertyRankById :one
UPDATE freelancers_properties
SET property_rank=$2 
WHERE id=$1
 RETURNING *;

 

-- name: GetFreelancersPropertiesByUsersId :many
SELECT freelancers_properties.id, freelancers_properties.property_title,  freelancers_properties.property
FROM freelancers_properties 
LEFT JOIN freelancers ON freelancers.id = freelancers_id 
WHERE freelancers.users_id = $1;

SELECT
    id,
    property_title,
    property_title_arabic,
    description,
    description_arabic,
    is_verified,
    property_rank,
    addresses_id,
    locations_id,
    property_types_id,
    profiles_id,
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
    list_of_date,
    list_of_notes,
    list_of_agent
from
    freelancers_properties fp
WHERE
    CASE
        WHEN $1 :: bigint = 0 THEN true
        WHEN $1 :: bigint = 1 THEN fp.addresses_id IN (
            SELECT
                id
            FROM
                addresses
            WHERE
                addresses.cities_id = $2
        )
        WHEN $1 :: bigint = 2 THEN fp.addresses_id IN (
            SELECT
                id
            FROM
                addresses
            WHERE
                addresses.cities_id = $2
                AND communities_id = ANY($3 :: bigint [])
        )
        WHEN $1 :: bigint = 3 THEN fp.addresses_id IN (
            SELECT
                id
            FROM
                addresses
            WHERE
                addresses.cities_id = $2
                AND communities_id = ANY($3 :: bigint [])
                AND sub_communities_id = ANY($4 :: bigint [])
        )
        WHEN $1 :: bigint = 4 THEN fp.addresses_id IN (
            SELECT
                id
            FROM
                addresses
            WHERE
                addresses.cities_id = $2
                AND communities_id = ANY($3 :: bigint [])
                AND sub_communities_id = ANY($4 :: bigint [])
                AND addresses.locations_id = $5
        )
    END
    AND (
        status != 5
        AND status != 6
    )
    AND fp.id = $6
LIMIT
    1;

-- name: GetFreelancerPropertyWithValidation :one
SELECT
    id,
    property_title,
    property_title_arabic,
    description,
    description_arabic,
    is_verified,
    property_rank,
    addresses_id,
    locations_id,
    property_types_id,
    profiles_id,
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
    list_of_date,
    list_of_notes,
    list_of_agent,
    owner_users_id
from
    freelancers_properties fp
WHERE
    CASE
        WHEN $1 :: bigint = 0 THEN true
        WHEN $1 :: bigint = 1 THEN fp.addresses_id IN (
            SELECT
                id
            FROM
                addresses
            WHERE
                addresses.cities_id = $2
        )
        WHEN $1 :: bigint = 2 THEN fp.addresses_id IN (
            SELECT
                id
            FROM
                addresses
            WHERE
                addresses.cities_id = $2
                AND communities_id = ANY($3 :: bigint [])
        )
        WHEN $1 :: bigint = 3 THEN fp.addresses_id IN (
            SELECT
                id
            FROM
                addresses
            WHERE
                addresses.cities_id = $2
                AND communities_id = ANY($3 :: bigint [])
                AND sub_communities_id = ANY($4 :: bigint [])
        )
        WHEN $1 :: bigint = 4 THEN fp.addresses_id IN (
            SELECT
                id
            FROM
                addresses
            WHERE
                addresses.cities_id = $2
                AND communities_id = ANY($3 :: bigint [])
                AND sub_communities_id = ANY($4 :: bigint [])
                AND addresses.locations_id = $5
        )
    END
    AND (
        status != 5
        AND status != 6
    )
    AND fp.id = $6
LIMIT
    1;

-- name: GetFreelancePropertiesByRefrenceNumber :one
SELECT * FROM freelancers_properties WHERE ref_no = $1 LIMIT 1;