DROP TABLE IF EXISTS social_connections CASCADE;


CREATE TABLE "social_connections" (
    "id" bigserial   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "requested_by" bigint   NOT NULL,
    "request_date" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    "remarks" varchar   NOT NULL,
    -- Requested - Accepted - Rejected - Blocked
    "connection_status_id" bigint   NOT NULL,
    CONSTRAINT "pk_social_connections" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "social_connections" ADD CONSTRAINT "fk_social_connections_companies_id" FOREIGN KEY("companies_id")
REFERENCES "companies" ("id");

ALTER TABLE "social_connections" ADD CONSTRAINT "fk_social_connections_requested_by" FOREIGN KEY("requested_by")
REFERENCES "companies" ("id");

COMMENT ON COLUMN social_connections.connection_status_id IS '1=>Requested, 2=>Accepted, 3=>Rejected & 4=>Blocked';
