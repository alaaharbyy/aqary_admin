CREATE TABLE "faqs" (
    "id" bigserial   NOT NULL,
    "company_id" bigint NULL,
    "section_id" bigint NULL,
    "tags" varchar[] NULL, 
    "questions" varchar NOT NULL,
    "answers" varchar NOT NULL,
    "media_urls" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint NOT NULL,
    CONSTRAINT "pk_faqs" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "faqs" ADD CONSTRAINT "fk_faqs_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");
 