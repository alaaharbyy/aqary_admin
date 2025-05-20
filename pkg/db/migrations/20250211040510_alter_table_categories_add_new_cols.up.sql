ALTER TABLE categories ADD COLUMN "type" bigint NOT NULL DEFAULT 1;
ALTER TABLE categories ALTER COLUMN "type" DROP DEFAULT;

INSERT INTO categories(category,created_at,updated_at,updated_by,"type")
SELECT category,now(),now(),updated_by,2 FROM categories;

COMMENT ON COLUMN categories.type IS '1=>facility, 2=>amenity';