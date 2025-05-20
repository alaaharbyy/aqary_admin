
CREATE TABLE "agent_products" (
    "id" bigserial   NOT NULL,
    "package_id" bigint   NOT NULL,
    "company_user_id" bigint   NOT NULL,
    "product" bigint   NOT NULL,
    "no_of_products" int   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_agent_products" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "agent_products" ADD CONSTRAINT "fk_agent_products_package_id" FOREIGN KEY("package_id")
REFERENCES "subscription_package" ("id");

ALTER TABLE "agent_products" ADD CONSTRAINT "fk_agent_products_company_user_id" FOREIGN KEY("company_user_id")
REFERENCES "company_users" ("id");

ALTER TABLE "agent_products" ADD CONSTRAINT "fk_agent_products_product" FOREIGN KEY("product")
REFERENCES "subscription_products" ("id");

ALTER TABLE "agent_products" ADD CONSTRAINT "fk_agent_products_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");