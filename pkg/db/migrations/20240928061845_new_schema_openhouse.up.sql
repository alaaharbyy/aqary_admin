DROP TABLE IF EXISTS openhouse CASCADE;

CREATE TABLE "openhouse" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "created_by" bigint   NOT NULL,
    "property_id" bigint   NOT NULL,
    "start_date" timestamptz   NOT NULL,
    "end_date" timestamptz   NOT NULL,
    -- status bigint DEFAULT=1
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "sessions" jsonb   NOT NULL,
    CONSTRAINT "pk_openhouse" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_openhouse_ref_no" UNIQUE (
        "ref_no"
    )
);

ALTER TABLE "openhouse" ADD CONSTRAINT "fk_openhouse_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "openhouse" ADD CONSTRAINT "fk_openhouse_property_id" FOREIGN KEY("property_id")
REFERENCES "property" ("id");