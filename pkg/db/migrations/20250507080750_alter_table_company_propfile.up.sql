CREATE TRIGGER project_slug_trigger
BEFORE INSERT OR UPDATE ON company_profiles_projects
FOR EACH ROW
EXECUTE FUNCTION generate_project_slug();
 