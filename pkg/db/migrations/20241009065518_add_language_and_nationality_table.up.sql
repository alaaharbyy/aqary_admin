


CREATE TABLE "profile_languages" (
    "id" bigserial   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "all_languages_id" bigint   NOT NULL,
    CONSTRAINT "pk_profile_languages" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "profile_nationalities" (
    "id" bigserial   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "country_id" bigint   NOT NULL,
    CONSTRAINT "pk_profile_nationalities" PRIMARY KEY (
        "id"
     )
);


ALTER TABLE "profile_languages" ADD CONSTRAINT "fk_profile_languages_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "profile_languages" ADD CONSTRAINT "fk_profile_languages_all_languages_id" FOREIGN KEY("all_languages_id")
REFERENCES "all_languages" ("id");

ALTER TABLE "profile_nationalities" ADD CONSTRAINT "fk_profile_nationalities_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "profile_nationalities" ADD CONSTRAINT "fk_profile_nationalities_country_id" FOREIGN KEY("country_id")
REFERENCES "countries" ("id");