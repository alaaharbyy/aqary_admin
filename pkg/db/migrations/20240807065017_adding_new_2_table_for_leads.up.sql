CREATE TABLE "routing_triggers" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "lead_activity" bigint   NOT NULL,
    "next_activity" bigint   NOT NULL,
    -- Activities
    "interval" bigint   NOT NULL,
    "interval_type" bigint   NOT NULL,
    "added_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_routing_triggers" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "agent_routes" (
    "id" bigserial   NOT NULL,
    "leads_id" bigint   NOT NULL,
    "assigned_to" bigint   NOT NULL,
    "routed_to" bigint   NOT NULL,
    "reason" varchar   NOT NULL,
    "routed_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_agent_routes" PRIMARY KEY (
        "id"
     )
);



ALTER TABLE "routing_triggers" ADD CONSTRAINT "fk_routing_triggers_added_by" FOREIGN KEY("added_by")
REFERENCES "users" ("id");

ALTER TABLE "agent_routes" ADD CONSTRAINT "fk_agent_routes_leads_id" FOREIGN KEY("leads_id")
REFERENCES "leads" ("id");

ALTER TABLE "agent_routes" ADD CONSTRAINT "fk_agent_routes_assigned_to" FOREIGN KEY("assigned_to")
REFERENCES "users" ("id");

ALTER TABLE "agent_routes" ADD CONSTRAINT "fk_agent_routes_routed_to" FOREIGN KEY("routed_to")
REFERENCES "users" ("id");