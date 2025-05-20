CREATE TABLE "aqary_guide" (
    "id" bigserial   NOT NULL,
    "guide_type" varchar   NOT NULL,
    "guide_content" varchar   NOT NULL,
    "guide_content_ar" varchar   NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz   NOT NULL,
    "updated_at" timestamptz   NOT NULL,
    CONSTRAINT "pk_aqary_guide" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "aqary_guide" ADD CONSTRAINT "fk_aqary_guide_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE listing_request
ALTER COLUMN name DROP NOT NULL,
ALTER COLUMN description DROP NOT NULL;
