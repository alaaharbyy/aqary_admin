ALTER TABLE "schedule_view"
    ADD COLUMN "address" varchar NULL;

 
ALTER TABLE "appointment"
    ADD COLUMN "appoinment_type" BIGINT NOT NULL DEFAULT 0;
 
ALTER TABLE "appointment"
    ADD COLUMN "appoinment_app" BIGINT  NULL;