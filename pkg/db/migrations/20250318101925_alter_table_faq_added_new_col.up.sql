ALTER TABLE faqs ADD COLUMN created_by bigint NOT NULL;
ALTER TABLE faqs ADD CONSTRAINT "fk_faqs_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");