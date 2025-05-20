-- INSERT INTO categories(
--     category,updated_by
-- )SELECT category,11 FROM facilities_amenities_categories;

-- -- type
-- -- 1 - Facility
-- -- 2 - Amenity

-- INSERT INTO facilities_amenities(
--     icon_url,title,type,categories,updated_by
-- )SELECT icon_url,title,1,category_id,11 FROM facilities;

-- INSERT INTO facilities_amenities(
--     icon_url,title,type,categories,updated_by
-- )SELECT icon_url,title,2,category_id,11 FROM amenities;

-- DROP TABLE IF EXISTS facilities_amenities_categories CASCADE;
-- DROP TABLE IF EXISTS facilities CASCADE;
-- DROP TABLE IF EXISTS amenities CASCADE;