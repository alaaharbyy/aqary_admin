ALTER TABLE license DROP CONSTRAINT uc_license_license_no;
ALTER TABLE license ADD CONSTRAINT uc_license_license_no_entity_type_id UNIQUE(license_no,entity_type_id);