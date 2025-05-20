ALTER TABLE community_guidelines ADD COLUMN deleted_at timestamptz NULL;
ALTER TABLE community_guidelines_insight ADD COLUMN deleted_at timestamptz NULL;
ALTER TABLE community_guidelines_subinsight ADD COLUMN deleted_at timestamptz NULL;
