TRUNCATE TABLE global_property_type CASCADE;
-- ALTER TABLE global_property_type ADD COLUMN is_project bool DEFAULT false NOT NULL;
ALTER SEQUENCE global_property_type_id_seq RESTART WITH 1;


TRUNCATE TABLE unit_type CASCADE;
ALTER SEQUENCE unit_type_id_seq RESTART WITH 1;

