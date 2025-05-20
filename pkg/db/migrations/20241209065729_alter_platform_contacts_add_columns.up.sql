ALTER TABLE platform_contacts 
ADD COLUMN preferred_email bool NOT NULL DEFAULT false,
ADD COLUMN preferred_phone bool NOT NULL DEFAULT false;