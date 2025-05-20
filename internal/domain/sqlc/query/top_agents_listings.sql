WITH x AS (
(select  -- broker_company_agents
        bca.id AS agent_id,
        bca.agent_rank AS agent_rank,
        bca.brn AS agent_brn,
        bca.experience_since AS agent_expirience_since,
        bca.users_id AS agent_user_id,
        bca.nationalities AS agent_nationalities,
        bca.brn_expiry AS agent_brn_expiry,
        bca.verification_document_url AS agent_verification_document_url,
        bca.about AS agent_about,
        bca.about_arabic AS agent_about_arabic,
        bca.linkedin_profile_url AS agent_linkedin_profile_url,
        bca.facebook_profile_url AS agent_facebook_profile_url,
        bca.twitter_profile_url AS agent_twitter_profile_url,
        bca.broker_companies_id AS agent_broker_companies_id,
        bca.created_at AS agent_created_at,
        bca.updated_at AS agent_updated_at,
        bca.status AS agent_status,
        bca.is_verified AS agent_is_verified,
        bca.profiles_id AS agent_profiles_id,
        bca.telegram AS agent_telegram,
        bca.botim AS agent_botim,
        bca.tawasal AS agent_tawasal,
        0 AS broker_companies_branches,
        
        -- profiles
        p.id AS profile_id,
        p.first_name AS first_name,
        p.last_name AS last_name,
        p.addresses_id AS addresses_id,
        p.profile_image_url AS profile_image_url,
        p.phone_number AS phone_number,
        p.company_number AS company_number,
        p.whatsapp_number AS whatsapp_number,
        p.gender AS gender,
        p.all_languages_id AS all_languages_id,
        p.created_at AS profile_created_at,
        p.updated_at AS profile_updated_at,
        p.ref_no AS profile_ref_no,
        p.cover_image_url AS cover_image_url,
        
        -- addresses
        a.countries_id AS country_id,
        a.states_id AS state_id,
        a.cities_id AS city_id,
        a.communities_id AS community_id,
        a.sub_communities_id AS sub_community_id,
        a.locations_id AS location_id,
        a.created_at AS address_created_at,
        a.updated_at AS address_updated_at,
        
         -- countries
        c.country AS country_name,
        c.flag AS country_flag,
        c.created_at AS country_created_at,
        c.updated_at AS country_updated_at,
        c.alpha2_code AS country_alpha2_code,
        c.alpha3_code AS country_alpha3_code,
        c.country_code AS country_code,
        c.lat AS country_lat,
        c.lng AS country_lng,
        
        -- states
        s.state AS state,
        s.created_at AS state_created_at,
        s.updated_at AS state_updated_at,
        s.lat AS state_lat,
        s.lng AS state_lng,
        
        -- cities
        ct.city AS city,
        ct.states_id AS city_states_id,
        ct.created_at AS city_created_at,
        ct.updated_at AS city_updated_at,
        ct.lat AS city_lat,
        ct.lng AS city_lng,
        
        -- broker_companies
        bc.company_name AS company_name,
        bc.description AS company_description,
        bc.logo_url AS company_logo_url,
        bc.addresses_id AS company_addresses_id,
        bc.email AS company_email,
        bc.phone_number AS company_phone_number,
        bc.whatsapp_number AS company_whatsapp_number,
        bc.commercial_license_no AS company_commercial_license_no,
        bc.commercial_license_file_url AS company_license_file_url,
        bc.commercial_license_expiry AS company_commercial_license_expiry,
        bc.rera_no AS company_rera_no,
        bc.rera_file_url AS company_rera_file_url,
        bc.rera_expiry AS company_rera_expiry,
        bc.is_verified AS company_is_verified,
        bc.website_url AS company_website_url,
        bc.cover_image_url AS company_cover_image_url,
        bc.tag_line AS company_tag_line,
        bc.vat_no AS company_vat_no,
        bc.vat_status AS company_vat_status,
        bc.vat_file_url AS company_vat_file_url,
        bc.facebook_profile_url AS company_facebook_profile_url,
        bc.instagram_profile_url AS company_instagram_profile_url,
        bc.twitter_profile_url AS company_twitter_profile_url,
        bc.no_of_employees AS company_no_of_employees,
        bc.users_id AS company_users_id,
        bc.linkedin_profile_url AS company_linkedin_profile_url,
        bc.broker_subscription_id AS company_broker_subscription_id,
        bc.broker_bank_account_details_id AS company_broker_bank_account_details_id,
        bc.broker_billing_info_id AS company_broker_billing_info_id,
        bc.main_services_id AS company_main_services_id,
        bc.company_rank AS company_company_rank,
        bc.status AS company_status,
        bc.country_id AS company_country_id,
        bc.company_type AS company_type,
        bc.is_branch AS company_is_branch,
        bc.created_at AS company_created_at,
        bc.updated_at AS company_updated_at,
        bc.subcompany_type AS company_subcompany_type,
        bc.ref_no AS company_ref_no,
        bc.rera_registration_date AS company_rera_registration_date,
        bc.rera_issue_date AS company_rera_issue_date,
        bc.commercial_license_registration_date AS company_commercial_license_registration_date,
        bc.commercial_license_issue_date AS company_commercial_license_issue_date,
        bc.extra_license_names AS company_extra_license_names,
        bc.extra_license_files AS company_extra_license_files,
        bc.extra_license_nos AS company_extra_license_nos,
        bc.youtube_profile_url AS company_youtube_profile_url,
        bc.orn_license_no AS company_orn_license_no,
        bc.orn_license_file_url AS company_orn_license_file_url,
        bc.orn_registration_date AS company_orn_registration_date,
        bc.orn_license_expiry AS company_orn_license_expiry
    FROM
        broker_company_agents AS bca
        INNER JOIN users AS u ON bca.users_id = u.id
        LEFT JOIN profiles AS p ON bca.profiles_id = p.id
        LEFT JOIN addresses AS a ON p.addresses_id = a.id
        LEFT JOIN countries AS c ON a.countries_id = c.id
        LEFT JOIN states AS s ON a.states_id = s.id
        LEFT JOIN cities AS ct ON a.cities_id = ct.id
        LEFT JOIN broker_companies AS bc ON bca.broker_companies_id = bc.id
    WHERE
        (bca.is_verified = ANY(array[true, false]::boolean[]))
        AND (bca.agent_rank = ANY(array[0,1,2,3,4]::bigint[]))
        AND (
			COALESCE(array[]::bigint[], ARRAY[]::bigint[]) = ARRAY[]::bigint[]
      		OR a.countries_id = ANY(COALESCE(array[]::bigint[], ARRAY[]::bigint[]))
      		)
        AND (
			COALESCE(array[]::bigint[], ARRAY[]::bigint[]) = ARRAY[]::bigint[]
      		OR a.states_id = ANY(COALESCE(array[]::bigint[], ARRAY[]::bigint[]))
        	)
        AND (
			COALESCE(array[]::bigint[], ARRAY[]::bigint[]) = ARRAY[]::bigint[]
      		OR a.communities_id = ANY(COALESCE(array[]::bigint[], ARRAY[]::bigint[]))
        	)
        AND (
        	COALESCE(array[]::bigint[], ARRAY[] :: bigint[]) = ARRAY[] :: bigint[]
      		OR a.sub_communities_id = ANY(COALESCE(array[]::bigint[], ARRAY[]::bigint[]))
      		)
        AND (
        	COALESCE(array[]::text[], ARRAY[]::TEXT[]) = ARRAY[]::TEXT[]
      		OR LOWER(c.country) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
      		OR LOWER(s.state) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
      		OR LOWER(ct.city) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
        	)
        AND (
        	COALESCE(array[]::text[], ARRAY[]::TEXT[]) = ARRAY[]::TEXT[]
      		OR LOWER(p.first_name) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
      		OR LOWER(p.last_name) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
      		OR LOWER(p.phone_number) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
      		OR LOWER(p.company_number) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
      		OR LOWER(p.whatsapp_number) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
      		OR LOWER(bc.company_name) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
        	)
)
        	
union all
(
SELECT
        -- broker_company_branches_agents
        bcab.id AS agent_id,
        bcab.agent_rank AS agent_rank,
        bcab.brn AS agent_brn,
        bcab.experience_since AS agent_expirience_since,
        bcab.users_id AS agent_user_id,
        bcab.nationalities AS agent_nationalities,
        bcab.brn_expiry AS agent_brn_expiry,
        bcab.verification_document_url AS agent_verification_document_url,
        bcab.about AS agent_about,
        bcab.about_arabic AS agent_about_arabic,
        bcab.linkedin_profile_url AS agent_linkedin_profile_url,
        bcab.facebook_profile_url AS agent_facebook_profile_url,
        bcab.twitter_profile_url AS agent_twitter_profile_url,
        bcab.broker_companies_branches_id AS agent_broker_companies_id,
        bcab.created_at AS agent_created_at,
        bcab.updated_at AS agent_updated_at,
        bcab.status AS agent_status,
        bcab.is_verified AS agent_is_verified,
        bcab.profiles_id AS agent_profiles_id,
        bcab.telegram AS agent_telegram,
        bcab.botim AS agent_botim,
        bcab.tawasal AS agent_tawasal,
        1 AS broker_companies_branches,
        
        -- profiles
        p.id AS profile_id,
        p.first_name AS first_name,
        p.last_name AS last_name,
        p.addresses_id AS addresses_id,
        p.profile_image_url AS profile_image_url,
        p.phone_number AS phone_number,
        p.company_number AS company_number,
        p.whatsapp_number AS whatsapp_number,
        p.gender AS gender,
        p.all_languages_id AS all_languages_id,
        p.created_at AS profile_created_at,
        p.updated_at AS profile_updated_at,
        p.ref_no AS profile_ref_no,
        p.cover_image_url AS cover_image_url,
        
        -- addresses
        a.countries_id AS country_id,
        a.states_id AS state_id,
        a.cities_id AS city_id,
        a.communities_id AS community_id,
        a.sub_communities_id AS sub_community_id,
        a.locations_id AS location_id,
        a.created_at AS address_created_at,
        a.updated_at AS address_updated_at,
        
         -- countries
        c.country AS country_name,
        c.flag AS country_flag,
        c.created_at AS country_created_at,
        c.updated_at AS country_updated_at,
        c.alpha2_code AS country_alpha2_code,
        c.alpha3_code AS country_alpha3_code,
        c.country_code AS country_code,
        c.lat AS country_lat,
        c.lng AS country_lng,
        
        -- states
        s.state AS state,
        s.created_at AS state_created_at,
        s.updated_at AS state_updated_at,
        s.lat AS state_lat,
        s.lng AS state_lng,
        
        -- cities
        ct.city AS city,
        ct.states_id AS city_states_id,
        ct.created_at AS city_created_at,
        ct.updated_at AS city_updated_at,
        ct.lat AS city_lat,
        ct.lng AS city_lng,
        
        -- broker_companies
        bcb.company_name AS company_name,
        bcb.description AS company_description,
        bcb.logo_url AS company_logo_url,
        bcb.addresses_id AS company_addresses_id,
        bcb.email AS company_email,
        bcb.phone_number AS company_phone_number,
        bcb.whatsapp_number AS company_whatsapp_number,
        bcb.commercial_license_no AS company_commercial_license_no,
        bcb.commercial_license_file_url AS company_license_file_url,
        bcb.commercial_license_expiry AS company_commercial_license_expiry,
        bcb.rera_no AS company_rera_no,
        bcb.rera_file_url AS company_rera_file_url,
        bcb.rera_expiry AS company_rera_expiry,
        bcb.is_verified AS company_is_verified,
        bcb.website_url AS company_website_url,
        bcb.cover_image_url AS company_cover_image_url,
        bcb.tag_line AS company_tag_line,
        bcb.vat_no AS company_vat_no,
        bcb.vat_status AS company_vat_status,
        bcb.vat_file_url AS company_vat_file_url,
        bcb.facebook_profile_url AS company_facebook_profile_url,
        bcb.instagram_profile_url AS company_instagram_profile_url,
        bcb.twitter_profile_url AS company_twitter_profile_url,
        bcb.no_of_employees AS company_no_of_employees,
        bcb.users_id AS company_users_id,
        bcb.linkedin_profile_url AS company_linkedin_profile_url,
        bcb.broker_subscription_id AS company_broker_subscription_id,
        bcb.broker_bank_account_details_id AS company_broker_bank_account_details_id,
        bcb.broker_billing_info_id AS company_broker_billing_info_id,
        bcb.main_services_id AS company_main_services_id,
        bcb.company_rank AS company_company_rank,
        bcb.status AS company_status,
        bcb.country_id AS company_country_id,
        bcb.company_type AS company_type,
        bcb.is_branch AS company_is_branch,
        bcb.created_at AS company_created_at,
        bcb.updated_at AS company_updated_at,
        bcb.subcompany_type AS company_subcompany_type,
        bcb.ref_no AS company_ref_no,
        bcb.rera_registration_date AS company_rera_registration_date,
        bcb.rera_issue_date AS company_rera_issue_date,
        bcb.commercial_license_registration_date AS company_commercial_license_registration_date,
        bcb.commercial_license_issue_date AS company_commercial_license_issue_date,
        bcb.extra_license_names AS company_extra_license_names,
        bcb.extra_license_files AS company_extra_license_files,
        bcb.extra_license_nos AS company_extra_license_nos,
        bcb.youtube_profile_url AS company_youtube_profile_url,
        bcb.orn_license_no AS company_orn_license_no,
        bcb.orn_license_file_url AS company_orn_license_file_url,
        bcb.orn_registration_date AS company_orn_registration_date,
        bcb.orn_license_expiry AS company_orn_license_expiry
    FROM
        broker_company_branches_agents AS bcab
        INNER JOIN users AS u ON bcab.users_id = u.id
        LEFT JOIN profiles AS p ON bcab.profiles_id = p.id
        LEFT JOIN addresses AS a ON p.addresses_id = a.id
        LEFT JOIN countries AS c ON a.countries_id = c.id
        LEFT JOIN states AS s ON a.states_id = s.id
        LEFT JOIN cities AS ct ON a.cities_id = ct.id
        LEFT JOIN broker_companies_branches AS bcb ON bcab.broker_companies_branches_id = bcb.id
    WHERE
        (bcab.is_verified = ANY(array[true, false]::boolean[]))
        AND (bcab.agent_rank = ANY(array[0,1,2,3,4]::bigint[]))
        AND (
			COALESCE(array[]::bigint[], ARRAY[]::bigint[]) = ARRAY[]::bigint[]
      		OR a.countries_id = ANY(COALESCE(array[]::bigint[], ARRAY[]::bigint[]))
      		)
        AND (
			COALESCE(array[]::bigint[], ARRAY[]::bigint[]) = ARRAY[]::bigint[]
      		OR a.states_id = ANY(COALESCE(array[]::bigint[], ARRAY[]::bigint[]))
        	)
        AND (
			COALESCE(array[]::bigint[], ARRAY[]::bigint[]) = ARRAY[]::bigint[]
      		OR a.communities_id = ANY(COALESCE(array[]::bigint[], ARRAY[]::bigint[]))
        	)
        AND (
        	COALESCE(array[]::bigint[], ARRAY[] :: bigint[]) = ARRAY[] :: bigint[]
      		OR a.sub_communities_id = ANY(COALESCE(array[]::bigint[], ARRAY[]::bigint[]))
      		)
        AND (
        	COALESCE(array[]::text[], ARRAY[]::TEXT[]) = ARRAY[]::TEXT[]
      		OR LOWER(c.country) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
      		OR LOWER(s.state) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
      		OR LOWER(ct.city) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
        	)
        AND (
        	COALESCE(array[]::text[], ARRAY[]::TEXT[]) = ARRAY[]::TEXT[]
      		OR LOWER(p.first_name) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
      		OR LOWER(p.last_name) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
      		OR LOWER(p.phone_number) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
      		OR LOWER(p.company_number) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
      		OR LOWER(p.whatsapp_number) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
      		OR LOWER(bcb.company_name) ILIKE ANY(array(select '%' || pt || '%' from unnest(array[]::text[]) pt)::TEXT[])
        	)
	)
)
SELECT *, COUNT(*) OVER() AS total_count FROM x
ORDER BY x.agent_is_verified;