

CREATE TABLE "banner_order"(
	"id" bigserial NOT NULL,
	"ref_no" VARCHAR NOT NULL, 
	"company_id" BIGINT NOT NULL,
	"plan_packages" jsonb NOT NULL, 
	"total_price" FLOAT NOT NULL, 
	"start_date" timestamptz NOT NULL, 
	"end_date" timestamptz NOT NULL,
	"created_by" BIGINT NOT NULL,
	"updated_by" BIGINT NULL,
	"created_at" timestamptz NOT NULL, 
    "updated_at" timestamptz NOT NULL, 
	CONSTRAINT "pk_banner_order" PRIMARY KEY ("id")

);
 	

ALTER TABLE "banner_order" ADD CONSTRAINT "fk_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");
 
ALTER TABLE "banner_order" ADD CONSTRAINT "fk_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");
 
ALTER TABLE "banner_order" ADD CONSTRAINT "fk_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");
 