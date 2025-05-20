




ALTER TABLE department ADD COLUMN company_id bigint NULL;
ALTER TABLE department ADD COLUMN department_ar varchar NULL;

ALTER TABLE roles ADD COLUMN department_id bigint  NULL;

  

ALTER TABLE "roles" ADD CONSTRAINT "fk_roles_department_id" FOREIGN KEY("department_id")
REFERENCES "department" ("id");

