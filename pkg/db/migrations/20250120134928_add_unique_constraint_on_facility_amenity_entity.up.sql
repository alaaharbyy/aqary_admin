WITH duplicates AS (
  SELECT 
    ctid,  -- PostgreSQL internal row identifier
    ROW_NUMBER() OVER (PARTITION BY entity_type_id, entity_id, facility_amenity_id ORDER BY ctid) AS rn
  FROM facilities_amenities_entity
)
DELETE FROM facilities_amenities_entity
WHERE ctid IN (
  SELECT ctid
  FROM duplicates
  WHERE rn > 1  -- Delete duplicates, keeping one
);

ALTER TABLE facilities_amenities_entity
ADD CONSTRAINT unique_facility_amenity_per_entity UNIQUE (entity_type_id, entity_id, facility_amenity_id);