ALTER TABLE company_activities RENAME COLUMN tag_id TO tags;
ALTER TABLE company_activities ALTER COLUMN tags SET DATA TYPE varchar[];
ALTER TABLE company_activities ALTER COLUMN status SET DEFAULT 2;
ALTER TABLE company_category ALTER COLUMN status SET DEFAULT 2;

DELETE FROM facilities_amenities_entity WHERE facility_amenity_id IN (83 ,92,94,211,219,223);

DELETE FROM facilities_amenities WHERE id = 92;
DELETE FROM facilities_amenities WHERE id = 94;
DELETE FROM facilities_amenities WHERE id = 211;
DELETE FROM facilities_amenities WHERE id = 219;
DELETE FROM facilities_amenities WHERE id = 223;

ALTER TABLE facilities_amenities ADD CONSTRAINT uc_facilities_amenities_title_type_categories UNIQUE(
    title,type,categories
);
