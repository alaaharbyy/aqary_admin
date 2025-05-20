
ALTER TABLE company_category ADD COLUMN temp_tag_id VARCHAR[];

UPDATE company_category
SET temp_tag_id = ARRAY(SELECT tag::VARCHAR FROM unnest(tag_id) AS tag);

ALTER TABLE company_category DROP COLUMN tag_id;

ALTER TABLE company_category RENAME COLUMN temp_tag_id TO tag_id;
