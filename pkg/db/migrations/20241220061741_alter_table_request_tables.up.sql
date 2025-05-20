ALTER TABLE request_data ADD COLUMN field_type VARCHAR DEFAULT NULL;
ALTER TABLE approvals ADD COLUMN required_fields bigint[] DEFAULT NULL;