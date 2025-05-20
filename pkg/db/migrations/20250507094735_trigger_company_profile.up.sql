
CREATE OR REPLACE FUNCTION generate_company_profile_project_slug()
RETURNS TRIGGER AS
$$
BEGIN
    -- Generating the slug based on the same logic provided in the query
    NEW.slug := LOWER(
        REPLACE(
            CONCAT(
                REPLACE(COALESCE((SELECT trim(p.project_name) FROM company_profiles_projects p
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



CREATE TRIGGER company_profile_project_slug_trigger
BEFORE INSERT OR UPDATE ON company_profiles_projects
FOR EACH ROW
EXECUTE FUNCTION generate_company_profile_project_slug();

 