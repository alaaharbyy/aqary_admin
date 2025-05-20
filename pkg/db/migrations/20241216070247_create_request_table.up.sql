CREATE TABLE "requests_type" (
    "id" bigserial   NOT NULL,
    "type" varchar   NOT NULL,
    "status" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NULL,
    CONSTRAINT "pk_requests_type" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "requests_verification" (
    "id" bigserial   NOT NULL,
    "request_type" bigint   NOT NULL,
    "entity_type" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "requested_by" bigint   NOT NULL,
    "status" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NULL,
    CONSTRAINT "pk_requests_verification" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "request_data" (
    "id" bigserial   NOT NULL,
    "request_id" bigint   NOT NULL,
    "field_name" varchar   NOT NULL,
    "field_value" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_request_data" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "workflows" (
    "id" bigserial   NOT NULL,
    "request_type" bigint   NOT NULL,
    "step" bigint   NOT NULL,
    "department" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_workflows" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "approvals" (
    "id" bigserial   NOT NULL,
    "request_id" bigint   NOT NULL,
    "workflow_step" bigint   NOT NULL,
    "department" bigint   NOT NULL,
    "approved_by" bigint   NOT NULL,
    "status" varchar   NOT NULL,
    "remarks" varchar   NOT NULL,
    "files" jsonb   NOT NULL,
    "updated_at" timestamptz   NULL,
    CONSTRAINT "pk_approvals" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "requests_verification" ADD CONSTRAINT "fk_requests_verification_request_type" FOREIGN KEY("request_type")
REFERENCES "requests_type" ("id");

ALTER TABLE "requests_verification" ADD CONSTRAINT "fk_requests_verification_entity_type" FOREIGN KEY("entity_type")
REFERENCES "entity_type" ("id");

ALTER TABLE "requests_verification" ADD CONSTRAINT "fk_requests_verification_requested_by" FOREIGN KEY("requested_by")
REFERENCES "users" ("id");

ALTER TABLE "request_data" ADD CONSTRAINT "fk_request_data_request_id" FOREIGN KEY("request_id")
REFERENCES "requests_verification" ("id");

ALTER TABLE "workflows" ADD CONSTRAINT "fk_workflows_request_type" FOREIGN KEY("request_type")
REFERENCES "requests_type" ("id");

ALTER TABLE "workflows" ADD CONSTRAINT "fk_workflows_department" FOREIGN KEY("department")
REFERENCES "department" ("id");

ALTER TABLE "approvals" ADD CONSTRAINT "fk_approvals_request_id" FOREIGN KEY("request_id")
REFERENCES "requests_verification" ("id");

ALTER TABLE "approvals" ADD CONSTRAINT "fk_approvals_workflow_step" FOREIGN KEY("workflow_step")
REFERENCES "workflows" ("id");

ALTER TABLE "approvals" ADD CONSTRAINT "fk_approvals_department" FOREIGN KEY("department")
REFERENCES "department" ("id");

ALTER TABLE "approvals" ADD CONSTRAINT "fk_approvals_approved_by" FOREIGN KEY("approved_by")
REFERENCES "users" ("id");