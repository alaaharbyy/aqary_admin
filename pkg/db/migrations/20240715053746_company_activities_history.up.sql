-- DROP TABLE IF EXISTS companies_activities CASCADE;

CREATE TABLE "companies_activities_history" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "module_name" varchar   NOT NULL,
    -- field_name, previous value & current value
    "field_value" jsonb  NULL,
    "created_by" bigint   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_companies_activities_history" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "companies_fileview_history" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    -- downloaded or viewed
    "activity" varchar   NOT NULL,
    "file_url" varchar   NOT NULL,
    "created_by" bigint   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_companies_fileview_history" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "companies_activities_history" ADD CONSTRAINT "fk_companies_activities_history_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "companies_fileview_history" ADD CONSTRAINT "fk_companies_fileview_history_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");