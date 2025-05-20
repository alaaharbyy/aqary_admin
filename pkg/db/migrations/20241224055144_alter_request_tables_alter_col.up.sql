ALTER TABLE requests_type
ALTER COLUMN status TYPE BOOLEAN
USING CASE 
    WHEN status = 't' THEN TRUE
    WHEN status = 'f' THEN FALSE
    ELSE NULL
END;

ALTER TABLE requests_verification
ALTER COLUMN status TYPE BOOLEAN
USING CASE 
    WHEN status = '1' THEN TRUE
    WHEN status = '2' THEN FALSE
    ELSE NULL
END;