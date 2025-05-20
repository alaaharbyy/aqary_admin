DROP TABLE IF EXISTS property_type_unit_type CASCADE;
CREATE TABLE "property_type_unit_type" (
    "id" bigserial   NOT NULL,
    "unit_type_id" bigint   NOT NULL,
    "property_type_id" bigint   NOT NULL,
    CONSTRAINT "pk_property_type_unit_type" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "property_type_unit_type" ADD CONSTRAINT "fk_property_type_unit_type_unit_type_id" FOREIGN KEY("unit_type_id")
REFERENCES "unit_type" ("id");

ALTER TABLE "property_type_unit_type" ADD CONSTRAINT "fk_property_type_unit_type_property_type_id" FOREIGN KEY("property_type_id")
REFERENCES "global_property_type" ("id");