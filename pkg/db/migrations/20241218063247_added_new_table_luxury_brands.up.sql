CREATE TABLE "luxury_brands" (
    "id" bigserial   NOT NULL,
    "brand_name" varchar   NOT NULL,
    "description" varchar  NULL,
    "logo_url" varchar   NOT NULL,
    "status" bigint NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_luxury_brands" PRIMARY KEY (
        "id"
    ),
    CONSTRAINT "uq_brand_name" UNIQUE ("brand_name") 
);