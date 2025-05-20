ALTER TABLE company_category ADD COLUMN company_type bigint NOT NULL DEFAULT 1;
ALTER TABLE company_category ALTER COLUMN company_type DROP DEFAULT;

ALTER TABLE company_category DROP CONSTRAINT IF EXISTS uc_company_category_category_name;
ALTER TABLE company_category ADD  CONSTRAINT uc_company_category_category_name_company_type UNIQUE (
        category_name,
        company_type
);

ALTER TABLE company_category 
DROP COLUMN icon_url,
DROP COLUMN tag_id;