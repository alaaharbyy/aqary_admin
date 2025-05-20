UPDATE unit_versions SET ref_no = ref_no||id;

ALTER TABLE unit_versions
ADD CONSTRAINT uc_unit_versions_ref_no UNIQUE (ref_no);