ALTER TABLE subscription_package ADD COLUMN original_price_per_unit float DEFAULT 0.0 NOT NULL;
ALTER TABLE subscription_package ALTER COLUMN original_price_per_unit DROP DEFAULT;

ALTER TABLE subscription_order
ALTER COLUMN payment_plan DROP NOT NULL,
DROP COLUMN IF EXISTS  is_free,
DROP COLUMN IF EXISTS contract_file;

ALTER TABLE subscription_products
ALTER COLUMN icon_url DROP NOT NULL;