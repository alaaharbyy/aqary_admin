-- CREATE TABLE "companies_activities" (
--     "id" bigserial   NOT NULL,
--     "activity_type" bigint   NOT NULL,
--     -- 1 - Transactions
--     -- 2 - File View
--     -- 3 - Portal View
--     "portal_url" varchar   NULL,
--     -- connected to company type
--     "company_type_id" bigint   NOT NULL,
--     -- [ref: > companies.id]
--     "companies_id" bigint   NOT NULL,
--     "is_branch" bool   NOT NULL,
--     -- null if transactions and portal view
--     "file_category" bigint   NULL,
--     -- 1 - Media
--     -- 2 - Plans
--     -- 3 - Documents
--     -- null if transactions and portal view
--     "file_url" varchar   NULL,
--     "activity" varchar   NOT NULL,
--     "user_id" bigint   NOT NULL,
--     "activity_date" timestamptz  DEFAULT now() NOT NULL,
--     -- added by asim b/c it was required
--     "ref_no" varchar   NOT NULL,
--     CONSTRAINT "pk_companies_activities" PRIMARY KEY (
--         "id"
--      )
-- );

-- ALTER TABLE "companies_activities" ADD CONSTRAINT "fk_companies_activities_user_id" FOREIGN KEY("user_id")
-- REFERENCES "users" ("id");

DROP TABLE IF EXISTS companies_activities_history CASCADE;
DROP TABLE IF EXISTS companies_fileview_history CASCADE;