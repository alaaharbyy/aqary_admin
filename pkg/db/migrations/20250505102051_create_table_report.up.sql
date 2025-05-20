CREATE TABLE "reports" (
    "id" bigserial   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "category" bigint NOT NULL, -- e.g., 'Spam', 'Copyright', 'Scam', 'Inappropriate', 'Others'
    "message" varchar NULL,
    "status" bigint NOT NULL,
    "created_by" bigint NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NOT NULL
);