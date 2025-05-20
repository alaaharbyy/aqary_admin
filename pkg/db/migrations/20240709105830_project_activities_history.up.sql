-- DROP TABLE IF EXISTS project_activities CASCADE;
-- DROP TABLE IF EXISTS activities CASCADE;


CREATE TABLE "project_activities_history" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "module_name" varchar   NOT NULL,
    -- field_name, previous value & current value
    "field_value" jsonb   NULL,
    "created_by" bigint   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_project_activities_history" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "project_activities_history" ADD CONSTRAINT "fk_project_activities_history_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

COMMENT ON COLUMN project_activities_history.title IS 'its name of project, unit, property etc';
COMMENT ON COLUMN project_activities_history.module_name IS 'name of side bar or action buttons, like add project, local projects, manage units etc';
COMMENT ON COLUMN project_activities_history.field_value IS 'its json obj for storing field name on which the activity perform & current & previous value';

CREATE TABLE "project_fileview_history" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    -- downloaded or viewed
    "activity" varchar   NOT NULL,
    "file_url" varchar   NOT NULL,
    "created_by" bigint   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_project_fileview_history" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "project_fileview_history" ADD CONSTRAINT "fk_project_fileview_history_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

COMMENT ON COLUMN project_fileview_history.activity IS 'either the file is downloaded or viewed';