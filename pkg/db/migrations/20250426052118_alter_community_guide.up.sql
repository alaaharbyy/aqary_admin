 CREATE TABLE country_guide (
    id BIGSERIAL PRIMARY KEY,
    country_id BIGINT NOT NULL UNIQUE,
    cover_image VARCHAR NOT NULL,
    description VARCHAR,
    status BIGINT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMPTZ

);
 
-- State Guide Table
CREATE TABLE state_guide (
    id BIGSERIAL PRIMARY KEY,
    state_id BIGINT NOT NULL UNIQUE,
    cover_image VARCHAR NOT NULL,
    description VARCHAR,
    status BIGINT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMPTZ

);
 
-- City Guide Table
CREATE TABLE city_guide (
    id BIGSERIAL PRIMARY KEY,
    city_id BIGINT NOT NULL UNIQUE,
    cover_image VARCHAR NOT NULL,
    description VARCHAR,
    status BIGINT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMPTZ

);
 
-- ALTER TABLE "country_guide" ADD CONSTRAINT "fk_country_id" FOREIGN KEY("country_id") REFERENCES "countries" ("id");
-- ALTER TABLE "city_guide" ADD CONSTRAINT "fk_city_id" FOREIGN KEY("city_id") REFERENCES "cities" ("id");
-- ALTER TABLE "state_guide" ADD CONSTRAINT "fk_state_id" FOREIGN KEY("state_id") REFERENCES "states" ("id");
 