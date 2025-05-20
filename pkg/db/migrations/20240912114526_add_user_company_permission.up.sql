



ALTER TABLE users DROP column permissions_id;
ALTER TABLE users DROP column sub_section_permission;
 

CREATE TABLE "user_company_permissions" (
    "id" bigserial   NOT NULL,
    "user_id" bigint   NOT NULL,
    "company_id" bigint,
    "permissions_id" bigint[]   NOT NULL,
    "sub_sections_id" bigint[]   NOT NULL,
    CONSTRAINT "pk_user_company_permissions" PRIMARY KEY (
        "id"
     )
);
ALTER TABLE "user_company_permissions" ADD CONSTRAINT "fk_user_company_permissions_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");
ALTER TABLE "user_company_permissions" ADD CONSTRAINT "fk_user_company_permissions_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");

