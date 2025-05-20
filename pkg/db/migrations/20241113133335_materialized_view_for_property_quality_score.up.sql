
-- materialized view for property quality score
CREATE MATERIALIZED VIEW property_quality_score AS
SELECT 
    p.id AS property_id,

    -- Title Quality (percentage of 60 characters)
    LEAST((LENGTH(p.property_title) / 60.0) * 100, 100) AS title_quality,

    -- Description Quality (percentage of 2,000 characters)
    LEAST((LENGTH(p.description) / 2000.0) * 100, 100) AS description_quality,

    -- Media Quality (percentage of 30 images)
    LEAST((COALESCE(COUNT(gm.id), 0) / 30.0) * 100, 100) AS media_quality,

    -- Address Quality (percentage of non-null address components)
    LEAST(((CASE WHEN a.countries_id IS NOT NULL THEN 1 ELSE 0 END +
            CASE WHEN a.cities_id IS NOT NULL THEN 1 ELSE 0 END +
            CASE WHEN a.communities_id IS NOT NULL THEN 1 ELSE 0 END +
            CASE WHEN a.sub_communities_id IS NOT NULL THEN 1 ELSE 0 END) / 4.0) * 100, 100) AS address_quality,

    -- Total Quality Score: weighted sum of all components
    ((LEAST((LENGTH(p.property_title) / 60.0) * 100, 100) +
     LEAST((LENGTH(p.description) / 2000.0) * 100, 100) +
     LEAST((COALESCE(COUNT(gm.id), 0) / 30.0) * 100, 100)  +
     LEAST(((CASE WHEN a.countries_id IS NOT NULL THEN 1 ELSE 0 END +
             CASE WHEN a.cities_id IS NOT NULL THEN 1 ELSE 0 END +
             CASE WHEN a.communities_id IS NOT NULL THEN 1 ELSE 0 END +
             CASE WHEN a.sub_communities_id IS NOT NULL THEN 1 ELSE 0 END) / 4.0) * 100, 100)) / 4) AS quality_score

FROM property p
-- Join address table to check address completeness
LEFT JOIN addresses a ON p.addresses_id = a.id
-- Join global_media to count images
LEFT JOIN global_media gm ON gm.entity_type_id = 3 AND gm.entity_id = p.id

GROUP BY p.id, p.property_title, p.description, a.countries_id, a.cities_id, a.communities_id, a.sub_communities_id;

-- Function to refresh the materialized view
CREATE OR REPLACE FUNCTION refresh_property_quality_score() 
RETURNS TRIGGER AS $$
BEGIN
    REFRESH MATERIALIZED VIEW property_quality_score;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;