DROP MATERIALIZED VIEW IF EXISTS hierarchical_location_view;

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
        co.country AS last_attribute,
        co.country AS location_string,
        co.country AS location_without,
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
        s.state,
        s.state || ', ' || co.country,
        co.country,
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
        c.city,
        c.city || ', ' || s.state,
        s.state,
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
        cm.community,
        cm.community || ', ' || c.city || ', ' || s.state,
        c.city || ', ' || s.state,
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
        sc.sub_community,
        sc.sub_community || ', ' || cm.community || ', ' || c.city || ', ' || s.state,
        cm.community || ', ' || c.city || ', ' || s.state,
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
        pm.property,
        pm.property || ', ' || sc.sub_community || ', ' || cm.community || ', ' || c.city || ', ' || s.state,
        sc.sub_community || ', ' || cm.community || ', ' || c.city || ', ' || s.state,
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
    last_attribute,
    location_string,
    location_without,
    level,
    search_vector
FROM location_hierarchy;

-- Create indexes
CREATE UNIQUE INDEX ON hierarchical_location_view (id);
CREATE INDEX hierarchical_location_view_location_id_idx ON hierarchical_location_view (location_id);
CREATE INDEX hierarchical_location_view_country_idx ON hierarchical_location_view (country_id);
CREATE INDEX hierarchical_location_view_state_idx ON hierarchical_location_view (state_id);
CREATE INDEX hierarchical_location_view_city_idx ON hierarchical_location_view (city_id);
CREATE INDEX hierarchical_location_view_community_idx ON hierarchical_location_view (community_id);
CREATE INDEX hierarchical_location_view_sub_community_idx ON hierarchical_location_view (sub_community_id);
CREATE INDEX hierarchical_location_view_property_map_idx ON hierarchical_location_view (property_map_id);
CREATE INDEX hierarchical_location_view_location_string_idx ON hierarchical_location_view USING gin (location_string gin_trgm_ops);
CREATE INDEX hierarchical_location_view_level_idx ON hierarchical_location_view (level);
CREATE INDEX hierarchical_location_view_search_idx ON hierarchical_location_view USING gin(search_vector);
-- new index for new fields
CREATE INDEX hierarchical_location_view_last_attribute_idx ON hierarchical_location_view USING gin (last_attribute gin_trgm_ops);
CREATE INDEX hierarchical_location_view_location_without_idx ON hierarchical_location_view USING gin (location_without gin_trgm_ops);