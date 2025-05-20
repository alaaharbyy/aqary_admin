
CREATE MATERIALIZED VIEW autocomplete_view AS
SELECT 
    sub_community AS name,
    'sub_community' AS type
FROM sub_communities
UNION ALL
SELECT 
    community,
    'community'
FROM communities
UNION ALL
SELECT 
    city,
    'city'
FROM cities
UNION ALL
SELECT 
    state,
    'state'
FROM states
UNION ALL
SELECT 
    country,
    'country'
FROM countries;

CREATE OR REPLACE FUNCTION refresh_autocomplete_view()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW autocomplete_view;
END;
$$ LANGUAGE plpgsql;

CREATE MATERIALIZED VIEW section_permission_mv AS
SELECT * FROM section_permission;

CREATE OR REPLACE FUNCTION refresh_section_permission_mv()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW section_permission_mv;
END;
$$ LANGUAGE plpgsql;

CREATE MATERIALIZED VIEW permissions_mv AS
SELECT * FROM permissions;

CREATE OR REPLACE FUNCTION refresh_permissions_mv()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW permissions_mv;
END;
$$ LANGUAGE plpgsql;

CREATE MATERIALIZED VIEW sub_section_mv AS
SELECT * FROM sub_section;

CREATE OR REPLACE FUNCTION refresh_sub_section_mv()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW sub_section_mv;
END;
$$ LANGUAGE plpgsql;


CREATE MATERIALIZED VIEW hierarchical_location_view AS

WITH RECURSIVE location_hierarchy AS (
    -- Country level
    SELECT 
        co.id AS location_id,
        co.id AS country_id,
        0::bigint AS state_id,
        0::bigint AS city_id,
        0::bigint AS community_id,
        0::bigint AS sub_community_id,
        0::bigint AS property_map_id,
        co.country AS location_string,
        1 AS level,
        setweight(to_tsvector('simple', coalesce(co.country,'')), 'A') AS search_vector
    FROM countries co

    UNION ALL

    -- State level
    SELECT 
        s.id,
        co.id,
        s.id,
        0::bigint,
        0::bigint,
        0::bigint,
        0::bigint AS property_map_id,
        co.country || ', ' || s.state,
        2,
        setweight(to_tsvector('simple', coalesce(co.country,'')), 'A') ||
        setweight(to_tsvector('simple', coalesce(s.state,'')), 'B')
    FROM states s
    JOIN countries co ON s.countries_id = co.id

    UNION ALL

    -- City level
    SELECT 
        c.id,
        co.id,
        s.id,
        c.id,
        0::bigint,
        0::bigint,
        0::bigint AS property_map_id,
        co.country || ', ' || s.state || ', ' || c.city,
        3,
        setweight(to_tsvector('simple', coalesce(co.country,'')), 'A') ||
        setweight(to_tsvector('simple', coalesce(s.state,'')), 'B') ||
        setweight(to_tsvector('simple', coalesce(c.city,'')), 'C')
    FROM cities c
    JOIN states s ON c.states_id = s.id
    JOIN countries co ON s.countries_id = co.id

    UNION ALL

    -- Community level
    SELECT 
        cm.id,
        co.id,
        s.id,
        c.id,
        cm.id,
        0::bigint,
        0::bigint AS property_map_id,
        co.country || ', ' || s.state || ', ' || c.city || ', ' || cm.community,
        4,
        setweight(to_tsvector('simple', coalesce(co.country,'')), 'A') ||
        setweight(to_tsvector('simple', coalesce(s.state,'')), 'B') ||
        setweight(to_tsvector('simple', coalesce(c.city,'')), 'C') ||
        setweight(to_tsvector('simple', coalesce(cm.community,'')), 'D')
    FROM communities cm
    JOIN cities c ON cm.cities_id = c.id
    JOIN states s ON c.states_id = s.id
    JOIN countries co ON s.countries_id = co.id

    UNION ALL

    -- Sub-community level
    SELECT 
        sc.id,
        co.id,
        s.id,
        c.id,
        cm.id,
        sc.id,
        0::bigint AS property_map_id,
        co.country || ', ' || s.state || ', ' || c.city || ', ' || cm.community || ', ' || sc.sub_community,
        5,
        setweight(to_tsvector('simple', coalesce(co.country,'')), 'A') ||
        setweight(to_tsvector('simple', coalesce(s.state,'')), 'B') ||
        setweight(to_tsvector('simple', coalesce(c.city,'')), 'C') ||
        setweight(to_tsvector('simple', coalesce(cm.community,'')), 'D') ||
        setweight(to_tsvector('simple', coalesce(sc.sub_community,'')), 'D')
    FROM sub_communities sc
    JOIN communities cm ON sc.communities_id = cm.id
    JOIN cities c ON cm.cities_id = c.id
    JOIN states s ON c.states_id = s.id
    JOIN countries co ON s.countries_id = co.id

    UNION ALL

    -- properties-map-location level
    SELECT 
        pm.id,
        co.id,
        s.id,
        c.id,
        cm.id,
        sc.id,
        pm.id,
        co.country || ', ' || s.state || ', ' || c.city || ', ' || cm.community || ', ' || sc.sub_community || ', ' || pm.property,
        6,
        setweight(to_tsvector('simple', coalesce(co.country,'')), 'A') ||
        setweight(to_tsvector('simple', coalesce(s.state,'')), 'B') ||
        setweight(to_tsvector('simple', coalesce(c.city,'')), 'C') ||
        setweight(to_tsvector('simple', coalesce(cm.community,'')), 'D') ||
        setweight(to_tsvector('simple', coalesce(sc.sub_community,'')), 'D') ||
        setweight(to_tsvector('simple', coalesce(pm.property,'')), 'D')
    FROM properties_map_location pm
    JOIN sub_communities sc ON pm.sub_communities_id = sc.id
    JOIN communities cm ON sc.communities_id = cm.id
    JOIN cities c ON cm.cities_id = c.id
    JOIN states s ON c.states_id = s.id
    JOIN countries co ON s.countries_id = co.id
)
SELECT 
ROW_NUMBER() OVER (ORDER BY level, country_id, state_id, city_id, community_id, sub_community_id, property_map_id) AS id,
    location_id,
    country_id,
    state_id,
    city_id,
    community_id,
    sub_community_id,
    property_map_id,
    location_string,
    level,
    search_vector
FROM location_hierarchy;

CREATE OR REPLACE FUNCTION refresh_hierarchical_location_view()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW hierarchical_location_view;
END;
$$ LANGUAGE plpgsql;

-- materialized view for property quality score
CREATE MATERIALIZED VIEW property_quality_score AS
SELECT p.id AS property_id, pv.id AS property_version_id,
    LEAST(length(pv.title::text)::numeric / 60.0 * 100::numeric, 100::numeric) AS title_quality,
    LEAST(length(pv.description::text)::numeric / 2000.0 * 100::numeric, 100::numeric) AS description_quality,
    LEAST(COALESCE(count(gm.id), 0::bigint)::numeric / 30.0 * 100::numeric, 100::numeric) AS media_quality,
    LEAST((
        CASE
            WHEN a.countries_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.cities_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.communities_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.sub_communities_id IS NOT NULL THEN 1
            ELSE 0
        END)::numeric / 4.0 * 100::numeric, 100::numeric) AS address_quality,
    (LEAST(length(pv.title::text)::numeric / 60.0 * 100::numeric, 100::numeric) + LEAST(length(pv.description::text)::numeric / 2000.0 * 100::numeric, 100::numeric) + LEAST(COALESCE(count(gm.id), 0::bigint)::numeric / 30.0 * 100::numeric, 100::numeric) + LEAST((
        CASE
            WHEN a.countries_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.cities_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.communities_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.sub_communities_id IS NOT NULL THEN 1
            ELSE 0
        END)::numeric / 4.0 * 100::numeric, 100::numeric)) / 4::numeric AS quality_score
   FROM property p
   LEFT JOIN property_versions pv ON pv.property_id = p.id
     LEFT JOIN addresses a ON p.addresses_id = a.id
     LEFT JOIN global_media gm ON (
     CASE WHEN pv.has_gallery = true THEN gm.entity_type_id = 15 AND gm.entity_id = pv.id 
     ELSE gm.entity_type_id = 3 AND gm.entity_id = p.id END
     )
  GROUP BY p.id,pv.id, pv.title, pv.description, a.countries_id, a.cities_id, a.communities_id, a.sub_communities_id;

-- Function to refresh the materialized view
CREATE OR REPLACE FUNCTION refresh_property_quality_score()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW property_quality_score;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_full_address() 
RETURNS TRIGGER AS $$
BEGIN
    -- Start building the address from the country, state, and city
    NEW.full_address := 
        COALESCE((SELECT country FROM countries WHERE id = NEW.countries_id), '') ||
        CASE WHEN COALESCE((SELECT country FROM countries WHERE id = NEW.countries_id), '') <> '' THEN ', ' ELSE '' END ||
        COALESCE((SELECT state FROM states WHERE id = NEW.states_id), '') ||
        CASE WHEN COALESCE((SELECT state FROM states WHERE id = NEW.states_id), '') <> '' THEN ', ' ELSE '' END ||
        COALESCE((SELECT city FROM cities WHERE id = NEW.cities_id), '') ||
        CASE WHEN COALESCE((SELECT city FROM cities WHERE id = NEW.cities_id), '') <> '' THEN ', ' ELSE '' END ||
        COALESCE((SELECT community FROM communities WHERE id = NEW.communities_id), '') ||
        CASE WHEN COALESCE((SELECT community FROM communities WHERE id = NEW.communities_id), '') <> '' THEN ', ' ELSE '' END ||
        COALESCE((SELECT sub_community FROM sub_communities WHERE id = NEW.sub_communities_id), '') ||
        CASE WHEN COALESCE((SELECT sub_community FROM sub_communities WHERE id = NEW.sub_communities_id), '') <> '' THEN ', ' ELSE '' END ||
        COALESCE((SELECT property FROM properties_map_location WHERE id = NEW.property_map_location_id), '');

    -- Remove any trailing comma and space
    NEW.full_address := rtrim(NEW.full_address, ', ');

    -- Return the modified row
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_full_address
BEFORE INSERT OR UPDATE ON addresses
FOR EACH ROW
EXECUTE FUNCTION update_full_address();


CREATE OR REPLACE FUNCTION generate_unique_ref_no()
RETURNS TRIGGER AS $$
DECLARE
    new_ref_no VARCHAR(12);  -- To store the generated reference number with the prefix
BEGIN
    -- Prefix for the reference number
    -- You can change 'REF-' to any other string if needed
    LOOP
        -- Generate a random 6-digit number
        new_ref_no := 'REQ-' || LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');

        -- Check if the generated ref_no already exists
        IF NOT EXISTS (SELECT 1 FROM requests_verification WHERE ref_no = new_ref_no) THEN
            -- If unique, assign it to the new row
            NEW.ref_no := new_ref_no;
            RETURN NEW;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER before_request_insert_trigger
BEFORE INSERT ON requests_verification
FOR EACH ROW
EXECUTE FUNCTION generate_unique_ref_no();


CREATE OR REPLACE FUNCTION generate_property_slug()
RETURNS TRIGGER AS
$$
BEGIN
    -- Generating the slug based on the logic provided
    NEW.slug := LOWER(
        REPLACE(
            CONCAT(
                REPLACE(COALESCE((SELECT pt."type" FROM property p
                                 JOIN global_property_type pt ON pt.id = p.property_type_id
                                 WHERE p.id = NEW.property_id), ''), ' ', '-'), 
                CASE WHEN (SELECT pt."type" FROM property p
                           JOIN global_property_type pt ON pt.id = p.property_type_id
                           WHERE p.id = NEW.property_id) IS NOT NULL 
                     AND NEW.category IS NOT NULL THEN '-for-' ELSE '' END,
                CASE 
                    WHEN NEW.category = 1 THEN 'sale' 
                    ELSE 'rent' 
                END,
                CASE WHEN (SELECT st."state" FROM addresses ad
                           JOIN states st ON st.id = ad.states_id
                           WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)) IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN (SELECT st."state" FROM addresses ad
                           JOIN states st ON st.id = ad.states_id
                           WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)) IS NOT NULL
                     THEN REPLACE(COALESCE((SELECT st."state" FROM addresses ad
                                            JOIN states st ON st.id = ad.states_id
                                            WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)), ''), ' ', '-') ELSE '' END,
                CASE WHEN (SELECT co.community FROM addresses ad
                           JOIN communities co ON co.id = ad.communities_id
                           WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)) IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN (SELECT co.community FROM addresses ad
                           JOIN communities co ON co.id = ad.communities_id
                           WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)) IS NOT NULL
                     THEN REPLACE(COALESCE((SELECT co.community FROM addresses ad
                                            JOIN communities co ON co.id = ad.communities_id
                                            WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)), ''), ' ', '-') ELSE '' END,
                CASE WHEN (SELECT sb.sub_community FROM addresses ad
                           JOIN sub_communities sb ON sb.id = ad.sub_communities_id
                           WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)) IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN (SELECT sb.sub_community FROM addresses ad
                           JOIN sub_communities sb ON sb.id = ad.sub_communities_id
                           WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)) IS NOT NULL
                     THEN REPLACE(COALESCE((SELECT sb.sub_community FROM addresses ad
                                            JOIN sub_communities sb ON sb.id = ad.sub_communities_id
                                            WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)), ''), ' ', '-') ELSE '' END,
                CASE WHEN (SELECT pml.property FROM addresses ad
                           JOIN properties_map_location pml ON pml.id = ad.property_map_location_id
                           WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)) IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN (SELECT pml.property FROM addresses ad
                           JOIN properties_map_location pml ON pml.id = ad.property_map_location_id
                           WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)) IS NOT NULL
                     THEN REPLACE(COALESCE((SELECT pml.property FROM addresses ad
                                            JOIN properties_map_location pml ON pml.id = ad.property_map_location_id
                                            WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)), ''), ' ', '-') ELSE '' END,
                CASE WHEN NEW.id IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN NEW.id IS NOT NULL THEN NEW.id END 
            ), 
            ' ', '-'
        )
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER property_slug_trigger
BEFORE INSERT OR UPDATE ON property_versions
FOR EACH ROW
EXECUTE FUNCTION generate_property_slug();


CREATE OR REPLACE FUNCTION generate_project_slug()
RETURNS TRIGGER AS
$$
BEGIN
    -- Generating the slug based on the same logic provided in the query
    NEW.slug := LOWER(
        REPLACE(
            CONCAT(
                REPLACE(COALESCE((SELECT p.project_name FROM projects p
                                 WHERE p.id = NEW.id), ''), ' ', '-'),
                CASE WHEN NEW.id IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN NEW.id IS NOT NULL THEN NEW.id END 
            ), 
            ' ', '-'
        )
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER project_slug_trigger
BEFORE INSERT OR UPDATE ON projects
FOR EACH ROW
EXECUTE FUNCTION generate_project_slug();


CREATE OR REPLACE FUNCTION generate_unit_version_slug()
RETURNS TRIGGER AS
$$
BEGIN
    -- Generating the slug based on the same logic provided in the query
    NEW.slug := LOWER(
        REPLACE(
            CONCAT(
                REPLACE(COALESCE((SELECT pt."type" FROM units p
                                 JOIN unit_type pt ON pt.id = p.unit_type_id
                                 WHERE p.id = NEW.unit_id), ''), ' ', '-'), 
                CASE WHEN (SELECT pt."type" FROM units p
                           JOIN unit_type pt ON pt.id = p.unit_type_id
                           WHERE p.id = NEW.unit_id) IS NOT NULL 
                     AND NEW."type" IS NOT NULL THEN '-for-' ELSE '' END,
                CASE 
                    WHEN NEW."type" = 1 THEN 'sale' 
                    WHEN NEW."type" = 2 THEN 'rent' 
                    WHEN NEW."type" = 3 THEN 'swap'
                END,
                CASE WHEN (SELECT st."state" FROM addresses ad
                           JOIN states st ON st.id = ad.states_id
                           WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)) IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN (SELECT st."state" FROM addresses ad
                           JOIN states st ON st.id = ad.states_id
                           WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)) IS NOT NULL
                     THEN REPLACE(COALESCE((SELECT st."state" FROM addresses ad
                                            JOIN states st ON st.id = ad.states_id
                                            WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)), ''), ' ', '-') ELSE '' END,
                CASE WHEN (SELECT co.community FROM addresses ad
                           JOIN communities co ON co.id = ad.communities_id
                           WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)) IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN (SELECT co.community FROM addresses ad
                           JOIN communities co ON co.id = ad.communities_id
                           WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)) IS NOT NULL
                     THEN REPLACE(COALESCE((SELECT co.community FROM addresses ad
                                            JOIN communities co ON co.id = ad.communities_id
                                            WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)), ''), ' ', '-') ELSE '' END,
                CASE WHEN (SELECT sb.sub_community FROM addresses ad
                           JOIN sub_communities sb ON sb.id = ad.sub_communities_id
                           WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)) IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN (SELECT sb.sub_community FROM addresses ad
                           JOIN sub_communities sb ON sb.id = ad.sub_communities_id
                           WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)) IS NOT NULL
                     THEN REPLACE(COALESCE((SELECT sb.sub_community FROM addresses ad
                                            JOIN sub_communities sb ON sb.id = ad.sub_communities_id
                                            WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)), ''), ' ', '-') ELSE '' END,
                CASE WHEN (SELECT pml.property FROM addresses ad
                           JOIN properties_map_location pml ON pml.id = ad.property_map_location_id
                           WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)) IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN (SELECT pml.property FROM addresses ad
                           JOIN properties_map_location pml ON pml.id = ad.property_map_location_id
                           WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)) IS NOT NULL
                     THEN REPLACE(COALESCE((SELECT pml.property FROM addresses ad
                                            JOIN properties_map_location pml ON pml.id = ad.property_map_location_id
                                            WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)), ''), ' ', '-') ELSE '' END,
                CASE WHEN NEW.id IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN NEW.id IS NOT NULL THEN NEW.id END 
            ), 
            ' ', '-'
        )
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER unit_versions_slug_trigger
BEFORE INSERT OR UPDATE ON unit_versions
FOR EACH ROW
EXECUTE FUNCTION generate_unit_version_slug();

CREATE OR REPLACE FUNCTION generate_service_slug()
RETURNS TRIGGER AS
$$
BEGIN
    -- Generating the slug based on the same logic provided in the query
    NEW.slug := LOWER(
        REPLACE(
            CONCAT(
                REPLACE(COALESCE((SELECT p.service_name FROM services p
                                 WHERE p.id = NEW.id), ''), ' ', '-'),
                CASE WHEN NEW.id IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN NEW.id IS NOT NULL THEN NEW.id END 
            ), 
            ' ', '-'
        )
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER services_slug_trigger
BEFORE INSERT OR UPDATE ON services
FOR EACH ROW
EXECUTE FUNCTION generate_service_slug();