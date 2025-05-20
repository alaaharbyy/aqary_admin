-- new table
CREATE TABLE "categories" (
    "id" bigserial   NOT NULL,
    "category" varchar   NOT NULL,
    -- status bigint
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_by" bigint   NOT NULL,
    CONSTRAINT "pk_categories" PRIMARY KEY (
        "id"
     )
);

-- new table
CREATE TABLE "facilities_amenities" (
    "id" bigserial   NOT NULL,
    "icon_url" varchar   NOT NULL,
    "title" varchar   NOT NULL,
    "type" bigint   NOT NULL,
    -- Types:
    -- 1- Facility
    -- 2- Amenity
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "categories" bigint   NOT NULL,
    "updated_by" bigint   NOT NULL,
    CONSTRAINT "pk_facilities_amenities" PRIMARY KEY (
        "id"
     )
);

-- new table
CREATE TABLE "facilities_amenities_entity" (
    "id" bigserial   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "facility_amenity_id" bigint   NOT NULL,
    CONSTRAINT "pk_facilities_amenities_entity" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "categories" ADD CONSTRAINT "fk_categories_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "facilities_amenities" ADD CONSTRAINT "fk_facilities_amenities_categories" FOREIGN KEY("categories")
REFERENCES "categories" ("id");

ALTER TABLE "facilities_amenities" ADD CONSTRAINT "fk_facilities_amenities_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "facilities_amenities_entity" ADD CONSTRAINT "fk_facilities_amenities_entity_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE "facilities_amenities_entity" ADD CONSTRAINT "fk_facilities_amenities_entity_facility_amenity_id" FOREIGN KEY("facility_amenity_id")
REFERENCES "facilities_amenities" ("id");

COMMENT ON COLUMN facilities_amenities.type IS '1=>Facility & 2=>Amenity';

COMMENT ON COLUMN unit_versions.type IS '1=>Sale, 2=>Rent, 3=>Swap & 4=>Booking';
COMMENT ON COLUMN property_versions.property_type IS '1=>Sale, 2=>Rent & 3=>Swap';