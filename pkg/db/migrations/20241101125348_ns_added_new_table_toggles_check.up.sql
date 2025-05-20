DROP TABLE IF EXISTS exclusiveness CASCADE;

CREATE TABLE "toggles_check" (
    "id" bigserial   NOT NULL,
    "entity_type" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "status_type" int   NOT NULL,
    -- 1- Exclusive
    -- 2- Leased
    -- 3- Investment
    "start_date" timestamptz   NOT NULL,
    "end_date" timestamptz   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_toggles_check" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "toggles_check" ADD CONSTRAINT "fk_toggles_check_entity_type" FOREIGN KEY("entity_type")
REFERENCES "entity_type" ("id");