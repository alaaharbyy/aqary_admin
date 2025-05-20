-- name: GetBankById :one
SELECT * FROM banks WHERE id = $1;

-- name: GetAllBanks :many
SELECT * FROM banks;

-- name: CreateBank :one
INSERT INTO bank_listing(
    name,
    bank_logo_url,
    bank_url,
    fixed_interest_rate,
    bank_process_fee,
    mail,
    created_by,
    created_at,
    updated_at,
    status,
    country_id
)VALUES (
    $1,  
    $2,  
    $3, 
    $4, 
    $5,  
    $6,  
    $7, 
    $8, 
    $9, 
    $10,
    $11
)
RETURNING * ;

-- name: UpdateBank :one
UPDATE bank_listing
SET
    name=$1,
    bank_logo_url=$2,
    bank_url=$3,
    fixed_interest_rate=$4,
    bank_process_fee=$5,
    mail=$6,
    updated_at=$7,
    country_id=$8
WHERE 
    id=$9
RETURNING * ;

-- name: UpdateBankStatus :one
UPDATE bank_listing
SET
    status=$1
WHERE 
    id=$2
RETURNING * ;

-- name: GetBanksByStatus :many 
SELECT 
sqlc.embed(bank_listing),countries.country
FROM bank_listing
JOIN countries ON countries.id=bank_listing.country_id
WHERE bank_listing.status= $1
ORDER BY updated_at DESC
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetBanksCountByStatus :one 
SELECT 
    count(bank_listing.id)
FROM bank_listing
WHERE bank_listing.status= $1;

-- name: GetBank :one 
SELECT 
    sqlc.embed(bank_listing),countries.country
FROM bank_listing
JOIN countries ON countries.id=bank_listing.country_id
WHERE bank_listing.id= $1;

-- name: CreateBankBranch :one
INSERT INTO bank_branches(
    bank_id,
    branch_name,
    phone,
    is_main_branch,
    address_id,
    status
)VALUES (
    $1,  
    $2,  
    $3, 
    $4, 
    $5,  
    $6
)
RETURNING * ;

-- name: UpdateBankBranch :one
UPDATE bank_branches
SET
    phone=$2,
    is_main_branch=$3,
    address_id=$4,
    branch_name=$5,
    bank_id=$6
WHERE id=$1
RETURNING * ;

-- name: UpdateBankMainBranch :one
UPDATE bank_branches
SET
    is_main_branch=$1
WHERE 
    id=$2
RETURNING * ;

-- name: UpdateBankBranchStatus :one
UPDATE bank_branches
SET
    status=$1
WHERE 
    id=$2
RETURNING * ;

-- name: GetBankBranch :one 
SELECT 
    sqlc.embed(bank_branches), sqlc.embed(addresses),
    coalesce(locations.lat,''::varchar)::varchar as "lat",
    coalesce(locations.lng,''::varchar)::varchar as "lng",
    coalesce(states.state,''::varchar)::varchar as "state",
    coalesce(cities.city,''::varchar)::varchar as "city",
    coalesce(communities.community,''::varchar)::varchar as "community",
    coalesce(sub_communities.sub_community,''::varchar)::varchar as "sub_community"

FROM bank_branches
JOIN addresses ON addresses.id=bank_branches.address_id 
LEFT JOIN locations ON locations.id=addresses.locations_id
LEFT JOIN states ON addresses.states_id = states.id
LEFT JOIN cities ON addresses.cities_id = cities.id
LEFT JOIN communities ON addresses.communities_id = communities.id
LEFT JOIN sub_communities ON addresses.sub_communities_id = sub_communities.id
WHERE bank_branches.id= $1;

-- name: GetBankBranchesByStatus :many 
SELECT
	sqlc.embed(bank_branches),
	addresses.full_address,
	bank_listing."name"
FROM bank_branches
JOIN addresses ON addresses.id=bank_branches.address_id 
JOIN bank_listing ON bank_listing.id=bank_branches.bank_id AND bank_listing.status=1
WHERE bank_branches.status=$1 AND bank_listing.id=$2
ORDER BY bank_branches.id DESC
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');


-- name: GetBankBranchesCountByStatus :one 
SELECT
	count(bank_branches.id)
FROM bank_branches
JOIN addresses ON addresses.id=bank_branches.address_id 
JOIN bank_listing ON bank_listing.id=bank_branches.bank_id AND bank_listing.status=1
WHERE bank_branches.status=$1 AND bank_listing.id=$2;