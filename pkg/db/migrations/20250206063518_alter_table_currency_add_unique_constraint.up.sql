-- WITH duplicates AS (
--     SELECT id, currency,
--            ROW_NUMBER() OVER (PARTITION BY currency ORDER BY id) AS row_num
--     FROM currency
-- )
-- DELETE FROM currency
-- WHERE id IN (
--     SELECT id
--     FROM duplicates
--     WHERE row_num > 1
-- );

-- CREATE TABLE "currency_new" (
--     "id" bigserial   NOT NULL,
--     "currency" varchar(255)   NOT NULL,
--     "code" varchar(255)   NOT NULL,
--     "flag" varchar   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     "currency_rate" float8 NOT NULL,
--     "status" bigint NOT NULL,
--     "deleted_at" timestamptz NULL,
--     "updated_by" bigint NOT NULL,
--     CONSTRAINT "pk_currency_new" PRIMARY KEY (
--         "id"
--      ),
--     CONSTRAINT "uc_currency_new_currency" UNIQUE (
--         "currency"
--     ),
--     CONSTRAINT "uc_currency_new_code" UNIQUE (
--         "code"
--     )
 
-- );

-- insert into currency_new(
--   currency,
--     code,
--     flag,
--     currency_rate,
--     updated_at,
--     updated_by,
--     created_at,
--     status
-- )SELECT  currency,
--     code,
--     flag,
--     currency_rate,
--     updated_at,
--     updated_by,
--     created_at,
--     status from currency;

-- update currency_new 
--     set currency='UAE Dirham1',
--     code='AED1',
--     flag='https://aqarydashboard.blob.core.windows.net/upload/flags/1731308024339707437019319ff-f213-7e58-93ce-aeb6be6a0c9eflag-of-the-united-arab-emirates.webp'
--     where code='AED';

-- UPDATE currency_new
-- SET 
--     currency=currency||'1',
--     code = code||'1',
--     flag = flag,
--     currency_rate = currency_rate,
--     updated_at = updated_at,
--     updated_by = updated_by,
--     created_at = created_at,
--     status = status
-- WHERE id = 1;

-- insert into currency_new(
--   currency,
--     code,
--     flag,
--     currency_rate,
--     updated_at,
--     updated_by,
--     created_at,
--     status
-- )SELECT  REPLACE(currency, '1', ''),
--     REPLACE(code, '1', ''),
--     flag,
--     currency_rate,
--     updated_at,
--     updated_by,
--     created_at,
--     status from currency_new where id  = 1;

-- update currency_new 
--     set currency='UAE Dirham',
--     code='AED',
--     flag='https://aqarydashboard.blob.core.windows.net/upload/flags/1731308024339707437019319ff-f213-7e58-93ce-aeb6be6a0c9eflag-of-the-united-arab-emirates.webp'
--     where id = 1;

-- DELETE FROM currency_new WHERE code = 'AED1';

-- ALTER TABLE currency RENAME TO currency_temp;
-- ALTER TABLE currency_new RENAME TO currency;

 
-- ALTER TABLE bank_account_details DROP CONSTRAINT fk_bank_account_details_currency_id;

-- ALTER TABLE bank_account_details
-- ADD CONSTRAINT fk_bank_account_details_currency_id FOREIGN KEY (currency_id) REFERENCES currency (id);

-- DROP TABLE IF EXISTS currency_temp;

-- ALTER TABLE currency DROP CONSTRAINT uc_currency_new_currency;
-- ALTER TABLE currency DROP CONSTRAINT uc_currency_new_code;

--  ALTER TABLE currency  
--  ADD CONSTRAINT "uc_currency_currency" UNIQUE (
--         "currency"
--     ),
--     ADD CONSTRAINT "uc_currency_code" UNIQUE (
--         "code"
--     );

-- ALTER TABLE currency RENAME CONSTRAINT pk_currency_new TO pk_currency;