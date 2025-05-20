ALTER TABLE refresh_schedules
ADD CONSTRAINT unique_entity_schedule
UNIQUE (entity_id, entity_type_id);
