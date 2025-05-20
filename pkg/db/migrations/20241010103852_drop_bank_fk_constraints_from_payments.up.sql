ALTER TABLE payments
DROP CONSTRAINT IF EXISTS fk_payments_bank,
ADD COLUMN reference_no varchar NULL,
ALTER COLUMN due_date SET NOT NULL;