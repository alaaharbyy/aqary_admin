ALTER TABLE projects
ADD COLUMN slug VARCHAR(255) DEFAULT 'slug' NOT NULL;

ALTER TABLE projects ALTER COLUMN slug DROP DEFAULT;

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

ALTER TABLE unit_versions
ADD COLUMN slug VARCHAR(255) DEFAULT 'slug' NOT NULL;

ALTER TABLE unit_versions ALTER COLUMN slug DROP DEFAULT;

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