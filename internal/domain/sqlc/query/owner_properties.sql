-- name: CreateOwnerProperties :one
INSERT INTO owner_properties (
  list_of_date,
  list_of_notes,
  list_of_agent,
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
  is_show_owner_info,
  property,
  -- facts_values,
  countries_id,
  ref_no,
  category,
  investment,
  contract_start_datetime,
  contract_end_datetime,
  amount,
  -- ask_price,
  unit_types,
    users_id,
    property_name 
)VALUES (
    $1, $2, $3, $4, $5, $6,$7,$8,$9,$10, $11, $12, $13, $14,  $15, $16, $17, $18, $19, $20,$21, $22, $23, $24, $25, $26, $27,  $28, $29, $30 
) RETURNING *;

-- name: GetOwnerProperties :one
SELECT * FROM owner_properties 
WHERE id = $1 LIMIT $1;

-- name: GetOwnerPropertiesByName :one
SELECT * FROM owner_properties 
WHERE property_title = $2 LIMIT $1;


-- name: GetAllOwnerProperties :many
SELECT * FROM owner_properties
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateOwnerProperties :one
UPDATE owner_properties
SET   property_title = $2,
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
  is_show_owner_info = $17,
  property = $18,
  -- facts_values = $19,
  countries_id = $19,
  ref_no = $20,
  category = $21,
  investment = $22,
  contract_start_datetime = $23,
  contract_end_datetime = $24,
  amount = $25,
  -- ask_price = $26,
  unit_types = $26,
    users_id = $27,
    property_name = $28,
      list_of_date = $29,
  list_of_notes =  $30,
  list_of_agent = $31  
Where id = $1
RETURNING *;


-- name: DeleteOwnerProperties :exec
DELETE FROM owner_properties
Where id = $1;

-- name: UpdateOwnerPropertyStatusById :one
UPDATE owner_properties
SET status = $2
WHERE id=$1
RETURNING *;

-- name: UpdateOwnerPropertyRankById :one
UPDATE owner_properties
SET property_rank = $2
WHERE id=$1
RETURNING *;

-- name: UpdateOwnerPropertyVerificationById :one
UPDATE owner_properties
SET is_verified = $2
WHERE id=$1
RETURNING *;


-- name: GetOwnerPropertiesByUserId :many
select id, property_title,  property from owner_properties op where op.users_id  = $1;



-- name: GetOwnerPropertiesWithValidation :one
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
    facilities_id,
    amenities_id,
    status,
    created_at,
    updated_at,
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
    property_name,
    list_of_date,
    list_of_notes,
    list_of_agent
FROM
    owner_properties fp
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

-- name: GetOwnerPropertiesByRefrenceNumber :one
SELECT * FROM owner_properties WHERE ref_no = $1 LIMIT 1;