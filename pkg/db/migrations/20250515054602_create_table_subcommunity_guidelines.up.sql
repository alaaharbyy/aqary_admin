CREATE TABLE "sub_community_guidelines" (
    "id" bigserial   NOT NULL,
    -- "title" varchar   NOT NULL,
    "country_id" bigint  NOT NULL,
    "state_id" bigint   NOT NULL,
    "city_id" bigint   NOT NULL,
    "community_id" bigint   NOT NULL,
    "sub_community_id" bigint   NOT NULL,
    "description" varchar   NOT NULL,
    "cover_image" varchar   NOT NULL,
    "insights" bigint[]  NULL,
    "sub_insights" bigint[]   NOT NULL,
    "status" bigint   NOT NULL,
    "about" varchar  NULL,
    "created_at" timestamptz   NOT NULL,
    "update_at" timestamptz   NOT NULL,
    "deleted_at" timestamptz  NULL,

    CONSTRAINT "pk_sub_community_guidelines" PRIMARY KEY (
        "id"
     ),
     CONSTRAINT "uc_sub_community_guidelines" UNIQUE (
        "sub_community_id"
     )
     
);