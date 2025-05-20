ALTER TABLE property_versions ADD COLUMN is_hotdeal boolean NOT NULL DEFAULT false;
ALTER TABLE unit_versions ADD COLUMN is_hotdeal boolean NOT NULL DEFAULT false;