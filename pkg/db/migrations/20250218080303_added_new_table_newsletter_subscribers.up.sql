DROP TABLE IF EXISTS newsletter_subscribers;
CREATE TABLE "newsletter_subscribers"(
    "id" bigserial NOT NULL,
    "email" varchar NOT NULL,
    "is_subscribed" boolean NOT NULL,
    "company_id" bigint NOT NULL,
    CONSTRAINT "pk_newsletter_subscribers" PRIMARY KEY (
        "id"
    ),
    CONSTRAINT "uc_email_company_id" UNIQUE (
        "email","company_id"
    )
);

ALTER TABLE "newsletter_subscribers" ADD CONSTRAINT "fk_newsletter_subscribers_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");