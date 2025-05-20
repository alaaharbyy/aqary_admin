DROP MATERIALIZED VIEW IF EXISTS property_quality_score;

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