
DROP TABLE IF EXISTS payment_plans_packages CASCADE;
DROP TABLE IF EXISTS unit_payment_plans CASCADE;

CREATE TABLE "payment_plans" (
    "id" bigserial   NOT NULL,
    "reference_no" varchar   NOT NULL,
    "payment_plan_title" varchar   NOT NULL,
    "no_of_installments" bigint   NOT NULL,
    CONSTRAINT "pk_payment_plans" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "plan_installments" (
    "id" bigserial   NOT NULL,
    "payment_plans" bigint   NOT NULL,
    "percentage" varchar   NOT NULL,
    "date" timestamptz   NULL,
    "milestone" varchar   NOT NULL,
    CONSTRAINT "pk_plan_installments" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "payment_plans_packages" (
    "id" bigserial   NOT NULL,
    "no_of_plans" bigint   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "payment_plans_id" bigint[]   NOT NULL,
    "is_enabled" bool   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_payment_plans_packages" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "plan_installments" ADD CONSTRAINT "fk_plan_installments_payment_plans" FOREIGN KEY("payment_plans")
REFERENCES "payment_plans" ("id");

ALTER TABLE "payment_plans_packages" ADD CONSTRAINT "fk_payment_plans_packages_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");