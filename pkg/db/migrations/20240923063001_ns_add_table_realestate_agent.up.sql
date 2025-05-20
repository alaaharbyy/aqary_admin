DROP TABLE IF EXISTS real_states_agents CASCADE;

CREATE TABLE "real_estate_agents" (
    "id" bigserial   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    -- linked by code
    "entity_id" bigint   NOT NULL,
    "agent_id" bigint   NOT NULL,
    "note" varchar   NOT NULL,
    "assignment_date" timestamptz  DEFAULT now() NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_real_estate_agents" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "real_estate_agents" ADD CONSTRAINT "fk_real_estate_agents_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE "real_estate_agents" ADD CONSTRAINT "fk_real_estate_agents_agent_id" FOREIGN KEY("agent_id")
REFERENCES "company_users" ("id");