DROP TABLE IF EXISTS sale_price_history CASCADE;
DROP TABLE IF EXISTS rental_contract_history CASCADE;

CREATE TABLE "real_estate_history" (
    "id" bigserial   NOT NULL,
    "category" bigint   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "price" float   NOT NULL,
    "payment_type" bigint   NULL,
    -- for sale & rent
    "effectivity_date" timestamptz   NOT NULL,
    "contract_end" timestamptz   NULL,
    CONSTRAINT "pk_real_estate_history" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "real_estate_history" ADD CONSTRAINT "fk_real_estate_history_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");