ALTER TABLE property_type_unit_type
ADD CONSTRAINT uc_property_type_unit_type_unit_type_id_property_type_id UNIQUE(
    unit_type_id,property_type_id
);

COMMENT ON COLUMN global_property_type.status IS '1=>in-active, 2=>active, 6=>deleted';

ALTER TABLE global_property_type ALTER COLUMN status SET DEFAULT 2;

UPDATE global_property_type SET status = 2 WHERE status = 1;

COMMENT ON COLUMN unit_type.status IS '1=>in-active, 2=>active, 6=>deleted';

ALTER TABLE unit_type ALTER COLUMN status SET DEFAULT 2;

UPDATE unit_type SET status = 2 WHERE status = 1;