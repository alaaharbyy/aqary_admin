-- Create entity_review table if it doesn't exist
CREATE TABLE IF NOT EXISTS "entity_review" (
    "id" bigserial NOT NULL,
    "entity_type_id" bigint NOT NULL,
    "entity_id" bigint NOT NULL,
    "description" varchar NOT NULL,
    "title" varchar NOT NULL,
    "reviewer" bigint NOT NULL,
    "review_date" timestamptz DEFAULT now() NOT NULL,
    CONSTRAINT "pk_entity_review" PRIMARY KEY ("id")
);

-- Create review_terms table if it doesn't exist
CREATE TABLE IF NOT EXISTS "review_terms" (
    "id" bigserial NOT NULL,
    "entity_type_id" bigint NOT NULL,
    "review_term" varchar NOT NULL,
    CONSTRAINT "pk_review_terms" PRIMARY KEY ("id")
);

-- Create reviews_table if it doesn't exist
CREATE TABLE IF NOT EXISTS "reviews_table" (
    "id" bigserial NOT NULL,
    "entity_review_id" bigint NOT NULL,
    "review_term_id" bigint NOT NULL,
    "review_value" int NOT NULL,
    CONSTRAINT "pk_reviews_table" PRIMARY KEY ("id")
);
 

CREATE INDEX IF NOT EXISTS idx_entity_review_entity ON entity_review(entity_type_id, entity_id);
CREATE INDEX IF NOT EXISTS idx_entity_review_reviewer ON entity_review(reviewer);
CREATE INDEX IF NOT EXISTS idx_review_terms_entity_type ON review_terms(entity_type_id);
CREATE INDEX IF NOT EXISTS idx_reviews_table_entity_review ON reviews_table(entity_review_id);
CREATE INDEX IF NOT EXISTS idx_reviews_table_review_term ON reviews_table(review_term_id);

 
COMMENT ON TABLE entity_review IS 'Stores entity reviews with their basic information';
COMMENT ON TABLE review_terms IS 'Stores available review terms for different entity types';
COMMENT ON TABLE reviews_table IS 'Stores the actual review values for each review term';