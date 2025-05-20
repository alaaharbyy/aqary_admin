-- CREATE TABLE "activities" (
--     "id" bigserial   NOT NULL,
--     "module_name" varchar   NOT NULL,
--     "previous" varchar   NULL,
--     "current" varchar  NULL,
--     "activity" varchar   NOT NULL,
--     "created_by" bigint   NOT NULL,
--     "activity_date" timestamptz  DEFAULT now() NOT NULL,
--     CONSTRAINT "pk_activities" PRIMARY KEY (
--         "id"
--      )
-- );

-- CREATE TABLE "project_activities" (
--     "id" bigserial   NOT NULL,
--     "activities_id" bigint   NOT NULL,
--     "is_project" bool  DEFAULT false NOT NULL,
--     -- FK - projects.id
--     "projects_id" bigint   NULL,
--     "is_phase" bool  DEFAULT false NOT NULL,
--     -- FK - phases.id
--     "phases_id" bigint   NULL,
--     "is_property" bool  DEFAULT false NOT NULL,
--     -- FK - project_properties.id
--     "project_properties_id" bigint   NULL,
--     "is_unit" bool  DEFAULT false NOT NULL,
--     -- FK - units.id
--     "units_id" bigint   NULL,
--     "gallery_id" bigint   NULL,
--     "document_id" bigint   NULL,
--     "plans_id" bigint   NULL,
--     "financial_providers_id" bigint   NULL,
--     "promotions_id" bigint   NULL,
--     "reviews_id" bigint   NULL,
--     "payment_plans_id" bigint   NULL,
--     "unit_types_id" bigint   NULL,
--     "openhouse_id" bigint   NULL,
--     CONSTRAINT "pk_project_activities" PRIMARY KEY (
--         "id"
--      )
-- );

-- ALTER TABLE "activities" ADD CONSTRAINT "fk_activities_created_by" FOREIGN KEY("created_by")
-- REFERENCES "users" ("id");

-- ALTER TABLE "project_activities" ADD CONSTRAINT "fk_project_activities_activities_id" FOREIGN KEY("activities_id")
-- REFERENCES "activities" ("id");

DROP TABLE IF EXISTS project_activities_history CASCADE;
DROP TABLE IF EXISTS project_fileview_history CASCADE;