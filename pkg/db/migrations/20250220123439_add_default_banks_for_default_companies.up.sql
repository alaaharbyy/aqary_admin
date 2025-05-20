INSERT INTO bank_account_details 
(account_name, account_number, iban, countries_id, currency_id, bank_name, bank_branch, swift_code, created_at, updated_at, entity_type_id, entity_id, updated_by) VALUES
('John Doe', '630679645', 'AE07 0331 2345 6789 0123 456', 1, 1, 'FAB', '9403356122', '5722153633840301', now(), now(), 6, 1, 1),
('John Doe', '630679645', 'AE07 0331 2345 6789 0123 456', 1, 1, 'FAB', '9403356122', '5722153633840301', now(), now(), 6, 2, 1);

INSERT INTO locations (lat, lng, created_at, updated_at) VALUES
('24.456237315585014', '54.37532988312636', '2025-02-20 07:02:37.156327+00', '2025-02-20 07:02:37.156327+00');
UPDATE addresses SET locations_id = (SELECT max(id) from locations) WHERE id = 2;

INSERT INTO locations (lat, lng, created_at, updated_at) VALUES
('24.456237315585014', '54.37532988312636', '2025-02-20 07:02:37.156327+00', '2025-02-20 07:02:37.156327+00');
UPDATE addresses SET locations_id = (SELECT max(id) from locations) WHERE id = 3;

INSERT INTO license(license_no,license_type_id,state_id,entity_type_id,entity_id)
VALUES('finehome123brn',2,1,6,1),('aqaryinvestment123brn',2,1,6,1),
('finehome123orn',3,1,6,1),('aqaryinvestment123orn',3,1,6,1);



CREATE TABLE "user_review" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "user_id" bigint   NOT NULL,
    "knowledge" int   NOT NULL,
    "expertise" int   NOT NULL,
    "responsiveness" int   NOT NULL,
    "negotiation" int   NOT NULL,
    "review_description" varchar   NOT NULL,
    "proof_images" varchar[]   NOT NULL,
    "reviewed_by" bigint   NOT NULL,
    "reviewed_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_user_review" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "user_review" ADD CONSTRAINT "fk_user_review_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "user_review" ADD CONSTRAINT "fk_user_review_reviewed_by" FOREIGN KEY("reviewed_by")
REFERENCES "users" ("id");