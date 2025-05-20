

-- name: GetAqaryUserAgentsAndCompany :many
SELECT * FROM users
WHERE user_types_id = 2 and user_types_id = 7 and status != 5 and status != 6;

-- name: GetAqaryUserAgents :many
SELECT * FROM users
WHERE user_types_id = 2 and status != 5 and status != 6;

-- -- name: GetSingleContact :one
-- select c.id, c.users_id, c.ref_no, c.contact_category_id, c.salutation, c.name, c.lastname, c.all_languages_id, c.ejari, c.assigned_to, c.shared_with, c.remarks, c.is_blockedlisted, c.is_vip, c.correspondence, c.direct_markerting, c.status, c.created_by, c.contact_platform, c.created_at, c.updated_at, c.updated_by,
--     scd.id, scd.contacts_id, scd.mobile, scd.mobile_share, scd.mobile2, scd.mobile2_share, scd.landline, scd.landline_share, scd.fax, scd.fax_share, scd.email, scd.email_share, scd.second_email, scd.second_email_share, scd.added_by, scd.created_at, scd.updated_at,
--      COALESCE(ra.id, 0) AS ra_id, COALESCE(ra.contacts_id, 0) AS ra_contacts_id, COALESCE(ra.address_type_id, 0) AS ra_address_type_id, COALESCE(ra.address1, '') AS ra_address1, COALESCE(ra.address2, '') AS ra_address2, COALESCE(ra.countries_id, 0) AS ra_countries_id, COALESCE(ra.states_id, 0) AS ra_states_id, COALESCE(ra.cities_id, 0) AS ra_cities_id, COALESCE(ra.community_id, 0) AS ra_community_id, COALESCE(ra.sub_community_id, 0) AS ra_sub_community_id, COALESCE(ra.postal_code, 0) AS ra_postal_code,
--     COALESCE(ca.id, 0) AS ca_id, COALESCE(ca.contacts_id, 0) AS ca_contacts_id, COALESCE(ca.address_type_id, 0) AS ca_address_type_id, COALESCE(ca.address1, '') AS ca_address1, COALESCE(ca.address2, '') AS ca_address2, COALESCE(ca.countries_id, 0) AS ca_countries_id, COALESCE(ca.states_id, 0) AS ca_states_id, COALESCE(ca.cities_id, 0) AS ca_cities_id, COALESCE(ca.community_id, 0) AS ca_community_id, COALESCE(ca.sub_community_id, 0) AS ca_sub_community_id, COALESCE(ca.postal_code, 0) AS ca_postal_code,ccd.id, ccd.contacts_id, ccd.companies_id, ccd.company_category, ccd.is_branch, ccd.no_of_employees, ccd.industry_id, ccd.no_local_business, ccd.retail_category_id, ccd.no_remote_business, ccd.nationality, ccd.license, ccd.issued_date, ccd.expiry_date, ccd.external_id,
--     cid.id, cid.contacts_id, cid.comapanies_id, cid.company_category, cid.is_branch, cid.date_of_birth, cid.professions_id, cid.gender, cid.marital_status, cid.nationality, cid.id_type, cid.id_number, cid.id_country_id, cid.id_issued_date, cid.id_expiry_date, cid.passport_number, cid.passport_country_id, cid.passport_issued_date, cid.passport_expiry_date, cid.interests,
--     cn1.country as resident_country,ci1.city as resident_city,
--     st1."state" as resident_state, com1.community as resident_community,
--     scom1.sub_community as resident_sub_community,
--     cn2.country as company_country,ci2.city as company_city,
--     st2."state" as company_state, com2.community as company_community,
--     scom2.sub_community as company_sub_community,
--     c.id AS contact_id,
--     c.created_by AS contact_created_by,
--     c.updated_by AS contact_updated_by,
--     u_created_by.username AS created_by_username,
--     u_updated_by.username AS updated_by_username,
--     c.all_languages_id AS contact_all_languages_id,
--     COALESCE(languages, '{}') AS languages,
--     c.assigned_to AS contact_assigned_to,
--     COALESCE(assigned_usernames, '{}') AS assigned_usernames,
--     c.shared_with AS contact_shared_with,
--     COALESCE(shared_usernames, '{}') AS shared_usernames,
--         i.title as company_industry,
--     n1.country as company_nationality,
--     rct.title as company_retail_cateogry,
--     p.title as individual_profession,
--     n2.country as individual_nationality,
--     idci.country as individual_country_id,
--     pci.country as individual_passport_country
-- FROM "public"."contacts" c
-- LEFT JOIN "public"."shareable_contact_details" scd ON c.id = scd.contacts_id
-- LEFT JOIN contacts_address ra ON c.id = ra.contacts_id AND ra.address_type_id = 1
-- left join countries cn1 on ra.countries_id = cn1.id
-- left join cities ci1 on ra.cities_id = ci1.id
-- left join states st1 on ra.states_id = st1.id
-- left join communities com1 on ra.community_id = com1.id
-- LEFT join sub_communities scom1 on ra.sub_community_id = scom1.id
-- LEFT JOIN contacts_address ca ON c.id = ca.contacts_id AND ca.address_type_id = 2
-- left join countries cn2 on ra.countries_id = cn2.id
-- left join cities ci2 on ra.cities_id = ci2.id
-- left join states st2 on ra.states_id = st2.id
-- left join communities com2 on ra.community_id = com2.id
-- LEFT join sub_communities scom2 on ra.sub_community_id = scom2.id
-- LEFT JOIN contacts_company_details ccd ON c.id = ccd.contacts_id AND c.contact_category_id = 1
-- left join industry i on ccd.industry_id = i.id
-- left join countries n1 on ccd.nationality = n1.id
-- left join retail_category rct on ccd.retail_category_id = rct.id
-- LEFT JOIN contacts_individual_details cid ON c.id = cid.contacts_id AND c.contact_category_id = 2
-- left join professions p on cid.professions_id = p.id
-- left join countries n2 on cid.nationality = n2.id
-- left join countries idci on cid.id_country_id = idci.id
-- left join countries pci on cid.passport_country_id = pci.id
--     LEFT JOIN "public"."users" u_created_by ON c.created_by = u_created_by.id
--     LEFT JOIN "public"."users" u_updated_by ON c.updated_by = u_updated_by.id
--     LEFT JOIN LATERAL (
--         SELECT array_agg(al.language)::varchar[] AS languages
--         FROM unnest(c.all_languages_id) AS lang_id
--         JOIN "public"."all_languages" al ON lang_id = al.id
--     ) AS languages ON TRUE
--     LEFT JOIN LATERAL (
--         SELECT array_agg(au.username)::varchar[] AS assigned_usernames
--         FROM unnest(c.assigned_to) AS assigned_id
--         JOIN "public"."users" au ON assigned_id = au.id
--     ) AS assigned_usernames ON TRUE
--     LEFT JOIN LATERAL (
--         SELECT array_agg(su.username)::varchar[] AS shared_usernames
--         FROM unnest(c.shared_with) AS shared_id
--         JOIN "public"."users" su ON shared_id = su.id
--     ) AS shared_usernames ON TRUE WHERE c.status != 5 AND c.status != 6 AND c.id = $1;

-- -- name: GetSingleContactByMobile :one
-- select c.id, c.users_id, c.ref_no, c.contact_category_id, c.salutation, c.name, c.lastname, c.all_languages_id, c.ejari, c.assigned_to, c.shared_with, c.remarks, c.is_blockedlisted, c.is_vip, c.correspondence, c.direct_markerting, c.status, c.created_by, c.contact_platform, c.created_at, c.updated_at, c.updated_by,
--     scd.id, scd.contacts_id, scd.mobile, scd.mobile_share, scd.mobile2, scd.mobile2_share, scd.landline, scd.landline_share, scd.fax, scd.fax_share, scd.email, scd.email_share, scd.second_email, scd.second_email_share, scd.added_by, scd.created_at, scd.updated_at,
--      COALESCE(ra.id, 0) AS ra_id, COALESCE(ra.contacts_id, 0) AS ra_contacts_id, COALESCE(ra.address_type_id, 0) AS ra_address_type_id, COALESCE(ra.address1, '') AS ra_address1, COALESCE(ra.address2, '') AS ra_address2, COALESCE(ra.countries_id, 0) AS ra_countries_id, COALESCE(ra.states_id, 0) AS ra_states_id, COALESCE(ra.cities_id, 0) AS ra_cities_id, COALESCE(ra.community_id, 0) AS ra_community_id, COALESCE(ra.sub_community_id, 0) AS ra_sub_community_id, COALESCE(ra.postal_code, 0) AS ra_postal_code,
--     COALESCE(ca.id, 0) AS ca_id, COALESCE(ca.contacts_id, 0) AS ca_contacts_id, COALESCE(ca.address_type_id, 0) AS ca_address_type_id, COALESCE(ca.address1, '') AS ca_address1, COALESCE(ca.address2, '') AS ca_address2, COALESCE(ca.countries_id, 0) AS ca_countries_id, COALESCE(ca.states_id, 0) AS ca_states_id, COALESCE(ca.cities_id, 0) AS ca_cities_id, COALESCE(ca.community_id, 0) AS ca_community_id, COALESCE(ca.sub_community_id, 0) AS ca_sub_community_id, COALESCE(ca.postal_code, 0) AS ca_postal_code,ccd.id, ccd.contacts_id, ccd.companies_id, ccd.company_category, ccd.is_branch, ccd.no_of_employees, ccd.industry_id, ccd.no_local_business, ccd.retail_category_id, ccd.no_remote_business, ccd.nationality, ccd.license, ccd.issued_date, ccd.expiry_date, ccd.external_id,
--     cid.id, cid.contacts_id, cid.comapanies_id, cid.company_category, cid.is_branch, cid.date_of_birth, cid.professions_id, cid.gender, cid.marital_status, cid.nationality, cid.id_type, cid.id_number, cid.id_country_id, cid.id_issued_date, cid.id_expiry_date, cid.passport_number, cid.passport_country_id, cid.passport_issued_date, cid.passport_expiry_date, cid.interests,
--     cn1.country as resident_country,ci1.city as resident_city,
--     st1."state" as resident_state, com1.community as resident_community,
--     scom1.sub_community as resident_sub_community,
--     cn2.country as company_country,ci2.city as company_city,
--     st2."state" as company_state, com2.community as company_community,
--     scom2.sub_community as company_sub_community,
--     c.id AS contact_id,
--     c.created_by AS contact_created_by,
--     c.updated_by AS contact_updated_by,
--     u_created_by.username AS created_by_username,
--     u_updated_by.username AS updated_by_username,
--     c.all_languages_id AS contact_all_languages_id,
--     COALESCE(languages, '{}') AS languages,
--     c.assigned_to AS contact_assigned_to,
--     COALESCE(assigned_usernames, '{}') AS assigned_usernames,
--     c.shared_with AS contact_shared_with,
--     COALESCE(shared_usernames, '{}') AS shared_usernames,
--         i.title as company_industry,
--     n1.country as company_nationality,
--     rct.title as company_retail_cateogry,
--     p.title as individual_profession,
--     n2.country as individual_nationality,
--     idci.country as individual_country_id,
--     pci.country as individual_passport_country
-- FROM "public"."contacts" c
-- LEFT JOIN "public"."shareable_contact_details" scd ON c.id = scd.contacts_id
-- LEFT JOIN contacts_address ra ON c.id = ra.contacts_id AND ra.address_type_id = 1
-- left join countries cn1 on ra.countries_id = cn1.id
-- left join cities ci1 on ra.cities_id = ci1.id
-- left join states st1 on ra.states_id = st1.id
-- left join communities com1 on ra.community_id = com1.id
-- LEFT join sub_communities scom1 on ra.sub_community_id = scom1.id
-- LEFT JOIN contacts_address ca ON c.id = ca.contacts_id AND ca.address_type_id = 2
-- left join countries cn2 on ra.countries_id = cn2.id
-- left join cities ci2 on ra.cities_id = ci2.id
-- left join states st2 on ra.states_id = st2.id
-- left join communities com2 on ra.community_id = com2.id
-- LEFT join sub_communities scom2 on ra.sub_community_id = scom2.id
-- LEFT JOIN contacts_company_details ccd ON c.id = ccd.contacts_id AND c.contact_category_id = 1
-- left join industry i on ccd.industry_id = i.id
-- left join countries n1 on ccd.nationality = n1.id
-- left join retail_category rct on ccd.retail_category_id = rct.id
-- LEFT JOIN contacts_individual_details cid ON c.id = cid.contacts_id AND c.contact_category_id = 2
-- left join professions p on cid.professions_id = p.id
-- left join countries n2 on cid.nationality = n2.id
-- left join countries idci on cid.id_country_id = idci.id
-- left join countries pci on cid.passport_country_id = pci.id
--     LEFT JOIN "public"."users" u_created_by ON c.created_by = u_created_by.id
--     LEFT JOIN "public"."users" u_updated_by ON c.updated_by = u_updated_by.id
--     LEFT JOIN LATERAL (
--         SELECT array_agg(al.language)::varchar[] AS languages
--         FROM unnest(c.all_languages_id) AS lang_id
--         JOIN "public"."all_languages" al ON lang_id = al.id
--     ) AS languages ON TRUE
--     LEFT JOIN LATERAL (
--         SELECT array_agg(au.username)::varchar[] AS assigned_usernames
--         FROM unnest(c.assigned_to) AS assigned_id
--         JOIN "public"."users" au ON assigned_id = au.id
--     ) AS assigned_usernames ON TRUE
--     LEFT JOIN LATERAL (
--         SELECT array_agg(su.username)::varchar[] AS shared_usernames
--         FROM unnest(c.shared_with) AS shared_id
--         JOIN "public"."users" su ON shared_id = su.id
--     ) AS shared_usernames ON TRUE
-- WHERE c.status != 5 AND c.status != 6 AND scd.mobile = $1;
 

-- name: GetContactsDocumentByIdAndDocCategory :one
SELECT * FROM contacts_document WHERE id = $1 AND document_category_id = $2;

-- name: GetContactsDocumentById :one
SELECT * FROM contacts_document WHERE id = $1 LIMIT $1;




-- name: CreateContact :one
INSERT INTO contacts (
    ref_no,
    salutation,
    firstname,
    lastname,
    status,
    created_by,
    created_at,
    updated_at,
    updated_by,
    entity_id,
    entity_type_id
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11
) RETURNING *;

 
-- name: CreateContactsDocument :one
INSERT INTO contacts_document (
    contacts_id,
    document_category_id, 
    expiry_date,
    is_private,  
    document_url,
    created_at,
    description,
    updated_at,
    created_by,
    title
) VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    $10
) RETURNING *;

-- name: CreateContactsTransaction :one
INSERT INTO contacts_transaction (
    contacts_id,
    leads_id,
    contact_type,
    category,
    property_ref_no, 
    unit_ref_no,
    transaction_date
) VALUES (
    $1, $2, $3, $4, $5, $6, $7
)
RETURNING *;


-- name: GetContactsRefNo :many
select ref_no from  contacts;


-- name: GetAllContactsDocuments :many
SELECT * FROM public.contacts_document ORDER BY id LIMIT $1 OFFSET $2;


-- name: UpdateContactsDocument :one
UPDATE contacts_document
SET
    contacts_id = $2,
    document_category_id = $3,
    document_url = $4,
    is_private = $5
WHERE
    id = $1
RETURNING id, contacts_id, document_category_id, is_private, document_url;



-- name: GetContactsDocumentByContactsIdAndCategoryId :one
SELECT
    id,
    contacts_id,
    document_category_id,
    is_private,
    document_url
FROM
    contacts_document
WHERE
    contacts_id = $1
    AND document_category_id = $2;

    

-- name: GetSingleContactDocument :many
SELECT * FROM public.contacts_document WHERE id = $1 LIMIT $2;


-- name: GetAllContactsWithoutOffset :many
SELECT * FROM contacts WHERE status != 6
ORDER BY id;


-- name: GetAllContactsOtherContact :many
SELECT
    coc.id AS id,
    coc.contacts_id AS contact_id,
    -- c1.firstname AS contact_name,
    coc.other_contacts_id AS other_contact_id,
    -- c2.firstname AS other_contact_name,
    coc.date_added
FROM
    contacts_other_contact coc
JOIN
    contacts c1 ON coc.contacts_id = c1.id
JOIN
    contacts c2 ON coc.other_contacts_id = c2.id;



-- name: GetAllContactsOtherContactWithPagination :many
SELECT
    coc.id AS id,
    coc.contacts_id AS contact_id,
    -- c1.firstname AS contact_name,
    coc.other_contacts_id AS other_contact_id,
    -- c2.firstname AS other_contact_name,
    coc.date_added
FROM
    contacts_other_contact coc
JOIN
    contacts c1 ON coc.contacts_id = c1.id
JOIN
    contacts c2 ON coc.other_contacts_id = c2.id
    ORDER BY coc.id LIMIT $1 OFFSET $2;


-- name: GetAllSingleContactDocuments :many
SELECT
    cd.*,
    dc.title as document_category,
    dc.title_ar as document_category_ar,
    u.username as uploaded_by
FROM
    public.contacts c
JOIN
    public.contacts_document cd ON c.id = cd.contacts_id
JOIN
    public.document_categories dc ON cd.document_category_id = dc.id 
LEFT JOIN users u on cd.created_by = u.id   WHERE cd.contacts_id = $1  ORDER BY cd.id  LIMIT $2 OFFSET $3 ;

-- name: GetCountAllSingleContactDocuments :one
SELECT
    COUNT(*)
FROM
    contacts_document
WHERE contacts_id = $1;;


-- name: GetAllContactDocumentsCustom :many
SELECT
    cd.id AS document_id,
    c.updated_at AS updated_date,
    cd.document_url AS title,
    c.created_at AS entered_on,
    c.created_by AS entered_by
FROM
    public.contacts_document cd
JOIN
    public.contacts c ON cd.contacts_id = c.id
LIMIT $1
OFFSET $2;



-- name: GetAllDeveloperCompaniesWithoutPagination :many
SELECT * FROM developer_companies
WHERE status != 5 AND status != 6 ORDER BY id;

-- name: GetAllDeveloperCompaniesBranchesWithoutPagination :many
SELECT * FROM developer_company_branches
WHERE status != 5 AND status != 6 ORDER BY id;

-- name: GetAllServiceCompaniesWithoutPagination :many
SELECT * FROM services_companies
WHERE status != 5 AND status != 6 ORDER BY id;

-- name: GetAllServiceCompaniesBranchesWithoutPagination :many
SELECT * FROM service_company_branches
WHERE status != 5 AND status != 6 ORDER BY id;

-- name: GetAllBrokerCompaniesWithoutPagination :many
SELECT * FROM broker_companies
WHERE status != 5 AND status != 6 ORDER BY id;

-- name: GetAllBrokerCompaniesBranchesWithoutPagination :many
SELECT * FROM broker_companies_branches
WHERE status != 5 AND status != 6 ORDER BY id;


-- name: CreateContactShareableDetails :one
INSERT INTO shareable_contact_details (
    contacts_id,
    mobile,
    mobile_share,
    mobile2,
    mobile2_share,
    landline,
    landline_share,
    fax,
    fax_share,
    email,
    email_share,
    second_email,
    second_email_share,
    added_by,
    created_at,
    updated_at
) VALUES (
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
    $11,
    $12,
    $13,
    $14,
    $15,
    $16
) RETURNING id, contacts_id, mobile, mobile_share, mobile2, mobile2_share, landline, landline_share, fax, fax_share, email, email_share, second_email, second_email_share, added_by, created_at, updated_at;




-- name: CreateContactsOtherContact :one
INSERT INTO contacts_other_contact (
    contacts_id,
    other_contacts_id,
    date_added,
    relationship
) VALUES (
    $1, $2, $3, $4
)
RETURNING *;

-- name: GetAllContactsOtherContactByContactsId :many
SELECT c.*, coc.*, 
    u_created_by.username AS created_by_username,
    u_updated_by.username AS updated_by_username,
    COALESCE(languages, '{}') AS languages,
    COALESCE(assigned_usernames, '{}') AS assigned_usernames,
    COALESCE(shared_usernames, '{}') AS shared_usernames
FROM contacts_other_contact coc JOIN contacts c on c.id = coc.other_contacts_id    LEFT JOIN "public"."users" u_created_by ON c.created_by = u_created_by.id
    LEFT JOIN "public"."users" u_updated_by ON c.updated_by = u_updated_by.id
    LEFT JOIN LATERAL (
        SELECT array_agg(al.language)::varchar[] AS languages
        FROM unnest(c.all_languages_id) AS lang_id
        JOIN "public"."all_languages" al ON lang_id = al.id
    ) AS languages ON TRUE
    LEFT JOIN LATERAL (
        SELECT array_agg(au.username)::varchar[] AS assigned_usernames
        FROM unnest(c.assigned_to) AS assigned_id
        JOIN "public"."users" au ON assigned_id = au.id
    ) AS assigned_usernames ON TRUE
    LEFT JOIN LATERAL (
        SELECT array_agg(su.username)::varchar[] AS shared_usernames
        FROM unnest(c.shared_with) AS shared_id
        JOIN "public"."users" su ON shared_id = su.id
    ) AS shared_usernames ON TRUE
WHERE coc.contacts_id = $1 AND c.status != 5 AND c.status != 6 LIMIT $2 OFFSET $3;

-- name: GetCountAllContactsOtherContactByContactsId :one
SELECT COUNT(*) FROM contacts_other_contact JOIN contacts on contacts.id = contacts_other_contact.other_contacts_id
WHERE contacts_id = $1 AND contacts.status != 5 AND contacts.status != 6 ;

-- name: EditContactsOtherContact :exec
UPDATE contacts_other_contact
SET
    contacts_id = $2,
    other_contacts_id = $3,
    date_added = $4,
    relationship = $5
WHERE id = $1
RETURNING *;

-- name: GetAllContactsOtherContactByContactsIdWithoutPagination :many
SELECT * FROM contacts_other_contact
WHERE contacts_id = $1;




-- name: CreateContactsIndividualDetail :one
INSERT INTO contacts_individual_details (
    contacts_id,
    comapanies_id,
    company_category,
    is_branch,
    date_of_birth,
    professions_id,
    gender,
    marital_status,
    nationality,
    id_type,
    id_number,
    id_country_id,
    id_issued_date,
    id_expiry_date,
    passport_number,
    passport_country_id,
    passport_issued_date,
    passport_expiry_date,
    interests
) VALUES (
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
    $11,
    $12,
    $13,
    $14,
    $15,
    $16,
    $17,
    $18,
    $19
) RETURNING id, contacts_id, comapanies_id, company_category, is_branch, date_of_birth, professions_id, gender, marital_status, nationality, id_type, id_number, id_country_id, id_issued_date, id_expiry_date, passport_number, passport_country_id, passport_issued_date, passport_expiry_date, interests;

-- name: CreateContactsAddress :one
INSERT INTO contacts_address (
    contacts_id,
    address_type_id,
    address1,
    address2,
    countries_id,
    states_id,
    cities_id,
    community_id,
    sub_community_id,
    postal_code
) VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    $10
) RETURNING id, contacts_id, address_type_id, address1, address2, countries_id, states_id, cities_id, community_id, sub_community_id, postal_code;




-- name: GetAllCompanyName :many
SELECT
    "company_name",
    "id",
    'services_companies' AS category
FROM
    "public"."services_companies"
UNION
SELECT
    "company_name",
    "id",
    'service_company_branches' AS category
FROM
    "public"."service_company_branches"
UNION
SELECT
    "company_name",
    "id",
    'broker_companies_branches' AS category
FROM
    "public"."broker_companies_branches"
UNION
SELECT
    "company_name",
    "id",
    'broker_companies' AS category
FROM
    "public"."broker_companies"
UNION
SELECT
    "company_name",
    "id",
    'developer_company_branches' AS category
FROM
    "public"."developer_company_branches"
UNION
SELECT
    "company_name",
    "id",
    'developer_companies' AS category
FROM
    "public"."developer_companies";



-- name: GetAllProfessions :many
SELECT * FROM "public"."professions"
LIMIT $1
OFFSET $2;

-- name: GetAllProfessionsWithoutPagination :many
SELECT * FROM "public"."professions";

-- name: CreateProfession :one
INSERT INTO "public"."professions" (
    "title",
    "title_ar"
) VALUES (
    $1, $2
)
RETURNING *;




-- name: GetAllIndustry :many
SELECT * FROM "public"."industry"
LIMIT $1
OFFSET $2;

-- name: GetAllIndustryWithoutPagination :many
SELECT * FROM "public"."industry";

-- name: CreateIndustry :one
INSERT INTO "public"."industry" (
    "title",
    "title_ar"
) VALUES (
    $1, $2
)
RETURNING *;


-- name: GetAllContactsWithoutPagination :many
SELECT
    c.*,
    scd.mobile,
    scd.mobile_share,
    scd.mobile2,
    scd.mobile2_share,
    scd.landline,
    scd.landline_share,
    scd.fax,
    scd.fax_share,
    scd.email,
    scd.email_share,
    scd.second_email,
    scd.second_email_share
FROM "public"."contacts" c
LEFT JOIN "public"."shareable_contact_details" scd ON c.id = scd.contacts_id;




-- name: UpdateContacts :one
UPDATE contacts
SET ref_no = $2,
    salutation = $3,
    firstname = $4,
    lastname = $5,
    updated_at = $6,
    updated_by = $7
WHERE
    id = $1
RETURNING *;

-- name: UpdateShareableDetails :one
UPDATE shareable_contact_details
SET
    mobile = $2,
    mobile_share = $3,
    mobile2 = $4,
    mobile2_share = $5,
    landline = $6,
    landline_share = $7,
    fax = $8,
    fax_share = $9,
    email = $10,
    email_share = $11,
    second_email = $12,
    second_email_share = $13,
    updated_at = $14
WHERE contacts_id = $1
RETURNING *;



-- name: GetUserIdFromContactsId :one
SELECT
    u.id AS user_id
FROM
    contacts c
JOIN
    profiles p ON c.all_languages_id = p.id
JOIN
    users u ON p.id = u.profiles_id
WHERE
    c.id = $1;


-- name: UpdateContactsAddressByContactsId :exec
UPDATE contacts_address
SET
    address_type_id = $2,
    address1 = $3,
    address2 = $4,
    countries_id = $5,
    states_id = $6,
    cities_id = $7,
    postal_code = $8
WHERE
    contacts_id = $1;

-- name: UpdateContactStatus :one
UPDATE contacts
SET
    status = $2,
    updated_by = $3,
    updated_at = $4
WHERE
    id = $1
RETURNING *;

-- name: GetContactStatus :one
SELECT status
FROM contacts
WHERE id = $1;


-- name: UpdateContactsIndividualDetail :one
UPDATE contacts_individual_details
SET
    comapanies_id = $2,
    company_category = $3,
    is_branch = $4,
    date_of_birth = $5,
    professions_id = $6,
    gender = $7,
    marital_status = $8,
    nationality = $9,
    id_type = $10,
    id_number = $11,
    id_country_id = $12,
    id_issued_date = $13,
    id_expiry_date = $14,
    passport_number = $15,
    passport_country_id = $16,
    passport_issued_date = $17,
    passport_expiry_date = $18,
    interests = $19
WHERE
    contacts_id = $1
RETURNING id, contacts_id, comapanies_id, company_category, is_branch, date_of_birth, professions_id, gender, marital_status, nationality, id_type, id_number, id_country_id, id_issued_date, id_expiry_date, passport_number, passport_country_id, passport_issued_date, passport_expiry_date, interests;


-- name: UpdateContactsAddress :one
UPDATE contacts_address
SET
    address1 = $3,
    address2 = $4,
    countries_id = $5,
    states_id = $6,
    cities_id = $7,
    community_id = $8,
    sub_community_id = $9,
    postal_code = $10
WHERE
    contacts_id = $1
    AND address_type_id = $2
RETURNING *;


-- -- name: GetContactDetailsByUserId :one
-- SELECT
--     c.id AS contact_id,
--     c.users_id,
--     c.ref_no,
--     c.contact_category_id,
--     c.salutation,
--     c.name,
--     c.lastname,
--     c.all_languages_id,
--     c.ejari,
--     c.assigned_to,
--     c.shared_with,
--     c.remarks,
--     c.is_blockedlisted,
--     c.is_vip,
--     c.status,
--     c.created_by,
--     c.contact_platform,
--     c.created_at AS contact_created_at,
--     c.updated_at AS contact_updated_at,
--     c.updated_by AS contact_updated_by,
--     c.direct_markerting,
--     scd.id AS shareable_details_id,
--     scd.contacts_id,
--     scd.mobile,
--     scd.mobile_share,
--     scd.mobile2,
--     scd.mobile2_share,
--     scd.landline,
--     scd.landline_share,
--     scd.fax,
--     scd.fax_share,
--     scd.email,
--     scd.email_share,
--     scd.second_email,
--     scd.second_email_share,
--     scd.added_by AS shareable_added_by,
--     scd.created_at AS shareable_created_at,
--     scd.updated_at AS shareable_updated_at
-- FROM
--     contacts c
-- JOIN
--     shareable_contact_details scd ON c.id = scd.contacts_id
-- WHERE
--     c.users_id = $1 LIMIT 1;



-- -- name: GetContactDetailsByPhoneNumber :one
-- SELECT
--     c.id AS contact_id,
--     c.users_id,
--     c.ref_no,
--     c.contact_category_id,
--     c.salutation,
--     c.name,
--     c.lastname,
--     c.all_languages_id,
--     c.ejari,
--     c.assigned_to,
--     c.shared_with,
--     c.remarks,
--     c.is_blockedlisted,
--     c.is_vip,
--     c.status,
--     c.created_by,
--     c.contact_platform,
--     c.created_at AS contact_created_at,
--     c.updated_at AS contact_updated_at,
--     c.updated_by AS contact_updated_by,
--     c.direct_markerting,
--     scd.id AS shareable_details_id,
--     scd.contacts_id,
--     scd.mobile,
--     scd.mobile_share,
--     scd.mobile2,
--     scd.mobile2_share,
--     scd.landline,
--     scd.landline_share,
--     scd.fax,
--     scd.fax_share,
--     scd.email,
--     scd.email_share,
--     scd.second_email,
--     scd.second_email_share,
--     scd.added_by AS shareable_added_by,
--     scd.created_at AS shareable_created_at,
--     scd.updated_at AS shareable_updated_at
-- FROM
--     contacts c
-- JOIN
--     shareable_contact_details scd ON c.id = scd.contacts_id
-- WHERE
--     scd.mobile = $1 AND c.status != 6 LIMIT 1;

-- -- name: GetContactsIdFromUserId :one
-- SELECT
--     c.id AS contacts_id
-- FROM
--     contacts c
-- WHERE
--     c.users_id = $1;

-- -- name: GetSingleContactDetails :one
-- SELECT
--     c.id AS contact_id,
--     c.users_id,
--     c.ref_no,
--     c.contact_category_id,
--     c.salutation,
--     c.name,
--     c.lastname,
--     c.all_languages_id,
--     c.ejari,
--     c.assigned_to,
--     c.shared_with,
--     c.remarks,
--     c.is_blockedlisted,
--     c.is_vip,
--     c.status,
--     c.created_by,
--     c.contact_platform,
--     c.created_at AS contact_created_at,
--     c.updated_at AS contact_updated_at,
--     c.updated_by AS contact_updated_by,
--     scd.id AS shareable_details_id,
--     scd.mobile,
--     scd.mobile_share,
--     scd.mobile2,
--     scd.mobile2_share,
--     scd.landline,
--     scd.landline_share,
--     scd.fax,
--     scd.fax_share,
--     scd.email,
--     scd.email_share,
--     scd.second_email,
--     scd.second_email_share,
--     scd.added_by AS shareable_added_by,
--     scd.created_at AS shareable_created_at,
--     scd.updated_at AS shareable_updated_at
-- FROM
--     contacts c
-- JOIN
--     shareable_contact_details scd ON c.id = scd.contacts_id
-- WHERE
--     c.id = $1;

-- -- name: GetContactNamesByIdsExcludingStatus6 :many
-- SELECT
--     id AS contact_id,
--     name,
--     lastname
-- FROM
--     contacts
-- WHERE
--     id IN ($1)
--     AND status != 6;

-- -- name: GetSingleContactNameById :one
-- SELECT
--     id AS contact_id,
--     name,
--     lastname
-- FROM
--     contacts
-- WHERE
--     id = $1;

-- name: GetCountContactsOtherContactCountByContactsId :one
SELECT COUNT(*)
FROM contacts_other_contact
WHERE contacts_id = $1;

-- -- name: GetSingleContactNamesByIdExcludingStatus6 :one
-- SELECT
--     id AS contact_id,
--     name,
--     lastname
-- FROM
--     contacts
-- WHERE
--     id = $1
--     AND status != 6;

-- -- name: GetListOfContactNamesByIdsExcludingStatus6 :many
-- SELECT
--     id AS contact_id,
--     name,
--     lastname
-- FROM
--     contacts
-- WHERE
--     id = ANY($1::bigint[])
--     AND status != 6;

-- name: UpdateSingleContactsOtherContact :one
UPDATE contacts_other_contact SET other_contacts_id = $2, relationship = $3
WHERE id = $1 RETURNING *;

-- name: DeleteSingleContactsOtherContact :exec
DELETE FROM contacts_other_contact WHERE id = $1;

-- -- name: UpdateContactsAddressCD :exec
-- UPDATE contacts_address
-- SET
--     correspondence = $3,
--     direct_markerting = $4
-- WHERE
--     contacts_id = $1
--     AND address_type_id = $2
-- RETURNING *;

-- name: UpdateContactsDocumentPrivacy :one
UPDATE contacts_document
SET
    is_private = $2
WHERE
    id = $1
RETURNING id, contacts_id, document_category_id, is_private, document_url;

-- -- name: GetSingleContactByUserId :one
-- select * from contacts where users_id = $1;

-- -- name: GetSingleContactDetailsByPhoneNumber :one
-- SELECT
--     c.id AS contact_id,
--     c.users_id,
--     c.ref_no,
--     c.contact_category_id,
--     c.salutation,
--     c.name,
--     c.lastname,
--     c.all_languages_id,
--     c.ejari,
--     c.assigned_to,
--     c.shared_with,
--     c.remarks,
--     c.is_blockedlisted,
--     c.is_vip,
--     c.status,
--     c.created_by,
--     c.contact_platform,
--     c.created_at AS contact_created_at,
--     c.updated_at AS contact_updated_at,
--     c.updated_by AS contact_updated_by,
--     scd.id AS shareable_details_id,
--     scd.mobile,
--     scd.mobile_share,
--     scd.mobile2,
--     scd.mobile2_share,
--     scd.landline,
--     scd.landline_share,
--     scd.fax,
--     scd.fax_share,
--     scd.email,
--     scd.email_share,
--     scd.second_email,
--     scd.second_email_share,
--     scd.added_by AS shareable_added_by,
--     scd.created_at AS shareable_created_at,
--     scd.updated_at AS shareable_updated_at
-- FROM
--     contacts c
-- JOIN
--     shareable_contact_details scd ON c.id = scd.contacts_id
-- WHERE
--     scd.mobile = $1 LIMIT 1;

-- name: GetCountAllContacts :one
SELECT COUNT(*) FROM contacts WHERE status != 5 AND status != 6;


-- -- name: GetAllContacts :many
-- select c.id, c.users_id, c.ref_no, c.contact_category_id, c.salutation, c.name, c.lastname, c.all_languages_id, c.ejari, c.assigned_to, c.shared_with, c.remarks, c.is_blockedlisted, c.is_vip, c.correspondence, c.direct_markerting, c.status, c.created_by, c.contact_platform, c.created_at, c.updated_at, c.updated_by,
--     scd.id, scd.contacts_id, scd.mobile, scd.mobile_share, scd.mobile2, scd.mobile2_share, scd.landline, scd.landline_share, scd.fax, scd.fax_share, scd.email, scd.email_share, scd.second_email, scd.second_email_share, scd.added_by, scd.created_at, scd.updated_at,
--      COALESCE(ra.id, 0) AS ra_id, COALESCE(ra.contacts_id, 0) AS ra_contacts_id, COALESCE(ra.address_type_id, 0) AS ra_address_type_id, COALESCE(ra.address1, '') AS ra_address1, COALESCE(ra.address2, '') AS ra_address2, COALESCE(ra.countries_id, 0) AS ra_countries_id, COALESCE(ra.states_id, 0) AS ra_states_id, COALESCE(ra.cities_id, 0) AS ra_cities_id, COALESCE(ra.community_id, 0) AS ra_community_id, COALESCE(ra.sub_community_id, 0) AS ra_sub_community_id, COALESCE(ra.postal_code, 0) AS ra_postal_code,
--     COALESCE(ca.id, 0) AS ca_id, COALESCE(ca.contacts_id, 0) AS ca_contacts_id, COALESCE(ca.address_type_id, 0) AS ca_address_type_id, COALESCE(ca.address1, '') AS ca_address1, COALESCE(ca.address2, '') AS ca_address2, COALESCE(ca.countries_id, 0) AS ca_countries_id, COALESCE(ca.states_id, 0) AS ca_states_id, COALESCE(ca.cities_id, 0) AS ca_cities_id, COALESCE(ca.community_id, 0) AS ca_community_id, COALESCE(ca.sub_community_id, 0) AS ca_sub_community_id, COALESCE(ca.postal_code, 0) AS ca_postal_code,ccd.id, ccd.contacts_id, ccd.companies_id, ccd.company_category, ccd.is_branch, ccd.no_of_employees, ccd.industry_id, ccd.no_local_business, ccd.retail_category_id, ccd.no_remote_business, ccd.nationality, ccd.license, ccd.issued_date, ccd.expiry_date, ccd.external_id,
--     cid.id, cid.contacts_id, cid.comapanies_id, cid.company_category, cid.is_branch, cid.date_of_birth, cid.professions_id, cid.gender, cid.marital_status, cid.nationality, cid.id_type, cid.id_number, cid.id_country_id, cid.id_issued_date, cid.id_expiry_date, cid.passport_number, cid.passport_country_id, cid.passport_issued_date, cid.passport_expiry_date, cid.interests,
--     cn1.country as resident_country,ci1.city as resident_city,
--     st1."state" as resident_state, com1.community as resident_community,
--     scom1.sub_community as resident_sub_community,
--     cn2.country as company_country,ci2.city as company_city,
--     st2."state" as company_state, com2.community as company_community,
--     scom2.sub_community as company_sub_community,
--     c.id AS contact_id,
--     c.created_by AS contact_created_by,
--     c.updated_by AS contact_updated_by,
--     u_created_by.username AS created_by_username,
--     u_updated_by.username AS updated_by_username,
--     c.all_languages_id AS contact_all_languages_id,
--     COALESCE(languages, '{}') AS languages,
--     c.assigned_to AS contact_assigned_to,
--     COALESCE(assigned_usernames, '{}') AS assigned_usernames,
--     c.shared_with AS contact_shared_with,
--     COALESCE(shared_usernames, '{}') AS shared_usernames,
--         i.title as company_industry,
--     n1.country as company_nationality,
--     rct.title as company_retail_cateogry,
--     p.title as individual_profession,
--     n2.country as individual_nationality,
--     idci.country as individual_country_id,
--     pci.country as individual_passport_country
-- FROM "public"."contacts" c
-- LEFT JOIN "public"."shareable_contact_details" scd ON c.id = scd.contacts_id
-- LEFT JOIN contacts_address ra ON c.id = ra.contacts_id AND ra.address_type_id = 1
-- left join countries cn1 on ra.countries_id = cn1.id
-- left join cities ci1 on ra.cities_id = ci1.id
-- left join states st1 on ra.states_id = st1.id
-- left join communities com1 on ra.community_id = com1.id
-- LEFT join sub_communities scom1 on ra.sub_community_id = scom1.id
-- LEFT JOIN contacts_address ca ON c.id = ca.contacts_id AND ca.address_type_id = 2
-- left join countries cn2 on ra.countries_id = cn2.id
-- left join cities ci2 on ra.cities_id = ci2.id
-- left join states st2 on ra.states_id = st2.id
-- left join communities com2 on ra.community_id = com2.id
-- LEFT join sub_communities scom2 on ra.sub_community_id = scom2.id
-- LEFT JOIN contacts_company_details ccd ON c.id = ccd.contacts_id AND c.contact_category_id = 1
-- left join industry i on ccd.industry_id = i.id
-- left join countries n1 on ccd.nationality = n1.id
-- left join retail_category rct on ccd.retail_category_id = rct.id
-- LEFT JOIN contacts_individual_details cid ON c.id = cid.contacts_id AND c.contact_category_id = 2
-- left join professions p on cid.professions_id = p.id
-- left join countries n2 on cid.nationality = n2.id
-- left join countries idci on cid.id_country_id = idci.id
-- left join countries pci on cid.passport_country_id = pci.id
--     LEFT JOIN "public"."users" u_created_by ON c.created_by = u_created_by.id
--     LEFT JOIN "public"."users" u_updated_by ON c.updated_by = u_updated_by.id
--     LEFT JOIN LATERAL (
--         SELECT array_agg(al.language)::varchar[] AS languages
--         FROM unnest(c.all_languages_id) AS lang_id
--         JOIN "public"."all_languages" al ON lang_id = al.id
--     ) AS languages ON TRUE
--     LEFT JOIN LATERAL (
--         SELECT array_agg(au.username)::varchar[] AS assigned_usernames
--         FROM unnest(c.assigned_to) AS assigned_id
--         JOIN "public"."users" au ON assigned_id = au.id
--     ) AS assigned_usernames ON TRUE
--     LEFT JOIN LATERAL (
--         SELECT array_agg(su.username)::varchar[] AS shared_usernames
--         FROM unnest(c.shared_with) AS shared_id
--         JOIN "public"."users" su ON shared_id = su.id
--     ) AS shared_usernames ON TRUE
-- WHERE c.status != 5 AND c.status != 6 
-- ORDER BY c.updated_at DESC LIMIT $1 OFFSET $2;


-- name: GetAllActiveContactsByCompanyId :many
SELECT id,TRIM(CONCAT(firstname,' ',lastname)) AS full_name
FROM contacts
WHERE status = 2 AND (@entity_id::BIGINT = 0 OR (entity_id = @entity_id::BIGINT AND entity_type_id = $1));

-- name: GetActiveContactById :one
SELECT * FROM contacts WHERE status = 2 AND id = $1;