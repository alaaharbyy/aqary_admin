ALTER TABLE currency ADD COLUMN currency_rate float8 DEFAULT 1;
ALTER TABLE currency ALTER COLUMN currency_rate DROP DEFAULT;