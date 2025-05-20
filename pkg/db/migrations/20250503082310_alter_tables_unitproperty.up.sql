ALTER TABLE property_versions ADD COLUMN score bigint default 0 not null;
ALTER TABLE unit_versions ADD COLUMN score bigint default 0 not null;