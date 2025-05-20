
ALTER TABLE "xml_url" ADD CONSTRAINT "fk_xml_url_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");