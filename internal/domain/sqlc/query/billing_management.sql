-- name: GetAllSubsribersByStatus :many
WITH x AS (
    SELECT 
        DISTINCT companies.id,
        companies.logo_url,
        companies.company_name AS subscriber_name,
        companies.status,
        1::bigint AS subscriber_type,
        subscription_order.order_no,
        subscription_order.contract_file,
        subscription_order.draft_contract
    FROM companies
    LEFT JOIN subscription_order 
        ON subscription_order.subscriber_id = companies.id 
        AND subscription_order.subscriber_type = 1
        AND subscription_order.status = 1 -- only draft subscription_order
    WHERE companies.status = @status::bigint
      AND (1 = @status::bigint OR subscription_order.id IS NOT NULL) -- handle pending legally or pending financially logic

    UNION ALL

    SELECT 
        DISTINCT users.id,
        '' AS logo_url,
        CONCAT(profiles.first_name, ' ', profiles.last_name) AS subscriber_name,
        users.status,
      CASE WHEN users.user_types_id = 3 THEN 3 ELSE 2 END::bigint AS subscriber_type,
        subscription_order.order_no,
        subscription_order.contract_file,
        subscription_order.draft_contract
    FROM users
    INNER JOIN profiles 
        ON profiles.users_id = users.id
    LEFT JOIN subscription_order 
        ON subscription_order.subscriber_id = users.id 
        AND subscription_order.subscriber_type IN (2,3)
        AND subscription_order.status = 1  -- only draft subscription_order
    WHERE users.status = @status::bigint
      AND (1 = @status::bigint OR subscription_order.id IS NOT NULL) -- handle pending legally or pending financially logic
      AND users.user_types_id IN (3,4) -- only freelancer & owner user type
)SELECT * FROM x
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');


-- name: GetCountAllSubsribersByStatus :one
WITH x AS (
    SELECT 
        DISTINCT companies.id,
        companies.logo_url,
        companies.company_name AS subscriber_name,
        companies.status,
        1::bigint AS subscriber_type,
        subscription_order.order_no,
        subscription_order.contract_file,
        subscription_order.draft_contract
    FROM companies
    LEFT JOIN subscription_order 
        ON subscription_order.subscriber_id = companies.id 
        AND subscription_order.subscriber_type = 1  -- only company subscriber type
        AND subscription_order.status = 1 -- only draft subscription_order
    WHERE companies.status = @status::bigint
      AND (1 = @status::bigint OR subscription_order.id IS NOT NULL) -- handle pending legally or pending financially logic

    UNION ALL

    SELECT 
        DISTINCT users.id,
        '' AS logo_url,
        CONCAT(profiles.first_name, ' ', profiles.last_name) AS subscriber_name,
        users.status,
      CASE WHEN users.user_types_id = 3 THEN 3 ELSE 2 END::bigint AS subscriber_type,
        subscription_order.order_no,
        subscription_order.contract_file,
        subscription_order.draft_contract
    FROM users
    INNER JOIN profiles 
        ON profiles.users_id = users.id
    LEFT JOIN subscription_order 
        ON subscription_order.subscriber_id = users.id 
        AND subscription_order.subscriber_type IN (2,3) -- only freelancer & owner subscriber type
        AND subscription_order.status = 1  -- only draft subscription_order
    WHERE users.status = @status::bigint
      AND (1 = @status::bigint OR subscription_order.id IS NOT NULL) -- handle pending legally or pending financially logic
      AND users.user_types_id IN (3,4) -- only freelancer & owner user type
)SELECT COUNT(*) FROM x;


-- name: GetAllSubscriberDocuments :many
WITH x AS (
    -- Company License Documents
    SELECT 
        license.id,
        license.license_type_id,
        license.license_no,
        license.license_issue_date,
        license.license_expiry_date,
        license.license_registration_date,
        license.license_file_url,
        CONCAT(
            license.metadata ->> 'original_file_name',
            license.metadata ->> 'original_file_extension'
        )::text AS original_file_name,
        1::bigint AS subscriber_type
    FROM license
    WHERE license.entity_id = @subscriber_id::bigint 
      AND license.entity_type_id = 6 -- Company
      AND 1 = @subscriber_type::bigint

    UNION ALL

    -- User License Document (if exists)
    SELECT 
        license.id,
        license.license_type_id,
        license.license_no,
        license.license_issue_date,
        license.license_expiry_date,
        license.license_registration_date,
        license.license_file_url,
        CONCAT(
            license.metadata ->> 'original_file_name',
            license.metadata ->> 'original_file_extension'
        )::text AS original_file_name,
        CASE 
            WHEN users.user_types_id = 3 THEN 3 
            ELSE 2 
        END::bigint AS subscriber_type
    FROM users
    INNER JOIN profiles ON profiles.users_id = users.id
    INNER JOIN license 
        ON license.entity_id = users.id 
        AND license.entity_type_id = 9 -- User License
    WHERE users.user_types_id IN (3, 4)
      AND users.id = @subscriber_id::bigint
      AND @subscriber_type::bigint IN (2, 3)

    UNION ALL

    -- User Passport Document (if exists)
    SELECT 
        users.id,
        0 AS license_type_id,
        profiles.passport_no,
        NULL AS license_issue_date,
        profiles.passport_expiry_date,
        NULL AS license_registration_date,
        profiles.passport_image_url,
        ''::text AS original_file_name,
        CASE 
            WHEN users.user_types_id = 3 THEN 3 
            ELSE 2 
        END::bigint AS subscriber_type
    FROM users
    INNER JOIN profiles ON profiles.users_id = users.id
    WHERE users.user_types_id IN (3, 4)
      AND users.id = @subscriber_id::bigint
      AND @subscriber_type::bigint IN (2, 3) 
)
SELECT * FROM x
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');


-- name: GetCountAllSubscriberDocuments :one
WITH x AS (
    -- Company License Documents
    SELECT 
        license.id,
        license.license_type_id,
        license.license_no,
        license.license_issue_date,
        license.license_expiry_date,
        license.license_registration_date,
        license.license_file_url,
        CONCAT(
            license.metadata ->> 'original_file_name',
            license.metadata ->> 'original_file_extension'
        )::text AS original_file_name,
        1::bigint AS subscriber_type
    FROM license
    WHERE license.entity_id = @subscriber_id::bigint 
      AND license.entity_type_id = 6 -- Company
      AND 1 = @subscriber_type::bigint

    UNION ALL

    -- User License Document (if exists)
    SELECT 
        license.id,
        license.license_type_id,
        license.license_no,
        license.license_issue_date,
        license.license_expiry_date,
        license.license_registration_date,
        license.license_file_url,
        CONCAT(
            license.metadata ->> 'original_file_name',
            license.metadata ->> 'original_file_extension'
        )::text AS original_file_name,
        CASE 
            WHEN users.user_types_id = 3 THEN 3 
            ELSE 2 
        END::bigint AS subscriber_type
    FROM users
    INNER JOIN profiles ON profiles.users_id = users.id
    INNER JOIN license 
        ON license.entity_id = users.id 
        AND license.entity_type_id = 9 -- User License
    WHERE users.user_types_id IN (3, 4)
      AND users.id = @subscriber_id::bigint
      AND @subscriber_type::bigint IN (2, 3)

    UNION ALL

    -- User Passport Document (if exists)
    SELECT 
        users.id,
        0 AS license_type_id,
        profiles.passport_no,
        NULL AS license_issue_date,
        profiles.passport_expiry_date,
        NULL AS license_registration_date,
        profiles.passport_image_url,
        ''::text AS original_file_name,
        CASE 
            WHEN users.user_types_id = 3 THEN 3 
            ELSE 2 
        END::bigint AS subscriber_type
    FROM users
    INNER JOIN profiles ON profiles.users_id = users.id
    WHERE users.user_types_id IN (3, 4)
      AND users.id = @subscriber_id::bigint
      AND @subscriber_type::bigint IN (2, 3) 
)
SELECT COUNT(*) FROM x;

-- name: GetSubscribersByType :many
SELECT so.subscriber_id,
       so.subscriber_type,
       so.order_no,
       CASE
         WHEN so.subscriber_type = 1 THEN companies.company_name
         ELSE Trim(Concat(pr.first_name, ' ', pr.last_name))
       END AS "subscriber_name"
FROM   subscription_order so
       LEFT JOIN companies
              ON so.subscriber_type = 1
                 AND companies.id = so.subscriber_id
       LEFT JOIN users
              ON so.subscriber_type IN ( 2, 3 )
                 AND users.id = so.subscriber_id
                 AND users.user_types_id IN ( 3, 4 )
       LEFT JOIN profiles pr
              ON so.subscriber_type IN ( 2, 3 )
                 AND users.id = pr.users_id
WHERE  so.subscriber_type = @type_id::bigint
       AND so.status NOT IN ( 5, 6 )
GROUP  BY so.subscriber_id,
          so.subscriber_type,
          so.order_no,
          companies.company_name,
          pr.first_name,
          pr.last_name; 



-- name: GetRejectedSubscribers :many
WITH latestverification
     AS (SELECT DISTINCT ON (entity_id) so.entity_type_id,
                                        so.entity_id,
                                        so.verification,
                                        so.notes,
                                        so.created_at
         FROM   company_verification so
         ORDER  BY so.entity_id,
                   so.created_at DESC)
SELECT lv.entity_type_id,
       lv.entity_id,
       lv.verification,
       lv.notes,
       lv.created_at,
       CASE
         WHEN lv.entity_type_id = 6 THEN 1
         WHEN users.user_types_id  = 3 THEN 3
         WHEN users.user_types_id = 4 THEN 2
       END::bigint AS "subscriber_type",
       CASE
         WHEN lv.entity_type_id = 6 THEN companies.company_name
         ELSE Trim(Concat(pr.first_name, ' ', pr.last_name))
       END::varchar AS "subscriber_name"
FROM   latestverification lv
       LEFT JOIN companies
              ON lv.entity_type_id = 6
                 AND companies.id = lv.entity_id
       LEFT JOIN users
              ON lv.entity_type_id = 9
                 AND users.id = lv.entity_id
       LEFT JOIN profiles pr
              ON lv.entity_type_id = 9
                 AND users.id = pr.users_id
       LEFT JOIN user_types ut
              ON lv.entity_type_id = 9
                 AND users.user_types_id = ut.id
WHERE  lv.verification IN ( 3, 4)
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');


-- name: GetRejectedSubscribersCount :one
WITH latestverification
     AS (SELECT DISTINCT ON (entity_id) so.entity_type_id,
                                        so.entity_id,
                                        so.verification,
                                        so.notes,
                                        so.created_at
         FROM   company_verification so
         ORDER  BY so.entity_id,
                   so.created_at DESC)
SELECT COUNT(lv.entity_id)
FROM   latestverification lv
WHERE  lv.verification IN ( 3, 4 ); 