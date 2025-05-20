ALTER TABLE company_activities
DROP COLUMN company_type_id;

CREATE TABLE "platform_users" (  
    "id" bigserial   NOT NULL,
    "company_id" bigint NULL,
    "username" varchar NOT NULL,
    "password" varchar NOT NULL,
    "country_code" varchar NULL,
    "phone_number" bigint NULL,
    "date_of_birth" date NULL,
    "first_name" varchar NULL,
    "last_name" varchar  NULL,		
    "email" varchar NOT NULL,
    "gender"  bigint  NULL,
    "profile_image_url" varchar NULL,
    "cover_image_url" varchar NULL,
    "about" varchar NULL,
    "addresses_id" bigint NOT NULL,

    "is_phone_verified" bool NOT NULL DEFAULT false,
   "is_email_verified" bool NOT NULL DEFAULT false,
    "status" bigint NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_platform_users" PRIMARY KEY (
        "id"
     ),
  CONSTRAINT "uc_platform_company_email" UNIQUE (
        "company_id",
        "email"
    )
);
 

ALTER TABLE "platform_users" ADD CONSTRAINT "fk_platform_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");