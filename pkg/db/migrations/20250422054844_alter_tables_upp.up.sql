ALTER TABLE unit_versions
ADD COLUMN refreshed_at TIMESTAMPTZ;
 
ALTER TABLE property_versions
ADD COLUMN refreshed_at TIMESTAMPTZ;
 
ALTER TABLE projects
ADD COLUMN refreshed_at TIMESTAMPTZ;

 