-- Enable the extension
CREATE EXTENSION IF NOT EXISTS pg_trgm;
-- Drop the existing materialized view if it exists
DROP MATERIALIZED VIEW IF EXISTS location_view;

-- Create the enhanced materialized view
CREATE MATERIALIZED VIEW location_view AS
SELECT
    sc.id,
    CONCAT_WS(', ', 
        co.country, 
        s.state, 
        c.city, 
        cm.community, 
        sc.sub_community
    ) AS address_string,
    co.id AS country_id,
    s.id AS state_id,
    c.id AS city_id,
    cm.id AS community_id,
    sc.id AS sub_community_id,
    sc.created_at,
    sc.updated_at,
    -- Add individual columns for each component
    co.country,
    s.state,
    c.city,
    cm.community,
    sc.sub_community,
    -- Create a tsvector column for full-text search
    setweight(to_tsvector('simple', coalesce(co.country,'')), 'A') ||
    setweight(to_tsvector('simple', coalesce(s.state,'')), 'B') ||
    setweight(to_tsvector('simple', coalesce(c.city,'')), 'C') ||
    setweight(to_tsvector('simple', coalesce(cm.community,'')), 'D') ||
    setweight(to_tsvector('simple', coalesce(sc.sub_community,'')), 'D') AS search_vector
FROM
    sub_communities sc
    JOIN communities cm ON sc.communities_id = cm.id
    JOIN cities c ON cm.cities_id = c.id
    JOIN states s ON c.states_id = s.id
    JOIN countries co ON s.countries_id = co.id;

-- Create a unique index on the id column
CREATE UNIQUE INDEX ON location_view (id);

-- Create a GIN index on the search_vector for fast full-text search
CREATE INDEX location_view_search_idx ON location_view USING gin(search_vector);

-- Create indexes on individual columns for non-full-text searches
CREATE INDEX location_view_country_idx ON location_view (country);
CREATE INDEX location_view_state_idx ON location_view (state);
CREATE INDEX location_view_city_idx ON location_view (city);
CREATE INDEX location_view_community_idx ON location_view (community);
CREATE INDEX location_view_sub_community_idx ON location_view (sub_community);

-- Create a trigram index on address_string for fast fuzzy searches
CREATE INDEX location_view_address_trgm_idx ON location_view USING gin (address_string gin_trgm_ops);