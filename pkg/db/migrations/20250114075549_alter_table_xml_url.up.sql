DROP TABLE IF EXISTS xml_ref_history;

ALTER TABLE xml_url 
DROP COLUMN company_type,
DROP COLUMN is_branch,
ADD COLUMN last_update timestamptz NULL;