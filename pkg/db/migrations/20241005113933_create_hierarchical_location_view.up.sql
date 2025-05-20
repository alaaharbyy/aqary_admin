-- Drop the existing materialized view if it exists
DROP MATERIALIZED VIEW IF EXISTS location_view;

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
)
SELECT 
ROW_NUMBER() OVER (ORDER BY level, country_id, state_id, city_id, community_id, sub_community_id) AS id,
    location_id,
    country_id,
    state_id,
    city_id,
    community_id,
    sub_community_id,
    location_string,
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
CREATE INDEX hierarchical_location_view_location_string_idx ON hierarchical_location_view USING gin (location_string gin_trgm_ops);
CREATE INDEX hierarchical_location_view_level_idx ON hierarchical_location_view (level);
CREATE INDEX hierarchical_location_view_search_idx ON hierarchical_location_view USING gin(search_vector);