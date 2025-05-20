CREATE TABLE entity_service_locations (
  id BIGSERIAL PRIMARY KEY,         
  entity_id BIGINT NOT NULL,    
  entity_type_id BIGINT NOT NULL,
  country_id BIGINT NOT NULL,
  state_id BIGINT NOT NULL,        
  city_id BIGINT NOT NULL,
  community_id BIGINT,
  sub_community_id BIGINT,
  created_at timestamptz  DEFAULT now() NOT NULL,
  updated_at timestamptz  DEFAULT now() NOT NULL
);
