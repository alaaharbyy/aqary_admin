ALTER TABLE projects DROP COLUMN polygon_coords;
ALTER TABLE phases DROP COLUMN polygon_coords;
ALTER TABLE phases ADD COLUMN polygon_lat float8[] NULL;
ALTER TABLE phases ADD COLUMN polygon_lng float8[] NULL;