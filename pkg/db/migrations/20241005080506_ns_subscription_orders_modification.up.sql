ALTER TABLE subscription_order ADD COLUMN is_free bool  DEFAULT false NOT NULL;
ALTER TABLE subscription_order ALTER COLUMN is_free DROP DEFAULT;