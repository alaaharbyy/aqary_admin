CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX IF NOT EXISTS "idx_appointment_client_id"
ON "appointment" ("client_id");

CREATE INDEX IF NOT EXISTS idx_sharing_entity ON sharing(entity_type_id, entity_id);
CREATE INDEX IF NOT EXISTS idx_sharing_shared_to ON sharing(shared_to);
CREATE INDEX IF NOT EXISTS idx_shared_documents_sharing ON shared_documents(sharing_id);
CREATE INDEX IF NOT EXISTS idx_shared_documents_category ON shared_documents(category_id, subcategory_id);
CREATE INDEX IF NOT EXISTS idx_shared_documents_status ON shared_documents(status);
CREATE INDEX IF NOT EXISTS idx_share_requests_document ON share_requests(document_id);
CREATE INDEX IF NOT EXISTS idx_share_requests_status ON share_requests(request_status);
CREATE INDEX IF NOT EXISTS idx_share_requests_requester ON share_requests(requester_id);


CREATE INDEX IF NOT EXISTS idx_entity_review_entity ON entity_review(entity_type_id, entity_id);
CREATE INDEX IF NOT EXISTS idx_entity_review_reviewer ON entity_review(reviewer);
CREATE INDEX IF NOT EXISTS idx_review_terms_entity_type ON review_terms(entity_type_id);
CREATE INDEX IF NOT EXISTS idx_reviews_table_entity_review ON reviews_table(entity_review_id);
CREATE INDEX IF NOT EXISTS idx_reviews_table_review_term ON reviews_table(review_term_id);

--------------- Indexing for Project listing -----------------------
CREATE INDEX IF NOT EXISTS idx_phases_projects_id ON phases (projects_id);
CREATE INDEX IF NOT EXISTS idx_property_entity ON property (entity_id, entity_type_id);
CREATE INDEX IF NOT EXISTS idx_property_property_type_id ON property (property_type_id);
CREATE INDEX IF NOT EXISTS idx_property_versions_property_id ON property_versions (property_id);
--------------- Indexing for Project listing -----------------------

-- Create indexes
CREATE UNIQUE INDEX ON hierarchical_location_view (id);
CREATE INDEX IF NOT EXISTS hierarchical_location_view_location_id_idx ON hierarchical_location_view (location_id);
CREATE INDEX IF NOT EXISTS hierarchical_location_view_country_idx ON hierarchical_location_view (country_id);
CREATE INDEX IF NOT EXISTS hierarchical_location_view_state_idx ON hierarchical_location_view (state_id);
CREATE INDEX IF NOT EXISTS hierarchical_location_view_city_idx ON hierarchical_location_view (city_id);
CREATE INDEX IF NOT EXISTS hierarchical_location_view_community_idx ON hierarchical_location_view (community_id);
CREATE INDEX IF NOT EXISTS hierarchical_location_view_sub_community_idx ON hierarchical_location_view (sub_community_id);
CREATE INDEX IF NOT EXISTS hierarchical_location_view_property_map_idx ON hierarchical_location_view (property_map_id);
CREATE INDEX IF NOT EXISTS hierarchical_location_view_location_string_idx ON hierarchical_location_view USING gin (location_string gin_trgm_ops);
CREATE INDEX IF NOT EXISTS hierarchical_location_view_level_idx ON hierarchical_location_view (level);
CREATE INDEX IF NOT EXISTS hierarchical_location_view_search_idx ON hierarchical_location_view USING gin(search_vector);

CREATE INDEX IF NOT EXISTS idx_project_search_ownership
ON projects((projects.facts->>'ownership'));

CREATE INDEX IF NOT EXISTS idx_project_search_completion_status
ON projects((projects.facts->>'completion_status'));

CREATE INDEX IF NOT EXISTS idx_units_search_unittype
ON units(unit_type_id);

CREATE INDEX IF NOT EXISTS idx_units_search_bathroom
ON units((units.facts->>'bathroom'));

CREATE INDEX IF NOT EXISTS idx_units_search_bedroom
ON units((units.facts->>'bedroom'));

CREATE INDEX IF NOT EXISTS idx_units_search_parking
ON units((units.facts->>'parking'));

CREATE INDEX IF NOT EXISTS idx_property_search_propertytype
ON property(property_type_id);

CREATE INDEX IF NOT EXISTS idx_property_search
ON property (
    exclusive,
    company_id,
    is_verified,
    (facts->>'roi'),
    (facts->>'life_style')
);
 
 
CREATE INDEX IF NOT EXISTS idx_property_versions_search
ON property_versions (
    status,
    category,
    (property_versions.facts->>'investment')
);

CREATE INDEX IF NOT EXISTS idx_units_search
ON units (
    exclusive,
    company_id,
    is_verified,
    (units.facts->>'roi'),
    (units.facts->>'life_style')
);
 
 
CREATE INDEX IF NOT EXISTS idx_unit_versions_search
ON unit_versions (
    status,
    type,
    (unit_versions.facts->>'investment')
);


CREATE INDEX IF NOT EXISTS idx_media_entity_filter
ON global_media (
	entity_id,
	entity_type_id,
	media_type
);
 
CREATE INDEX IF NOT EXISTS idx_media_media_type
ON global_media (media_type);
 
 
CREATE INDEX IF NOT EXISTS idx_media_entity_type_and_id
ON global_media (entity_type_id,entity_id);
 
 
CREATE INDEX IF NOT EXISTS idx_media_entity_id
ON global_media (entity_id);
 
 
CREATE INDEX IF NOT EXISTS idx_media_entity_type
ON global_media (entity_type_id);

CREATE INDEX IF NOT EXISTS idx_payment_plans_packages_entity
ON payment_plans_packages (
	entity_id,
	entity_type_id
);
 
 
 
CREATE INDEX IF NOT EXISTS idx_plan_installments_filter 
ON plan_installments (
	payment_plans,
	date
);

CREATE INDEX IF NOT EXISTS idx_swap_requirement_entity
ON swap_requirement(
	entity_id,
	entity_type
);
 
 
CREATE INDEX IF NOT EXISTS idx_swap_requirment_address_filter
ON swap_requirment_address (swap_requirment_id);

CREATE INDEX IF NOT EXISTS idx_facilities_amenities_join_check
ON facilities_amenities(id,type);
 
CREATE INDEX IF NOT EXISTS idx_facilities_amenities_type
ON facilities_amenities(type);
 
CREATE INDEX IF NOT EXISTS idx_facilities_amenities_entity_join_check
ON facilities_amenities_entity(entity_id,entity_type_id);