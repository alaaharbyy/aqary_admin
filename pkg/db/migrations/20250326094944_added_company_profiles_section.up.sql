CREATE TABLE "company_profiles" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_type" bigint  NOT NULL,
	"company_name" varchar  NOT NULL,
    "company_category_id" bigint NOT NULL,
    "company_activities_id" bigint[]   NOT NULL,
    "website_url" varchar   NULL,
    "company_email" varchar   NOT NULL,
    "phone_number" varchar   NOT NULL,
    "logo_url" varchar   NOT NULL,
	"cover_image_url" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_ar" varchar   NULL,
    "status" bigint   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_by" bigint   NULL, 
    CONSTRAINT "pk_company_profiles" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_profiles_ref_no" UNIQUE (
        "ref_no"
    )
);

ALTER TABLE "company_profiles" ADD CONSTRAINT "fk_company_profiles_company_type" FOREIGN KEY("company_type")
REFERENCES "company_types"("id");

ALTER TABLE "company_profiles" ADD CONSTRAINT "fk_company_profiles_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses"("id");

ALTER TABLE "company_profiles" ADD CONSTRAINT "fk_company_profiles_created_by" FOREIGN KEY("created_by")
REFERENCES "users"("id");

ALTER TABLE "company_profiles" ADD CONSTRAINT "fk_company_profiles_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users"("id");

ALTER TABLE "company_profiles" ADD CONSTRAINT "fk_company_profiles_company_category_id" FOREIGN KEY("company_category_id")
REFERENCES "company_category"("id");


CREATE TABLE "company_profiles_projects" (
    "id" bigserial   NOT NULL,
	"ref_number" varchar  NOT NULL,
	"project_no" varchar   NOT NULL,
    "project_name" varchar   NOT NULL,
    "company_profiles_id" bigint   NOT NULL,
    "is_verified" boolean NOT NULL,
	"is_multiphase" boolean   NOT NULL,
    "license_no" varchar NOT NULL,
    "addresses_id" bigint   NOT NULL,
	"bank_name" VARCHAR NULL,    
    "escrow_number" VARCHAR NULL,
	"registration_date" DATE NULL,
	"status" bigint  DEFAULT 1 NOT NULL,
	"description" varchar   NOT NULL,
    "description_arabic" varchar   NULL,
    "properties_ref_nos" varchar[]  NULL,
    "facts" jsonb NOT NULL,
    "promotions" jsonb NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_company_profiles_projects" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_profiles_projects_ref_number" UNIQUE (
        "ref_number"
    )
);

ALTER TABLE "company_profiles_projects" ADD CONSTRAINT "fk_company_profiles_projects_company_profiles_id" FOREIGN KEY("company_profiles_id")
REFERENCES "company_profiles"("id");

ALTER TABLE "company_profiles_projects" ADD CONSTRAINT "fk_company_profiles_projects_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses"("id");

CREATE TABLE "company_profiles_phases" (
    "id" bigserial   NOT NULL,
	"ref_number" varchar  NOT NULL,
	"company_profiles_projects_id" bigint NOT NULL,
	"phase_name" varchar NOT NULL,
    "registration_date" DATE NULL,
    "bank_name" varchar NULL,
    "escrow_number" varchar NULL,
    "facts" jsonb NOT NULL,
	"properties_ref_nos" varchar[]  NULL,
    "promotions" jsonb NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_company_profiles_phases" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_profiles_phases_ref_number" UNIQUE (
        "ref_number"
    )
);

ALTER TABLE "company_profiles_phases" ADD CONSTRAINT "fk_company_profiles_phases_company_profiles_projects_id" FOREIGN KEY("company_profiles_projects_id")
REFERENCES "company_profiles_projects"("id");



INSERT INTO "entity_type" ("id", "name") VALUES
(18, 'Company Profile'),
(19, 'Company Profile Project'),
(20, 'Company Profile Phase');
SELECT setval('entity_type_id_seq', 20, true);

INSERT INTO "license" ("license_file_url", "license_no", "license_issue_date", "license_registration_date", "license_expiry_date", "license_type_id", "state_id", "entity_type_id", "entity_id", "metadata") VALUES
('https://aqarydashboard.blob.core.windows.net/upload/company/174073107817902200001954ba8-5623-7e0f-a995-b71e28d62ccfresize-image-Copy(2).png', 'CN-1149643_dummy', '2025-01-20 20:00:00+00', '2008-09-27 20:00:00+00', '2026-01-19 23:41:12+00', 1, 1, 18, 1, '{"original_file_name": "aqary_investment_full_black", "original_file_extension": ".png"}');