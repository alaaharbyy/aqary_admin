ALTER TABLE services
ADD COLUMN slug VARCHAR(255) DEFAULT 'slug' NOT NULL;

ALTER TABLE services ALTER COLUMN slug DROP DEFAULT;

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