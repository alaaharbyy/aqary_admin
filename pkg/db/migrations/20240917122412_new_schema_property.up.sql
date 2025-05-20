DROP TABLE IF EXISTS property CASCADE;
DROP TABLE IF EXISTS property_facts CASCADE;
DROP TABLE IF EXISTS sale_properties CASCADE;
DROP TABLE IF EXISTS rent_properties CASCADE;
DROP TABLE IF EXISTS property_type_facts CASCADE;
DROP TABLE IF EXISTS property_types CASCADE;
DROP TABLE IF EXISTS unit_type_variation CASCADE;


-- CREATE TABLE IF NOT EXISTS "facts" (
--     "id" bigserial   NOT NULL,
--     "entity_type_id" bigint   NOT NULL,
--     "entity_id" bigint   NOT NULL,
--     "plot_area" float   NULL,
--     "built_up_area" float   NULL,
--     "furnished" bigint   NULL,
--     "ownership" bigint   NULL,
--     "completion_status" bigint   NULL,
--     "bedroom" varchar   NULL,
--     "bathroom" bigint   NULL,
--     "start_date" timestamptz   NULL,
--     "completion_date" timestamptz   NULL,
--     "handover_date" timestamptz   NULL,
--     "no_of_floor" bigint   NULL,
--     "no_of_units" bigint   NULL,
--     "min_area" float   NULL,
--     "max_area" float   NULL,
--     "service_charge" bigint   NULL,
--     "parking" bigint   NULL,
--     "ask_price" bool   NULL,
--     "price" bigint   NULL,
--     -- for rent
--     "rent_type" bigint   NULL,
--     -- for rent
--     "no_of_payment" bigint   NULL,
--     "no_of_retail" bigint   NULL,
--     "no_of_pool" bigintNULL   NOT NULL,
--     "elevator" bigint   NULL,
--     "starting_price" bigint   NULL,
--     "life_style" bigint   NULL,
--     "available_units" bigint   NULL,
--     "commercial_tax" float   NULL,
--     "municipality_tax" float   NULL,
--     "completion_percentage" bigint   NULL,
--     "completion_percentage_date" timestamptz   NULL,
--     "sc_currency_id" bigint   NULL,
--     "unit_of_measure" varchar   NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     "worksop" bigint   NULL,
--     "warehouse" bigint   NULL,
--     "office" bigint   NULL,
--     "sector_no" bigint   NOT NULL,
--     "plot_no" bigint   NOT NULL,
--     "property_no" bigint   NOT NULL,
--     "no_of_tree" bigint   NULL,
--     "no_of_water_well" bigint   NULL,
--     "investment" bool  DEFAULT false NOT NULL,
--     "contract_start_datetime" timestamptz   NULL,
--     "contract_end_datetime" timestamptz   NULL,
--     "contract_amount" bigint   NULL,
--     "contract_currency" bigint   NULL,
--     CONSTRAINT "pk_facts" PRIMARY KEY (
--         "id"
--      )
-- );


CREATE TABLE "property" (
    "id" bigserial   NOT NULL,
    "company_id" bigint  NULL,
    "property_type_id" bigint   NOT NULL,
    "property_title" varchar  NOT NULL,
    "property_title_arabic" varchar  NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "property_rank" bigint  DEFAULT 1 NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_show_owner_info" bool  DEFAULT true NOT NULL,
    "property_name" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar  NULL,
    "owner_users_id" bigint   NULL,
    "user_id" bigint  NOT NULL,
    "updated_by" bigint  NOT NULL,
    "from_xml" bool  DEFAULT false NOT NULL,
    "facts" jsonb NOT NULL,
    "notes" varchar  NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,

    CONSTRAINT "pk_property" PRIMARY KEY (
        "id"
     )
);


-- new changes
CREATE TABLE "property_type" (
    "id" bigserial   NOT NULL,
    "type" varchar   NOT NULL,
    "code" varchar   NOT NULL,
    "property_type_facts" jsonB NOT NULL,
    "usage" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "icon" varchar   NULL,
    CONSTRAINT "pk_property_type" PRIMARY KEY (
        "id"
     )
);

-- CREATE TABLE IF NOT EXISTS "property_type_facts" (
--     "id" bigserial   NOT NULL,
--     "title" varchar   NOT NULL,
--     "status" bigint   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     "icon" varchar   NOT NULL,
--     CONSTRAINT "pk_property_type_facts" PRIMARY KEY (
--         "id"
--      )
-- );



-- new table
-- CREATE TABLE IF NOT EXISTS "property_type_property_facts" (
--     "id" bigserial   NOT NULL,
--     "property_type_id" bigint   NOT NULL,
--     "property_type_facts_id" bigint   NOT NULL,
--     CONSTRAINT "pk_property_type_property_facts" PRIMARY KEY (
--         "id"
--      )
-- );

-- CREATE TABLE IF NOT EXISTS "property_type_property_facts_values" (
--     "id" bigserial   NOT NULL,
--     "facts_id" bigint   NOT NULL,
--     "entity_type_id" bigint   NOT NULL,
--     "entity_id" bigint   NOT NULL,
--     "fact_value" varchar   NOT NULL,
--     CONSTRAINT "pk_property_type_property_facts_values" PRIMARY KEY (
--         "id"
--      )
-- );

-- new table - add new record with every add or update to property
CREATE TABLE "property_versions" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "title_arabic" varchar   NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NULL,
    "property_id" bigint   NOT NULL,
    "facts" jsonb   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_by" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "agent_id" bigint   NOT NULL,
    -- nullable
    "ref_no" varchar   NOT NULL,
    "property_type" bigint  DEFAULT 1 NOT NULL,

    CONSTRAINT "pk_property_versions" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_property_versions_ref_no" UNIQUE (
        "ref_no"
    )
);

-- 1- sale
-- 2- rent
-- 3- swap
-- changes - new table
CREATE TABLE "property_agents" (
    "id" bigserial   NOT NULL,
    "property_id" bigint   NOT NULL,
    "agent_id" bigint   NOT NULL, 
    "note" VARCHAR   NOT NULL,
    "assignment_date" timestamptz  DEFAULT now() NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_property_agents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "unit_type_variation" (
    "id" bigserial   NOT NULL,
    "description" varchar   NOT NULL,
    "min_area" float8   NOT NULL,
    "max_area" float8   NOT NULL,
    "min_price" float8   NOT NULL,
    "max_price" float8   NOT NULL,
    "parking" bigint  DEFAULT 0 NOT NULL,
    "balcony" bigint  DEFAULT 0 NOT NULL,
    "bedrooms" varchar   NULL,
    "bathroom" varchar   NULL,
    "property_id" bigint   NOT NULL,
    "unit_type_id" bigint NOT NULL,
    -- unit_facts jsonB
    "title" varchar   NOT NULL,
    "image_url" varchar[]   NOT NULL,
    "description_ar" varchar   NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "ref_no" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_unit_type_variation" PRIMARY KEY (
        "id"
     )
);

-- TODO
-- -- new table
-- CREATE TABLE IF NOT EXISTS "property_type_unit_type" (
--     "id" bigserial   NOT NULL,
--     "unit_type_id" bigint   NOT NULL,
--     "property_type_id" bigint   NOT NULL,
--     CONSTRAINT "pk_property_type_unit_type" PRIMARY KEY (
--         "id"
--      )
-- );

-- ALTER TABLE "facts" ADD CONSTRAINT "fk_facts_entity_type_id" FOREIGN KEY("entity_type_id")
-- REFERENCES "entity_type" ("id");

-- ALTER TABLE "property" ADD CONSTRAINT "fk_property_companies_id" FOREIGN KEY("companies_id")
-- REFERENCES "companies" ("id");

ALTER TABLE "property" ADD CONSTRAINT "fk_property_property_type_id" FOREIGN KEY("property_type_id")
REFERENCES "property_type" ("id");

ALTER TABLE "property" ADD CONSTRAINT "fk_property_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "property" ADD CONSTRAINT "fk_property_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

-- ALTER TABLE "property" ADD CONSTRAINT "fk_property_created_by" FOREIGN KEY("created_by")
-- REFERENCES "users" ("id");

ALTER TABLE "property" ADD CONSTRAINT "fk_property_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

-- ALTER TABLE "property_type_property_facts" ADD CONSTRAINT "fk_property_type_property_facts_property_type_id" FOREIGN KEY("property_type_id")
-- REFERENCES "property_type" ("id");

-- ALTER TABLE "property_type_property_facts" ADD CONSTRAINT "fk_property_type_property_facts_property_type_facts_id" FOREIGN KEY("property_type_facts_id")
-- REFERENCES "property_type_facts" ("id");

-- ALTER TABLE "property_type_property_facts_values" ADD CONSTRAINT "fk_property_type_property_facts_values_facts_id" FOREIGN KEY("facts_id")
-- REFERENCES "property_type_property_facts" ("id");

-- ALTER TABLE "property_type_property_facts_values" ADD CONSTRAINT "fk_property_type_property_facts_values_entity_type_id" FOREIGN KEY("entity_type_id")
-- REFERENCES "entity_type" ("id");

ALTER TABLE "property_versions" ADD CONSTRAINT "fk_property_versions_property_id" FOREIGN KEY("property_id")
REFERENCES "property" ("id");

ALTER TABLE "property_versions" ADD CONSTRAINT "fk_property_versions_agent_id" FOREIGN KEY("agent_id")
REFERENCES "users" ("id");

-- ALTER TABLE "property_versions" ADD CONSTRAINT "fk_property_versions_company_id" FOREIGN KEY("company_id")
-- REFERENCES "companies" ("id");

ALTER TABLE "property_agents" ADD CONSTRAINT "fk_property_agents_property_id" FOREIGN KEY("property_id")
REFERENCES "property" ("id");

ALTER TABLE "property_agents" ADD CONSTRAINT "fk_property_agents_agent_id" FOREIGN KEY("agent_id")
REFERENCES "users" ("id");

-- ALTER TABLE "property_type_unit_type" ADD CONSTRAINT "fk_property_type_unit_type_unit_type_id" FOREIGN KEY("unit_type_id")
-- REFERENCES "unit_type" ("id");

-- ALTER TABLE "property_type_unit_type" ADD CONSTRAINT "fk_property_type_unit_type_property_type_id" FOREIGN KEY("property_type_id")
-- REFERENCES "property_type" ("id");

ALTER TABLE "unit_type_variation" ADD CONSTRAINT "fk_unit_type_variation_property_id" FOREIGN KEY("property_id")
REFERENCES "property" ("id");

ALTER TABLE "unit_type_variation" ADD CONSTRAINT "fk_unit_type_variation_unit_type_id" FOREIGN KEY("unit_type_id")
REFERENCES "unit_type" ("id");