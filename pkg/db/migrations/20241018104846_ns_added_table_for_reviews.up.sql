CREATE TABLE "entity_review" (
    "id" bigserial   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "description" varchar   NOT NULL,
    "title" varchar   NOT NULL,
    "reviewer" bigint   NOT NULL,
    "review_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_entity_review" PRIMARY KEY (
        "id"
     )
);
CREATE TABLE "review_terms" (
    "id" bigserial   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "review_term" varchar   NOT NULL,
    CONSTRAINT "pk_review_terms" PRIMARY KEY (
        "id"
     )
);
 
 
CREATE TABLE "reviews_table" (
    "id" bigserial   NOT NULL,
    "entity_review_id" bigint   NOT NULL,
    "review_term_id" bigint   NOT NULL,
    "review_value" int   NOT NULL,
    CONSTRAINT "pk_reviews_table" PRIMARY KEY (
        "id"
     )
);
 
 
ALTER TABLE "entity_review" ADD CONSTRAINT "fk_entity_review_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");
 
ALTER TABLE "entity_review" ADD CONSTRAINT "fk_entity_review_reviewer" FOREIGN KEY("reviewer")
REFERENCES "users" ("id");
 
ALTER TABLE "review_terms" ADD CONSTRAINT "fk_review_terms_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");
 
ALTER TABLE "reviews_table" ADD CONSTRAINT "fk_reviews_table_entity_review_id" FOREIGN KEY("entity_review_id")
REFERENCES "entity_review" ("id");
 
ALTER TABLE "reviews_table" ADD CONSTRAINT "fk_reviews_table_review_term_id" FOREIGN KEY("review_term_id")
REFERENCES "review_terms" ("id");