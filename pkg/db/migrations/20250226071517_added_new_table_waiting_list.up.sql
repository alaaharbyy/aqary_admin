CREATE TABLE "waiting_list" (
    "id" bigserial   NOT NULL,
    "name" varchar  NOT NULL,
    "email" varchar  NOT NULL,
    "phone_number" varchar NOT NULL,
    "country_code" varchar NOT NULL, 
    "company_id" bigint NOT NULL, 
    "section" varchar NOT NULL, 
    CONSTRAINT "pk_waiting_list" PRIMARY KEY (
        "id"
     ), 
      CONSTRAINT "uc_email_company_id_section" UNIQUE (
        "email","company_id","section"
    ), 
    CONSTRAINT "uc_phone_company_id_section" UNIQUE (
        "phone_number","country_code","company_id","section"
    )
);

ALTER TABLE "waiting_list" ADD CONSTRAINT "fk_waiting_list_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");