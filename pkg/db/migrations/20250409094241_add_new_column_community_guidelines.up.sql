ALTER TABLE community_guidelines ADD COLUMN status BIGINT NOT NULL;
ALTER TABLE community_guidelines ADD COLUMN created_at timestamptz NOT NULL;
ALTER TABLE community_guidelines ADD COLUMN update_at timestamptz NOT NULL;


ALTER TABLE community_guidelines_insight ADD COLUMN status BIGINT NOT NULL;
ALTER TABLE community_guidelines_insight ADD COLUMN created_at timestamptz NOT NULL;
ALTER TABLE community_guidelines_insight ADD COLUMN update_at timestamptz NOT NULL;

ALTER TABLE community_guidelines_subinsight ADD COLUMN status BIGINT NOT NULL;
ALTER TABLE community_guidelines_subinsight ADD COLUMN created_at timestamptz NOT NULL;
ALTER TABLE community_guidelines_subinsight ADD COLUMN update_at timestamptz NOT NULL;