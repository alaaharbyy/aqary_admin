ALTER TABLE countries ADD COLUMN default_settings jsonb NOT NULL DEFAULT '{"base_currency":1}';
ALTER TABLE countries ALTER COLUMN default_settings DROP DEFAULT;