CREATE TABLE "exclusiveness" (
    "id" bigserial   NOT NULL,
    "entity_type" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "is_exclusive" bool  DEFAULT false NOT NULL,
    "start_date" timestamptz  DEFAULT now() NOT NULL,
    "end_date" timestamptz   NULL,
    "contract_file" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_exclusiveness" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "exclusiveness" ADD CONSTRAINT "fk_exclusiveness_entity_type" FOREIGN KEY("entity_type")
REFERENCES "entity_type" ("id");