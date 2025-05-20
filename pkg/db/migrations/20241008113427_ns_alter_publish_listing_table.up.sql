TRUNCATE TABLE publish_listing;

ALTER TABLE publish_listing
DROP COLUMN is_project,
DROP COLUMN project_id,
DROP COLUMN phase_id,
DROP COLUMN is_property,
DROP COLUMN property_key,
DROP COLUMN property_id,
DROP COLUMN is_unit,
DROP COLUMN unit_id,
DROP COLUMN unit_category,
ADD COLUMN entity_type_id BIGINT NOT NULL,
ADD COLUMN entity_id BIGINT NOT NULL;
 
ALTER TABLE publish_listing
ADD CONSTRAINT fk_entity_type
FOREIGN KEY (entity_type_id)
REFERENCES entity_type(id);