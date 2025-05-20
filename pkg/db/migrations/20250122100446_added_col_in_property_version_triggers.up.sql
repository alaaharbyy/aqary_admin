ALTER TABLE property_versions
ADD COLUMN slug VARCHAR(255) DEFAULT 'slug' NOT NULL;

ALTER TABLE property_versions ALTER COLUMN slug DROP DEFAULT;

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