ALTER TABLE payments
ALTER COLUMN payment_method DROP NOT NULL,
ALTER COLUMN payment_date DROP NOT NULL,
ALTER COLUMN due_date DROP NOT NULL,
ALTER COLUMN invoice_file DROP NOT NULL,
ALTER COLUMN bank DROP NOT NULL,
ALTER COLUMN cheque_no DROP NOT NULL,
ALTER COLUMN status SET DEFAULT 1;