DROP TABLE IF EXISTS main_services CASCADE;
DROP TABLE IF EXISTS services CASCADE;
DROP TABLE IF EXISTS service_reviews CASCADE;
DROP TABLE IF EXISTS company_activities CASCADE;

CREATE TABLE "company_activities" (
    "id" bigserial   NOT NULL,
    "company_category_id" bigint   NOT NULL,
    "sub_activity_name" varchar   NOT NULL,
    "icon_url" varchar   NULL,
    -- FK >-  tags.id
    "tag_id" int[]   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- fk - users.id
    "updated_by" bigint   NULL,
    CONSTRAINT "pk_company_activities" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_activities_sub_activity_name" UNIQUE (
        "sub_activity_name"
    )
);

CREATE TABLE "services" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_id" bigint   NOT NULL,
    "company_activities_id" bigint   NOT NULL,
    "service_name" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_ar" varchar   NOT NULL,
    "price" float   NOT NULL,
    "tag_id" bigint[]   NOT NULL,
    "service_rank" int   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_services" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "service_reviews" (
    "id" bigserial   NOT NULL,
    "service" bigint   NOT NULL,
    "service_quality" int   NOT NULL,
    "service_expertise" int   NOT NULL,
    "service_facilities" int   NOT NULL,
    "service_responsiveness" int   NOT NULL,
    "review_description" varchar   NOT NULL,
    "proof_images" varchar[]   NOT NULL,
    "reviewed_by" int   NOT NULL,
    "reviewed_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_service_reviews" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "company_activities" ADD CONSTRAINT "fk_company_activities_company_category_id" FOREIGN KEY("company_category_id")
REFERENCES "company_category" ("id");

ALTER TABLE "company_activities" ADD CONSTRAINT "fk_company_activities_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "services" ADD CONSTRAINT "fk_services_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");

ALTER TABLE "services" ADD CONSTRAINT "fk_services_company_activities_id" FOREIGN KEY("company_activities_id")
REFERENCES "company_activities" ("id");

ALTER TABLE "services" ADD CONSTRAINT "fk_services_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "service_reviews" ADD CONSTRAINT "fk_service_reviews_service" FOREIGN KEY("service")
REFERENCES "services" ("id");

ALTER TABLE "service_reviews" ADD CONSTRAINT "fk_service_reviews_reviewed_by" FOREIGN KEY("reviewed_by")
REFERENCES "users" ("id");