ALTER TABLE projects ADD COLUMN polygon_coords jsonb DEFAULT '[{"lat":25.774,"lng":-80.19},{"lat":18.466,"lng":-66.118},{"lat":32.321,"lng":-64.757},{"lat":25.774,"lng":-80.19}]' NOT NULL;
ALTER TABLE phases DROP COLUMN polygon_lat;
ALTER TABLE phases DROP COLUMN polygon_lng;
ALTER TABLE phases ADD COLUMN polygon_coords jsonb DEFAULT '[{"lat":25.774,"lng":-80.19},{"lat":18.466,"lng":-66.118},{"lat":32.321,"lng":-64.757},{"lat":25.774,"lng":-80.19}]' NOT NULL;