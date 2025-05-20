CREATE TABLE "community_guidelines" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "country_id" bigint  NOT NULL,
    "state_id" bigint   NOT NULL,
    "city_id" bigint   NOT NULL,
    "community_id" bigint   NOT NULL,
    "description" varchar   NOT NULL,
    "cover_image" varchar   NOT NULL,
    "insights" bigint[]   NOT NULL,
    "sub_insights" bigint[]   NOT NULL,
    CONSTRAINT "pk_community_guidelines" PRIMARY KEY (
        "id"
     ),
     CONSTRAINT "uc_community_guidelines" UNIQUE (
        "country_id",
        "state_id",
        "city_id",
        "community_id"
     )
     
);

CREATE TABLE "community_guidelines_insight" (
    "id" bigserial   NOT NULL,
    "insight_name" varchar   NOT NULL,
    "insight_name_ar" varchar   NOT NULL,
    "icon" varchar   NOT NULL,
    "description_text" varchar NULL,
    CONSTRAINT "pk_community_guidelines_insight" PRIMARY KEY (
        "id"
     ),
     CONSTRAINT "uc_community_guidelines_insight" UNIQUE (
        "insight_name"
     )
);

CREATE TABLE "community_guidelines_subinsight" (
    "id" bigserial   NOT NULL,
    "insight_id" bigint   NOT NULL,
    "subinsight_name" varchar   NOT NULL,
    "subinsight_name_ar" varchar   NOT NULL,
    "icon" varchar   NOT NULL,
    "description_text" varchar NULL,
    CONSTRAINT "pk_community_guidelines_subinsight" PRIMARY KEY (
        "id"
     ),
     CONSTRAINT "uc_community_guidelines_subinsight" UNIQUE (
        "insight_id",
        "subinsight_name"
     )
);

ALTER TABLE "community_guidelines_subinsight" ADD CONSTRAINT "fk_community_guidelines_subinsight_insight_id" FOREIGN KEY("insight_id")
REFERENCES "community_guidelines_insight" ("id");