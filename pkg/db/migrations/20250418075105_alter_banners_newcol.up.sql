ALTER TABLE "banners"
ADD COLUMN "banner_cost_id" BIGINT NOT NULL;
 
ALTER TABLE "banners"
ADD CONSTRAINT "fk_banner_cost_id" FOREIGN KEY ("banner_cost_id")
REFERENCES "banner_plan_cost" ("id");
 