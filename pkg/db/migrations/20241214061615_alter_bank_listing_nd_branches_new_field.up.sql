ALTER TABLE bank_listing ADD COLUMN status bigint DEFAULT 1 NOT NULL;
ALTER TABLE bank_branches ADD COLUMN status bigint DEFAULT 1 NOT NULL;
ALTER TABLE bank_branches 
ADD COLUMN id bigserial  NOT NULL,
ADD CONSTRAINT pk_bank_branches PRIMARY KEY (id);