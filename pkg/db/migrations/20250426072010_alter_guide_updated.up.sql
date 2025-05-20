
ALTER TABLE country_guide DROP CONSTRAINT IF EXISTS country_guide_country_id_key;
ALTER TABLE state_guide DROP CONSTRAINT IF EXISTS state_guide_state_id_key;
ALTER TABLE city_guide DROP CONSTRAINT IF EXISTS city_guide_city_id_key;
ALTER TABLE country_guide ADD CONSTRAINT country_guide_country_id_status_key UNIQUE (country_id, status);
ALTER TABLE state_guide ADD CONSTRAINT state_guide_state_id_status_key UNIQUE (state_id, status);
ALTER TABLE city_guide ADD CONSTRAINT city_guide_city_id_status_key UNIQUE (city_id, status);
 
 
 