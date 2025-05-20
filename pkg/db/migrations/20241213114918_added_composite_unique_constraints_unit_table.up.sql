UPDATE units SET unit_no = id || unit_no;
ALTER TABLE units
ADD CONSTRAINT unique_unit_no_entity_type_id_entity_id_units UNIQUE (unit_no,entity_type_id,entity_id);