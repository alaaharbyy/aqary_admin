ALTER TABLE company_category ADD COLUMN status bigint DEFAULT 1 NOT NULL;
ALTER TABLE company_activities ADD COLUMN status bigint DEFAULT 1 NOT NULL;
ALTER TABLE services ADD COLUMN status bigint DEFAULT 1 NOT NULL;