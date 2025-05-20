CREATE TABLE "global_media" (
    "id" bigserial   NOT NULL,
    "file_urls" varchar[]   NOT NULL,
    "gallery_type" varchar   NOT NULL,
    "media_type" bigint   NOT NULL,
    -- only linked from code
    "entity_id" bigint   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_global_media" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "global_media" ADD CONSTRAINT "fk_global_media_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

CREATE TABLE "global_documents" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    -- only linked from code
    "entity_id" bigint   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_global_documents" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "global_documents" ADD CONSTRAINT "fk_global_documents_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

-- default data
INSERT INTO "entity_type"(name)
VALUES('Project'),('Phase'),('Property'),('Exhibitions'),('Unit'),('Company'),('Profile'),('Freelancer'),('User'),('Holiday');