ALTER TABLE license ADD COLUMN metadata jsonb NULL;

COMMENT ON COLUMN license.metadata IS 'to store the filename,extension etc.';