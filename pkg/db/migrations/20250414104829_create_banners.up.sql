CREATE TABLE "banners" (
    "id" bigserial NOT NULL,
    "company_id" bigint NOT NULL,
    "banner_name" varchar NOT NULL,
    "banner_type" bigint NOT NULL,
    "target_url" varchar NOT NULL,
    "platform_id" bigint NOT NULL, 
    "plan_package_id" bigint NOT NULL,
    "duration" bigint NOT NULL,
    "banner_direction" bigint NOT NULL,
    "banner_position" bigint NOT NULL,
    "media_type" bigint NOT NULL,
    "file_url" varchar NOT NULL,
    "description" varchar NULL,
    "created_by" bigint NOT NULL,
    "updated_by" bigint NULL,
    "created_at" timestamptz NOT NULL, 
    "updated_at" timestamptz NOT NULL, 
    CONSTRAINT "pk_banners" PRIMARY KEY ("id")
);

-- Add foreign key constraints
ALTER TABLE "banners" ADD CONSTRAINT "fk_company_id" FOREIGN KEY("company_id") REFERENCES "companies" ("id");
ALTER TABLE "banners" ADD CONSTRAINT "fk_plan_package_id" FOREIGN KEY("plan_package_id") REFERENCES "banner_plan_package" ("id");
ALTER TABLE "banners" ADD CONSTRAINT "fk_created_by" FOREIGN KEY("created_by") REFERENCES "users" ("id");

 
CREATE TABLE "banner_criteria" (

    "id" bigserial   NOT NULL,
    "type" bigint not null,
    "name" varchar not null,
    "banners_id" bigint not null,
    CONSTRAINT "pk_banner_criteria" PRIMARY KEY (
        "id"
     ),   
     CONSTRAINT "uc_type_name_banner_id" UNIQUE (
        "type","name","banners_id"
    )
     
    );
    
ALTER TABLE "banner_criteria" ADD CONSTRAINT "fk_banners_id" FOREIGN KEY("banners_id") REFERENCES "banners" ("id");