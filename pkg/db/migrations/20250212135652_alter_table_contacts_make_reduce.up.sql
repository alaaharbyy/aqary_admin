-- ALTER TABLE contacts 
-- DROP COLUMN users_id,
-- DROP COLUMN contact_category_id,
-- DROP COLUMN all_languages_id,
-- DROP COLUMN ejari,
-- DROP COLUMN assigned_to,
-- DROP COLUMN shared_with,
-- DROP COLUMN remarks,
-- DROP COLUMN is_blockedlisted,
-- DROP COLUMN is_vip,
-- DROP COLUMN contact_platform,
-- DROP COLUMN correspondence,
-- DROP COLUMN direct_markerting,
-- ADD COLUMN company_id bigint NULL;

-- ALTER TABLE contacts
-- RENAME COLUMN name TO firstname;

--- * INFO::  JUST FOR STAGING  

CREATE TABLE "contacts" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_id" bigint NULL,
    "salutation" varchar   NOT NULL,
    "firstname" varchar   NOT NULL,
    "lastname" varchar   NOT NULL,
    "status" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_by" bigint   NULL,
    CONSTRAINT "pk_contacts" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_contacts_ref_no" UNIQUE (
        "ref_no"
    )
);

ALTER TABLE "contacts" ADD CONSTRAINT "fk_contacts_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");

--- * INFO::  JUST FOR STAGING  