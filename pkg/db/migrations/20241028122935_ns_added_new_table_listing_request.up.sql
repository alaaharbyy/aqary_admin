CREATE TABLE "listing_request" (
    "id" bigserial   NOT NULL,
    "entity_type" bigint   NOT NULL,
    "category" bigint   NOT NULL,
    -- 1- Sale
    -- 2- Rent
    -- 3- Swap
    "property_type" bigint   NULL,
    "unit_type" bigint   NULL,
    "name" varchar   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "phone_number" varchar   NOT NULL,
    "title" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "images" varchar[]   NOT NULL,
    CONSTRAINT "pk_listing_request" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "listing_request" ADD CONSTRAINT "fk_listing_request_entity_type" FOREIGN KEY("entity_type")
REFERENCES "entity_type" ("id");

ALTER TABLE "listing_request" ADD CONSTRAINT "fk_listing_request_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");