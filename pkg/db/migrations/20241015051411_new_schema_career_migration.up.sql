DROP TABLE IF EXISTS employers CASCADE;
DROP TABLE IF EXISTS career_articles CASCADE;
DROP TABLE IF EXISTS candidates CASCADE;
DROP TABLE IF EXISTS careers CASCADE;
DROP TABLE IF EXISTS benefits CASCADE;
DROP TABLE IF EXISTS job_categories CASCADE;
DROP TABLE IF EXISTS applicants CASCADE;
DROP TABLE IF EXISTS application CASCADE;
DROP TABLE IF EXISTS applicant_milestone CASCADE;
DROP TABLE IF EXISTS skills CASCADE;
DROP TABLE IF EXISTS posted_career_portal CASCADE;
DROP TABLE IF EXISTS specialization CASCADE;
DROP TABLE IF EXISTS field_of_studies CASCADE;
DROP TABLE IF EXISTS job_portals CASCADE;

CREATE TABLE "careers" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "job_title" varchar   NOT NULL,
    "job_title_ar" varchar   NULL,
    -- full time - part time
    "employment_types" bigint   NOT NULL,
    -- remote - onsite - hybrid
    "employment_mode" bigint   NULL,
    -- contract - volunteer - internship/student - temporary - perminant
    "job_style" bigint   NULL,
    "job_categories" bigint   NOT NULL,
    -- junior - senior - expert -any
    "career_level" bigint   NULL,
    -- countries_id bigint
    -- city_id bigint null
    -- state_id bigint null
    -- community_id bigint null
    -- subcommunity_id bigint null
    "addresses_id" bigint   NOT NULL,
    "is_urgent" boolean  DEFAULT false NOT NULL,
    "job_description" varchar   NOT NULL,
    "job_image" varchar   NULL,
    "number_of_positions" bigint   NULL,
    "years_of_experience" bigint   NULL,
    "gender" bigint   NOT NULL,
    "nationality_id" bigint[]   NOT NULL,
    "min_salary" float   NULL,
    "max_salary" float   NULL,
    -- FK >- all_languages.id
    "languages" bigint[]   NULL,
    "uploaded_by" bigint   NOT NULL,
    -- date_posted timestamptz
    "date_expired" timestamptz   NOT NULL,
    -- published - deleted
    "career_status" bigint   NOT NULL,
    -- secondary - diploma - university - masters- phd -any
    "education_level" bigint   NULL,
    -- FK >- specializations.id
    "specialization" bigint[]   NULL,
    -- FK >- skills.id {1,2,3,4,5,6,7}
    "skills" bigint[]   NULL,
    -- FK >- tags.id
    "global_tagging_id" bigint[]   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- employers_id bigint FK >- employers.id
    -- benefits bigint[] NULL
    "field_of_study" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    CONSTRAINT "pk_careers" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_careers_ref_no" UNIQUE (
        "ref_no"
    )
);
 
-- Draft
-- Active
-- expired
-- Reposted
-- Closed
 
CREATE TABLE "benefits" (
    "id" bigserial   NOT NULL,
    "career" bigint   NOT NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NULL,
    "icon_url" varchar   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NULL,
    -- is_default bool NULL
    -- employer_id bigint NULL
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_benefits" PRIMARY KEY (
        "id"
     )
);
 
CREATE TABLE "job_categories" (
    "id" bigserial   NOT NULL,
    -- ref_no varchar unique
    "parent_category_id" bigint   NULL,
    "category_name" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    -- company_types_id bigint
    -- companies_id bigint
    -- is_branch bool
    "category_image" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    -- created_by bigint FK >- users.id
    "status" bigint   NOT NULL,
    -- company_name varchar NULL
    "updated_at" timestamptz   NULL,
    CONSTRAINT "pk_job_categories" PRIMARY KEY (
        "id"
     )
);
 
 
CREATE TABLE "applicants" (
    "id" bigserial   NOT NULL,
    "full_name" varchar   NOT NULL,
    "email_address" varchar   NOT NULL,
    "mobile_number" varchar   NOT NULL,
    "cv_url" varchar   NOT NULL,
    "cover_letter" varchar   NULL,
    -- applicant_info varchar
    -- users_id bigint NULL
    -- is_verified bool
    "expected_salary" float   NULL,
    "highest_education" bigint   NULL,
    "years_of_experience" bigint   NOT NULL,
    "languages" bigint[]   NULL,
    "location" varchar   NOT NULL,
    "gender" bigint   NOT NULL,
    "applicant_photo" varchar   NULL,
    "specialization" bigint[]   NULL,
    "skills" bigint[]   NULL,
    "field_of_study" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    -- updated_at timestamptz NULL
    "status" bigint   NOT NULL,
    CONSTRAINT "pk_applicants" PRIMARY KEY (
        "id"
     )
);
 
CREATE TABLE "application" (
    "id" bigserial   NOT NULL,
    "careers_id" bigint   NOT NULL,
    "applicant_id" bigint   NOT NULL,
    "status" int   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_application" PRIMARY KEY (
        "id"
     )
);
 
CREATE TABLE "applicant_milestone" (
    "id" bigserial   NOT NULL,
    "applicant_id" bigint   NOT NULL,
    "application_status" bigint   NOT NULL,
    "status_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_applicant_milestone" PRIMARY KEY (
        "id"
     )
);
 
CREATE TABLE "specialization" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NULL,
    CONSTRAINT "pk_specialization" PRIMARY KEY (
        "id"
     )
);
 
 
CREATE TABLE "skills" (
    "id" bigserial   NOT NULL,
    -- technical - academical - personal
    "skill_type" varchar   NOT NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NULL,
    CONSTRAINT "pk_skills" PRIMARY KEY (
        "id"
     )
);
 
CREATE TABLE "field_of_studies" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NULL,
    CONSTRAINT "pk_field_of_studies" PRIMARY KEY (
        "id"
     )
);
 
 
CREATE TABLE "job_portals" (
    "id" bigserial   NOT NULL,
    "portal_name" varchar   NOT NULL,
    "portal_url" varchar   NOT NULL,
    "portal_logo" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint   NOT NULL,
    "updated_at" timestamptz   NULL,
    CONSTRAINT "pk_job_portals" PRIMARY KEY (
        "id"
     )
);
 
CREATE TABLE "posted_career_portal" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "careers_id" bigint   NOT NULL,
    "job_portals_id" bigint   NOT NULL,
    "career_url" varchar   NOT NULL,
    "expiry_date" timestamptz   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NULL,
    -- published - un published
    "status" bigint   NOT NULL,
    CONSTRAINT "pk_posted_career_portal" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_posted_career_portal_ref_no" UNIQUE (
        "ref_no"
    )
);

ALTER TABLE "posted_career_portal" ADD CONSTRAINT "fk_posted_career_portal_careers_id" FOREIGN KEY("careers_id")
REFERENCES "careers" ("id");
 
ALTER TABLE "posted_career_portal" ADD CONSTRAINT "fk_posted_career_portal_job_portals_id" FOREIGN KEY("job_portals_id")
REFERENCES "job_portals" ("id");
 
ALTER TABLE "applicants" ADD CONSTRAINT "fk_applicants_field_of_study" FOREIGN KEY("field_of_study")
REFERENCES "field_of_studies" ("id");
 
ALTER TABLE "careers" ADD CONSTRAINT "fk_careers_field_of_study" FOREIGN KEY("field_of_study")
REFERENCES "field_of_studies" ("id");

ALTER TABLE "application" ADD CONSTRAINT "fk_application_applicant_id" FOREIGN KEY("applicant_id")
REFERENCES "applicants" ("id");
 
ALTER TABLE "applicant_milestone" ADD CONSTRAINT "fk_applicant_milestone_applicant_id" FOREIGN KEY("applicant_id")
REFERENCES "applicants" ("id");
 
ALTER TABLE "careers" ADD CONSTRAINT "fk_careers_job_categories" FOREIGN KEY("job_categories")
REFERENCES "job_categories" ("id");

ALTER TABLE "benefits" ADD CONSTRAINT "fk_benefits_career" FOREIGN KEY("career")
REFERENCES "careers" ("id");

ALTER TABLE "careers" ADD CONSTRAINT "fk_careers_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");
 
ALTER TABLE "careers" ADD CONSTRAINT "fk_careers_uploaded_by" FOREIGN KEY("uploaded_by")
REFERENCES "users" ("id");

ALTER TABLE "application" ADD CONSTRAINT "fk_application_careers_id" FOREIGN KEY("careers_id")
REFERENCES "careers" ("id");
 
ALTER TABLE "careers" ADD COLUMN "rank" bigint NOT NULL;


COMMENT ON COLUMN careers.employment_types IS '1=> full time 2=> part time';
COMMENT ON COLUMN careers.employment_mode IS '1=> remote 2=> onsite 3=> hybrid';
COMMENT ON COLUMN careers.job_style IS '1=> contract 2=> volunteer 3=> internship/student 4=>temporary 5=> perminant';
COMMENT ON COLUMN careers.career_level IS '1=> junior 2=> senior 3=> expert 4=> any';
COMMENT ON COLUMN careers.career_status IS '1=> published 2=> deleted';
COMMENT ON COLUMN careers.education_level IS '1=> secondary 2=> diploma 3=> university 4=> masters 5=> phd 6=> any';
COMMENT ON COLUMN careers.status IS '1=> Draft 2=> Active 3=> expired 4=> Reposted 5=> Closed';
COMMENT ON COLUMN careers.rank IS '1=> standard 2=> featured 3=> premium 4=> top deal';
