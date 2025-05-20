ALTER TABLE countries 
DROP COLUMN status,
DROP COLUMN deleted_at,
DROP COLUMN updated_by;

ALTER TABLE states 
DROP COLUMN status,
DROP COLUMN deleted_at,
DROP COLUMN updated_by;

ALTER TABLE cities 
DROP COLUMN status,
DROP COLUMN deleted_at,
DROP COLUMN updated_by;

ALTER TABLE communities 
DROP COLUMN status,
DROP COLUMN deleted_at,
DROP COLUMN updated_by;

ALTER TABLE sub_communities 
DROP COLUMN status,
DROP COLUMN deleted_at,
DROP COLUMN updated_by;

ALTER TABLE properties_map_location 
DROP COLUMN status,
DROP COLUMN deleted_at,
DROP COLUMN updated_by;

ALTER TABLE currency 
DROP COLUMN status,
DROP COLUMN deleted_at,
DROP COLUMN updated_by;

ALTER TABLE property_type_unit_type
DROP CONSTRAINT uc_property_type_unit_type_unit_type_id_property_type_id;
COMMENT ON COLUMN global_property_type.status IS '';
ALTER TABLE global_property_type ALTER COLUMN status SET DEFAULT 1;
UPDATE global_property_type SET status = 1 WHERE status = 2;
COMMENT ON COLUMN unit_type.status IS '';
ALTER TABLE unit_type ALTER COLUMN status SET DEFAULT 1;
UPDATE unit_type SET status = 1 WHERE status = 2;
