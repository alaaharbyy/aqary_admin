DROP TABLE IF EXISTS units CASCADE;
DROP TABLE IF EXISTS sale_unit CASCADE;
DROP TABLE IF EXISTS rent_unit CASCADE;
DROP TABLE IF EXISTS unit_facts CASCADE;

DROP TABLE IF EXISTS rent_unit CASCADE;
DROP TABLE IF EXISTS rent_unit CASCADE;

-- only linked from code new table
CREATE TABLE "entity_type" (
    "id" bigserial   NOT NULL,
    "name" varchar   NOT NULL,
    CONSTRAINT "pk_entity_type" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_entity_type_name" UNIQUE (
        "name"
    )
);


CREATE TABLE "units" (
    "id" bigint   NOT NULL,
    "unit_no" varchar   NOT NULL,
    -- companies_id bigint FK >- companies.id
    "unitno_is_public" bool  DEFAULT false NOT NULL,
    "notes" varchar   NOT NULL,
    "unit_title" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "unit_title_arabic" varchar   NOT NULL,
    "notes_arabic" varchar   NOT NULL,
    "notes_public" bool  DEFAULT false NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    -- linked by code
    "entity_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "addresses_id" bigint   NOT NULL,
    -- countries_id bigint
    "unit_type_id" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
    "updated_by" bigint   NOT NULL,
    -- section varchar
    -- can be nullable
    "type_name_id" bigint   NOT NULL,
    "owner_users_id" bigint   NOT NULL,
    "from_xml" bool  DEFAULT false NOT NULL,
    "company_id" bigint   NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    -- new field for facts
    "facts" jsonb   NOT NULL,
    CONSTRAINT "pk_units" PRIMARY KEY (
        "id"
     )
);

-- add new record every time unit is added or updated
CREATE TABLE "unit_versions" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "title_arabic" varchar   NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NULL,
    "unit_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "type" bigint   NOT NULL,
    -- need to add this for ranking
    "unit_rank" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    "updated_by" bigint   NOT NULL,
    -- new field for facts
    "facts" jsonb   NOT NULL,
    -- if agent is null then owner user id
    "agent_id" bigint   NOT NULL,
    CONSTRAINT "pk_unit_versions" PRIMARY KEY (
        "id"
     )
);

-- new table
CREATE TABLE "unit_versions_agents" (
    "id" bigserial   NOT NULL,
    "agent_id" bigint   NOT NULL,
    "unit_version_id" bigint   NOT NULL,
    CONSTRAINT "pk_unit_versions_agents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "unit_type" (
    "id" bigserial   NOT NULL,
    "type" varchar   NOT NULL,
    "code" varchar   NOT NULL,
    "facts" jsonb   NOT NULL,
    -- unit_facts_id bigint[] FK >- unit_facts.id
    "usage" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "icon" varchar   NULL,
    CONSTRAINT "pk_unit_type" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "global_property_type" (
    "id" bigserial   NOT NULL,
    "type" varchar   NOT NULL,
    "code" varchar   NOT NULL,
    "property_type_facts" jsonB NOT NULL,
    "usage" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "icon" varchar   NULL,
    "is_project" bool DEFAULT false NOT NULL,
    CONSTRAINT "pk_global_property_type" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "property" (
    "id" bigserial   NOT NULL,
    "company_id" bigint  NULL,
    "property_type_id" bigint   NOT NULL,
    "unit_type_id" bigint[]   NULL,
    "property_title" varchar  NOT NULL,
    "property_title_arabic" varchar  NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    -- "property_rank" bigint  DEFAULT 1 NOT NULL,
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
    "notes_ar" varchar NULL,
    "is_public_note" boolean NOT NULL DEFAULT false,
    "is_project_property" boolean NOT NULL DEFAULT false,
    "exclusive" boolean NOT NULL DEFAULT false,
    "start_date" DATE NULL,
    "end_date" DATE NULL,
    CONSTRAINT "pk_property" PRIMARY KEY (
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


ALTER TABLE "units" ADD CONSTRAINT "fk_units_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE "units" ADD CONSTRAINT "fk_units_unit_type_id" FOREIGN KEY("unit_type_id")
REFERENCES "unit_type" ("id");

ALTER TABLE "units" ADD CONSTRAINT "fk_units_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "units" ADD CONSTRAINT "fk_units_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "unit_versions" ADD CONSTRAINT "fk_unit_versions_unit_id" FOREIGN KEY("unit_id")
REFERENCES "units" ("id");

ALTER TABLE "unit_versions" ADD CONSTRAINT "fk_unit_versions_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "unit_versions" ADD CONSTRAINT "fk_unit_versions_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "unit_versions" ADD CONSTRAINT "fk_unit_versions_agent_id" FOREIGN KEY("agent_id")
REFERENCES "users" ("id");

ALTER TABLE "unit_versions_agents" ADD CONSTRAINT "fk_unit_versions_agents_agent_id" FOREIGN KEY("agent_id")
REFERENCES "users" ("id");

ALTER TABLE "unit_versions_agents" ADD CONSTRAINT "fk_unit_versions_agents_unit_version_id" FOREIGN KEY("unit_version_id")
REFERENCES "unit_versions" ("id");

ALTER TABLE "unit_type_variation" ADD CONSTRAINT "fk_unit_type_variation_property_id" FOREIGN KEY("property_id")
REFERENCES "property" ("id");

ALTER TABLE "unit_type_variation" ADD CONSTRAINT "fk_unit_type_variation_unit_type_id" FOREIGN KEY("unit_type_id")
REFERENCES "unit_type" ("id");


ALTER TABLE "property" ADD CONSTRAINT "fk_property_property_type_id" FOREIGN KEY("property_type_id")
REFERENCES "global_property_type" ("id");

ALTER TABLE "property" ADD CONSTRAINT "fk_property_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "property" ADD CONSTRAINT "fk_property_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "property" ADD CONSTRAINT "fk_property_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");