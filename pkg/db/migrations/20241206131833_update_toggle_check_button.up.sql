
DROP TABLE IF EXISTS toggles_check;


CREATE TABLE "toggles_check" (
    "id" bigserial   NOT NULL,
    "entity_type" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "status_type" int   NOT NULL,
    -- 1- Verify
    -- 2- Exclusive
    -- 3- Leased
    "start_date" timestamptz   NOT NULL,
    "end_date" timestamptz   NULL,
    "company_id" bigint   NULL,
    "doc" bigint[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_toggles_check" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "toggles_check" ADD CONSTRAINT "fk_toggles_check_entity_type" FOREIGN KEY("entity_type")
REFERENCES "entity_type" ("id");

