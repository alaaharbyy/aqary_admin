DROP TABLE IF EXISTS project_financial_provider CASCADE;
DROP TABLE IF EXISTS financial_providers CASCADE;
DROP TABLE IF EXISTS financial_providers_branch CASCADE;

CREATE TABLE IF NOT EXISTS "financial_providers" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "provider_type" bigint   NOT NULL,
    "provider_name" varchar   NOT NULL,
    "logo_url" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_financial_providers" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_financial_providers_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE IF NOT EXISTS "project_financial_provider" (
    "id" bigserial   NOT NULL,
    "projects_id" bigint   NOT NULL,
    "phases_id" bigint   NULL,
    -- FK >- financial_providers.id
    "financial_providers_id" bigint[]   NULL,
    CONSTRAINT "pk_project_financial_provider" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "project_financial_provider" ADD CONSTRAINT "fk_project_financial_provider_projects_id" FOREIGN KEY("projects_id")
REFERENCES "projects" ("id");


COMMENT ON COLUMN financial_providers.provider_type IS '1 => Bank & 2 => Financial Institution';
COMMENT ON COLUMN project_financial_provider.financial_providers_id IS 'foriegn key ids of table financial_providers';