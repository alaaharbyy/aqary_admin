-- Create or replace a generic trigger function for score calculation
CREATE OR REPLACE FUNCTION calculate_entity_score()
RETURNS TRIGGER AS $$
BEGIN
    -- Calculate the score based on the formula (same for both properties and units)
    NEW.score := LEAST(100,
        CASE WHEN NEW.exclusive THEN 35 ELSE 0 END +
        CASE WHEN NEW.is_hotdeal THEN 20 ELSE 0 END +
        CASE WHEN (NEW.facts->>'life_style')::int = 3 THEN 20 ELSE 0 END +
        CASE WHEN NEW.is_verified THEN 25 ELSE 0 END
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
 
-- Drop the triggers if they already exist
DROP TRIGGER IF EXISTS update_property_score ON property_versions;
DROP TRIGGER IF EXISTS update_unit_score ON unit_versions;
 
-- Create the triggers for both tables
CREATE TRIGGER update_property_score
BEFORE INSERT OR UPDATE OF exclusive, is_hotdeal, facts, is_verified ON property_versions
FOR EACH ROW
EXECUTE FUNCTION calculate_entity_score();
 
CREATE TRIGGER update_unit_score
BEFORE INSERT OR UPDATE OF exclusive, is_hotdeal, facts, is_verified ON unit_versions
FOR EACH ROW
EXECUTE FUNCTION calculate_entity_score();