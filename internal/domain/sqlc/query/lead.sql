-- name: CreateLeadDetails :one
INSERT INTO leads (
    ref_no,
    contacts_id,
    lead_type,
    contact_type,
    languages,
    property_category,
    is_property,
    property_unit_id,
    unit_category,
    property_type_id,
    property_statuses_id,
    purpose_id,
    min_budget,
    max_budget,
    min_area,
    max_area,
    bedroom,
    bathroom,
    countries_id,
    states_id,
    cities_id,
    community_id,
    subcommunity_id,
    lat,
    lng,
    is_luxury,
    mortgage_status,
    created_at
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28
)
RETURNING *;

-- name: UpdateLeadInternalNotes :one
UPDATE leads
SET internal_notes = $2
WHERE id = $1
RETURNING *;

-- name: UpdateLeadReferenceDetails :one
UPDATE leads
SET
    lead_source = $2,
    media_name = $3,
    is_exclusive = $4,
    assigned_to = $5,
    residential_status = $6,
    referred_to = $7,
    priority_level = $8,
    is_finance = $9,
    mortgage_status = $10,
    required_start = $11,
    required_end = $12,
    closing_remarks = $13,
    mortgage_bank_id = $14
WHERE
    id = $1
RETURNING *;


-- name: UpdateLeadDetails :one
UPDATE leads
SET
    lead_type = $2,
    contact_type = $3,
    languages = $4,
    property_category = $5,
    is_property = $6,
    property_unit_id = $7,
    unit_category = $8,
    property_type_id = $9,
    property_statuses_id = $10,
    purpose_id = $11,
    min_budget = $12,
    max_budget = $13,
    min_area = $14,
    max_area = $15,
    bedroom = $16,
    bathroom = $17,
    countries_id = $18,
    states_id = $19,
    cities_id = $20,
    community_id = $21,
    subcommunity_id = $22,
    lat = $23,
    lng = $24,
    is_luxury = $25,
    mortgage_status = $26
WHERE
    id = $1
RETURNING *;

-- name: GetLeadById :one
SELECT l.*, c.country, ci.city, s."state",  COALESCE(communities_names, '{}') AS communities_names, 
COALESCE(sub_communities_names, '{}') AS sub_communities_names
FROM leads l
left join countries c on l.countries_id = c.id
left join cities ci on l.cities_id = ci.id
left join states s on l.states_id = s.id
    LEFT JOIN LATERAL (
        SELECT array_agg(com.community)::varchar[] AS communities_names
        FROM unnest(l.community_id) AS community_id
        JOIN communities com ON community_id = com.id
    ) AS communities_names ON TRUE
    LEFT JOIN LATERAL (
        SELECT array_agg(scom.sub_community)::varchar[] AS sub_communities_names
        FROM unnest(l.subcommunity_id) AS sub_community_id
        JOIN sub_communities scom ON sub_community_id = scom.id
    ) AS sub_communities_names ON TRUE
WHERE l.id = $1;

-- name: GetLeadsByContactIdWithPagination :many
SELECT *
FROM leads
WHERE contacts_id = $1
ORDER BY id
OFFSET $2
LIMIT $3;
 
-- name: GetCountLeadsByContactId :one
SELECT count(*)
FROM leads
WHERE contacts_id = $1;

-- name: GetLeadsBySources :many
SELECT l.id, l.ref_no, l.created_at, l.internal_notes,
CASE WHEN lp.lead_status = 1 THEN 'Open' WHEN lp.lead_status = 2 THEN 'Close' ELSE null END AS "status",
CASE WHEN lp.progress_status = 1 THEN 'In Progress' WHEN lp.lead_status = 2 THEN 'Not yet connected'
WHEN lp.lead_status = 3 THEN 'Called but no reply' WHEN lp.lead_status = 4 THEN 'Follow-up'
WHEN lp.lead_status = 2 THEN 'Awaiting Finance Approval' WHEN lp.lead_status = 2 THEN 'Change Travel Plans'
ELSE null END AS "progress status",
  CASE WHEN l.lead_source = 1 THEN (SELECT COUNT(*) FROM leads_properties WHERE leads_properties.leads_id = l.id) ELSE NULL END AS "count",
  CASE WHEN l.lead_source != 1 THEN ' - ' ELSE NULL END AS "message",
  CASE WHEN l.lead_source = 3 THEN ' - ' ELSE NULL END AS "inquiry"
FROM leads l
LEFT JOIN leads_progress lp ON l.id = lp.leads_id WHERE l.lead_source = $1 LIMIT $2 OFFSET $3;

-- name: GetCountLeadsBySources :one
SELECT count(*)
FROM leads
WHERE lead_source = $1;

-- name: GetSingleLead :one
SELECT * FROM leads WHERE id = $1 LIMIT 1;

-- -- name: GetLeadsByContactIdWithoutPagination :many
-- SELECT
-- 	lead.id,
--     lead.ref_no AS ref_no,
--     lead.lead_type AS lead_type,
--     lead.is_property,
--     lead.property_type_id,
--     lead.unit_category,
--     contact.name AS contact_name,
--     scd.mobile AS contact_mobile,
--     scd.email AS contact_email,
--     lp.lead_status AS lead_status,
--     lp.progress_status AS progress_status
-- FROM
--     leads AS lead 
-- INNER JOIN
--     contacts AS contact ON lead.contacts_id = contact.id
-- INNER JOIN
--     shareable_contact_details AS scd ON contact.id = scd.contacts_id
-- LEFT JOIN
--     leads_progress AS lp ON lead.id = lp.leads_id WHERE lead.contacts_id = $1 ORDER BY lp.id desc;

-- name: UpdateLead :one
UPDATE leads
SET lead_source = $2,
    media_name = $3,
    lead_type = $4,
    contact_type = $5,
    property_category = $6,
    is_property = $7,
    unit_category = $8,
    property_type_id = $9,
    is_luxury = $10,
    property_unit_id = $11,
    property_statuses_id = $12,
    purpose_id = $13,
    min_budget = $14,
    max_budget = $15,
    min_area = $16,
    max_area = $17,
    bedroom = $18,
    bathroom = $19,
    countries_id = $20,
    states_id = $21,
    cities_id = $22,
    community_id = $23,
    subcommunity_id = $24,
    lat = $25,
    lng = $26,
    assigned_to = $27,
    residential_status = $28,
    referred_to = $29,
    is_exclusive = $30,
    priority_level = $31,
    is_finance = $32,
    mortgage_bank_id = $33,
    mortgage_status = $34,
    required_start = $35,
    required_end = $36,
    closing_remarks = $37,
    internal_notes = $38,
    with_reference = $39,
    is_property_branch = $40,
    property_reference_name = $41,
    social_media_name = $42,
    section_type = $43
WHERE id = $1
RETURNING *;

-- name: CreateLead :one
INSERT INTO leads (ref_no, contacts_id, lead_source, media_name, lead_type, contact_type, languages, property_category, is_property,
 unit_category, property_type_id, is_luxury, property_unit_id, property_statuses_id, purpose_id, min_budget, max_budget, min_area, max_area,
  bedroom, bathroom, countries_id, states_id, cities_id, community_id, subcommunity_id, lat, lng, assigned_to, residential_status, referred_to,
   is_exclusive, priority_level, is_finance, mortgage_bank_id, mortgage_status, required_start, required_end, closing_remarks, internal_notes,
    created_at, leads_won, with_reference, is_property_branch, property_reference_name, social_media_name, section_type)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, 
$21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $40, 
$41, $42, $43, $44, $45, $46, $47) RETURNING *;

-- name: GetLeadDetailsById :one
SELECT 
    l.*,
    lp.progress_date,
    lp.progress_status,
    lp.lead_status,
    ln.agent_sms,
    ln.agent_mail,
    ln.agent_whatsapp,
    ln.agent_system_notofication,
    ln.lead_sms,
    ln.lead_mail,
    ln.lead_whatsapp,
    ln.lead_system_notification,
    ln.follow_up_email,
    ln.closed_lost_email,
    ln.closed_lost_sms,
    ln.closed_lost_whatsapp,
    ln.closed_won_email,
    ln.closed_won_sms,
    ln.closed_won_whatsapp
FROM 
    leads l
LEFT JOIN 
    leads_progress lp ON l.id = lp.leads_id
LEFT JOIN 
    leads_notification ln ON l.id = ln.leads_id
WHERE 
    l.id = $1 LIMIT 1;

-- name: GetAllLeadDetailsByContactId :many
SELECT 
    l.*,
    lp.progress_date,
    lp.progress_status,
    lp.lead_status,
    ln.agent_sms,
    ln.agent_mail,
    ln.agent_whatsapp,
    ln.agent_system_notofication,
    ln.lead_sms,
    ln.lead_mail,
    ln.lead_whatsapp,
    ln.lead_system_notification,
    ln.follow_up_email,
    ln.closed_lost_email,
    ln.closed_lost_sms,
    ln.closed_lost_whatsapp,
    ln.closed_won_email,
    ln.closed_won_sms,
    ln.closed_won_whatsapp
FROM 
    leads l
LEFT JOIN 
    leads_progress lp ON l.id = lp.leads_id
LEFT JOIN 
    leads_notification ln ON l.id = ln.leads_id
WHERE l.contacts_id = $1 LIMIT $2 OFFSET $3;

-- name: GetCountAllLeadsByContactId :one
SELECT COUNT(*) FROM leads WHERE contacts_id = $1;

-- name: GetAllLeads :many
SELECT 
    l.*,
    lp.progress_date,
    lp.progress_status,
    lp.lead_status,
    ln.agent_sms,
    ln.agent_mail,
    ln.agent_whatsapp,
    ln.agent_system_notofication,
    ln.lead_sms,
    ln.lead_mail,
    ln.lead_whatsapp,
    ln.lead_system_notification,
    ln.follow_up_email,
    ln.closed_lost_email,
    ln.closed_lost_sms,
    ln.closed_lost_whatsapp,
    ln.closed_won_email,
    ln.closed_won_sms,
    ln.closed_won_whatsapp
FROM 
    leads l
LEFT JOIN 
    leads_progress lp ON l.id = lp.leads_id
LEFT JOIN 
    leads_notification ln ON l.id = ln.leads_id
LIMIT $1 OFFSET $2;

-- name: GetCountAllLeads :many
SELECT COUNT(*) FROM leads;

-- -- name: GetLeadsForManage :many
-- SELECT
-- 	lead.id,
--     lead.ref_no AS ref_no,
--     lead.lead_type AS lead_type,
--     lead.is_property,
--     lead.property_type_id,
--     lead.unit_category,
--     lead.section_type,
--     contact.name AS contact_name,
--     scd.mobile AS contact_mobile,
--     scd.email AS contact_email,
--     lp.lead_status AS lead_status,
--     lp.progress_status AS progress_status
-- FROM
--     leads AS lead
-- INNER JOIN
--     contacts AS contact ON lead.contacts_id = contact.id
-- INNER JOIN
--     shareable_contact_details AS scd ON contact.id = scd.contacts_id
-- LEFT JOIN
--     leads_progress AS lp ON lead.id = lp.leads_id ORDER BY lp.id desc LIMIT $1 OFFSET $2;

-- name: GetCountLeadsForManage :one
SELECT
COUNT(*)
FROM
    leads AS lead
INNER JOIN
    contacts AS contact ON lead.contacts_id = contact.id
INNER JOIN
    shareable_contact_details AS scd ON contact.id = scd.contacts_id
LEFT JOIN
    leads_progress AS lp ON lead.id = lp.leads_id;

-- name: GetLeadsBySourcesFilter :many
-- SELECT l.id, l.ref_no, l.created_at, l.internal_notes,
-- CASE WHEN lp.lead_status = 1 THEN 'Open' WHEN lp.lead_status = 2 THEN 'Close' ELSE null END AS "status",
-- CASE WHEN lp.progress_status = 1 THEN 'In Progress' WHEN lp.lead_status = 2 THEN 'Not yet connected'
-- WHEN lp.lead_status = 3 THEN 'Called but no reply' WHEN lp.lead_status = 4 THEN 'Follow-up'
-- WHEN lp.lead_status = 2 THEN 'Awaiting Finance Approval' WHEN lp.lead_status = 2 THEN 'Change Travel Plans'
-- ELSE null END AS "progress status",
--   CASE WHEN l.lead_source = 1 THEN (SELECT COUNT(*) FROM leads_properties WHERE leads_properties.leads_id = l.id) ELSE NULL END AS "count",
--   CASE WHEN l.lead_source != 1 THEN ' - ' ELSE NULL END AS "message",
--   CASE WHEN l.lead_source = 3 THEN ' - ' ELSE NULL END AS "inquiry"
-- FROM leads l
-- LEFT JOIN leads_progress lp ON l.id = lp.leads_id WHERE l.lead_source = $1 AND l.required_start >= $2 AND l.required_end <= $3 AND l.assigned_to = $4 AND l.contacts_id IN (SELECT cu.users_id FROM company_users cu JOIN contacts c ON cu.users_id = c.users_id WHERE cu.company_id = $5 AND cu.company_type = $6 AND cu.is_branch = $7) AND l.lead_type = $8 LIMIT $9 OFFSET $10
-- ; 

-- name: GetCountLeadsBySourcesFilter :one
-- SELECT count(*)
-- FROM leads
-- WHERE lead_source = $1 AND required_start >= $2 AND required_end <= $3 AND leads.assigned_to = $4 AND contacts_id IN (SELECT cu.users_id FROM company_users cu JOIN contacts c ON cu.users_id = c.users_id WHERE cu.company_id = $5
-- --  AND cu.company_type = $6 AND cu.is_branch = $7
--  ) AND lead_type = $8 ;

-- name: GetLeadsByCityAndLeadType :many
SELECT city,
  SUM(CASE WHEN lead_type = 1 THEN cnt ELSE 0 END) AS sale,
  SUM(CASE WHEN lead_type = 2 THEN cnt ELSE 0 END) AS rent,
  SUM(CASE WHEN lead_type = 3 THEN cnt ELSE 0 END) AS exchange
FROM (
  SELECT c.city, l.lead_type, COUNT(*) AS cnt
  FROM leads l JOIN cities c on l.cities_id = c.id
  GROUP BY c.city, l.lead_type
) AS grouped_data
GROUP BY city;

-- name: GetLeadsByCityAndLeadTypeFilter :many
SELECT city,
  SUM(CASE WHEN lead_type = 1 THEN cnt ELSE 0 END) AS sale,
  SUM(CASE WHEN lead_type = 2 THEN cnt ELSE 0 END) AS rent,
  SUM(CASE WHEN lead_type = 3 THEN cnt ELSE 0 END) AS exchange
FROM (
  SELECT c.city, l.lead_type, COUNT(*) AS cnt
  FROM leads l JOIN cities c on l.cities_id = c.id
  WHERE required_start >= $1 AND required_end <= $2 AND l.assigned_to = $3 AND contacts_id IN (SELECT cu.users_id FROM company_users cu JOIN contacts c ON cu.users_id = c.users_id WHERE cu.company_id = $4 
--   AND
--    cu.company_type = $5
--     AND cu.is_branch = $6
    ) GROUP BY c.city, l.lead_type
) AS grouped_data
GROUP BY city;

-- name: GetLeadStatisticsByLeadType :many
SELECT lead_type, COUNT(*) FROM leads GROUP BY lead_type ORDER BY lead_type;

-- -- name: GetLeadsForContact :many
-- SELECT
-- 	lead.id,
--     lead.ref_no AS ref_no,
--     lead.lead_type AS lead_type,
--     lead.is_property,
--     lead.property_type_id,
--     lead.unit_category,
--     contact.name AS contact_name,
--     scd.mobile AS contact_mobile,
--     scd.email AS contact_email,
--     lp.lead_status AS lead_status,
--     lp.progress_status AS progress_status
-- FROM
--     leads AS lead 
-- INNER JOIN
--     contacts AS contact ON lead.contacts_id = contact.id
-- INNER JOIN
--     shareable_contact_details AS scd ON contact.id = scd.contacts_id
-- LEFT JOIN
--     leads_progress AS lp ON lead.id = lp.leads_id WHERE lead.contacts_id = $1 ORDER BY lp.id desc LIMIT $2 OFFSET $3;

-- name: GetCountLeadsForContacts :one
SELECT
COUNT(*)
FROM
    leads AS lead
INNER JOIN
    contacts AS contact ON lead.contacts_id = contact.id
INNER JOIN
    shareable_contact_details AS scd ON contact.id = scd.contacts_id
LEFT JOIN
    leads_progress AS lp ON lead.id = lp.leads_id Where lead.contacts_id = $1;

-- name: GetLeadsIdAndRefNo :many
SELECT id, ref_no FROM leads WHERE contacts_id = $1;

-- name: GetSectionTypes :many
SELECT id, type FROM property_types WHERE id = ANY($1::bigint[]);

-- name: GetLeadByRefNo :one
SELECT * FROM leads WHERE ref_no = $1 and contacts_id = $2 LIMIT 1;