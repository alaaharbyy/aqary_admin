DROP TABLE IF EXISTS companies_reviews CASCADE;

DROP TABLE IF EXISTS company_reviews CASCADE;


CREATE TABLE "company_review" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_id" bigint   NOT NULL,
    "customer_service" int   NOT NULL,
    "staff_courstesy" int   NOT NULL,
    "implementation" int   NOT NULL,
    "quality" int   NOT NULL,
    "review_description" varchar   NOT NULL,
    "proof_images" varchar[]   NOT NULL,
    "reviewed_by" bigint   NOT NULL,
    "reviewed_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_company_review" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "user_review" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "user_id" bigint   NOT NULL,
    "knowledge" int   NOT NULL,
    "expertise" int   NOT NULL,
    "responsiveness" int   NOT NULL,
    "negotiation" int   NOT NULL,
    "review_description" varchar   NOT NULL,
    "proof_images" varchar[]   NOT NULL,
    "reviewed_by" bigint   NOT NULL,
    "reviewed_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_user_review" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "company_review" ADD CONSTRAINT "fk_company_review_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");

ALTER TABLE "company_review" ADD CONSTRAINT "fk_company_review_reviewed_by" FOREIGN KEY("reviewed_by")
REFERENCES "users" ("id");

ALTER TABLE "user_review" ADD CONSTRAINT "fk_user_review_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "user_review" ADD CONSTRAINT "fk_user_review_reviewed_by" FOREIGN KEY("reviewed_by")
REFERENCES "users" ("id");