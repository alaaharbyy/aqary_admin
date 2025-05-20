 ALTER TABLE "company_user_expertise" ADD CONSTRAINT "fk_company_user" FOREIGN KEY("company_user_id")
REFERENCES "company_users" ("id");
 