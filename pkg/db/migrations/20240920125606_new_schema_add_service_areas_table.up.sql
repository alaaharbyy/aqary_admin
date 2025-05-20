ALTER TABLE users ADD COLUMN experience_since timestamptz NULL;

CREATE TABLE "service_areas" (
    "id" bigserial   NOT NULL,
    "company_users_id" bigint   NOT NULL,
    -- address -> sub community
    "service_areas_id" bigint   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    CONSTRAINT "pk_service_areas" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "service_areas" ADD CONSTRAINT "fk_service_areas_company_users_id" FOREIGN KEY("company_users_id")
REFERENCES "company_users" ("id");

ALTER TABLE "service_areas" ADD CONSTRAINT "fk_service_areas_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE "service_areas" ADD CONSTRAINT "fk_service_areas_service_areas_id" FOREIGN KEY("service_areas_id")
REFERENCES "sub_communities" ("id");