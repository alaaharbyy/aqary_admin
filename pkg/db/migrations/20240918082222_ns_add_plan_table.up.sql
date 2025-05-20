-- ***names
-- 1- Project
-- 2- Phase
-- 3- Property
-- 4- Exhibitions
-- 5- Unit
-- -------
-- 6- company
-- 7- profile
-- 8- freelancer
-- 9- user
-- 10- holiday

DROP TABLE IF EXISTS entity_type CASCADE;

-- only linked from code new table
CREATE TABLE "entity_type" (
    "id" bigserial   NOT NULL,
    "name" varchar   NOT NULL,
    CONSTRAINT "pk_entity_type" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_entity_type_name" UNIQUE (
        "name"
    )
);


CREATE TABLE IF NOT EXISTS "plans" (
    "id" bigserial   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "title" varchar   NOT NULL,
    "file_urls" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "uploaded_by" bigint   NOT NULL,
    "updated_by" bigint   NOT NULL,
    CONSTRAINT "pk_plans" PRIMARY KEY (
        "id"
     )
);
 
 
ALTER TABLE "plans" ADD CONSTRAINT "fk_plans_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");
 
ALTER TABLE "plans" ADD CONSTRAINT "fk_plans_uploaded_by" FOREIGN KEY("uploaded_by")
REFERENCES "users" ("id");
 
ALTER TABLE "plans" ADD CONSTRAINT "fk_plans_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");