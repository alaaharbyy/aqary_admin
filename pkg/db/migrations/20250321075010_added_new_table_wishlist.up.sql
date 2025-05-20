CREATE TABLE "wishlist"(
    "id" bigserial NOT NULL,
    "entity_type_id" bigint NOT NULL,
    "entity_id" bigint NOT NULL,
    "platform_user_id" bigint NOT NULL,
    "company_id" bigint ,
    "created_at" TIMESTAMPTZ NOT NULL,
    CONSTRAINT "pk_wishlist" PRIMARY KEY ("id"),
    CONSTRAINT "uc_wishlist_entity_type_id_entity_id_platform_user_id" UNIQUE("entity_type_id", "entity_id","platform_user_id")
);
 
 
ALTER TABLE "wishlist" ADD CONSTRAINT "fk_platform_user_id" FOREIGN KEY("platform_user_id")
REFERENCES "platform_users" ("id");
 
ALTER TABLE "wishlist" ADD CONSTRAINT "fk_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");
 
ALTER TABLE "wishlist" ADD CONSTRAINT "fk_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");