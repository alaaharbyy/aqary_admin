ALTER TABLE projects ADD CONSTRAINT uc_projects_project_name_countries_id UNIQUE (project_name, countries_id);
ALTER TABLE projects ADD CONSTRAINT uc_projects_project_no_countries_id UNIQUE (project_no, countries_id);
ALTER TABLE projects ADD CONSTRAINT uc_projects_license_no_countries_id UNIQUE (license_no, countries_id);