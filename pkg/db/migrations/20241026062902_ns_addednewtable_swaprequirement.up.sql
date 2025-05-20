CREATE TABLE "swap_requirement" (
    "id" bigserial   NOT NULL,
    -- addresses_id bigint FK >- addresses.id
    -- property_id bigint FK >- property.id
    "entity_type" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "category" bigint   NOT NULL,
    -- if the category isn't unit this field required
    "property_type" bigint   NULL,
    -- if the category is unit this field required
    "unit_types" bigint   NULL,
    "no_of_bathrooms" bigint   NULL,
    "no_of_bedrooms" bigint   NULL,
    "min_plot_area" float   NULL,
    "max_plot_area" float   NULL,
    "completion_status" int   NULL,
    "min_no_of_units" bigint   NULL,
    "max_no_of_units" bigint   NULL,
    "min_no_of_floors" bigint   NULL,
    "max_no_of_floors" bigint   NULL,
    "views" bigint[]   NULL,
    "min_no_of_parkings" bigint   NULL,
    "max_no_of_parkings" bigint   NULL,
    "min_built_up_area" bigint   NULL,
    "max_built_up_area" bigint   NULL,
    "min_price" bigint   NULL,
    "max_price" bigint   NULL,
    "ownership" bigint   NOT NULL,
    "furnished" bigint   NULL,
    "mortgage" bool   NOT NULL,
    "notes" varchar   NULL,
    "notes_arabic" varchar   NULL,
    "is_notes_public" bool   NOT NULL,
    CONSTRAINT "pk_swap_requirement" PRIMARY KEY (
        "id"
     )
);
 
CREATE TABLE "swap_requirment_address" (
    "id" bigserial   NOT NULL,
    "swap_requirment_id" bigint   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    CONSTRAINT "pk_swap_requirment_address" PRIMARY KEY (
        "id"
     )
);
 
 
ALTER TABLE "swap_requirement" ADD CONSTRAINT "fk_swap_requirement_entity_type" FOREIGN KEY("entity_type")
REFERENCES "entity_type" ("id");
 
ALTER TABLE "swap_requirment_address" ADD CONSTRAINT "fk_swap_requirment_address_swap_requirment_id" FOREIGN KEY("swap_requirment_id")
REFERENCES "swap_requirement" ("id");

CREATE TABLE "platform_contacts" (
    "id" bigserial   NOT NULL,
    "name" varchar(255) NOT NULL,
    "email" varchar(255) NOT NULL,
    "message" varchar(255) NOT NULL,
    "platform" bigserial  NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "uc_platform_contacts_email_platform" UNIQUE (
        "email","platform"
    ),
     CONSTRAINT "pk_platform_contacts" PRIMARY KEY (
        "id"
     )
);