ALTER TABLE property ADD COLUMN unit_type_id bigint[]   NOT NULL DEFAULT ARRAY[1];
ALTER TABLE property ALTER COLUMN unit_type_id DROP DEFAULT;
