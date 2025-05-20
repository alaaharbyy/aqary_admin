ALTER TABLE global_property_type ADD COLUMN listing_facts bigint[] NOT NULL DEFAULT '{}';
ALTER TABLE unit_type ADD COLUMN listing_facts bigint[] NOT NULL DEFAULT '{}';
ALTER TABLE global_property_type ALTER COLUMN listing_facts DROP DEFAULT;
ALTER TABLE unit_type ALTER COLUMN listing_facts DROP DEFAULT;