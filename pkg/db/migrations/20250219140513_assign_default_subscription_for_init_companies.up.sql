ALTER TABLE subscription_order ALTER COLUMN sign_date DROP NOT NULL;

-- INSERT INTO subscription_order
-- (order_no, subscriber_id, subscriber_type, start_date, end_date, sign_date, total_amount, vat, no_of_payments, payment_plan, notes, status, created_by, created_at, updated_at) VALUES
-- ('ORD_0000001', 1, 1, '2025-02-01 20:00:00+00', '2026-01-31 20:00:00+00', '0001-01-01 00:00:00+00', 0, 0, 0, 0, '', 1, 1, now(), now()),
-- ('ORD_0000002', 2, 1, '2025-02-01 20:00:00+00', '2026-01-31 20:00:00+00', '0001-01-01 00:00:00+00', 0, 0, 0, 0, '', 1, 1, now(), now());

-- INSERT INTO subscription_package 
-- (subscription_order_id, product, no_of_products, original_price_per_unit, product_discount, start_date, end_date, created_by, created_at, updated_at) VALUES
-- (16, 1, 3000, 10, 100, '2025-02-01 20:00:00+00', '2026-01-31 20:00:00+00', 1, '2025-02-17 13:58:50.2371+00', '2025-02-17 13:58:50.2371+00'),
-- (16, 2, 3000, 15, 100, '2025-02-01 20:00:00+00', '2026-01-31 20:00:00+00', 1, '2025-02-17 13:58:50.2371+00', '2025-02-17 13:58:50.2371+00'),
-- (16, 3, 3000, 20, 100, '2025-02-01 20:00:00+00', '2026-01-31 20:00:00+00', 1, '2025-02-17 13:58:50.2371+00', '2025-02-17 13:58:50.2371+00'),
-- (16, 4, 3000, 25, 100, '2025-02-01 20:00:00+00', '2026-01-31 20:00:00+00', 1, '2025-02-17 13:58:50.2371+00', '2025-02-17 13:58:50.2371+00'),

-- (17, 1, 3000, 10, 100, '2025-02-01 20:00:00+00', '2026-01-31 20:00:00+00', 1, '2025-02-17 13:58:50.2371+00', '2025-02-17 13:58:50.2371+00'),
-- (17, 2, 3000, 15, 100, '2025-02-01 20:00:00+00', '2026-01-31 20:00:00+00', 1, '2025-02-17 13:58:50.2371+00', '2025-02-17 13:58:50.2371+00'),
-- (17, 3, 3000, 20, 100, '2025-02-01 20:00:00+00', '2026-01-31 20:00:00+00', 1, '2025-02-17 13:58:50.2371+00', '2025-02-17 13:58:50.2371+00'),
-- (17, 4, 3000, 25, 100, '2025-02-01 20:00:00+00', '2026-01-31 20:00:00+00', 1, '2025-02-17 13:58:50.2371+00', '2025-02-17 13:58:50.2371+00');

-- INSERT INTO agent_products
-- (company_user_id, product, no_of_products, created_by, created_at, updated_at) VALUES
-- (1, 1, 1500, 1, now(), now()),
-- (1, 2, 1500, 2, now(), now()),
-- (1, 3, 1500, 3, now(), now()),
-- (1, 4, 1500, 4, now(), now()),
-- (2, 1, 1500, 1, now(), now()),
-- (2, 2, 1500, 2, now(), now()),
-- (2, 3, 1500, 3, now(), now()),
-- (2, 4, 1500, 4, now(), now());

-- INSERT INTO company_verification 
-- (entity_type_id, entity_id, verification_type, verification, response_date, updated_by, notes, contract_file, contract_upload_date, uploaded_by, upload_notes, created_at, draft_contract) VALUES
-- (6, 1, 2, 2, now(), 1, '', '', now(), 1, NULL, now(), ''),
-- (6, 2, 2, 2, now(), 1, '', '', now(), 1, NULL, now(), '');

-- UPDATE companies SET status = 2 WHERE id  IN (1,2);
-- UPDATE users SET phone_number = '505552525', country_code = 971 WHERE id  IN (2,3);