ALTER TABLE property_versions
RENAME COLUMN views TO views_count;

ALTER TABLE unit_versions
RENAME COLUMN views TO views_count;
