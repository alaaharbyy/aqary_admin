ALTER TABLE property DROP CONSTRAINT fk_property_property_type_id;

-- CREATE TABLE "global_property_type" (
--     "id" bigserial   NOT NULL,
--     "type" varchar   NOT NULL,
--     "code" varchar   NOT NULL,
--     "property_type_facts" jsonB NOT NULL,
--     "usage" bigint   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     "status" bigint  DEFAULT 1 NOT NULL,
--     "icon" varchar   NULL,
--     CONSTRAINT "pk_global_property_type" PRIMARY KEY (
--         "id"
--      )
-- );


ALTER TABLE "property" ADD CONSTRAINT "fk_property_global_property_type_id" FOREIGN KEY("property_type_id")
REFERENCES "global_property_type" ("id");


-- just data transfer no need later
-- INSERT INTO global_property_type(
--     type,code,property_type_facts,usage,icon
-- )SELECT type,code,property_type_facts,usage,icon FROM property_type;

DROP TABLE IF EXISTS property_type CASCADE;
-- REFERENCES "global_property_type" ("id"); 
