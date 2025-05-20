CREATE TABLE "properties_map_location" (
    "id" bigserial   NOT NULL,
    "property" varchar   NOT NULL,
    "sub_communities_id" bigint   NOT NULL,
    "lat" float  DEFAULT 0.0 NOT NULL,
    "lng" float  DEFAULT 0.0 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NULL,
    CONSTRAINT "pk_properties_map_location" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "properties_map_location" ADD CONSTRAINT "fk_properties_map_location_sub_communities_id" FOREIGN KEY("sub_communities_id")
REFERENCES "sub_communities" ("id");