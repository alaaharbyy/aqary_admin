
ALTER TABLE addresses
DROP COLUMN IF EXISTS full_address,
ADD COLUMN full_address varchar NULL;


CREATE OR REPLACE FUNCTION update_full_address() 
RETURNS TRIGGER AS $$
BEGIN
    -- Start building the address from the country, state, and city
    NEW.full_address := 
        COALESCE((SELECT country FROM countries WHERE id = NEW.countries_id), '') ||
        CASE WHEN COALESCE((SELECT country FROM countries WHERE id = NEW.countries_id), '') <> '' THEN ', ' ELSE '' END ||
        COALESCE((SELECT state FROM states WHERE id = NEW.states_id), '') ||
        CASE WHEN COALESCE((SELECT state FROM states WHERE id = NEW.states_id), '') <> '' THEN ', ' ELSE '' END ||
        COALESCE((SELECT city FROM cities WHERE id = NEW.cities_id), '') ||
        CASE WHEN COALESCE((SELECT city FROM cities WHERE id = NEW.cities_id), '') <> '' THEN ', ' ELSE '' END ||
        COALESCE((SELECT community FROM communities WHERE id = NEW.communities_id), '') ||
        CASE WHEN COALESCE((SELECT community FROM communities WHERE id = NEW.communities_id), '') <> '' THEN ', ' ELSE '' END ||
        COALESCE((SELECT sub_community FROM sub_communities WHERE id = NEW.sub_communities_id), '') ||
        CASE WHEN COALESCE((SELECT sub_community FROM sub_communities WHERE id = NEW.sub_communities_id), '') <> '' THEN ', ' ELSE '' END ||
        COALESCE((SELECT property FROM properties_map_location WHERE id = NEW.property_map_location_id), '');

    -- Remove any trailing comma and space
    NEW.full_address := rtrim(NEW.full_address, ', ');

    -- Return the modified row
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



DROP TRIGGER IF EXISTS trigger_update_full_address ON addresses CASCADE;

CREATE TRIGGER trigger_update_full_address
BEFORE INSERT OR UPDATE ON addresses
FOR EACH ROW
EXECUTE FUNCTION update_full_address();


-- update the existing data
UPDATE addresses
SET full_address = 
    COALESCE((SELECT country FROM countries WHERE id = addresses.countries_id), '') ||
    CASE WHEN COALESCE((SELECT country FROM countries WHERE id = addresses.countries_id), '') <> '' THEN ', ' ELSE '' END ||
    COALESCE((SELECT state FROM states WHERE id = addresses.states_id), '') ||
    CASE WHEN COALESCE((SELECT state FROM states WHERE id = addresses.states_id), '') <> '' THEN ', ' ELSE '' END ||
    COALESCE((SELECT city FROM cities WHERE id = addresses.cities_id), '') ||
    CASE WHEN COALESCE((SELECT city FROM cities WHERE id = addresses.cities_id), '') <> '' THEN ', ' ELSE '' END ||
    COALESCE((SELECT community FROM communities WHERE id = addresses.communities_id), '') ||
    CASE WHEN COALESCE((SELECT community FROM communities WHERE id = addresses.communities_id), '') <> '' THEN ', ' ELSE '' END ||
    COALESCE((SELECT sub_community FROM sub_communities WHERE id = addresses.sub_communities_id), '') ||
    CASE WHEN COALESCE((SELECT sub_community FROM sub_communities WHERE id = addresses.sub_communities_id), '') <> '' THEN ', ' ELSE '' END ||
    COALESCE((SELECT property FROM properties_map_location WHERE id = addresses.property_map_location_id), '');