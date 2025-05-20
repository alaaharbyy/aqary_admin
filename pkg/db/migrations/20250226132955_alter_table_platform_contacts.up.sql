ALTER TABLE platform_contacts
DROP COLUMN mode_of_contact;

ALTER TABLE platform_contacts 
ADD COLUMN phone_number varchar NULL,
ADD COLUMN country_code varchar NULL;