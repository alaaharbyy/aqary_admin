ALTER TABLE mortagage
ALTER COLUMN created_by DROP NOT NULL,
DROP CONSTRAINT IF EXISTS fk_mortagage_created_by;