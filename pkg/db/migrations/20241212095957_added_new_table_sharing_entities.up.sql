CREATE TABLE "sharing_entities" (
    "id" bigserial   NOT NULL,
    "sharing_id" bigint   NOT NULL,
    "entity_type" bigint   NOT NULL,
    -- version id of unit & property
    "entity_id" bigint   NOT NULL,
    -- if unit is a property unit
    "property_id" bigint   NULL,
    "phase_id" bigint NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NULL,
    -- fk - users.id
    "updated_by" bigint   NULL,
    CONSTRAINT "pk_sharing_entities" PRIMARY KEY (
        "id"
     )
);


ALTER TABLE "sharing_entities" ADD CONSTRAINT "fk_sharing_entities_sharing_id" FOREIGN KEY("sharing_id")
REFERENCES "sharing" ("id");

ALTER TABLE "sharing_entities" ADD CONSTRAINT "fk_sharing_entities_entity_type" FOREIGN KEY("entity_type")
REFERENCES "entity_type" ("id");