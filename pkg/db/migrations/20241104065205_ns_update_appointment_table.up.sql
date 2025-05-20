-- DROP TABLE IF EXISTS appointment CASCADE;

-- CREATE TABLE "appointment" (
--     "id" bigserial   NOT NULL,
--     "timeslots_id" bigint   NOT NULL,
--     -- agent_id bigint NULL
--     "created_by" bigint   NOT NULL,
--     -- requested, booked, closed, rescheduled, deleted, rejected
--     "status" bigint  DEFAULT 1 NOT NULL,
--     "remark" varchar   NULL,
--     "reject_reason" varchar   NULL,
--     -- "lead_id" bigint   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     "request_type" bigint   NOT NULL,
--     -- online
--     -- live/onsite
--     "platform_type" bigint   NULL,
--     "background_color" varchar   NOT NULL,
--     CONSTRAINT "pk_appointment" PRIMARY KEY (
--         "id"
--      )
-- );

-- ALTER TABLE "appointment" ADD CONSTRAINT "fk_appointment_timeslots_id" FOREIGN KEY("timeslots_id")
-- REFERENCES "timeslots" ("id");

-- ALTER TABLE "appointment" ADD CONSTRAINT "fk_appointment_created_by" FOREIGN KEY("created_by")
-- REFERENCES "users" ("id");

-- CREATE TABLE "platforms" (
--     "id" bigserial   NOT NULL,
--     "name" varchar   NOT NULL,
--     "url" varchar   NOT NULL,
--     CONSTRAINT "pk_platforms" PRIMARY KEY (
--         "id"
--      )
-- );