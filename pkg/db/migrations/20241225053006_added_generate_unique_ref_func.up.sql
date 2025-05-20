CREATE OR REPLACE FUNCTION generate_unique_ref_no()
RETURNS TRIGGER AS $$
DECLARE
    new_ref_no VARCHAR(12);  -- To store the generated reference number with the prefix
BEGIN
    -- Prefix for the reference number
    -- You can change 'REF-' to any other string if needed
    LOOP
        -- Generate a random 6-digit number
        new_ref_no := 'REQ-' || LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');

        -- Check if the generated ref_no already exists
        IF NOT EXISTS (SELECT 1 FROM requests_verification WHERE ref_no = new_ref_no) THEN
            -- If unique, assign it to the new row
            NEW.ref_no := new_ref_no;
            RETURN NEW;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER before_request_insert_trigger
BEFORE INSERT ON requests_verification
FOR EACH ROW
EXECUTE FUNCTION generate_unique_ref_no();


ALTER TABLE requests_verification
ADD COLUMN ref_no VARCHAR NOT NULL;