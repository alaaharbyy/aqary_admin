ALTER TABLE payment_plans ADD COLUMN is_enabled bool DEFAULT TRUE NOT NULL;
ALTER TABLE payment_plans_packages DROP COLUMN is_enabled;