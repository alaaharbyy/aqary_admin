ALTER TABLE community_guidelines ALTER COLUMN sub_insights DROP NOT NULL;
ALTER TABLE community_guidelines ADD COLUMN about varchar NULL;