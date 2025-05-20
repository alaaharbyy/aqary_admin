CREATE TABLE "project_media" (
    "id" bigserial   NOT NULL,
    "file_urls" varchar[]   NOT NULL,
    "gallery_type" varchar   NOT NULL,
    "media_type" bigint   NOT NULL,
    "projects_id" bigint   NULL,
    "phases_id" bigint   NULL,
    "project_properties_id" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_project_media" PRIMARY KEY (
        "id"
     )
);

CREATE INDEX "idx_project_media_projects_id_not_null"
ON "project_media" ("projects_id") WHERE "projects_id" IS NOT NULL;

CREATE INDEX "idx_project_media_phases_id_not_null"
ON "project_media" ("phases_id") WHERE "phases_id" IS NOT NULL;

CREATE TABLE "properties_media" (
    "id" bigserial   NOT NULL,
    "file_urls" varchar[]   NOT NULL,
    "gallery_type" varchar   NOT NULL,
    "media_type" bigint   NOT NULL,
    -- id from any properties  table broker, project ,owner,freelancer properties.
    "properties_id" bigint   NOT NULL,
    -- keys 1 => project property,2=> freelancer property, 3 => broker property, 4=>owner property
    "property" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_properties_media" PRIMARY KEY (
        "id"
     )
);

CREATE INDEX "idx_properties_media_properties_id_property" 
ON "properties_media" ("properties_id", "property");

CREATE TABLE "unit_media" (
    "id" bigserial   NOT NULL,
    "file_urls" varchar[]   NOT NULL,
    "gallery_type" varchar   NOT NULL,
    "media_type" bigint   NOT NULL,
    "units_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_unit_media" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "unit_media" ADD CONSTRAINT "fk_unit_media_units_id" FOREIGN KEY("units_id")
REFERENCES "units" ("id");

COMMENT ON COLUMN project_media.media_type IS '1=>image,2=>image_360,3=>video,4=>panaroma,5=>pdf';
COMMENT ON COLUMN unit_media.media_type IS '1=>image,2=>image_360,3=>video,4=>panaroma,5=>pdf';
COMMENT ON COLUMN properties_media.media_type IS '1=>image,2=>image_360,3=>video,4=>panaroma,5=>pdf';

COMMENT ON COLUMN properties_media.properties_id IS 'id from any properties  table broker, project ,owner,freelancer properties';
COMMENT ON COLUMN properties_media.property IS 'keys 1 => project property,2=> freelancer property, 3 => broker property, 4=>owner property';