ALTER TABLE platform_contacts
ADD COLUMN mode_of_contact varchar NOT NULL DEFAULT '',
ADD COLUMN purpose varchar NOT NULL DEFAULT '';

ALTER TABLE platform_contacts
ALTER COLUMN mode_of_contact DROP DEFAULT,
ALTER COLUMN purpose DROP DEFAULT;