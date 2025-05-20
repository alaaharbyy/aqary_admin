DROP FUNCTION IF EXISTS refresh_autocomplete_view() CASCADE;
DROP MATERIALIZED VIEW IF EXISTS autocomplete_view CASCADE;

DROP FUNCTION IF EXISTS refresh_section_permission_mv() CASCADE;
DROP MATERIALIZED VIEW IF EXISTS section_permission_mv CASCADE;

DROP FUNCTION IF EXISTS refresh_permissions_mv() CASCADE;
DROP MATERIALIZED VIEW IF EXISTS permissions_mv CASCADE;

DROP FUNCTION IF EXISTS refresh_sub_section_mv() CASCADE;
DROP MATERIALIZED VIEW IF EXISTS sub_section_mv CASCADE;

DROP FUNCTION IF EXISTS refresh_hierarchical_location_view() CASCADE;
DROP MATERIALIZED VIEW IF EXISTS hierarchical_location_view CASCADE;

DROP FUNCTION IF EXISTS refresh_property_quality_score() CASCADE;
DROP MATERIALIZED VIEW IF EXISTS property_quality_score CASCADE;

DROP TRIGGER IF EXISTS trigger_update_full_address ON addresses CASCADE;
DROP FUNCTION IF EXISTS update_full_address() CASCADE;

DROP TRIGGER IF EXISTS before_request_insert_trigger ON requests_verification CASCADE;
DROP FUNCTION IF EXISTS generate_unique_ref_no() CASCADE;

DROP TRIGGER IF EXISTS property_slug_trigger ON property_versions CASCADE;
DROP FUNCTION IF EXISTS generate_property_slug() CASCADE;

DROP TRIGGER IF EXISTS project_slug_trigger ON projects CASCADE;
DROP FUNCTION IF EXISTS generate_project_slug() CASCADE;

DROP TRIGGER IF EXISTS unit_versions_slug_trigger ON unit_versions CASCADE;
DROP FUNCTION IF EXISTS generate_unit_version_slug() CASCADE;

DROP TRIGGER IF EXISTS services_slug_trigger ON services CASCADE;
DROP FUNCTION IF EXISTS generate_service_slug() CASCADE;