DROP TABLE IF EXISTS bank_branches CASCADE;

CREATE TABLE "bank_listing" (
    "id" bigserial   NOT NULL,
    "name" varchar   NOT NULL,
    -- address_id bigint FK >- addresses.id
    "bank_logo_url" varchar   NOT NULL,
    "bank_url" varchar   NOT NULL,
    -- branch_name varchar
    "fixed_interest_rate" float   NOT NULL,
    "bank_process_fee" float   NOT NULL,
    "mail" varchar   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz   NOT NULL,
    "updated_at" timestamptz   NOT NULL,
    CONSTRAINT "pk_bank_listing" PRIMARY KEY (
        "id"
     )
);
 
 
CREATE TABLE "bank_branches" (
    "bank_id" bigint   NOT NULL,
    "branch_name" varchar   NOT NULL,
    "phone" varchar   NOT NULL,
    "is_main_branch" bool   NOT NULL,
    "address_id" bigint   NOT NULL
);
 
 
CREATE TABLE "mortagage" (
    "id" bigserial   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "type" bigint   NOT NULL,
    -- fixed
    -- variable
    "employement_type" bigint   NOT NULL,
    -- salaried uae national
    -- self employed uae national
    -- salaried uae resident
    -- self employed uae resident
    -- non resident
    "age" bigint   NOT NULL,
    "monthly_income" float   NOT NULL,
    "interest_rate" float   NOT NULL,
    "loan_duration" float   NOT NULL,
    "down_payment" float   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz   NOT NULL,
    "updated_at" timestamptz   NOT NULL,
    CONSTRAINT "pk_mortagage" PRIMARY KEY (
        "id"
     )
);
 
 
ALTER TABLE "bank_listing" ADD CONSTRAINT "fk_bank_listing_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");
 
 
ALTER TABLE "bank_branches" ADD CONSTRAINT "fk_bank_branches_bank_id" FOREIGN KEY("bank_id")
REFERENCES "bank_listing" ("id");
 
ALTER TABLE "bank_branches" ADD CONSTRAINT "fk_bank_branches_address_id" FOREIGN KEY("address_id")
REFERENCES "addresses" ("id");
 
 
ALTER TABLE "mortagage" ADD CONSTRAINT "fk_mortagage_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");
 
ALTER TABLE "mortagage" ADD CONSTRAINT "fk_mortagage_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");