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