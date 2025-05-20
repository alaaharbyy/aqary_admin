-- materialized view for unit quality score
DROP MATERIALIZED VIEW IF EXISTS unit_quality_score;
CREATE MATERIALIZED VIEW unit_quality_score AS
SELECT u.id AS unit_id, uv.id AS unit_version_id,
    LEAST(length(uv.title::text)::numeric / 60.0 * 100::numeric, 100::numeric) AS title_quality,
    LEAST(length(uv.description::text)::numeric / 2000.0 * 100::numeric, 100::numeric) AS description_quality,
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
    (LEAST(length(uv.title::text)::numeric / 60.0 * 100::numeric, 100::numeric) + 
     LEAST(length(uv.description::text)::numeric / 2000.0 * 100::numeric, 100::numeric) + 
     LEAST(COALESCE(count(gm.id), 0::bigint)::numeric / 30.0 * 100::numeric, 100::numeric) + 
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
        END)::numeric / 4.0 * 100::numeric, 100::numeric)) / 4::numeric AS quality_score
   FROM units u
   LEFT JOIN unit_versions uv ON uv.unit_id = u.id
   LEFT JOIN addresses a ON u.addresses_id = a.id
   LEFT JOIN global_media gm ON (
   CASE WHEN uv.has_gallery = true THEN gm.entity_type_id = 14 AND gm.entity_id = uv.id 
   ELSE gm.entity_type_id = 5 AND gm.entity_id = u.id END
   )
  GROUP BY u.id, uv.id, uv.title, uv.description, a.countries_id, a.cities_id, a.communities_id, a.sub_communities_id;

-- Function to refresh the materialized view
CREATE OR REPLACE FUNCTION refresh_unit_quality_score()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW unit_quality_score;
END;
$$ LANGUAGE plpgsql;
 