ALTER TABLE projects DROP CONSTRAINT IF EXISTS uc_projects_project_name_countries_id;
ALTER TABLE projects DROP CONSTRAINT IF EXISTS uc_projects_project_no_countries_id;
ALTER TABLE projects DROP CONSTRAINT IF EXISTS uc_projects_license_no_countries_id;