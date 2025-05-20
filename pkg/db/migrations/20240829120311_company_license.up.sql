DROP TABLE IF EXISTS companies_licenses CASCADE;

ALTER TABLE "companies" DROP CONSTRAINT IF EXISTS "fk_companies_companies_licenses_id";

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_company_type" FOREIGN KEY("company_type")
REFERENCES "company_types" ("id");

ALTER TABLE "company_types" DROP COLUMN IF EXISTS "main_company_type_id";
ALTER TABLE "company_types" ALTER COLUMN "description" DROP NOT NULL;
ALTER TABLE "company_types" ADD CONSTRAINT "uc_company_types_title" UNIQUE("title");


CREATE TABLE "companies_licenses" (
    "id" bigserial   NOT NULL,
    "company_id" bigint   NOT NULL,
    "commercial_license_no" varchar   NOT NULL,
    "commercial_license_file_url" varchar   NOT NULL,
    "commercial_license_issue_date" timestamptz   NULL,
    "commercial_license_expiry" timestamptz   NOT NULL,
    -- when the commercial license registered for the first time
    "commercial_license_registration_date" timestamptz   NULL,
    "rera_no" varchar   NULL,
    "rera_file_url" varchar   NULL,
    "rera_issue_date" timestamptz   NULL,
    "rera_expiry" timestamptz   NULL,
    -- when the rera registered for the first time
    "rera_registration_date" timestamptz   NULL,
    "vat_no" varchar   NULL,
    "vat_status" bigint   NULL,
    "vat_file_url" varchar   NULL,
    "orn_license_no" varchar   NULL,
    "orn_license_file_url" varchar   NULL,
    "orn_registration_date" timestamptz   NULL,
    "orn_license_expiry" timestamptz   NULL,
    -- only for dubai
    "trakhees_permit_no" varchar   NULL,
    -- only for dubai
    "license_dcci_no" varchar   NULL,
    -- only for dubai
    "register_no" varchar   NULL,
    -- extra_license_id bigint FK >- extra_license.id
    "extra_license" jsonb  NULL,
    CONSTRAINT "pk_companies_licenses" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_companies_licenses_commercial_license_no" UNIQUE (
        "commercial_license_no"
    ),
    CONSTRAINT "uc_companies_licenses_rera_no" UNIQUE (
        "rera_no"
    )
);

ALTER TABLE "companies_licenses" ADD CONSTRAINT "fk_companies_licenses_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");

ALTER TABLE "companies" ADD COLUMN  "description_ar" VARCHAR NULL;