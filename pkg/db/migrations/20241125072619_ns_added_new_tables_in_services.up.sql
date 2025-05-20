CREATE TABLE "service_promotions" (
    "id" bigserial   NOT NULL,
    "service" bigint   NOT NULL,
    "promotion_name" varchar   NOT NULL,
    "promotion_details" varchar   NOT NULL,
    "price" float   NOT NULL,
    "tags_id" bigint   NOT NULL,
    "start_date" timestamptz   NOT NULL,
    "end_date" timestamptz   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_service_promotions" PRIMARY KEY (
        "id"
     )
);


ALTER TABLE "service_promotions" ADD CONSTRAINT "fk_service_promotions_service" FOREIGN KEY("service")
REFERENCES "services" ("id");

ALTER TABLE "service_promotions" ADD CONSTRAINT "fk_service_promotions_tags_id" FOREIGN KEY("tags_id")
REFERENCES "tags" ("id");

ALTER TABLE "service_promotions" ADD CONSTRAINT "fk_service_promotions_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");
