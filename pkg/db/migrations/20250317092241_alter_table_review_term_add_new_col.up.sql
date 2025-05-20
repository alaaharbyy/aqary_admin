ALTER TABLE review_terms
ADD COLUMN status bigint NOT NULL DEFAULT 2,
ADD COLUMN created_at timestamptz NOT NULL DEFAULT now(),
ADD COLUMN updated_at timestamptz NOT NULL DEFAULT now();  