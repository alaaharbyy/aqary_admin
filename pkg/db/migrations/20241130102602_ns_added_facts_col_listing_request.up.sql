ALTER TABLE listing_request ADD COLUMN facts jsonb NOT NULL DEFAULT '{}';
ALTER TABLE listing_request ALTER COLUMN facts DROP DEFAULT;