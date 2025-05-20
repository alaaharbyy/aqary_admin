CREATE TABLE "banner_plan_package"(
    "id" bigserial NOT NULL,
    "package_name" BIGINT NOT NULL,
    "plan_type" BIGINT NOT NULL,
    "plan_package_name" VARCHAR NOT NULL,
    "quantity" BIGINT NOT NULL,-- number of banners
    "counts_per_banner" BIGINT NOT NULL,
    "icon" VARCHAR NOT NULL,
    "description" VARCHAR NULL,
    "status" BIGINT NOT NULL,
    "created_at" timestamptz NOT NULL,
    "updated_at" timestamptz NOT NULL,
    CONSTRAINT "pk_banner_plan_package" PRIMARY KEY ("id"),
    CONSTRAINT "banner_plan_package_unique_constraint" UNIQUE("plan_package_name")
);

CREATE TABLE "banner_plan_cost"(
 "id" bigserial NOT NULL,
 "country_id" BIGINT NOT NULL, 
 "company_type" BIGINT NOT NULL,
 "plan_package_id" BIGINT NOT NULL, 
 "platform" BIGINT NOT NULL, 
 "price" FLOAT NOT NULL, 
 "status" BIGINT NOT NULL,
 "created_at" timestamptz NOT NULL,
    "updated_at" timestamptz NOT NULL,
 CONSTRAINT "pk_banner_plan_cost" PRIMARY KEY ("id"), 
 CONSTRAINT "banner_plan_cost_unique_constraint" UNIQUE("country_id","company_type","plan_package_id","platform")
);

ALTER TABLE "banner_plan_cost" ADD CONSTRAINT "fk_country_id" FOREIGN KEY("country_id")
REFERENCES "countries" ("id");
ALTER TABLE "banner_plan_cost" ADD CONSTRAINT "fk_plan_package_id" FOREIGN KEY("plan_package_id") 
REFERENCES "banner_plan_package" ("id");