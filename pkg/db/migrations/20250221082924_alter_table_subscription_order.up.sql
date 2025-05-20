ALTER TABLE subscription_order 
ADD COLUMN draft_contract varchar NOT NULL DEFAULT '',
ADD COLUMN contract_file varchar NULL;

ALTER TABLE subscription_order ALTER COLUMN draft_contract DROP DEFAULT;