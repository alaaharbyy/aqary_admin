DROP TABLE IF EXISTS single_share_doc CASCADE;
DROP TABLE IF EXISTS shared_doc CASCADE;

CREATE TABLE "single_share_doc" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar   NOT NULL,
    "is_allowed" bool   NOT NULL,
    CONSTRAINT "pk_single_share_doc" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "shared_doc" (
    "id" bigserial   NOT NULL,
    -- this id can be from internal or external sharing
    "sharing_id" bigint   NOT NULL,
    -- from here you are gonna know which foriegn key it is if true then it will be from internal other wise external
    "is_internal" bool  DEFAULT false NOT NULL,
    -- it will be an array of single share doc table
    "single_share_docs" bigint[]   NOT NULL,
    "is_project" bool   NULL,
    "project_id" bigint   NULL,
    -- is_project_branch bool DEFAULT=FALSE
    "is_property" bool   NULL,
    "is_property_branch" bool   NULL,
    -- is_unit_branch bool DEFAULT=FALSE
    "property_id" bigint   NULL,
    "property_key" bigint   NULL,
    -- owners_info bool DEFAULT=FALSE
    "is_unit" bool   NULL,
    "unit_id" bigint   NULL,
    "unit_category" varchar   NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    -- it can shared to company or user i.e external company id  or shared_to   // TODO: we have to change it to the array
    "shared_to" bigint   NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    "phase_id" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_shared_doc" PRIMARY KEY (
        "id"
     )
);



ALTER TABLE "single_share_doc" ADD CONSTRAINT "fk_single_share_doc_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "single_share_doc" ADD CONSTRAINT "fk_single_share_doc_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");