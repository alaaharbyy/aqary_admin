INSERT INTO "entity_type"(name)
VALUES('Open House'),('Schedule View');

DROP INDEX IF EXISTS idx_timeslots_openhouse_id;

DROP TABLE IF EXISTS timeslots CASCADE;
DROP TABLE IF EXISTS appointment CASCADE;
DROP TABLE IF EXISTS schedule_view CASCADE;

CREATE TABLE "timeslots" (
    "id" bigserial   NOT NULL,
    "date" timestamptz   NOT NULL,
    "start_time" timestamptz   NOT NULL,
    "end_time" timestamptz   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    CONSTRAINT "pk_timeslots" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "appointment" (
    "id" bigserial   NOT NULL,
    "timeslots_id" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "client_id" bigint   NULL,
    "remarks" varchar   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "background_color" varchar   NOT NULL,
    CONSTRAINT "pk_appointment" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "schedule_view" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "created_by" bigint   NOT NULL,
    "owner_id" bigint   NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "start_date" timestamptz   NOT NULL,
    "end_date" timestamptz   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "interval_time" bigint   NOT NULL,
    "sessions" jsonb   NOT NULL,
    CONSTRAINT "pk_schedule_view" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_schedule_view_ref_no" UNIQUE (
        "ref_no"
    )
);


ALTER TABLE "timeslots" ADD CONSTRAINT "fk_timeslots_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE "appointment" ADD CONSTRAINT "fk_appointment_timeslots_id" FOREIGN KEY("timeslots_id")
REFERENCES "timeslots" ("id");

ALTER TABLE "appointment" ADD CONSTRAINT "fk_appointment_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "schedule_view" ADD CONSTRAINT "fk_schedule_view_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "schedule_view" ADD CONSTRAINT "fk_schedule_view_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

CREATE INDEX "idx_appointment_client_id"
ON "appointment" ("client_id");

COMMENT ON COLUMN timeslots.entity_type_id IS 'only 12=>Open House or 13=> Schedule View';