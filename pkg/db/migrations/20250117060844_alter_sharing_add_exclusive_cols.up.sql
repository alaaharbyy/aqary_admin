ALTER TABLE sharing_entities 
ADD COLUMN exclusive_start_date DATE NULL,
ADD COLUMN exclusive_expire_date DATE NULL,
ADD COLUMN is_exclusive BOOLEAN DEFAULT false NOT NULL;