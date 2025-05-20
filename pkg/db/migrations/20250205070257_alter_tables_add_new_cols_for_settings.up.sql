ALTER TABLE countries
ADD COLUMN status bigint NOT NULL DEFAULT 2,
ADD COLUMN deleted_at timestamptz NULL,
ADD COLUMN updated_by bigint NOT NULL DEFAULT 1;
ALTER TABLE countries ADD CONSTRAINT fk_countries_updated_by FOREIGN KEY(updated_by)
REFERENCES users (id);
ALTER TABLE countries
ALTER COLUMN status DROP DEFAULT,
ALTER COLUMN updated_by DROP DEFAULT;


ALTER TABLE states
ADD COLUMN status bigint NOT NULL DEFAULT 2,
ADD COLUMN deleted_at timestamptz NULL,
ADD COLUMN updated_by bigint NOT NULL DEFAULT 1;
ALTER TABLE states ADD CONSTRAINT fk_states_updated_by FOREIGN KEY(updated_by)
REFERENCES users (id);
ALTER TABLE states
ALTER COLUMN status DROP DEFAULT,
ALTER COLUMN updated_by DROP DEFAULT;

ALTER TABLE cities
ADD COLUMN status bigint NOT NULL DEFAULT 2,
ADD COLUMN deleted_at timestamptz NULL,
ADD COLUMN updated_by bigint NOT NULL DEFAULT 1;
ALTER TABLE cities ADD CONSTRAINT fk_cities_updated_by FOREIGN KEY(updated_by)
REFERENCES users (id);
ALTER TABLE cities
ALTER COLUMN status DROP DEFAULT,
ALTER COLUMN updated_by DROP DEFAULT;


ALTER TABLE communities
ADD COLUMN status bigint NOT NULL DEFAULT 2,
ADD COLUMN deleted_at timestamptz NULL,
ADD COLUMN updated_by bigint NOT NULL DEFAULT 1;
ALTER TABLE communities ADD CONSTRAINT fk_communities_updated_by FOREIGN KEY(updated_by)
REFERENCES users (id);
ALTER TABLE communities
ALTER COLUMN status DROP DEFAULT,
ALTER COLUMN updated_by DROP DEFAULT;

ALTER TABLE sub_communities
ADD COLUMN status bigint NOT NULL DEFAULT 2,
ADD COLUMN deleted_at timestamptz NULL,
ADD COLUMN updated_by bigint NOT NULL DEFAULT 1;
ALTER TABLE sub_communities ADD CONSTRAINT fk_sub_communities_updated_by FOREIGN KEY(updated_by)
REFERENCES users (id);
ALTER TABLE sub_communities
ALTER COLUMN status DROP DEFAULT,
ALTER COLUMN updated_by DROP DEFAULT;

ALTER TABLE properties_map_location
ADD COLUMN status bigint NOT NULL DEFAULT 2,
ADD COLUMN deleted_at timestamptz NULL,
ADD COLUMN updated_by bigint NOT NULL DEFAULT 1;
ALTER TABLE properties_map_location ADD CONSTRAINT fk_properties_map_location_updated_by FOREIGN KEY(updated_by)
REFERENCES users (id);
ALTER TABLE properties_map_location
ALTER COLUMN status DROP DEFAULT,
ALTER COLUMN updated_by DROP DEFAULT;

ALTER TABLE currency
ADD COLUMN status bigint NOT NULL DEFAULT 2,
ADD COLUMN deleted_at timestamptz NULL,
ADD COLUMN updated_by bigint NOT NULL DEFAULT 1;
ALTER TABLE currency ADD CONSTRAINT fk_currency_updated_by FOREIGN KEY(updated_by)
REFERENCES users (id);
ALTER TABLE currency
ALTER COLUMN status DROP DEFAULT,
ALTER COLUMN updated_by DROP DEFAULT;

COMMENT ON COLUMN countries.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN states.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN cities.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN communities.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN sub_communities.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN properties_map_location.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN currency.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';