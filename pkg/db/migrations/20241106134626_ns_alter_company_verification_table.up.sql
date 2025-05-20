 DROP TABLE IF EXISTS company_verification CASCADE;
 
 CREATE TABLE "company_verification" (
    "id" bigserial   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "verification_type" bigint   NOT NULL,
    -- registration_date timestamptz
    -- 1-Approve 2-Reject
    "verification" int   NOT NULL,
    "response_date" timestamptz   NOT NULL,
    "updated_by" bigint   NOT NULL,
    "notes" varchar   NOT NULL,
    -- finance_verification int
    -- finance_response_date timestamptz
    -- finance_user bigint FK >- company_users.id
    -- finance_notes varchar
    "contract_file" varchar   NULL,
    "contract_upload_date" timestamptz   NULL,
    "uploaded_by" bigint   NULL,
    "upload_notes" varchar   NULL,
    CONSTRAINT "pk_company_verification" PRIMARY KEY (
        "id"
     )
);



ALTER TABLE "company_verification" ADD CONSTRAINT "fk_company_verification_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE "company_verification" ADD CONSTRAINT "fk_company_verification_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "company_verification" ADD CONSTRAINT "fk_company_verification_uploaded_by" FOREIGN KEY("uploaded_by")
REFERENCES "users" ("id");