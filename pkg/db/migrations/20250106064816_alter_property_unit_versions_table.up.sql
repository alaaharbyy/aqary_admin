ALTER TABLE property_versions 
ADD COLUMN is_main BOOLEAN DEFAULT FALSE NOT NULL,
ADD COLUMN is_verified BOOLEAN DEFAULT FALSE NOT NULL,
ADD COLUMN exclusive BOOLEAN DEFAULT FALSE NOT NULL,
ADD COLUMN start_date DATE NULL,
ADD COLUMN end_date DATE NULL;

ALTER TABLE unit_versions 
ADD COLUMN is_main BOOLEAN DEFAULT FALSE NOT NULL,
ADD COLUMN is_verified BOOLEAN DEFAULT FALSE NOT NULL,
ADD COLUMN exclusive BOOLEAN DEFAULT FALSE NOT NULL,
ADD COLUMN start_date DATE NULL,
ADD COLUMN end_date DATE NULL;