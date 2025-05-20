ALTER TABLE requests_verification
ALTER COLUMN status TYPE BIGINT
USING CASE 
    WHEN status = TRUE THEN 1
    WHEN status = FALSE THEN 2
    ELSE NULL
END;

ALTER TABLE bank_listing
ADD COLUMN country_id bigint NOT NULL DEFAULT 1;

ALTER TABLE bank_listing ALTER COLUMN country_id DROP DEFAULT,
ADD CONSTRAINT "fk_bank_listing_country_id" FOREIGN KEY("country_id")
REFERENCES "countries" ("id");


CREATE TABLE IF NOT EXISTS "subscription_consuming" (
    "id" bigserial   NOT NULL,
    "package_id" bigint   NOT NULL,
    "user_id" bigint   NOT NULL,
    "product" bigint   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "consumed_at" timestamptz   NOT NULL,
    CONSTRAINT "pk_subscription_consuming" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "subscription_consuming" DROP CONSTRAINT IF EXISTS "fk_subscription_consuming_package_id";
ALTER TABLE "subscription_consuming" ADD CONSTRAINT "fk_subscription_consuming_package_id" FOREIGN KEY("package_id")
REFERENCES "subscription_package" ("id");

ALTER TABLE "subscription_consuming" DROP CONSTRAINT IF EXISTS "fk_subscription_consuming_user_id";
ALTER TABLE "subscription_consuming" ADD CONSTRAINT  "fk_subscription_consuming_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "subscription_consuming" DROP CONSTRAINT IF EXISTS "fk_subscription_consuming_product";
ALTER TABLE "subscription_consuming" ADD CONSTRAINT  "fk_subscription_consuming_product" FOREIGN KEY("product")
REFERENCES "subscription_products" ("id");

ALTER TABLE "subscription_consuming" DROP CONSTRAINT IF EXISTS "fk_subscription_consuming_entity_type_id";
ALTER TABLE "subscription_consuming" ADD CONSTRAINT  "fk_subscription_consuming_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE approvals
ALTER COLUMN status TYPE BIGINT
USING CASE 
    WHEN status = '1' THEN 1
    WHEN status = '4' THEN 4
    ELSE NULL
END;
