DROP TABLE IF EXISTS subscription_cost CASCADE;

CREATE TABLE IF NOT EXISTS "subscription_cost" (
    "id" bigserial   NOT NULL,
    "countries_id" bigint   NOT NULL,
    "subscriber_type_id" bigint   NOT NULL,
    -- category id is the company main service
    "category_id" bigint   NULL,
    "product" bigint   NOT NULL,
    "price_per_unit" float   NOT NULL,
    "no_of_units_per_months" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_subscription_cost" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "subscription_cost" ADD CONSTRAINT "fk_subscription_cost_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "subscription_cost" ADD CONSTRAINT "fk_subscription_cost_product" FOREIGN KEY("product")
REFERENCES "subscription_products" ("id");

ALTER TABLE "subscription_cost" ADD CONSTRAINT "fk_subscription_cost_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");
