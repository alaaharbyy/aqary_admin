ALTER TABLE "schedule_view"
    DROP COLUMN "address";
ALTER TABLE "schedule_view"
    ADD COLUMN "lat" varchar NOT NULL DEFAULT 0;
ALTER TABLE "schedule_view"
    ADD COLUMN "lng" varchar NOT NULL DEFAULT 0;