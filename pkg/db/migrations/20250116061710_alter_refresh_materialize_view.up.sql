DROP FUNCTION IF EXISTS refresh_property_quality_score;

CREATE OR REPLACE FUNCTION refresh_property_quality_score()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW property_quality_score;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS refresh_autocomplete_view;

CREATE OR REPLACE FUNCTION refresh_autocomplete_view()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW autocomplete_view;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS refresh_hierarchical_location_view;

CREATE OR REPLACE FUNCTION refresh_hierarchical_location_view()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW hierarchical_location_view;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS refresh_permissions_mv;

CREATE OR REPLACE FUNCTION refresh_permissions_mv()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW permissions_mv;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS refresh_section_permission_mv;

CREATE OR REPLACE FUNCTION refresh_section_permission_mv()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW section_permission_mv;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS refresh_sub_section_mv;

CREATE OR REPLACE FUNCTION refresh_sub_section_mv()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW sub_section_mv;
END;
$$ LANGUAGE plpgsql;