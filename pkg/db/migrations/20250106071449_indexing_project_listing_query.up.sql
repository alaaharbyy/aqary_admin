CREATE INDEX idx_phases_projects_id ON phases (projects_id);
CREATE INDEX idx_property_entity ON property (entity_id, entity_type_id);
CREATE INDEX idx_property_property_type_id ON property (property_type_id);
CREATE INDEX idx_property_versions_property_id ON property_versions (property_id);