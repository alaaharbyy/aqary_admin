-- 1. Drop columns banner_type and platform_id
ALTER TABLE "banners"
DROP COLUMN "banner_type",
DROP COLUMN "platform_id";

-- 2. Add new column banner_order_id (not null if every banner must be linked)
ALTER TABLE "banners"
ADD COLUMN "banner_order_id" BIGINT NOT NULL;

-- 3. Add foreign key constraint
ALTER TABLE "banners"
ADD CONSTRAINT "fk_banner_order_id" FOREIGN KEY ("banner_order_id")
REFERENCES "banner_order" ("id");
