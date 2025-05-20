DROP TABLE IF EXISTS subscription_cost CASCADE;

CREATE TABLE "subscription_products" (
    "id" bigserial   NOT NULL,
    "product" varchar   NOT NULL,
    -- country_id bigint FK >- countries.id
    -- company_type_id bigserial
    "icon_url" varchar    NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_subscription_products" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "draft_contracts" (
    "id" bigserial   NOT NULL,
    "subscriber_type" int   NOT NULL,
    -- FK >-  company_types.id
    "company_type_id" bigserial   NOT NULL,
    -- FK >-  main_services.id
    "company_main_service" bigserial   NOT NULL,
    -- FK >-  user_types.id
    "user_type_id" bigserial   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_draft_contracts" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "subscription_order" (
    "id" bigserial   NOT NULL,
    "order_no" varchar   NOT NULL,
    -- could be company or user
    "subscriber_id" bigint   NOT NULL,
    -- company/user
    "subscriber_type" bigint   NOT NULL,
    "start_date" timestamptz   NOT NULL,
    "end_date" timestamptz   NOT NULL,
    "sign_date" timestamptz   NOT NULL,
    "total_amount" float   NOT NULL,
    "vat" float   NOT NULL,
    "no_of_payments" bigint   NOT NULL,
    -- Monthly - Bi Anual - Yearly
    "payment_plan" bigint   NOT NULL,
    "notes" varchar   NOT NULL,
    -- Active - Inavtive
    "status" bigint   NOT NULL,
    "contract_file" varchar   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_subscription_order" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "subscription_package" (
    "id" bigserial   NOT NULL,
    "subscription_order_id" bigint   NOT NULL,
    "product" bigint   NOT NULL,
    "no_of_products" bigint   NOT NULL,
    "product_discount" float   NOT NULL,
    "remained_units" bigint   NOT NULL,
    "start_date" timestamptz   NULL,
    "end_date" timestamptz   NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_subscription_package" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "payments" (
    "id" bigserial   NOT NULL,
    "order_id" bigint   NOT NULL,
    "due_date" timestamptz   NOT NULL,
    "payment_method" bigint   NOT NULL,
    "amount" float   NOT NULL,
    "payment_date" timestamptz   NOT NULL,
    "bank" bigint   NOT NULL,
    "cheque_no" varchar   NOT NULL,
    "invoice_file" varchar   NOT NULL,
    "status" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_payments" PRIMARY KEY (
        "id"
     )
);

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

CREATE TABLE "subscription_cost" (
    "id" bigserial   NOT NULL,
    "countries_id" int   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "product" int   NOT NULL,
    "price_per_unit" float   NOT NULL,
    "no_of_units_per_months" int   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_subscription_cost" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "subscription_consuming" (
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

ALTER TABLE "subscription_products" ADD CONSTRAINT "fk_subscription_products_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "draft_contracts" ADD CONSTRAINT "fk_draft_contracts_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "subscription_order" ADD CONSTRAINT "fk_subscription_order_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "subscription_package" ADD CONSTRAINT "fk_subscription_package_subscription_order_id" FOREIGN KEY("subscription_order_id")
REFERENCES "subscription_order" ("id");

ALTER TABLE "subscription_package" ADD CONSTRAINT "fk_subscription_package_product" FOREIGN KEY("product")
REFERENCES "subscription_products" ("id");

ALTER TABLE "subscription_package" ADD CONSTRAINT "fk_subscription_package_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "payments" ADD CONSTRAINT "fk_payments_order_id" FOREIGN KEY("order_id")
REFERENCES "subscription_order" ("id");

ALTER TABLE "payments" ADD CONSTRAINT "fk_payments_bank" FOREIGN KEY("bank")
REFERENCES "bank_account_details" ("id");

ALTER TABLE "payments" ADD CONSTRAINT "fk_payments_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "agent_products" ADD CONSTRAINT "fk_agent_products_package_id" FOREIGN KEY("package_id")
REFERENCES "subscription_package" ("id");

ALTER TABLE "agent_products" ADD CONSTRAINT "fk_agent_products_company_user_id" FOREIGN KEY("company_user_id")
REFERENCES "company_users" ("id");

ALTER TABLE "agent_products" ADD CONSTRAINT "fk_agent_products_product" FOREIGN KEY("product")
REFERENCES "subscription_products" ("id");

ALTER TABLE "agent_products" ADD CONSTRAINT "fk_agent_products_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "subscription_cost" ADD CONSTRAINT "fk_subscription_cost_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE "subscription_cost" ADD CONSTRAINT "fk_subscription_cost_product" FOREIGN KEY("product")
REFERENCES "subscription_products" ("id");

ALTER TABLE "subscription_cost" ADD CONSTRAINT "fk_subscription_cost_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "subscription_consuming" ADD CONSTRAINT "fk_subscription_consuming_package_id" FOREIGN KEY("package_id")
REFERENCES "subscription_package" ("id");

ALTER TABLE "subscription_consuming" ADD CONSTRAINT "fk_subscription_consuming_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "subscription_consuming" ADD CONSTRAINT "fk_subscription_consuming_product" FOREIGN KEY("product")
REFERENCES "subscription_products" ("id");

ALTER TABLE "subscription_consuming" ADD CONSTRAINT "fk_subscription_consuming_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE subscription_order DROP COLUMN IF EXISTS contract_file;

COMMENT ON COLUMN payments.status IS '1=>unpaid & 2=>paid';