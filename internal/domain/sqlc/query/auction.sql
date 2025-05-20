

-- name: CreateAuctionActivity :one
INSERT INTO auctions_activities (
    auction_id, activity_type, file_category, file_url, portal_url, activity, user_id,
    activity_date, created_at
) VALUES (
    $1, $2, $3, $4, $5, $6, $7,$8, NOW()
)RETURNING *;

-- name: GetActivitiesByType :many
SELECT * FROM
    auctions_activities
WHERE activity_type = $1
    AND ($2::TEXT IS NULL OR activity ILIKE '%' || $2 || '%')
ORDER BY
    created_at DESC
LIMIT $3 OFFSET $4;

-- name: CountActivitiesByType :one
SELECT COUNT(id) FROM
    auctions_activities
WHERE activity_type = $1
    AND ($2::TEXT IS NULL OR activity ILIKE '%' || $2 || '%');


-- name: CreateActivityChange :one
INSERT INTO auctions_activity_changes (
    section_id, activities_id, field_name, before, after,
    activity_date, created_at
) VALUES (
    $1, $2, $3, $4, $5, $6, NOW()
)RETURNING *;

-- name: GetChangesByActivityID :many
SELECT * FROM
    auctions_activity_changes
WHERE
    activities_id = $1
    AND ($2::TEXT IS NULL OR
        field_name ILIKE '%' || $2 || '%' OR
        before ILIKE '%' || $2 || '%' OR
        after ILIKE '%' || $2 || '%')
ORDER BY
    created_at DESC
LIMIT $3 OFFSET $4;

-- name: CountChangesByActivityID :one
SELECT COUNT(id) FROM
    auctions_activity_changes
WHERE
    activities_id = $1
    AND ($2::TEXT IS NULL OR
        field_name ILIKE '%' || $2 || '%' OR
        before ILIKE '%' || $2 || '%' OR
        after ILIKE '%' || $2 || '%');

 


-- query.sql

-- Insert a new addresses
-- name: CreateAuctionsAddresses :one
INSERT INTO auctions_addresses (
    country, state, city, community, sub_community, location_url, lat, lng
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING *;

-- Get a addresses by ID
-- name: GetAddressByID :one
SELECT * FROM auctions_addresses WHERE id = $1;

-- List all addresses
-- name: ListAddresses :many
SELECT * FROM auctions_addresses;


-- name: UpdateAuctionsAddress :one
 UPDATE auctions_addresses
SET
    country = $1,
    state = $2,
    city = $3,
    community = $4,
    sub_community = $5,
    location_url = $6,
    lat = $7,
    lng = $8,
    updated_at = NOW()  -- Assuming you want to track the update timestamp
WHERE id = $9  -- Use the actual address ID
RETURNING *;

 
 
-- name: CreateAuction :one
INSERT INTO auctions (
    ref_no, auction_title, auction_description, auction_category, companies_id, mobile_number,
    email_address,whatsapp,select_type,property_name, property_category,
    property_usage, properties_unites_id, plot_no, sector_no, has_tenants, lat, lng,
    prebid_start_date, start_date, end_date, min_bid_amount, min_increment_amount,
    winning_bid_amount, auction_url, auction_type, description, description_ar,
    addresses_id, location_url, ownership_id, auction_status, tags_id, created_at, updated_at
) VALUES (
    $1, $2, $3, $4, $5, $6,
    $7, $8, $9, $10, $11, $12, $13,
    $14, $15, $16, $17, $18,
    $19, $20, $21, $22, $23,
    $24, $25, $26, $27, $28,
    $29, $30, $31, $32, $33, now(), now()
) RETURNING *;

-- name: GetAuctionByID :one
SELECT
    a.*,
    COUNT(DISTINCT pb.bidder_id) AS number_of_bidder,
    COALESCE(MAX(pb.amount), 0)::float8 AS current_max_bid_amount
FROM
    auctions a
LEFT JOIN
    auctions_pre_bids pb ON a.id = pb.auction_id
WHERE a.deleted_at IS NULL AND a.id = $1
GROUP BY a.id;

-- name: GetAuctionByAuctionTitle :one
SELECT *
FROM auctions
WHERE deleted_at IS NULL
    AND auction_title = $1;

-- name: ListAuctions :many
SELECT
    a.*,
    COUNT(DISTINCT pb.bidder_id) AS number_of_bidder,
    COALESCE(MAX(pb.amount), 0)::float8 AS current_max_bid_amount
FROM
    auctions a
LEFT JOIN
    auctions_pre_bids pb ON a.id = pb.auction_id
WHERE a.deleted_at IS NULL
AND ($1::BIGINT IS NULL OR a.auction_type = $1)  --local OR internation
AND ($2::TEXT IS NULL OR
    a.auction_title ILIKE '%' || $2 || '%' OR
    a.description ILIKE '%' || $2 || '%' OR
    a.auction_description ILIKE '%' || $2 || '%' OR
    a.auction_url ILIKE '%' || $2 || '%'
)
GROUP BY a.id
ORDER BY a.created_at DESC
LIMIT $3 OFFSET $4;

-- name: CountAuctions :one
SELECT COUNT(id)
FROM auctions
WHERE deleted_at IS NULL
AND ($1::bigint IS NULL OR auction_type = $1::bigint)
AND (
    $2::TEXT IS NULL OR
    auction_title ILIKE '%' || $2 || '%' OR
    description ILIKE '%' || $2 || '%' OR
    auction_description ILIKE '%' || $2 || '%' OR
    auction_url ILIKE '%' || $2 || '%'
);

-- name: UpdateAuction :one
UPDATE auctions SET
    auction_title = $2, auction_description = $3, auction_category = $4,select_type = $5, property_name = $6, property_category = $7,
    property_usage = $8, properties_unites_id = $9, plot_no = $10, sector_no = $11, has_tenants = $12, lat = $13, lng = $14,
    prebid_start_date = $15, start_date = $16, end_date = $17, min_bid_amount = $18, min_increment_amount = $19,
    auction_url = $20, auction_type = $21, description = $22, description_ar = $23,
    addresses_id = $24, location_url = $25, ownership_id = $26, updated_at = now(), auction_status = $27, tags_id = $28
WHERE id = $1
RETURNING *;

-- name: SoftDeleteAuction :exec
UPDATE auctions SET
    auction_status = $2, -- DELETED
    updated_at = now(),
    deleted_at = now()
WHERE id = $1;

-- name: ListDeletedAuctions :many
SELECT
    a.*,
    COUNT(DISTINCT pb.bidder_id) AS number_of_bidder,
    COALESCE(MAX(pb.amount), 0)::float8 AS current_max_bid_amount
FROM
    auctions a
LEFT JOIN
    auctions_pre_bids pb ON a.id = pb.auction_id
WHERE a.deleted_at IS NOT NULL
AND (
    $1::TEXT IS NULL OR
    a.auction_title ILIKE '%' || $1 || '%' OR
    a.auction_description ILIKE '%' || $1 || '%' OR
    a.description ILIKE '%' || $1 || '%' OR
    a.auction_url ILIKE '%' || $1 || '%'
)
GROUP BY a.id
ORDER BY a.created_at DESC
LIMIT $2 OFFSET $3;

-- name: CountDeletedAuctions :one
SELECT COUNT(id)
FROM auctions
WHERE deleted_at IS NOT NULL
AND (
    $1::TEXT IS NULL OR
    auction_title ILIKE '%' || $1 || '%' OR
    auction_description ILIKE '%' || $1 || '%' OR
    description ILIKE '%' || $1 || '%' OR
    auction_url ILIKE '%' || $1 || '%'
);


-- name: RestoreAuctionById :exec
UPDATE auctions SET
    auction_status = $2,
    updated_at = now(),
    deleted_at = NULL
WHERE id = $1 AND deleted_at IS NOT NULL;



 

-- -- name: GetAuctionByID :one
-- SELECT
--     a.*,
--     COUNT(DISTINCT pb.bidder_id) AS number_of_bidder,
--     COALESCE(MAX(pb.amount), 0)::float8 AS current_max_bid_amount
-- FROM
--     auctions a
-- LEFT JOIN
--     auctions_pre_bids pb ON a.id = pb.auction_id
-- WHERE a.deleted_at IS NULL AND a.id = $1
-- GROUP BY a.id;

-- -- name: GetAuctionByAuctionTitle :one
-- SELECT *
-- FROM auctions
-- WHERE deleted_at IS NULL
 -- AND auction_title = $1;

-- -- name: ListAuctions :many
-- SELECT
--     a.*,
--     COUNT(DISTINCT pb.bidder_id) AS number_of_bidder,
--     COALESCE(MAX(pb.amount), 0)::float8 AS current_max_bid_amount
-- FROM
--     auctions a
-- LEFT JOIN
--     auctions_pre_bids pb ON a.id = pb.auction_id
-- WHERE a.deleted_at IS NULL
-- AND ($1::BIGINT IS NULL OR a.auction_type = $1)  --local OR internation
-- AND ($2::TEXT IS NULL OR
--     a.auction_title ILIKE '%' || $2 || '%' OR
--     a.description ILIKE '%' || $2 || '%' OR
--     a.auction_description ILIKE '%' || $2 || '%' OR
--     a.auction_url ILIKE '%' || $2 || '%'
-- )
-- GROUP BY a.id
-- ORDER BY a.created_at DESC
-- LIMIT $3 OFFSET $4;

-- -- name: CountAuctions :one
-- SELECT COUNT(id)
-- FROM auctions
-- WHERE deleted_at IS NULL
-- AND ($1::bigint IS NULL OR auction_type = $1::bigint)
-- AND (
--     $2::TEXT IS NULL OR
--     auction_title ILIKE '%' || $2 || '%' OR
--     description ILIKE '%' || $2 || '%' OR
--     auction_description ILIKE '%' || $2 || '%' OR
--     auction_url ILIKE '%' || $2 || '%'
-- );

-- -- name: UpdateAuction :one
-- UPDATE auctions SET
--     auction_title = $2, auction_description = $3, auction_category = $4,select_type = $5, property_name = $6, property_category = $7,
--     property_usage = $8, properties_unites_id = $9, plot_no = $10, sector_no = $11, has_tenants = $12, lat = $13, lng = $14,
--     prebid_start_date = $15, start_date = $16, end_date = $17, min_bid_amount = $18, min_increment_amount = $19,
--     auction_url = $20, auction_type = $21, description = $22, description_ar = $23,
--     addresses_id = $24, location_url = $25, ownership_id = $26, updated_at = now(), auction_status = $27, tags_id = $28
-- WHERE id = $1
-- RETURNING *;

-- -- name: SoftDeleteAuction :exec
-- UPDATE auctions SET
--     auction_status = $2, -- DELETED
--     updated_at = now(),
--     deleted_at = now()
-- WHERE id = $1;

-- -- name: ListDeletedAuctions :many
-- SELECT
--     a.*,
--     COUNT(DISTINCT pb.bidder_id) AS number_of_bidder,
--     COALESCE(MAX(pb.amount), 0)::float8 AS current_max_bid_amount
-- FROM
--     auctions a
-- LEFT JOIN
--     auctions_pre_bids pb ON a.id = pb.auction_id
-- WHERE a.deleted_at IS NOT NULL
-- AND (
--     $1::TEXT IS NULL OR
--     a.auction_title ILIKE '%' || $1 || '%' OR
--     a.auction_description ILIKE '%' || $1 || '%' OR
--     a.description ILIKE '%' || $1 || '%' OR
--     a.auction_url ILIKE '%' || $1 || '%'
-- )
-- GROUP BY a.id
-- ORDER BY a.created_at DESC
-- LIMIT $2 OFFSET $3;

-- -- name: CountDeletedAuctions :one
-- SELECT COUNT(id)
-- FROM auctions
-- WHERE deleted_at IS NOT NULL
-- AND (
--     $1::TEXT IS NULL OR
--     auction_title ILIKE '%' || $1 || '%' OR
--     auction_description ILIKE '%' || $1 || '%' OR
--     description ILIKE '%' || $1 || '%' OR
--     auction_url ILIKE '%' || $1 || '%'
-- );


-- -- name: RestoreAuctionById :exec
-- UPDATE auctions SET
--     auction_status = $2,
--     updated_at = now(),
--     deleted_at = NULL
-- WHERE id = $1 AND deleted_at IS NOT NULL;


 



-- name: GetCompanyDetailsById :one
SELECT * FROM auctions_companies
WHERE deleted_at IS NULL AND id = $1;

-- name: GetCompanyDetailsByUserId :one
SELECT
    c.*
FROM
    auctions_users u
JOIN
    auctions_companies c ON u.company_id = c.id
WHERE c.deleted_at IS NULL
    AND u.id = $1;



 


-- query.sql

-- name: CreateAuctionDocument :one
INSERT INTO auctions_documents (auction_id, document_type, document_url, created_at)
VALUES ($1, $2, $3, NOW())
RETURNING *;

-- name: GetAuctionDocumentByID :one
SELECT *
FROM auctions_documents
WHERE id = $1 AND deleted_at IS NULL;

-- name: GetAuctionDocumentsByAuctionID :many
SELECT *
FROM auctions_documents
WHERE deleted_at IS NULL
    AND auction_id = $1
ORDER BY created_at DESC
LIMIT $2 OFFSET $3;

-- name: CountAuctionDocumentsByAuctionID :one
SELECT COUNT(id)
FROM auctions_documents
WHERE deleted_at IS NULL
    AND auction_id = $1;

-- name: GetDocumentByDocumentTypeAndAuctionID :one
SELECT *
FROM auctions_documents
WHERE deleted_at IS NULL
    AND auction_id = $1
    AND document_type = $2;

-- name: UpdateDocumentUrls :one
UPDATE auctions_documents
SET document_url = $2,
    updated_at = NOW()
WHERE id = $1 AND deleted_at IS NULL
RETURNING *;

-- name: DeleteAuctionDocument :exec
UPDATE auctions_documents
SET deleted_at = NOW()
WHERE id = $1;
 
 

-- name: CreateFAQ :one
INSERT INTO auctions_faqs (ref_no, question, answer, created_at)
VALUES ($1, $2, $3, NOW())
RETURNING id, ref_no, question, answer, created_at, updated_at, deleted_at;

-- name: GetFAQByID :one
SELECT id, ref_no, question, answer, created_at, updated_at, deleted_at
FROM auctions_faqs
WHERE id = $1 AND deleted_at IS NULL;

-- name: ListAllFAQs :many
SELECT *
FROM auctions_faqs
WHERE deleted_at IS NULL
    AND ($1::TEXT IS NULL OR question ILIKE '%' || $1 || '%' OR answer ILIKE '%' || $1 || '%')
ORDER BY created_at DESC
LIMIT $2 OFFSET $3;

-- name: CountAllFAQs :one
SELECT COUNT(*)
FROM auctions_faqs
WHERE deleted_at IS NULL AND (
    $1::TEXT IS NULL
    OR question ILIKE '%' || $1 || '%'
    OR answer ILIKE '%' || $1 || '%');

-- name: UpdateFAQ :one
UPDATE auctions_faqs
SET question = $3,
    answer = $2,
    updated_at = NOW()
WHERE id = $1 AND deleted_at IS NULL
RETURNING id, ref_no, question, answer, created_at, updated_at, deleted_at;

-- name: SoftDeleteFAQ :exec
UPDATE auctions_faqs
SET deleted_at = NOW()
WHERE id = $1;

-- name: GetDeletedFAQs :many
SELECT *
FROM auctions_faqs
WHERE deleted_at IS NOT NULL
    AND ($1::TEXT IS NULL OR question ILIKE '%' || $1 || '%' OR answer ILIKE '%' || $1 || '%')
ORDER BY created_at DESC
LIMIT $2 OFFSET $3;

-- name: CountDeletedFaqs :one
SELECT COUNT(id)
FROM auctions_faqs
WHERE deleted_at IS NOT NULL
    AND ($1::TEXT IS NULL OR question ILIKE '%' || $1 || '%' OR answer ILIKE '%' || $1 || '%');

-- name: RestoreFAQ :exec
UPDATE auctions_faqs
SET deleted_at = NULL
WHERE id = $1 AND deleted_at IS NOT NULL;

 

-- name: CreateAuctionMedia :one
INSERT INTO auctions_media (auction_id, gallery_type, media_type, media_url, created_at)
VALUES ($1, $2, $3, $4, NOW())
RETURNING *;

-- name: GetAuctionMediaByID :one
SELECT *
FROM auctions_media
WHERE id = $1 AND deleted_at IS NULL;

-- name: GetAuctionMediaByAuctionID :many
SELECT *
FROM auctions_media
WHERE deleted_at IS NULL
    AND auction_id = $1
ORDER BY created_at DESC
LIMIT $2 OFFSET $3;

-- name: CountAuctionMediaRecordByAuctionID :one
SELECT COUNT(id)
FROM auctions_media
WHERE deleted_at IS NULL
    AND auction_id = $1;

-- name: UpdateAuctionMediaUrls :one
UPDATE auctions_media
SET media_url = $2,
    updated_at = NOW()
WHERE id = $1 AND deleted_at IS NULL
RETURNING *;

-- name: DeleteAuctionMedia :exec
UPDATE auctions_media
SET deleted_at = NOW()
WHERE id = $1;

-- name: GetMediaCountOfAuction :one
SELECT COUNT(unnested_media) AS media_count
FROM auctions_media,
UNNEST(media_url) AS unnested_media
WHERE auction_id = $1 AND deleted_at IS NULL;


 

-- name: CreateAuctionPartner :one
INSERT INTO auctions_partners (ref_no, auction_id, partner_name, partner_logo, website, created_at)
VALUES ($1, $2, $3, $4, $5, NOW())
RETURNING *;

-- name: GetAuctionPartnerByID :one
SELECT *
FROM auctions_partners
WHERE id = $1 AND deleted_at IS NULL;


-- name: ListAuctionPartners :many
SELECT *
FROM auctions_partners
WHERE deleted_at IS NULL
    AND auction_id = $1
    AND ($2::TEXT IS NULL
    OR partner_name ILIKE '%' || $2 || '%'
    OR website ILIKE '%' || $2 || '%'
)
ORDER BY created_at DESC
LIMIT $3 OFFSET $4;

-- name: CountAuctionPartners :one
SELECT COUNT(*)
FROM auctions_partners
WHERE deleted_at IS NULL
    AND auction_id = $1
    AND ($2::TEXT IS NULL
    OR partner_name ILIKE '%' || $2 || '%'
    OR website ILIKE '%' || $2 || '%'
);


-- name: UpdateAuctionPartner :one
UPDATE auctions_partners
SET partner_logo = $2,
    partner_name = $3,
    website = $4,
    updated_at = NOW()
WHERE id = $1 AND deleted_at IS NULL
RETURNING *;


-- name: SoftDeleteAuctionPartner :exec
UPDATE auctions_partners
SET deleted_at = NOW()
WHERE id = $1;

-- name: ListDeletedPartners :many
SELECT *
FROM auctions_partners
WHERE deleted_at IS NOT NULL
    AND ($1::TEXT IS NULL
    OR partner_name ILIKE '%' || $1 || '%'
    OR website ILIKE '%' || $1 || '%')
ORDER BY created_at DESC
LIMIT $2 OFFSET $3;

-- name: CountDeletedAuctionPartners :one
SELECT COUNT(*)
FROM auctions_partners
WHERE deleted_at IS  NOT NULL
    AND ($1::TEXT IS NULL
    OR partner_name ILIKE '%' || $1 || '%'
    OR website ILIKE '%' || $1 || '%');

-- name: RestoreAuctionPartner :exec
UPDATE auctions_partners
SET deleted_at = NULL
WHERE id = $1;



 

-- name: CreateAuctionPlan :one
INSERT INTO auctions_plans (auction_id, plan_title, plan_url, created_at)
VALUES ($1, $2, $3, NOW())
RETURNING *;

-- name: GetAuctionPlanByID :one
SELECT *
FROM auctions_plans
WHERE id = $1 AND deleted_at IS NULL;

-- name: GetAuctionPlansByAuctionID :many
SELECT *
FROM auctions_plans
WHERE deleted_at IS NULL AND auction_id = $1
ORDER BY created_at DESC
LIMIT $2 OFFSET $3;

-- name: CountAuctionPlansByAuctionID :one
SELECT COUNT(id)
FROM auctions_plans
WHERE deleted_at IS NULL AND auction_id = $1;


-- name: GetPlansByPlanTitleAndAuctionID :one
SELECT *
FROM auctions_plans
WHERE deleted_at IS NULL
    AND auction_id = $1
    AND plan_title = $2;

-- name: UpdatePlanUrls :one
UPDATE auctions_plans
SET plan_url = $2,
    updated_at = NOW()
WHERE id = $1 AND deleted_at IS NULL
RETURNING *;

-- name: DeleteAuctionPlan :exec
UPDATE auctions_plans
SET deleted_at = NOW()
WHERE id = $1;


 


-- name: CreateProperty :one
INSERT INTO auctions_properties (
    ref_no, companies_id, property_title, property_title_arabic,
    description, description_arabic, is_verified, property_rank,
    addresses_id, property_types_id, status, facilities_id, amenities_id,
    is_show_owner_info, property, category, investment, contract_start_datetime,
    contract_end_datetime, amount, unit_types, property_name, from_xml,
    list_of_date, list_of_notes, list_of_agent, owner_users_id,
    created_at, updated_at
) VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19,
        $20, $21, $22, $23, $24, $25, $26, $27, NOW(), NOW()
) RETURNING *;

-- name: GetPropertyById :one
SELECT *
FROM auctions_properties
WHERE id = $1;

-- name: UpdateProperty :one
UPDATE auctions_properties
SET
    companies_id = $2,
    property_title = $3,
    property_title_arabic = $4,
    description = $5,
    description_arabic = $6,
    is_verified = $7,
    property_rank = $8,
    addresses_id = $9,
    property_types_id = $10,
    status = $11,
    facilities_id = $12,
    amenities_id = $13,
    is_show_owner_info = $14,
    property = $15,
    category = $16,
    investment = $17,
    contract_start_datetime = $18,
    contract_end_datetime = $19,
    amount = $20,
    unit_types = $21,
    property_name = $22,
    from_xml = $23,
    list_of_date = $24,
    list_of_notes = $25,
    list_of_agent = $26,
    owner_users_id = $27,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: CreatePropertiesFact :one
INSERT INTO auctions_properties_facts (
    bedroom,
    plot_area,
    built_up_area,
    view,
    furnished,
    ownership,
    completion_status,
    start_date,
    completion_date,
    handover_date,
    no_of_floor,
    no_of_units,
    min_area,
    max_area,
    service_charge,
    parking,
    ask_price,
    price,
    rent_type,
    no_of_payment,
    no_of_retail,
    no_of_pool,
    elevator,
    starting_price,
    life_style,
    properties_id,
    property,
    is_branch,
    available_units,
    commercial_tax,
    municipality_tax,
    is_project_fact,
    project_id,
    completion_percentage,
    completion_percentage_date,
    type_name_id,
    sc_currency_id,
    unit_of_measure,
    created_at
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33, $34, $35, $36, $37,$38, NOW()
) RETURNING *;

-- name: GetPropertiesFactByPropertyID :one
SELECT * FROM auctions_properties_facts WHERE properties_id = $1;

-- name: UpdatePropertiesFacts :one
UPDATE auctions_properties_facts
SET
    plot_area = $2,
    built_up_area = $3,
    view = $4,
    furnished = $5,
    ownership = $6,
    completion_status = $7,
    start_date = $8,
    completion_date = $9,
    handover_date = $10,
    no_of_floor = $11,
    no_of_units = $12,
    min_area = $13,
    max_area = $14,
    service_charge = $15,
    parking = $16,
    ask_price = $17,
    price = $18,
    rent_type = $19,
    no_of_payment = $20,
    no_of_retail = $21,
    no_of_pool = $22,
    elevator = $23,
    starting_price = $24,
    life_style = $25,
    property = $26,
    is_branch = $27,
    available_units = $28,
    commercial_tax = $29,
    municipality_tax = $30,
    is_project_fact = $31,
    project_id = $32,
    completion_percentage = $33,
    completion_percentage_date = $34,
    type_name_id = $35,
    sc_currency_id = $36,
    unit_of_measure = $37,
    bedroom = $38,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: CreateAuctionsUnits :one
INSERT INTO auctions_units (
    ref_no,
    unit_no,
    unitno_is_public,
    notes,
    notes_arabic,
    notes_public,
    is_verified,
    amenities_id,
    property_unit_rank,
    properties_id,
    property,
    addresses_id,
    countries_id,
    property_types_id,
    created_by,
    property_name,
    section,
    type_name_id,
    owner_users_id,
    created_at,
    updated_at
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, DEFAULT, DEFAULT
) RETURNING *;

-- name: GetUnitById :one
SELECT *
FROM auctions_units
WHERE id = $1;

-- name: UpdateAuctionsUnits :one
UPDATE auctions_units
SET
    unit_no = $2,
    unitno_is_public = $3,
    notes = $4,
    notes_arabic = $5,
    notes_public = $6,
    is_verified = $7,
    amenities_id = $8,
    property_unit_rank = $9,
    properties_id = $10,
    property = $11,
    addresses_id = $12,
    countries_id = $13,
    property_types_id = $14,
    created_by = $15,
    property_name = $16,
    section = $17,
    type_name_id = $18,
    owner_users_id = $19,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: CreateAuctionsUnitFact :one
INSERT INTO auctions_unit_facts (
    bedroom,
    bathroom,
    plot_area,
    built_up_area,
    view,
    furnished,
    ownership,
    completion_status,
    start_date,
    completion_date,
    handover_date,
    no_of_floor,
    no_of_units,
    min_area,
    max_area,
    service_charge,
    parking,
    ask_price,
    price,
    rent_type,
    no_of_payment,
    no_of_retail,
    no_of_pool,
    elevator,
    starting_price,
    life_style,
    unit_id,
    category,
    is_branch,
    commercial_tax,
    municipality_tax,
    sc_currency_id,
    unit_of_measure,
    created_at
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32,$33, NOW()
) RETURNING *;

-- name: GetUnitFactByUnitID :one
SELECT * FROM auctions_unit_facts WHERE unit_id = $1;

-- name: UpdateAuctionsUnitFacts :one
UPDATE auctions_unit_facts
SET
    bathroom = $2,
    plot_area = $3,
    built_up_area = $4,
    view = $5,
    furnished = $6,
    ownership = $7,
    completion_status = $8,
    start_date = $9,
    completion_date = $10,
    handover_date = $11,
    no_of_floor = $12,
    no_of_units = $13,
    min_area = $14,
    max_area = $15,
    service_charge = $16,
    parking = $17,
    ask_price = $18,
    price = $19,
    rent_type = $20,
    no_of_payment = $21,
    no_of_retail = $22,
    no_of_pool = $23,
    elevator = $24,
    starting_price = $25,
    life_style = $26,
    bedroom = $27,
    category = $28,
    is_branch = $29,
    commercial_tax = $30,
    municipality_tax = $31,
    sc_currency_id = $32,
    unit_of_measure = $33,
    updated_at = NOW()
WHERE id = $1
RETURNING *;




