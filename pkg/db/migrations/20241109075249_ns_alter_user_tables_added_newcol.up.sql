ALTER TABLE users 
ADD COLUMN phone_number VARCHAR NULL,
ADD COLUMN is_phone_verified BOOL DEFAULT FALSE NOT NULL,
ADD COLUMN is_email_verified BOOL DEFAULT FALSE NOT NULL;