
 
ALTER TABLE company_users DROP COLUMN company_type;
ALTER TABLE company_users DROP COLUMN is_branch;
ALTER TABLE company_users DROP COLUMN designation;
 

ALTER TABLE company_users ADD COLUMN company_department bigint NULL; 
ALTER TABLE company_users ADD COLUMN company_roles bigint  NULL;
ALTER TABLE company_users ADD COLUMN user_rank bigint DEFAULT 1  NOT NULL ;
ALTER TABLE company_users ADD COLUMN is_verified bool  NULL;


ALTER TABLE "company_users" ADD CONSTRAINT "fk_company_users_company_department" FOREIGN KEY("company_department")
REFERENCES "department" ("id");

ALTER TABLE "company_users" ADD CONSTRAINT "fk_company_users_company_roles" FOREIGN KEY("company_roles")
REFERENCES "roles" ("id");