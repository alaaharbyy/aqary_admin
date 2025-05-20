CREATE TABLE "social_media_profile" (
    "id" bigserial   NOT NULL,
    "social_media_name" varchar  NOT NULL,
    "social_media_url" varchar   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    CONSTRAINT "pk_social_media_profile" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "social_media_profile" ADD CONSTRAINT "fk_social_media_profile_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");