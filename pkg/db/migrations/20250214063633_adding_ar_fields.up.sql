ALTER TABLE views ADD COLUMN title_ar varchar NULL;
ALTER TABLE user_types ADD COLUMN user_type_ar varchar NULL;

ALTER TABLE unit_type_variation ADD COLUMN title_ar varchar NULL;
ALTER TABLE unit_type ADD COLUMN type_ar varchar NULL;
ALTER TABLE tags ADD COLUMN type_name_ar varchar NULL;
ALTER TABLE services ADD COLUMN service_name_ar varchar NULL;

ALTER TABLE service_promotions 
ADD COLUMN promotion_name_ar varchar NULL,
ADD COLUMN promotion_details_ar varchar NULL;

ALTER TABLE roles ADD COLUMN role_ar varchar NULL;
ALTER TABLE review_terms ADD COLUMN review_term_ar varchar NULL; -- not exist in schema
ALTER TABLE global_property_type ADD COLUMN type_ar varchar NULL;
ALTER TABLE global_media ADD COLUMN gallery_type_ar varchar NULL;
-- ALTER TABLE facts ADD COLUMN title_ar varchar NULL;
ALTER TABLE facilities_amenities ADD COLUMN title_ar varchar NULL;
ALTER TABLE documents_subcategory ADD COLUMN sub_category_ar varchar NULL;
ALTER TABLE documents_category ADD COLUMN category_ar varchar NULL;
ALTER TABLE company_types ADD COLUMN title_ar varchar NULL;
ALTER TABLE company_category ADD COLUMN category_name_ar varchar NULL;
ALTER TABLE blog_categories 
ADD COLUMN category_title_ar varchar NULL,
ADD COLUMN description_ar varchar NULL;

ALTER TABLE addresses 
ADD COLUMN full_address_ar varchar NULL;

ALTER TABLE countries ADD COLUMN country_ar varchar NULL;
ALTER TABLE states ADD COLUMN state_ar varchar NULL;
ALTER TABLE cities ADD COLUMN city_ar varchar NULL;
ALTER TABLE communities ADD COLUMN community_ar varchar NULL;
ALTER TABLE sub_communities ADD COLUMN sub_community_ar varchar NULL;
ALTER TABLE properties_map_location ADD COLUMN property_ar varchar NULL;