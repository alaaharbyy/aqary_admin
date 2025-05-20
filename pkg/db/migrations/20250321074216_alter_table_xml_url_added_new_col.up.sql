ALTER TABLE xml_url ADD COLUMN contact_email VARCHAR NOT NULL DEFAULT 'dummy@email.com';
ALTER TABLE xml_url ALTER COLUMN contact_email DROP DEFAULT;
