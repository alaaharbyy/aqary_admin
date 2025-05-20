DROP TABLE IF EXISTS companies CASCADE;
DROP TABLE IF EXISTS company_types CASCADE;
DROP TABLE IF EXISTS bank_account_details CASCADE;
DROP TABLE IF EXISTS companies_services CASCADE;


CREATE TABLE IF NOT EXISTS "company_types" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    -- Title -->
    "image_url" varchar   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_company_types" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_types_title" UNIQUE (
        "title"
    )
);

-- -- default data
-- INSERT INTO company_types(
--     title
-- )VALUES('Broker Company'),('Developer Company'),('Services Company'),('Product Company');


CREATE TABLE "companies" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_name" varchar   NOT NULL,
    -- company_category_id bigint FK >-  company_category.id
    -- FK >-  company_activities.id
    "company_activities_id" bigint[]   NOT NULL,
    -- self-reference
    "company_parent_id" bigint   NULL,
    "tag_line" varchar   NULL,
    "description" varchar   NOT NULL,
    "description_ar" varchar   NULL,
    "logo_url" varchar   NOT NULL,
    "email" varchar   NOT NULL,
    "phone_number" varchar   NOT NULL,
    "whatsapp_number" varchar   NULL,
    "is_verified" bool   NOT NULL,
    "website_url" varchar   NULL,
    "cover_image_url" varchar   NOT NULL,
    "no_of_employees" bigint   NULL,
    "company_rank" bigint  DEFAULT 1 NOT NULL,
    "status" bigint   NOT NULL,
    "company_type" bigint   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "users_id" bigint   NOT NULL,
    -- country_id bigint FK >- countries.id
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- FK - users.id
    "updated_by" bigint   NULL,
    "location_url" varchar NULL,
    "vat_no" varchar NULL,
    "vat_status" bigint NULL,
    "vat_file_url" varchar NULL,
    CONSTRAINT "pk_companies" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_companies_ref_no" UNIQUE (
        "ref_no"
    ),
    CONSTRAINT "uc_companies_company_name" UNIQUE (
        "company_name"
    )
);

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_company_type" FOREIGN KEY("company_type")
REFERENCES "company_types" ("id");

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

DROP TABLE IF EXISTS companies_licenses CASCADE;

CREATE TABLE "license" (
    "id" bigserial   NOT NULL,
    "license_file_url" varchar   NULL,
    "license_no" varchar   NULL,
    "license_issue_date" timestamptz   NULL,
    "license_registration_date" timestamptz   NULL,
    "license_expiry_date" timestamptz   NULL,
    "license_type_id" bigint   NOT NULL,
    -- license_state_fields_id bigint FK >- state_license_fields.id
    "state_id" bigint   NOT NULL,
    -- new field
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    CONSTRAINT "pk_license" PRIMARY KEY (
        "id"
     )
);

-- new table
CREATE TABLE "license_type" (
    "id" bigserial   NOT NULL,
    "name" varchar   NOT NULL,
    CONSTRAINT "pk_license_type" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_license_type_name" UNIQUE (
        "name"
    )
);

-- new table
CREATE TABLE "state_license_fields" (
    "id" bigserial   NOT NULL,
    "field_name" varchar   NOT NULL,
    -- trakhees_permit_no only for dubai
    -- license_dcci_no   only for dubai
    -- register_no  only for dubai
    "field_value" varchar   NOT NULL,
    "license_id" bigint   NOT NULL,
    CONSTRAINT "pk_state_license_fields" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "license" ADD CONSTRAINT "fk_license_license_type_id" FOREIGN KEY("license_type_id")
REFERENCES "license_type" ("id");

ALTER TABLE "license" ADD CONSTRAINT "fk_license_state_id" FOREIGN KEY("state_id")
REFERENCES "states" ("id");

ALTER TABLE "license" ADD CONSTRAINT "fk_license_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE "state_license_fields" ADD CONSTRAINT "fk_state_license_fields_license_id" FOREIGN KEY("license_id")
REFERENCES "license" ("id");


INSERT INTO license_type(
    name
)VALUES('Commercial License'),('Rera Number'),('ORN License'),('Extra License'),('BRN License'),('NOC License');


CREATE TABLE "bank_account_details" (
    "id" bigserial   NOT NULL,
    "account_name" varchar   NOT NULL,
    "account_number" varchar   NOT NULL,
    "iban" varchar   NOT NULL,
    "countries_id" bigint   NOT NULL,
    "currency_id" bigint   NOT NULL,
    "bank_name" varchar   NOT NULL,
    "bank_branch" varchar   NOT NULL,
    "swift_code" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    -- fk - users.id
    "updated_by" bigint   NULL,
    CONSTRAINT "pk_bank_account_details" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "bank_account_details" ADD CONSTRAINT "fk_bank_account_details_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "bank_account_details" ADD CONSTRAINT "fk_bank_account_details_currency_id" FOREIGN KEY("currency_id")
REFERENCES "currency" ("id");

ALTER TABLE "bank_account_details" ADD CONSTRAINT "fk_bank_account_details_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");


CREATE TABLE "company_category" (
    "id" bigserial   NOT NULL,
    "main_service_name" varchar   NOT NULL,
    "icon_url" varchar   NULL,
    -- FK >-  tags.id
    "tag_id" int[]   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- fk - users.id
    "updated_by" bigint   NULL,
    CONSTRAINT "pk_company_category" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_category_main_service_name" UNIQUE (
        "main_service_name"
    )
);

CREATE TABLE "company_activities" (
    "id" bigserial   NOT NULL,
    "company_category_id" bigint   NOT NULL,
    "sub_activity_name" varchar   NOT NULL,
    "icon_url" varchar   NULL,
    -- FK >-  tags.id
    "tag_id" int[]   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- fk - users.id
    "updated_by" bigint   NULL,
    CONSTRAINT "pk_company_activities" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_activities_sub_activity_name" UNIQUE (
        "sub_activity_name"
    )
);

ALTER TABLE "company_category" ADD CONSTRAINT "fk_company_category_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "company_activities" ADD CONSTRAINT "fk_company_activities_company_category_id" FOREIGN KEY("company_category_id")
REFERENCES "company_category" ("id");

ALTER TABLE "company_activities" ADD CONSTRAINT "fk_company_activities_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE company_activities RENAME sub_activity_name TO activity_name;
ALTER TABLE company_activities RENAME CONSTRAINT uc_company_activities_sub_activity_name TO uc_company_activities_activity_name;

ALTER TABLE company_category RENAME main_service_name TO category_name;
ALTER TABLE company_category RENAME CONSTRAINT uc_company_category_main_service_name TO uc_company_category_category_name;

ALTER TABLE license ADD CONSTRAINT "uc_license_license_no" UNIQUE ("license_no");
ALTER TABLE license ALTER COLUMN license_no SET NOT NULL;

ALTER TABLE state_license_fields ADD CONSTRAINT "uc_state_license_fields_field_value" UNIQUE ("field_value");