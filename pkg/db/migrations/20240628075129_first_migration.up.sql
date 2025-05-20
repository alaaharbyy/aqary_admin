--  //-------what it this ------//----

-- -- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- -- Link to schema: https://app.quickdatabasediagrams.com/#/d/D5efbj
-- -- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "sub_communities" (
    "id" bigserial   NOT NULL,
    "sub_community" varchar(255)   NOT NULL,
    "communities_id" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "lng" float   NULL,
    "lat" float   NULL,
    CONSTRAINT "pk_sub_communities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "communities" (
    "id" bigserial   NOT NULL,
    "community" varchar(255)   NOT NULL,
    "cities_id" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "lat" float   NULL,
    "lng" float   NULL,
    CONSTRAINT "pk_communities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "cities" (
    "id" bigserial   NOT NULL,
    "city" varchar(255)   NOT NULL,
    "states_id" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "lat" float   NULL,
    "lng" float   NULL,
    CONSTRAINT "pk_cities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "states" (
    "id" bigserial   NOT NULL,
    "state" varchar(255)   NOT NULL,
    "countries_id" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "lat" float   NULL,
    "lng" float   NULL,
    CONSTRAINT "pk_states" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "countries" (
    "id" bigserial   NOT NULL,
    "country" varchar(255)   NOT NULL,
    "flag" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "alpha2_code" varchar   NULL,
    "alpha3_code" varchar   NULL,
    "country_code" bigint   NULL,
    "lat" float   NULL,
    "lng" float   NULL,
    CONSTRAINT "pk_countries" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "locations" (
    "id" bigserial   NOT NULL,
    "lat" varchar(255)  DEFAULT '0.0' NOT NULL,
    "lng" varchar(255)  DEFAULT '0.0' NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_locations" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "addresses" (
    "id" bigserial   NOT NULL,
    "countries_id" bigint   NULL,
    "states_id" bigint   NULL,
    "cities_id" bigint   NULL,
    "communities_id" bigint   NULL,
    "sub_communities_id" bigint   NULL,
    "locations_id" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_addresses" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "all_languages" (
    "id" bigserial   NOT NULL,
    "language" varchar(255)   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "code" varchar   NULL,
    "flag" varchar   NULL,
    CONSTRAINT "pk_all_languages" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "facilities" (
    "id" bigserial   NOT NULL,
    "icon_url" varchar(255)   NULL,
    "title" varchar(255)   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "category_id" bigint   NOT NULL,
    CONSTRAINT "pk_facilities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "amenities" (
    "id" bigserial   NOT NULL,
    "icon_url" varchar(255)   NULL,
    "title" varchar(255)   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "category_id" bigint   NOT NULL,
    CONSTRAINT "pk_amenities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "ranks" (
    "id" bigserial   NOT NULL,
    "rank" varchar   NOT NULL,
    "price" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_ranks" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "broker_company_agents" (
    "id" bigserial   NOT NULL,
    "brn" varchar(255)   NOT NULL,
    "experience_since" timestamptz   NULL,
    -- agent user id
    "users_id" bigint   NOT NULL,
    "nationalities" bigint[]   NOT NULL,
    "brn_expiry" timestamptz   NOT NULL,
    -- any documnet use for verification of the agent
    "verification_document_url" varchar(255)   NOT NULL,
    "about" varchar(255)   NULL,
    "about_arabic" varchar(255)   NULL,
    "linkedin_profile_url" varchar(255)   NULL,
    "facebook_profile_url" varchar(255)   NULL,
    "twitter_profile_url" varchar(255)   NULL,
    "broker_companies_id" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    -- profile of the same user
    "profiles_id" bigint   NOT NULL,
    "telegram" varchar   NULL,
    "botim" varchar   NULL,
    "tawasal" varchar   NULL,
    -- foreign keys of cities table, the cities specified for the agent from where the agent will have properties or units
    "service_areas" bigint[]   NULL,
    "agent_rank" bigint   NOT NULL,
    CONSTRAINT "pk_broker_company_agents" PRIMARY KEY (
        "id"
     )
);

-- for agent subscription quota assigned by admin of the company
CREATE TABLE "agent_subscription_quota" (
    "id" bigserial   NOT NULL,
    "standard" bigint   NOT NULL,
    "featured" bigint   NOT NULL,
    "premium" bigint   NOT NULL,
    "top_deal" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "broker_company_agents_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    CONSTRAINT "pk_agent_subscription_quota" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_agent_subscription_quota_ref_no" UNIQUE (
        "ref_no"
    )
);

-- for branch agent subscription quota assigned by admin of the company
CREATE TABLE "agent_subscription_quota_branch" (
    "id" bigserial   NOT NULL,
    "standard" bigint   NOT NULL,
    "featured" bigint   NOT NULL,
    "premium" bigint   NOT NULL,
    "top_deal" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "broker_company_branches_agents_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    CONSTRAINT "pk_agent_subscription_quota_branch" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_agent_subscription_quota_branch_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "broker_agent_reviews" (
    "id" bigserial   NOT NULL,
    "rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "review" varchar(255)   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "localknowledge_rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "processexpertise_rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "responsiveness_rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "negotiationskills_rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "services_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "broker_company_agents_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_broker_agent_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "developer_companies" (
    "id" bigserial   NOT NULL,
    "company_name" varchar  NOT NULL,
    "tag_line" varchar NULL,
    "commercial_license_no" varchar   NOT NULL,
    "commercial_license_file_url" varchar   NOT NULL,
    "commercial_license_expiry" timestamptz   NOT NULL,
    "vat_no" varchar NULL,
    "vat_status" bigint   NULL,
    "vat_file_url" varchar NULL,
    "facebook_profile_url" varchar NULL,
    "instagram_profile_url" varchar NULL,
    "linkedin_profile_url" varchar NULL,
    "twitter_profile_url" varchar NULL,
    "users_id" bigint   NOT NULL, 
    "bank_account_details_id" bigint   NOT NULL,
    "no_of_employees" bigint  NULL,
    "logo_url" varchar  NOT NULL,
    "cover_image_url" varchar NULL,
    "description" varchar  NULL,
    "is_verified" bool DEFAULT false  NOT NULL,
    "website_url" varchar NULL,
    "phone_number" varchar NULL,
    "email" varchar NULL,
    "whatsapp_number" varchar  NULL,
    "addresses_id" bigint   NOT NULL,
    "company_rank" bigint DEFAULT 1  NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "country_id" bigint   NOT NULL,
    "company_type" bigint  DEFAULT 2 NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- when the commercial license registered for the first time
    "commercial_license_registration_date" timestamptz NULL,
    "commercial_license_issue_date" timestamptz  NULL,
    "extra_license_nos" varchar[] NULL,
    "extra_license_files" varchar[] NULL,
    "extra_license_names" varchar[] NULL,
    "extra_license_issue_date" timestamptz[] NULL,
    "extra_license_expiry_date" timestamptz[] NULL,
    "license_dcci_no" varchar NULL,
    "register_no" varchar NULL,
    "other_social_media" varchar[] NULL,
    "youtube_profile_url" varchar   NULL,
    "created_by" bigint   NOT NULL,
    CONSTRAINT "pk_developer_companies" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_developer_companies_company_name" UNIQUE (
        "company_name"
    ),
    CONSTRAINT "uc_developer_companies_commercial_license_no" UNIQUE (
        "commercial_license_no"
    ),
    CONSTRAINT "uc_developer_companies_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "broker_companies_branches" (
    "id" bigserial   NOT NULL,
    "broker_companies_id" bigint   NOT NULL,
    "company_name" varchar   NOT NULL,
    "description" varchar   NULL,
    "logo_url" varchar   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "email" varchar   NULL,
    "phone_number" varchar   NULL,
    "whatsapp_number" varchar   NULL,
    "commercial_license_no" varchar   NOT NULL,
    "commercial_license_file_url" varchar   NOT NULL,
    "commercial_license_expiry" timestamptz   NOT NULL,
    "rera_no" varchar   NOT NULL,
    "rera_file_url" varchar   NOT NULL,
    "rera_expiry" timestamptz   NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "website_url" varchar   NULL,
    "cover_image_url" varchar   NULL,
    "tag_line" varchar   NULL,
    "vat_no" varchar   NULL,
    "vat_status" bigint   NULL,
    "vat_file_url" varchar   NULL,
    "facebook_profile_url" varchar   NULL,
    "instagram_profile_url" varchar   NULL,
    "twitter_profile_url" varchar   NULL,
    "no_of_employees" bigint   NULL,
    -- admin of the company
    "users_id" bigint   NOT NULL,
    "linkedin_profile_url" varchar   NULL,
    "bank_account_details_id" bigint   NOT NULL,
    "company_rank" bigint  DEFAULT 1 NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "country_id" bigint   NOT NULL,
    "company_type" bigint  DEFAULT 1 NOT NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- when the rera registered for the first time
    "rera_registration_date" timestamptz   NULL,
    "rera_issue_date" timestamptz   NULL,
    -- when the commercial license registered for the first time
    "commercial_license_registration_date" timestamptz   NULL,
    "commercial_license_issue_date" timestamptz   NULL,
    "extra_license_names" varchar[]   NULL,
    "extra_license_files" varchar[]   NULL,
    "extra_license_nos" varchar[]   NULL,
    "extra_license_issue_date" timestamptz[]   NULL,
    "extra_license_expiry_date" timestamptz[]   NULL,
    "youtube_profile_url" varchar   NULL,
    "orn_license_no" varchar   NULL,
    "orn_license_file_url" varchar   NULL,
    "orn_registration_date" timestamptz   NULL,
    "orn_license_expiry" timestamptz   NULL,
    "created_by" bigint   NOT NULL,
    -- only for dubai
    "trakhees_permit_no" varchar   NULL,
    -- only for dubai
    "license_dcci_no" varchar   NULL,
    -- only for dubai
    "register_no" varchar   NULL,
    "other_social_media" varchar[]   NULL,
    CONSTRAINT "pk_broker_companies_branches" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_broker_companies_branches_company_name" UNIQUE (
        "company_name"
    ),
    CONSTRAINT "uc_broker_companies_branches_commercial_license_no" UNIQUE (
        "commercial_license_no"
    ),
    CONSTRAINT "uc_broker_companies_branches_rera_no" UNIQUE (
        "rera_no"
    ),
    CONSTRAINT "uc_broker_companies_branches_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "broker_company_branches_agents" (
    "id" bigserial   NOT NULL,
    "brn" varchar(255)   NOT NULL,
    "experience_since" timestamptz   NULL,
    -- agent user id
    "users_id" bigint   NOT NULL,
    "nationalities" bigint[]   NOT NULL,
    "broker_companies_branches_id" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "brn_expiry" timestamptz   NOT NULL,
    -- any documnet use for verification of the agent
    "verification_document_url" varchar(255)   NOT NULL,
    "about" varchar(255)   NULL,
    "about_arabic" varchar(255)   NULL,
    "linkedin_profile_url" varchar(255)   NULL,
    "facebook_profile_url" varchar(255)   NULL,
    "twitter_profile_url" varchar(255)   NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    -- is_freelancer bool DEFAULT=false
    -- noc_file_url varchar NULL
    "profiles_id" bigint   NOT NULL,
    "telegram" varchar   NULL,
    "botim" varchar   NULL,
    "tawasal" varchar   NULL,
    -- foreign keys of cities table, the cities specified for the agent from where the agent will have properties or units
    "service_areas" bigint[]   NULL,
    "agent_rank" bigint   NOT NULL,
    CONSTRAINT "pk_broker_company_branches_agents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "broker_branch_agent_reviews" (
    "id" bigserial   NOT NULL,
    "rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "review" varchar(255)   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "localknowledge_rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "processexpertise_rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "responsiveness_rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "negotiationskills_rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "services_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "broker_company_branches_agents_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_broker_branch_agent_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "broker_companies_branches_services" (
    "id" bigserial   NOT NULL,
    "broker_companies_branches_id" bigint   NOT NULL,
    "services_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_broker_companies_branches_services" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "broker_branch_company_reviews" (
    "id" bigserial   NOT NULL,
    "rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "review" varchar(255)   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "broker_companies_branches_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_broker_branch_company_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "designations" (
    "id" bigserial   NOT NULL,
    "designation" varchar(255)   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_designations" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "developer_company_branches" (
    "id" bigserial   NOT NULL,
    "developer_companies_id" bigint   NOT NULL,
    "company_name" varchar   NOT NULL,
    "tag_line" varchar   NULL,
    "commercial_license_no" varchar   NOT NULL,
    "commercial_license_file_url" varchar   NOT NULL,
    "commercial_license_expiry" timestamptz   NOT NULL,
    "vat_no" varchar   NULL,
    "vat_status" bigint   NULL,
    "vat_file_url" varchar   NULL,
    "facebook_profile_url" varchar   NULL,
    "instagram_profile_url" varchar   NULL,
    "linkedin_profile_url" varchar   NULL,
    "twitter_profile_url" varchar   NULL,
    -- admin of the company
    "users_id" bigint   NOT NULL,
    "bank_account_details_id" bigint   NOT NULL,
    "no_of_employees" bigint   NULL,
    "logo_url" varchar   NOT NULL,
    "cover_image_url" varchar   NULL,
    "description" varchar   NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "website_url" varchar   NULL,
    "phone_number" varchar   NULL,
    "email" varchar   NULL,
    "whatsapp_number" varchar   NULL,
    "addresses_id" bigint   NOT NULL,
    "company_rank" bigint  DEFAULT 1 NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "country_id" bigint   NOT NULL,
    "company_type" bigint  DEFAULT 2 NOT NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- when the commercial license registered for the first time
    "commercial_license_registration_date" timestamptz   NULL,
    "commercial_license_issue_date" timestamptz   NULL,
    "extra_license_names" varchar[]   NULL,
    "extra_license_files" varchar[]   NULL,
    "extra_license_nos" varchar[]   NULL,
    "extra_license_issue_date" timestamptz[]   NULL,
    "extra_license_expiry_date" timestamptz[]   NULL,
    "youtube_profile_url" varchar   NULL,
    "created_by" bigint   NOT NULL,
    -- only for dubai
    "license_dcci_no" varchar   NULL,
    -- only for dubai
    "register_no" varchar   NULL,
    "other_social_media" varchar[]   NULL,
    CONSTRAINT "pk_developer_company_branches" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_developer_company_branches_company_name" UNIQUE (
        "company_name"
    ),
    CONSTRAINT "uc_developer_company_branches_commercial_license_no" UNIQUE (
        "commercial_license_no"
    ),
    CONSTRAINT "uc_developer_company_branches_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "developer_company_directors" (
    "id" bigserial   NOT NULL,
    "profile_image" varchar(255)   NOT NULL,
    "name" varchar(255)   NOT NULL,
    "description" varchar(255)   NOT NULL,
    "director_designations_id" bigint   NOT NULL,
    "developer_companies_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    CONSTRAINT "pk_developer_company_directors" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_developer_company_directors_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "developer_branch_company_directors" (
    "id" bigserial   NOT NULL,
    "profile_image" varchar(255)   NOT NULL,
    "name" varchar(255)   NOT NULL,
    "description" varchar(255)   NOT NULL,
    "director_designations_id" bigint   NOT NULL,
    "developer_company_branches" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    CONSTRAINT "pk_developer_branch_company_directors" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_developer_branch_company_directors_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "developer_company_reviews" (
    "id" bigserial   NOT NULL,
    "rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "review" varchar(255)   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "developer_companies_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_developer_company_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "services_companies_reviews" (
    "id" bigserial   NOT NULL,
    "rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "review" varchar(255)   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "services_companies_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_services_companies_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "developer_branch_company_reviews" (
    "id" bigserial   NOT NULL,
    "rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "review" varchar(255)   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "developer_company_branches_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_developer_branch_company_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "developer_branch_company_directors_reviews" (
    "id" bigserial   NOT NULL,
    "rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "review" varchar(255)   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "developer_branch_company_directors_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_developer_branch_company_directors_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "service_branch_company_reviews" (
    "id" bigserial   NOT NULL,
    "rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "review" varchar(255)   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "service_company_branches_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_service_branch_company_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "developer_company_directors_reviews" (
    "id" bigserial   NOT NULL,
    "rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "review" varchar(255)   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "developer_company_directors_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_developer_company_directors_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "broker_companies" (
    "id" bigserial   NOT NULL,
    "company_name" varchar   NOT NULL,
    "description" varchar NULL,
    "logo_url" varchar  NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "email" varchar NULL,
    "phone_number" varchar   NULL,
    "whatsapp_number" varchar  NULL,
    "commercial_license_no" varchar   NOT NULL,
    "commercial_license_file_url" varchar  NOT NULL,
    "commercial_license_expiry" timestamptz   NOT NULL,
    "rera_no" varchar   NOT NULL,
    "rera_file_url" varchar   NOT NULL,
    "rera_expiry" timestamptz   NOT NULL,
    "is_verified" bool DEFAULT false  NOT NULL,
    "website_url" varchar NULL,
    "cover_image_url" varchar  NULL,
    "tag_line" varchar  NULL,
    "vat_no" varchar  NULL,
    "vat_status" bigint  NULL,
    "vat_file_url" varchar  NULL,
    "facebook_profile_url" varchar  NULL,
    "instagram_profile_url" varchar NULL,
    "twitter_profile_url" varchar NULL,
    "no_of_employees" bigint  NULL,
    "users_id" bigint   NOT NULL,
    "linkedin_profile_url" varchar NULL,
    "bank_account_details_id" bigint NOT NULL,
    "company_rank" bigint DEFAULT 1  NOT NULL,
    "status" bigint DEFAULT 1   NOT NULL,
    "country_id" bigint   NOT NULL,
    "company_type" bigint  DEFAULT 1 NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- when the rera registered for the first time
    "rera_registration_date" timestamptz  NULL,
    "rera_issue_date" timestamptz  NULL,
    -- when the commercial license registered for the first time
    "commercial_license_registration_date" timestamptz  NULL,
    "commercial_license_issue_date" timestamptz  NULL,
    "extra_license_nos" varchar[] NULL,
    "extra_license_files" varchar[] NULL,
    "extra_license_names" varchar[] NULL,
    "extra_license_issue_date" timestamptz[] NULL,
    "extra_license_expiry_date" timestamptz[] NULL,
    "license_dcci_no" varchar NULL,
    "register_no"  varchar NULL,
    "other_social_media" varchar[] NULL,
    "youtube_profile_url" varchar   NULL,
    "orn_license_no" varchar   NULL,
    "orn_license_file_url" varchar   NULL,
    "orn_registration_date" timestamptz   NULL,
    "orn_license_expiry" timestamptz   NULL,
    "created_by" bigint   NOT NULL,
    "trakhees_permit_no" varchar NULL,
    CONSTRAINT "pk_broker_companies" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_broker_companies_company_name" UNIQUE (
        "company_name"
    ),
    CONSTRAINT "uc_broker_companies_commercial_license_no" UNIQUE (
        "commercial_license_no"
    ),
    CONSTRAINT "uc_broker_companies_rera_no" UNIQUE (
        "rera_no"
    ),
    CONSTRAINT "uc_broker_companies_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "services_companies" (
    "id" bigserial   NOT NULL,
    "company_name" varchar   NOT NULL,
    "description" varchar  NULL,
    "logo_url" varchar   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "email" varchar NULL,
    "phone_number" varchar NULL,
    "whatsapp_number" varchar  NULL,
    "commercial_license_no" varchar   NOT NULL,
    "commercial_license_file_url" varchar   NOT NULL,
    "commercial_license_expiry" timestamptz   NOT NULL,
    "is_verified" bool DEFAULT false   NOT NULL,
    "website_url" varchar  NULL,
    "cover_image_url" varchar  NULL,
    "tag_line" varchar  NULL,
    "vat_no" varchar  NULL,
    "vat_status" bigint  NULL,
    "vat_file_url" varchar  NULL,
    "facebook_profile_url" varchar  NULL,
    "instagram_profile_url" varchar  NULL,
    "twitter_profile_url" varchar  NULL,
    "no_of_employees" bigint  NULL,
    "users_id" bigint   NOT NULL,
    "linkedin_profile_url" varchar  NULL,
    "bank_account_details_id" bigint   NOT NULL,
    "company_rank" bigint DEFAULT 1  NOT NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    "country_id" bigint   NOT NULL,
    "company_type" bigint  DEFAULT 3 NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- when the commercial license registered for the first time
    "commercial_license_registration_date" timestamptz  NULL,
    "commercial_license_issue_date" timestamptz  NULL,
    "youtube_profile_url" varchar   NULL,
    "created_by" bigint   NOT NULL,
    "extra_license_nos" varchar[] NULL,
    "extra_license_files" varchar[] NULL,
    "extra_license_names" varchar[] NULL,
    "extra_license_issue_date" timestamptz[] NULL,
    "extra_license_expiry_date" timestamptz[] NULL,
    "license_dcci_no" varchar NULL,
    "register_no" varchar NULL,
    "other_social_media" varchar[] NULL,
    CONSTRAINT "pk_services_companies" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_services_companies_company_name" UNIQUE (
        "company_name"
    ),
    CONSTRAINT "uc_services_companies_commercial_license_no" UNIQUE (
        "commercial_license_no"
    ),
    CONSTRAINT "uc_services_companies_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "service_company_branches" (
    "id" bigserial   NOT NULL,
    "services_companies_id" bigint   NOT NULL,
    "company_name" varchar   NOT NULL,
    "description" varchar   NULL,
    "logo_url" varchar   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "email" varchar   NULL,
    "phone_number" varchar   NULL,
    "whatsapp_number" varchar   NULL,
    "commercial_license_no" varchar   NOT NULL,
    "commercial_license_file_url" varchar   NOT NULL,
    "commercial_license_expiry" timestamptz   NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "website_url" varchar   NULL,
    "cover_image_url" varchar   NULL,
    "tag_line" varchar   NULL,
    "vat_no" varchar   NULL,
    "vat_status" bigint   NULL,
    "vat_file_url" varchar   NULL,
    "facebook_profile_url" varchar   NULL,
    "instagram_profile_url" varchar   NULL,
    "twitter_profile_url" varchar   NULL,
    "no_of_employees" bigint   NULL,
    "users_id" bigint   NOT NULL,
    "linkedin_profile_url" varchar   NULL,
    "bank_account_details_id" bigint   NOT NULL,
    "company_rank" bigint  DEFAULT 1 NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "country_id" bigint   NOT NULL,
    "company_type" bigint  DEFAULT 3 NOT NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- when the commercial license registered for the first time
    "commercial_license_registration_date" timestamptz   NULL,
    "commercial_license_issue_date" timestamptz   NULL,
    "extra_license_names" varchar[]   NULL,
    "extra_license_files" varchar[]   NULL,
    "extra_license_nos" varchar[]   NULL,
    "extra_license_issue_date" timestamptz[]   NULL,
    "extra_license_expiry_date" timestamptz[]   NULL,
    "youtube_profile_url" varchar   NULL,
    "created_by" bigint   NOT NULL,
    -- only for dubai
    "license_dcci_no" varchar   NULL,
    -- only for dubai
    "register_no" varchar   NULL,
    "other_social_media" varchar[]   NULL,
    CONSTRAINT "pk_service_company_branches" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_service_company_branches_company_name" UNIQUE (
        "company_name"
    ),
    CONSTRAINT "uc_service_company_branches_commercial_license_no" UNIQUE (
        "commercial_license_no"
    ),
    CONSTRAINT "uc_service_company_branches_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "services_branch_companies_services" (
    "id" bigserial   NOT NULL,
    "service_company_branches_id" bigint   NOT NULL,
    "services_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_services_branch_companies_services" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "currency" (
    "id" bigserial   NOT NULL,
    "currency" varchar(255)   NOT NULL,
    "code" varchar(255)   NOT NULL,
    "flag" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_currency" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "bank_account_details" (
    "id" bigserial   NOT NULL,
    "account_name" varchar   NOT NULL,
    "account_number" varchar   NOT NULL,
    "iban" varchar   NOT NULL,
    "countries_id" bigint   NOT NULL,
    "currency_id" bigint   NOT NULL,
    "bank_name" varchar   NOT NULL,
    "bank_branch" varchar NULL,
    "swift_code" varchar NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_bank_account_details" PRIMARY KEY (
        "id"
     )
);

-- CREATE TABLE "developer_bank_account_details" (
--     "id" bigserial   NOT NULL,
--     "account_name" varchar(255)   NOT NULL,
--     "account_number" varchar(255)   NOT NULL,
--     "iban" varchar(255)   NOT NULL,
--     "countries_id" bigint   NOT NULL,
--     "currency_id" bigint   NOT NULL,
--     "bank_name" varchar(255)   NOT NULL,
--     "branch" varchar(255)   NOT NULL,
--     "swift_code" varchar(255)   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     CONSTRAINT "pk_developer_bank_account_details" PRIMARY KEY (
--         "id"
--      )
-- );

-- CREATE TABLE "broker_bank_account_details" (
--     "id" bigserial   NOT NULL,
--     "account_name" varchar(255)   NOT NULL,
--     "account_number" varchar(255)   NOT NULL,
--     "iban" varchar(255)   NOT NULL,
--     "countries_id" bigint   NOT NULL,
--     "currency_id" bigint   NOT NULL,
--     "bank_name" varchar(255)   NOT NULL,
--     "branch" varchar(255)   NOT NULL,
--     "swift_code" varchar(255)   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     CONSTRAINT "pk_broker_bank_account_details" PRIMARY KEY (
--         "id"
--      )
-- );

-- CREATE TABLE "services_bank_account_details" (
--     "id" bigserial   NOT NULL,
--     "account_name" varchar(255)   NOT NULL,
--     "account_number" varchar(255)   NOT NULL,
--     "iban" varchar(255)   NOT NULL,
--     "countries_id" bigint   NOT NULL,
--     "currency_id" bigint   NOT NULL,
--     "bank_name" varchar(255)   NOT NULL,
--     "branch" varchar(255)   NOT NULL,
--     "swift_code" varchar(255)   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     CONSTRAINT "pk_services_bank_account_details" PRIMARY KEY (
--         "id"
--      )
-- );

CREATE TABLE "broker_company_reviews" (
    "id" bigserial   NOT NULL,
    "rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "review" varchar(255)   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "broker_companies_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_broker_company_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "sale_property_media" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "sale_property_units_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_sale_property_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "sale_property_media_branch" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "sale_property_units_branch_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    CONSTRAINT "pk_sale_property_media_branch" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "property_types" (
    "id" bigserial   NOT NULL,
    "type" varchar(255)   NOT NULL,
    "code" varchar(255)   NOT NULL,
    "is_residential" bool   NOT NULL,
    "is_commercial" bool   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "property_type_facts_id" bigint[]   NOT NULL,
    "category" varchar   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    -- property types id for property hub unit section, come from the same table pk id
    "unit_types" bigint[]   NULL,
    "icon" varchar   NULL,
    CONSTRAINT "pk_property_types" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "property_type_facts" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "icon" varchar   NULL,
    CONSTRAINT "pk_property_type_facts" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "sale_property_unit_plans" (
    "id" bigserial   NOT NULL,
    "img_url" varchar[]   NOT NULL,
    -- floor plan, master plan etc
    "title" varchar NOT NULL,
    "sale_property_units_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_sale_property_unit_plans" PRIMARY KEY (
        "id"
     )
);
CREATE TABLE "sale_property_unit_plans_branch" (
    "id" bigserial   NOT NULL,
    "img_url" varchar[]   NOT NULL,
    -- floor plan, master plan etc
    "title" varchar NOT NULL,
    "sale_property_units_branch_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_sale_property_unit_plans_branch" PRIMARY KEY (
        "id"
     )
);
CREATE TABLE "rent_property_unit_plans" (
    "id" bigserial   NOT NULL,
    "img_url" varchar[]   NOT NULL,
    -- floor plan, master plan etc
    "title" varchar NOT NULL,
    "rent_property_units_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_rent_property_unit_plans" PRIMARY KEY (
        "id"
     )
);
CREATE TABLE "rent_property_unit_plans_branch" (
    "id" bigserial   NOT NULL,
    "img_url" varchar[]  NOT NULL,
    -- floor plan, master plan etc
    "title" varchar NOT NULL,
    "rent_property_units_branch_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_rent_property_unit_plans_branch" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "views" (
    "id" bigserial   NOT NULL,
    "title" varchar(255)   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_views" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "rent_property_media" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "rent_property_units_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_rent_property_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "rent_property_media_branch" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "rent_property_units_branch_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    CONSTRAINT "pk_rent_property_media_branch" PRIMARY KEY (
        "id"
     )
);

-- CREATE TABLE "project_property_media" (
--     "id" bigserial   NOT NULL,
--     "image_url" varchar[]   NULL,
--     "image360_url" varchar[]   NULL,
--     "video_url" varchar[]   NULL,
--     "panaroma_url" varchar[]   NULL,
--     "main_media_section" varchar   NOT NULL,
--     "projects_id" bigint   NOT NULL,
--     "project_properties_id" bigint   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     CONSTRAINT "pk_project_property_media" PRIMARY KEY (
--         "id"
--      )
-- );

CREATE TABLE "projects" (
    "id" bigserial   NOT NULL,
    "project_name" varchar   NOT NULL,
    "ref_number" varchar  NOT NULL,
    "no_of_views" bigint  DEFAULT 0 NOT NULL,
    "is_verified" bool   NOT NULL,
    "project_rank" bigint  DEFAULT 1 NOT NULL,
    "addresses_id" bigint   NOT NULL,
    -- phases_id bigint[]
    "status" bigint  DEFAULT 1 NOT NULL,
    "developer_companies_id" bigint   NOT NULL,
    "developer_company_branches_id" bigint   NULL,
    -- is_shared bool DEFAULT=false
    "countries_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_multiphase" bool   NOT NULL,
    "live_status" bool  DEFAULT true NOT NULL,
    "project_no" varchar   NOT NULL,
    "license_no" varchar   NOT NULL,
    "users_id" bigint   NOT NULL,
    -- we are already managing this from facts
    -- completion_status bigint
    -- completion_percentage float NULL
    -- completion_percentage_date timestamptz NULL
    "facilities_id" bigint[]   NOT NULL,
    -- only for single phase project
    "amenities_id" bigint[]   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NULL,
    "rating" float  DEFAULT 0.0 NOT NULL,
    CONSTRAINT "pk_projects" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_projects_project_name" UNIQUE (
        "project_name"
    ),
    CONSTRAINT "uc_projects_ref_number" UNIQUE (
        "ref_number"
    ),
    CONSTRAINT "uc_projects_project_no" UNIQUE (
        "project_no"
    ),
    CONSTRAINT "uc_projects_license_no" UNIQUE (
        "license_no"
    )
);

-- CREATE TABLE "project_media" (
--     "id" bigserial   NOT NULL,
--     "image_url" varchar[]   NULL,
--     "image360_url" varchar[]   NULL,
--     "video_url" varchar[]   NULL,
--     "panaroma_url" varchar[]   NULL,
--     "main_media_section" varchar   NOT NULL,
--     "projects_id" bigint   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     CONSTRAINT "pk_project_media" PRIMARY KEY (
--         "id"
--      )
-- );

-- CREATE TABLE "phases_media" (
--     "id" bigserial   NOT NULL,
--     "image_url" varchar[]   NULL,
--     "image360_url" varchar[]   NULL,
--     "video_url" varchar[]   NULL,
--     "panaroma_url" varchar[]   NULL,
--     "main_media_section" varchar   NOT NULL,
--     "phases_id" bigint   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     CONSTRAINT "pk_phases_media" PRIMARY KEY (
--         "id"
--      )
-- );

-- project_shared_with
-- --
-- id bigserial PK
-- projects_id bigint FK - projects.id
-- company_id bigint
-- is_branch bool
-- created_at timestamptz DEFAULT=NOW()
-- updated_at timestamptz DEFAULT=NOW()
-- addresses_id bigint FK - addresses.id
CREATE TABLE "project_promotions" (
    "id" bigserial   NOT NULL,
    "promotion_types_id" bigint   NOT NULL,
    "description" varchar   NOT NULL,
    "expiry_date" timestamptz   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "projects_id" bigint   NOT NULL,
    "phases_id" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "live_status" bool  DEFAULT true NOT NULL,
    "ref_no" varchar   NOT NULL,
    "is_phase" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_project_promotions" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_project_promotions_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "promotion_types" (
    "id" bigserial   NOT NULL,
    "types" varchar   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_promotion_types" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_promotion_types_types" UNIQUE (
        "types"
    )
);

CREATE TABLE "project_requests" (
    "id" bigserial   NOT NULL,
    "request_type" bigint   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "projects_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "ref_no" varchar   NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_project_requests" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_project_requests_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "building_reviews" (
    "id" bigserial   NOT NULL,
    "property_id" bigint   NOT NULL,
    "property_table" varchar   NOT NULL,
    "reviews" varchar(255)   NOT NULL,
    "maintenance_rating" varchar(255)   NOT NULL,
    "staff_rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "gym_rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "noise_rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "children_rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "traffic_rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "guest_parking_rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_building_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "documents_category" (
    "id" bigserial   NOT NULL,
    "category" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_documents_category" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "documents_subcategory" (
    "id" bigserial   NOT NULL,
    "sub_category" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_documents_subcategory" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "project_documents" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "projects_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_project_documents" PRIMARY KEY (
        "id"
     )
);

-- composite_unique_phase_name_projects_id
-- because of phase name must be unique inside same project id but can be same in different project
CREATE TABLE "phases" (
    "id" bigserial   NOT NULL,
    "phase_name" varchar NOT NULL,
    -- added by creenx 2024-02-27 1756
    "addresses_id" bigint   NULL,
    "polygon_lat" float[]   NULL,
    "polygon_lng" float[]   NULL,
    -- no_of_unit_types bigint
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint   NOT NULL,
    "live_status" bool  DEFAULT true NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- "openhouse_start_datetime" timestamptz   NULL,
    -- "openhouse_end_datetime" timestamptz   NULL,
    -- later make it not null & foriegn key with projects table & remove phases id list in project table
    "projects_id" bigint   NOT NULL,
    "facilities" bigint[]   NOT NULL,
    "rating" float  DEFAULT 0.0 NOT NULL,
    "description" varchar   NOT NULL,
    "description_ar" varchar   NULL,
    "amenities" bigint[]   NULL,
    CONSTRAINT "pk_phases" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_phases_ref_no" UNIQUE (
        "ref_no"
    )
);

-- table for floor plan, master plan etc
CREATE TABLE "properties_plans" (
    "id" bigserial   NOT NULL,
    "img_url" varchar[]   NOT NULL,
    -- floor plan, master plan etc
    "title" varchar   NOT NULL,
    "projects_id" bigint   NULL,
    -- any one id from these tables owner properties, broker agent properties, project properties
    "properties_id" bigint   NOT NULL,
    "property" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_properties_plans" PRIMARY KEY (
        "id"
     )
);

-- table for floor plan, master plan etc || branch data will be save
CREATE TABLE "properties_plans_branch" (
    "id" bigserial   NOT NULL,
    "img_url" varchar[]   NOT NULL,
    -- floor plan, master plan etc
    "title" varchar   NOT NULL,
    -- any one id from these tables owner properties, broker agent properties, project properties
    "properties_id" bigint   NOT NULL,
    "property" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "projects_id" bigint   NULL,
    CONSTRAINT "pk_properties_plans_branch" PRIMARY KEY (
        "id"
     )
);

-- property_name must be unique in single-phase project but can be same in different single-phase project
-- property_name must be unique in phase of multi-phase project but can be same in different phases of multiphase project
CREATE TABLE "project_properties" (
    "id" bigserial   NOT NULL,
    "property_name" varchar   NOT NULL,
    "property_name_arabic" varchar  NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "property_rank" bigint  DEFAULT 1 NOT NULL,
    -- only for multiphase properties
    "amenities_id" bigint[]   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    -- FK - phases.id
    "phases_id" bigint   NULL,
    "property_types_id" bigint[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "projects_id" bigint   NOT NULL,
    "is_show_owner_info" bool  DEFAULT true NOT NULL,
    "property" bigint  DEFAULT 1 NOT NULL,
    "live_status" bool  DEFAULT true NOT NULL,
    "countries_id" bigint   NOT NULL,
    -- this will be developer company id ....
    "developer_companies_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- we are already managing this from facts table
    -- completion_status bigint
    -- completion_percentage float NULL
    -- completion_percentage_date timestamptz NULL
    "users_id" bigint   NOT NULL,
    -- user id for user_type owner || owner of this property
    "owner_users_id" bigint   NULL,
    "is_multiphase" bool  DEFAULT false NOT NULL,
    "property_title" varchar   NULL,
    "notes" varchar   NULL,
    "notes_arabic" varchar   NULL,
    "is_notes_public" bool   NULL,
    CONSTRAINT "pk_project_properties" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_project_properties_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "project_properties_documents" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    -- imported_from bigint[]
    -- imported_documents varchar[]
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "project_properties_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_project_properties_documents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "unit_types" (
    "id" bigserial   NOT NULL,
    "description" varchar   NULL,
    "image_url" varchar[]   NOT NULL,
    "min_area" float   NOT NULL,
    "max_area" float   NOT NULL,
    "min_price" float   NOT NULL,
    "max_price" float   NOT NULL,
    "parking" bigint  DEFAULT 0 NOT NULL,
    "balcony" bigint  DEFAULT 0 NOT NULL,
    "properties_id" bigint   NOT NULL,
    -- either this table is related to project_properties, owener properties or any one of 2 other tables
    "property" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- Type A, Type B etc
    "title" varchar   NOT NULL,
    -- Studio, 1 Bedroom, until 11 then 12+
    "bedrooms" varchar   NULL,
     "description_ar" varchar   NULL,
     "status" bigint DEFAULT 1 NOT NULL,
   "ref_no" varchar   NOT NULL,
    CONSTRAINT "pk_unit_types" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_unit_types_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "unit_types_branch" (
    "id" bigserial   NOT NULL,
    "description" varchar   NULL,
    "image_url" varchar[]   NOT NULL,
    "min_area" float   NOT NULL,
    "max_area" float   NOT NULL,
    "min_price" float   NOT NULL,
    "max_price" float   NOT NULL,
    "parking" bigint  DEFAULT 0 NOT NULL,
    "balcony" bigint  DEFAULT 0 NOT NULL,
    -- branch table id's
    "properties_id" bigint   NOT NULL,
    -- either this table is related to project_properties, owener properties or any one of 2 other tables
    "property" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- Type A, Type B etc
    "title" varchar   NOT NULL,
    -- Studio, 1 Bedroom, until 11 then 12+
    "bedrooms" varchar   NULL,
    "description_ar" varchar   NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    "ref_no" varchar   NOT NULL,
    CONSTRAINT "pk_unit_types_branch" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_unit_types_branch_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "broker_company_agent_properties" (
    "id" bigserial   NOT NULL,
    "property_title" varchar(255)   NOT NULL,
    "property_title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "property_rank" bigint  DEFAULT 1 NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "locations_id" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    -- remove this
    "profiles_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "facilities_id" bigint[]   NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    "broker_companies_id" bigint   NOT NULL,
    "broker_company_agents" bigint   NOT NULL,
    "is_show_owner_info" bool  DEFAULT true NOT NULL,
    "property" bigint  DEFAULT 3 NOT NULL,
    "countries_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "developer_company_name" varchar   NULL,
    "sub_developer_company_name" varchar   NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    -- only Sale or Rent
    "category" varchar   NOT NULL,
    "investment" bool  DEFAULT false NOT NULL,
    "contract_start_datetime" timestamptz   NULL,
    "contract_end_datetime" timestamptz   NULL,
    "amount" float  DEFAULT 0.0 NOT NULL,
    -- id's list of property_types
    "unit_types" bigint[]   NOT NULL,
    -- created by
    "users_id" bigint   NOT NULL,
    "property_name" varchar   NOT NULL,
    -- is the data inserted from xml feed or not
    "from_xml" bool  DEFAULT false NOT NULL,
    "list_of_date" timestamptz[]   NOT NULL,
    "list_of_notes" varchar[]   NOT NULL,
    "list_of_agent" bigint[]   NOT NULL,
    -- user id for user_type owner || owner of this property
    "owner_users_id" bigint   NULL,
    CONSTRAINT "pk_broker_company_agent_properties" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_broker_company_agent_properties_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "broker_company_agent_properties_branch" (
    "id" bigserial   NOT NULL,
    "property_title" varchar(255)   NOT NULL,
    "property_title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "property_rank" bigint  DEFAULT 1 NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "locations_id" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    -- remove this
    "profiles_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "facilities_id" bigint[]   NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    "broker_companies_branches_id" bigint   NOT NULL,
    "broker_company_branches_agents" bigint   NOT NULL,
    "is_show_owner_info" bool  DEFAULT true NOT NULL,
    "property" bigint  DEFAULT 3 NOT NULL,
    -- facts_values json
    "countries_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "developer_company_name" varchar   NULL,
    "sub_developer_company_name" varchar   NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    -- only Sale or Rent
    "category" varchar   NOT NULL,
    "investment" bool  DEFAULT false NOT NULL,
    "contract_start_datetime" timestamptz   NULL,
    "contract_end_datetime" timestamptz   NULL,
    "amount" float  DEFAULT 0.0 NOT NULL,
    -- ask_price bool DEFAULT=FALSE
    -- id's list of property_types
    "unit_types" bigint[]   NOT NULL,
    -- created_by
    "users_id" bigint   NOT NULL,
    "property_name" varchar   NOT NULL,
    -- is the data inserted from xml feed or not
    "from_xml" bool  DEFAULT false NOT NULL,
    "list_of_date" timestamptz[]   NOT NULL,
    "list_of_notes" varchar[]   NOT NULL,
    "list_of_agent" bigint[]   NOT NULL,
    -- user id for user_type owner || owner of this property
    "owner_users_id" bigint   NULL,
    CONSTRAINT "pk_broker_company_agent_properties_branch" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_broker_company_agent_properties_branch_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "broker_company_agent_properties_media" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "broker_company_agent_properties_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_broker_company_agent_properties_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "broker_company_agent_properties_media_branch" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "broker_company_agent_properties_branch_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    CONSTRAINT "pk_broker_company_agent_properties_media_branch" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "broker_company_agent_properties_documents" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "broker_company_agent_properties_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_broker_company_agent_properties_documents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "broker_company_agent_properties_documents_branch" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "broker_company_agent_properties_branch_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    CONSTRAINT "pk_broker_company_agent_properties_documents_branch" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "owner_properties" (
    "id" bigserial   NOT NULL,
    "property_title" varchar(255)   NOT NULL,
    "property_title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "property_rank" bigint  DEFAULT 1 NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "locations_id" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    -- remove this
    "profiles_id" bigint   NOT NULL,
    "facilities_id" bigint[]   NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_show_owner_info" bool  DEFAULT true NOT NULL,
    "property" bigint  DEFAULT 4 NOT NULL,
    -- facts_values json
    "countries_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- only Sale or Rent
    "category" varchar   NOT NULL,
    "investment" bool  DEFAULT false NOT NULL,
    "contract_start_datetime" timestamptz   NULL,
    "contract_end_datetime" timestamptz   NULL,
    "amount" float  DEFAULT 0.0 NOT NULL,
    -- ask_price bool DEFAULT=FALSE
    -- id's list of property_types
    "unit_types" bigint[]   NOT NULL,
    -- created by
    "users_id" bigint   NOT NULL,
    "property_name" varchar   NOT NULL,
    "list_of_date" timestamptz[]   NOT NULL,
    "list_of_notes" varchar[]   NOT NULL,
    "list_of_agent" bigint[]   NOT NULL,
    CONSTRAINT "pk_owner_properties" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_owner_properties_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "owner_properties_media" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "owner_properties_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_owner_properties_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "owner_properties_documents" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "owner_properties_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_owner_properties_documents" PRIMARY KEY (
        "id"
     )
);

-- developer_company_properties
-- --
-- id bigserial PK
-- property_title varchar(255)
-- property_title_arabic varchar
-- description varchar
-- description_arabic varchar
-- is_verified bool DEFAULT=false
-- property_rank bigint DEFAULT=1
-- addresses_id bigint FK - addresses.id
-- locations_id bigint FK - locations.id
-- property_types_id bigint[]
-- developer_companies_id bigint FK >- developer_companies.id
-- facilities_id bigint[]
-- amenities_id bigint[]
-- status bigint DEFAULT=1
-- created_at timestamptz DEFAULT=NOW()
-- updated_at timestamptz DEFAULT=NOW()
-- is_show_owner_info bool DEFAULT=TRUE
-- property bigint DEFAULT=2
-- facts_values json
-- countries_id bigint FK - countries.id
-- ref_no varchar UNIQUE
-- is_branch bool DEFAULT=FALSE
-- developer_company_properties_branch
-- --
-- id bigserial PK
-- property_title varchar(255)
-- property_title_arabic varchar
-- description varchar
-- description_arabic varchar
-- is_verified bool DEFAULT=false
-- property_rank bigint DEFAULT=1
-- addresses_id bigint FK - addresses.id
-- locations_id bigint FK - locations.id
-- property_types_id bigint[]
-- developer_company_branches_id bigint FK >- developer_company_branches.id
-- facilities_id bigint[]
-- amenities_id bigint[]
-- status bigint DEFAULT=1
-- created_at timestamptz DEFAULT=NOW()
-- updated_at timestamptz DEFAULT=NOW()
-- is_show_owner_info bool DEFAULT=TRUE
-- property bigint DEFAULT=2
-- facts_values json
-- countries_id bigint FK - countries.id
-- ref_no varchar UNIQUE
-- is_branch bool DEFAULT=TRUE
-- developer_company_properties_media
-- --
-- id bigserial PK
-- image_url varchar[] NULL
-- image360_url varchar[] NULL
-- video_url varchar[] NULL
-- panaroma_url varchar[] NULL
-- main_media_section varchar
-- developer_company_properties_id bigint FK >- developer_company_properties.id
-- created_at timestamptz DEFAULT=NOW()
-- updated_at timestamptz DEFAULT=NOW()
-- is_branch bool DEFAULT=FALSE
-- developer_company_properties_media_branch
-- --
-- id bigserial PK
-- image_url varchar[] NULL
-- image360_url varchar[] NULL
-- video_url varchar[] NULL
-- panaroma_url varchar[] NULL
-- main_media_section varchar
-- developer_company_properties_branch_id bigint FK >- developer_company_properties_branch.id
-- created_at timestamptz DEFAULT=NOW()
-- updated_at timestamptz DEFAULT=NOW()
-- is_branch bool DEFAULT=TRUE
-- developer_company_properties_documents
-- --
-- id bigserial PK
-- documents_category_id bigint FK - documents_category.id
-- documents_subcategory_id bigint FK - documents_subcategory.id
-- file_url varchar[]
-- created_at timestamptz DEFAULT=NOW()
-- updated_at timestamptz DEFAULT=NOW()
-- developer_company_properties_id bigint FK - developer_company_properties.id
-- status bigint DEFAULT=1
-- is_branch bool DEFAULT=FALSE
-- developer_company_properties_documents_branch
-- --
-- id bigserial PK
-- documents_category_id bigint FK - documents_category.id
-- documents_subcategory_id bigint FK - documents_subcategory.id
-- file_url varchar[]
-- created_at timestamptz DEFAULT=NOW()
-- updated_at timestamptz DEFAULT=NOW()
-- developer_company_properties_branch_id bigint FK - developer_company_properties_branch.id
-- status bigint DEFAULT=1
-- is_branch bool DEFAULT=TRUE
CREATE TABLE "sale_property_units" (
    "id" bigserial   NOT NULL,
    "unit_no" varchar   NULL,
    "unitno_is_public" bool  DEFAULT false NOT NULL,
    "title" varchar   NOT NULL,
    "title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "notes" varchar   NULL,
    "notes_arabic" varchar   NULL,
    "notes_public" bool  DEFAULT false NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    -- come from properties
    "facilities_id" bigint[]   NOT NULL,
    "property_unit_rank" bigint  DEFAULT 1 NOT NULL,
    "broker_company_agents_id" bigint   NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "status_change_reason" varchar(255)   NULL,
    -- null for xml only & either this is project_properties, owner properties,broker_company_agent_properties etc
    "properties_id" bigint   NULL,
    -- null for xml only
    "property" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- come from property, same as property
    "addresses_id" bigint   NOT NULL,
    -- come from property, same as property
    "countries_id" bigint   NOT NULL,
    "investment" bool  DEFAULT false NOT NULL,
    "contract_start_datetime" timestamptz   NULL,
    "contract_end_datetime" timestamptz   NULL,
    -- contract amount
    "amount" bigint NULL,
    "is_available_for_booking" bool NULL,
    "is_request_video" bool NULL,
    -- "is_open_house" bool NULL,
    -- "openhouse_start_datetime" timestamptz   NULL,
    -- "openhouse_end_datetime" timestamptz   NULL,
    "property_types_id" bigint   NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    -- created by
    "users_id" bigint   NOT NULL,
    -- is the data inserted from xml feed or not
    "from_xml" bool  DEFAULT false NOT NULL,
    "property_name" varchar   NOT NULL,
    -- which section project, propertyhub, unit, industrial, agricultural
    "section" varchar   NOT NULL,
    -- user id for user_type owner || owner of this unit
    "owner_users_id" bigint   NULL,
    -- unit_types table id to connect unit_type.
    "type_name_id" bigint   NULL,
    CONSTRAINT "pk_sale_property_units" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_sale_property_units_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "sale_property_units_branch" (
    "id" bigserial   NOT NULL,
    "unit_no" varchar   NULL,
    "unitno_is_public" bool  DEFAULT false NOT NULL,
    "title" varchar   NOT NULL,
    "title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "notes" varchar   NULL,
    "notes_arabic" varchar   NULL,
    "notes_public" bool  DEFAULT false NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    -- come from properties
    "facilities_id" bigint[]   NOT NULL,
    "property_unit_rank" bigint  DEFAULT 1 NOT NULL,
    "broker_company_branches_agents_id" bigint   NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "status_change_reason" varchar(255)   NULL,
    -- null for xml only & either this is project_properties, owner properties,broker_company_agent_properties etc
    "properties_id" bigint   NULL,
    -- null for xml only
    "property" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- come from property, same as property
    "addresses_id" bigint   NOT NULL,
    -- come from property, same as property
    "countries_id" bigint   NOT NULL,
    "investment" bool  DEFAULT false NOT NULL,
    "contract_start_datetime" timestamptz   NULL,
    "contract_end_datetime" timestamptz   NULL,
    -- contract amount
    "amount" bigint NULL,
    "is_available_for_booking" bool NULL,
    "is_request_video" bool NULL,
    -- "is_open_house" bool NULL,
    -- "openhouse_start_datetime" timestamptz   NULL,
    -- "openhouse_end_datetime" timestamptz   NULL,
    "property_types_id" bigint   NOT NULL,
    -- facts_values json
    "is_branch" bool  DEFAULT true NOT NULL,
    -- ask_price bool DEFAULT=FALSE
    -- created by
    "users_id" bigint   NOT NULL,
    -- is the data inserted from xml feed or not
    "from_xml" bool  DEFAULT false NOT NULL,
    "property_name" varchar   NOT NULL,
    -- which section project, propertyhub, unit, industrial, agricultural
    "section" varchar   NOT NULL,
    -- user id for user_type owner || owner of this unit
    "owner_users_id" bigint   NULL,
    -- unit_types table id to connect unit_type.
    "type_name_id" bigint   NULL,
    CONSTRAINT "pk_sale_property_units_branch" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_sale_property_units_branch_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "sale_property_units_documents" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "sale_property_units_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_sale_property_units_documents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "sale_property_units_documents_branch" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "sale_property_units_branch_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    CONSTRAINT "pk_sale_property_units_documents_branch" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "sale_property_units_reviews" (
    "id" bigserial   NOT NULL,
    "sale_property_units_id" bigint   NOT NULL,
    "review" varchar   NULL,
    "rating" float   NULL,
    "users_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_sale_property_units_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "sale_property_units_branch_reviews" (
    "id" bigserial   NOT NULL,
    "sale_property_units_branch_id" bigint   NOT NULL,
    "review" varchar   NULL,
    "rating" float   NULL,
    "users_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_sale_property_units_branch_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "rent_property_units" (
    "id" bigserial   NOT NULL,
    "unit_no" varchar   NULL,
    "unitno_is_public" bool  DEFAULT false NOT NULL,
    "title" varchar   NOT NULL,
    "title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "notes" varchar   NULL,
    "notes_arabic" varchar   NULL,
    "notes_public" bool  DEFAULT false NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    -- come from properties
    "facilities_id" bigint[]   NOT NULL,
    "property_unit_rank" bigint  DEFAULT 1 NOT NULL,
    "broker_company_agents_id" bigint   NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "status_change_reason" varchar   NULL,
    -- null for xml only & either this is project_properties, owner properties,broker_company_agent_properties etc
    "properties_id" bigint   NULL,
    -- null for xml only
    "property" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- come from property, same as property
    "addresses_id" bigint   NOT NULL,
    -- come from property, same as property
    "countries_id" bigint   NOT NULL,
    "is_available_for_booking" bool NULL,
    "is_request_video" bool NULL,
    -- "is_open_house" bool NULL,
    -- "openhouse_start_datetime" timestamptz   NULL,
    -- "openhouse_end_datetime" timestamptz   NULL,
    "property_types_id" bigint   NOT NULL,
    -- facts_values json
    "is_branch" bool  DEFAULT false NOT NULL,
    -- ask_price bool DEFAULT=FALSE
    -- created by
    "users_id" bigint   NOT NULL,
    -- is the data inserted from xml feed or not
    "from_xml" bool  DEFAULT false NOT NULL,
    "property_name" varchar   NOT NULL,
    -- which section project, propertyhub, unit, industrial, agricultural
    "section" varchar   NOT NULL,
    -- unit_types table id to connect unit_type.
    "type_name_id" bigint   NULL,
    -- user id for user_type owner || owner of this unit
    "owner_users_id" bigint   NULL,
    CONSTRAINT "pk_rent_property_units" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_rent_property_units_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "rent_property_units_branch" (
    "id" bigserial   NOT NULL,
    "unit_no" varchar   NULL,
    "unitno_is_public" bool  DEFAULT false NOT NULL,
    "title" varchar   NOT NULL,
    "title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "notes" varchar   NULL,
    "notes_arabic" varchar   NULL,
    "notes_public" bool  DEFAULT false NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    -- come from properties
    "facilities_id" bigint[]   NOT NULL,
    "property_unit_rank" bigint  DEFAULT 1 NOT NULL,
    "broker_company_branches_agents_id" bigint   NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "status_change_reason" varchar   NULL,
    -- null for xml only & either this is project_properties, owner properties,broker_company_agent_properties etc
    "properties_id" bigint   NULL,
    -- null for xml only
    "property" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- come from property, same as property
    "addresses_id" bigint   NOT NULL,
    -- come from property, same as property
    "countries_id" bigint   NOT NULL,
    "is_available_for_booking" bool NULL,
    "is_request_video" bool NULL,
--   "is_open_house" bool NULL,
--     "openhouse_start_datetime" timestamptz   NULL,
--     "openhouse_end_datetime" timestamptz   NULL,
    "property_types_id" bigint   NOT NULL,
    -- facts_values json
    "is_branch" bool  DEFAULT true NOT NULL,
    -- ask_price bool DEFAULT=FALSE
    -- created by
    "users_id" bigint   NOT NULL,
    -- is the data inserted from xml feed or not
    "from_xml" bool  DEFAULT false NOT NULL,
    "property_name" varchar   NOT NULL,
    -- which section project, propertyhub, unit, industrial, agricultural
    "section" varchar   NOT NULL,
    -- unit_types_branch table id to connect unit_type.
    "type_name_id" bigint   NULL,
    -- user id for user_type owner || owner of this unit
    "owner_users_id" bigint   NULL,
    CONSTRAINT "pk_rent_property_units_branch" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_rent_property_units_branch_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "rent_property_units_reviews" (
    "id" bigserial   NOT NULL,
    "rent_property_units_id" bigint   NOT NULL,
    "review" varchar   NULL,
    "rating" float   NULL,
    "users_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_rent_property_units_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "rent_property_units_branch_reviews" (
    "id" bigserial   NOT NULL,
    "rent_property_units_branch_id" bigint   NOT NULL,
    "review" varchar   NULL,
    "rating" float   NULL,
    "users_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_rent_property_units_branch_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "rent_property_units_documents" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "rent_property_units_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_rent_property_units_documents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "rent_property_units_documents_branch" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "rent_property_units_branch_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    CONSTRAINT "pk_rent_property_units_documents_branch" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "exchange_property_units" (
    "id" bigserial   NOT NULL,
    "unit_no" varchar   NULL,
    "unitno_is_public" bool  DEFAULT false NOT NULL,
    "title" varchar   NOT NULL,
    "title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "notes" varchar   NULL,
    "notes_arabic" varchar   NULL,
    "notes_public" bool  DEFAULT false NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    -- come from properties
    "facilities_id" bigint[]   NOT NULL,
    "property_unit_rank" bigint  DEFAULT 1 NOT NULL,
    "broker_company_agents_id" bigint   NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "status_change_reason" varchar   NULL,
    -- either this is project_properties, owner properties,broker_company_agent_properties etc
    "properties_id" bigint   NOT NULL,
    "property" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- come from property, same as property
    "addresses_id" bigint   NOT NULL,
    -- come from property, same as property
    "countries_id" bigint   NOT NULL,
    "is_available_for_booking" bool NULL,
    "is_request_video" bool NULL,
    -- "is_open_house" bool NULL,
    -- "openhouse_start_datetime" timestamptz   NULL,
    -- "openhouse_end_datetime" timestamptz   NULL,
    "property_types_id" bigint   NOT NULL,
    -- facts_values json
    "is_branch" bool  DEFAULT false NOT NULL,
    -- ask_price bool DEFAULT=FALSE
    -- created by
    "users_id" bigint   NOT NULL,
    "property_name" varchar   NOT NULL,
    -- which section project, propertyhub, unit, industrial, agricultural
    "section" varchar   NOT NULL,
    -- unit_types table id to connect unit_type.
    "type_name_id" bigint   NULL,
    -- user id for user_type owner || owner of this unit
    "owner_users_id" bigint   NULL,
    CONSTRAINT "pk_exchange_property_units" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_exchange_property_units_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "exchange_property_units_branch" (
    "id" bigserial   NOT NULL,
    "unit_no" varchar   NULL,
    "unitno_is_public" bool  DEFAULT false NOT NULL,
    "title" varchar   NOT NULL,
    "title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "notes" varchar   NULL,
    "notes_arabic" varchar   NULL,
    "notes_public" bool  DEFAULT false NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    -- come from properties
    "facilities_id" bigint[]   NOT NULL,
    "property_unit_rank" bigint  DEFAULT 1 NOT NULL,
    "broker_company_branches_agents_id" bigint   NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "status_change_reason" varchar   NULL,
    -- either this is project_properties, owner properties,broker_company_agent_properties etc
    "properties_id" bigint   NOT NULL,
    "property" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- come from property, same as property
    "addresses_id" bigint   NOT NULL,
    -- come from property, same as property
    "countries_id" bigint   NOT NULL,
    "is_available_for_booking" bool NULL,
    "is_request_video" bool NULL,
    -- "is_open_house" bool NULL,
    -- "openhouse_start_datetime" timestamptz   NULL,
    -- "openhouse_end_datetime" timestamptz   NULL,
    "property_types_id" bigint   NOT NULL,
    -- facts_values json
    "is_branch" bool  DEFAULT true NOT NULL,
    -- ask_price bool DEFAULT=FALSE
    -- created by
    "users_id" bigint   NOT NULL,
    "property_name" varchar   NOT NULL,
    -- which section project, propertyhub, unit, industrial, agricultural
    "section" varchar   NOT NULL,
    -- unit_types_branch table id to connect unit_type.
    "type_name_id" bigint   NULL,
    -- user id for user_type owner || owner of this unit
    "owner_users_id" bigint   NULL,
    CONSTRAINT "pk_exchange_property_units_branch" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_exchange_property_units_branch_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "exchange_property_units_reviews" (
    "id" bigserial   NOT NULL,
    "exchange_property_units_id" bigint   NOT NULL,
    "review" varchar   NULL,
    "rating" float   NULL,
    "users_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_exchange_property_units_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "exchange_property_units_branch_reviews" (
    "id" bigserial   NOT NULL,
    "exchange_property_units_branch_id" bigint   NOT NULL,
    "review" varchar   NULL,
    "rating" float   NULL,
    "users_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_exchange_property_units_branch_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "exchange_property_units_documents" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "exchange_property_units_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_exchange_property_units_documents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "exchange_property_units_documents_branch" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "exchange_property_units_branch_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    CONSTRAINT "pk_exchange_property_units_documents_branch" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "listing_problems_report" (
    "id" bigserial   NOT NULL,
    "unit_id" bigint   NOT NULL,
    -- either this is property table or unit table, specify the name of table like sale_property_unit or owner_property etc
    "unit_reference_table" varchar   NOT NULL,
    "reason" varchar   NOT NULL,
    "message" varchar   NOT NULL,
    "company_id" bigint   NOT NULL,
    -- either this is broker or developer or services
    "company_type" bigint   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_listing_problems_report" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_listing_problems_report_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "exchange_property_media" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "exchange_property_units_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_exchange_property_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "exchange_property_media_branch" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "exchange_property_units_branch_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    CONSTRAINT "pk_exchange_property_media_branch" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "exchange_property_unit_plans" (
    "id" bigserial   NOT NULL,
    "img_url" varchar(255)   NOT NULL,
    "exchange_property_units_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_exchange_property_unit_plans" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "exchange_property_unit_plans_branch" (
    "id" bigserial   NOT NULL,
    "img_url" varchar(255)   NOT NULL,
    "exchange_property_units_branch_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    CONSTRAINT "pk_exchange_property_unit_plans_branch" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "desired_exchange_unit" (
    "id" bigserial   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "property_type" bigint   NOT NULL,
    "no_of_bathrooms" bigint   NULL,
    "no_of_bedrooms" bigint   NULL,
    "plot_area" bigint   NULL,
    "views" bigint[]   NOT NULL,
    "no_of_parkings" bigint   NULL,
    "built_up_area" bigint   NULL,
    "ownership" bigint   NULL,
    "furnished" bigint   NULL,
    "maintenance_fee" bigint   NULL,
    "mortage" bool   NOT NULL,
    "vat_value" bigint   NULL,
    "vat" bigint   NULL,
    "unit_usage" bigint   NOT NULL,
    "service_charge" bigint   NULL,
    "paid_until" timestamptz   NULL,
    "amenites" bigint[]   NOT NULL,
    "facilities" bigint[]   NOT NULL,
    "description" varchar   NOT NULL,
    "users_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- foriegn key of unit
    "unit_id" bigint   NOT NULL,
    "category" varchar   NOT NULL,
    CONSTRAINT "pk_desired_exchange_unit" PRIMARY KEY (
        "id"
     )
);











CREATE TABLE "developer_subscription" (
    "id" bigserial   NOT NULL,
    "subscription_duration" varchar(255)   NOT NULL,
    "start_date" timestamptz   NULL,
    "end_date" timestamptz   NULL,
    "standard_units" bigint   NOT NULL,
    "standard_unit_price" bigint   NOT NULL,
    "standard_discount" varchar(255)   NOT NULL,
    "featured_units" bigint   NOT NULL,
    "featured_unit_price" bigint   NOT NULL,
    "featured_discount" varchar(255)   NOT NULL,
    "premium_units" bigint   NOT NULL,
    "premium_unit_price" bigint   NOT NULL,
    "premium_discount" varchar(255)   NOT NULL,
    "topdeal_units" bigint   NOT NULL,
    "topdeal_unit_price" bigint   NOT NULL,
    "topdeal_discount" varchar(255)   NOT NULL,
    "status" bigint   NOT NULL,
    "total_price" varchar  DEFAULT 0 NOT NULL,
    "total_unit" bigint  DEFAULT 0 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- ??
    "subscription_mode" bigint  DEFAULT 1 NOT NULL,
    "company_type" bigint  DEFAULT 2 NOT NULL,
    "company_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "order_no" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    -- added by creenx 2024-05-10 1644
    -- initial value will be same as the total_unit
    "remaining_units" bigint   NOT NULL,
    CONSTRAINT "pk_developer_subscription" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "broker_subscription" (
    "id" bigserial   NOT NULL,
    "subscription_duration" varchar(255)   NOT NULL,
    "start_date" timestamptz   NULL,
    "end_date" timestamptz   NULL,
    "standard_units" bigint   NOT NULL,
    "standard_unit_price" bigint   NOT NULL,
    "standard_discount" varchar(255)   NOT NULL,
    "featured_units" bigint   NOT NULL,
    "featured_unit_price" bigint   NOT NULL,
    "featured_discount" varchar(255)   NOT NULL,
    "premium_units" bigint   NOT NULL,
    "premium_unit_price" bigint   NOT NULL,
    "premium_discount" varchar(255)   NOT NULL,
    "topdeal_units" bigint   NOT NULL,
    "topdeal_unit_price" bigint   NOT NULL,
    "topdeal_discount" varchar(255)   NOT NULL,
    "status" bigint   NOT NULL,
    "total_price" varchar  DEFAULT 0 NOT NULL,
    "total_unit" bigint  DEFAULT 0 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "subscription_mode" bigint  DEFAULT 1 NOT NULL,
    "company_type" bigint  DEFAULT 1 NOT NULL,
    "company_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "order_no" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    -- added by creenx 2024-05-10 1644
    -- initial value will be same as the total_unit
    "remaining_units" bigint   NOT NULL,
    CONSTRAINT "pk_broker_subscription" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "services_subscription" (
    "id" bigserial   NOT NULL,
    "subscription_duration" varchar(255)   NOT NULL,
    "start_date" timestamptz   NULL,
    "end_date" timestamptz   NULL,
    "standard_units" bigint   NOT NULL,
    "standard_unit_price" bigint   NOT NULL,
    "standard_discount" varchar(255)   NOT NULL,
    "featured_units" bigint   NOT NULL,
    "featured_unit_price" bigint   NOT NULL,
    "featured_discount" varchar(255)   NOT NULL,
    "premium_units" bigint   NOT NULL,
    "premium_unit_price" bigint   NOT NULL,
    "premium_discount" varchar(255)   NOT NULL,
    "topdeal_units" bigint   NOT NULL,
    "topdeal_unit_price" bigint   NOT NULL,
    "topdeal_discount" varchar(255)   NOT NULL,
    "status" bigint   NOT NULL,
    "total_price" varchar  DEFAULT 0 NOT NULL,
    "total_unit" bigint  DEFAULT 0 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "subscription_mode" bigint  DEFAULT 1 NOT NULL,
    "company_type" bigint  DEFAULT 3 NOT NULL,
    "company_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "order_no" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    -- added by creenx 2024-05-10 1644
    -- initial value will be same as the total_unit, will update once an agent quota added
    "remaining_units" bigint   NOT NULL,
    CONSTRAINT "pk_services_subscription" PRIMARY KEY (
        "id"
     )
);



-- CREATE TABLE "subscription" (
--     "id" bigserial   NOT NULL,
--     "subscription_duration" varchar(255)   NOT NULL,
--     "start_date" timestamptz   NULL,
--     "end_date" timestamptz   NULL,
--     "standard_units" bigint   NOT NULL,
--     "standard_units_price" float   NOT NULL,
--     "standard_units_actual_price" float   NOT NULL,
--     "standard_discount" varchar(255)   NOT NULL,
--     "standard_units_price_after_discount" float   NOT NULL,
--     "featured_units" bigint   NOT NULL,
--     "featured_units_price" float   NOT NULL,
--     "featured_units_actual_price" float   NOT NULL,
--     "featured_discount" varchar(255)   NOT NULL,
--     "featured_units_price_after_discount" float   NOT NULL,
--     "premium_units" bigint   NOT NULL,
--     "premium_units_price" float   NOT NULL,
--     "premium_units_actual_price" float   NOT NULL,
--     "premium_discount" varchar(255)   NOT NULL,
--     "premium_units_price_after_discount" float   NOT NULL,
--     "topdeal_units" bigint   NOT NULL,
--     "topdeal_unit_price" float   NOT NULL,
--     "topdeal_unit_actual_price" float   NOT NULL,
--     "topdeal_discount" varchar(255)   NOT NULL,
--     "topdeal_units_price_after_discount" float   NOT NULL,
--     "status" bigint   NOT NULL,
--     "total_price" varchar  DEFAULT 0 NOT NULL,
--     "total_unit" bigint  DEFAULT 0 NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     "subscription_mode" bigint  DEFAULT 1 NOT NULL,
--     "company_type" bigint  DEFAULT 1 NOT NULL,
--     "company_id" bigint   NOT NULL,
--     "is_branch" bool   NOT NULL,
--     "order_no" timestamptz  DEFAULT now() NOT NULL,
--     "created_by" bigint   NOT NULL,
--     -- added by creenx 2024-05-10 1644
--     -- initial value will be same as the total_unit
--     "remaining_units" bigint   NOT NULL,
--     CONSTRAINT "pk_subscription" PRIMARY KEY (
--         "id"
--      )
-- );



 

-- CREATE TABLE "subscription_units" (
--     "id" bigserial   NOT NULL,
--     "subscription_id" bigint   NOT NULL,
--     "unit_type" varchar(50)   NOT NULL,
--     "no_units" bigint   NOT NULL,
--     "unit_price" numeric(12,2)   NOT NULL,
--     "unit_actual_price" numeric(12,2)   NOT NULL,
--     "discount" varchar(255)   NOT NULL,
--     "price_after_discount" numeric(12,2)   NOT NULL,
--     CONSTRAINT "pk_subscription_units" PRIMARY KEY (
--         "id"
--      )
-- );


 

CREATE TABLE "profiles" (
    "id" bigserial   NOT NULL,
    "first_name" varchar(255)   NOT NULL,
    "last_name" varchar(255)   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "profile_image_url" varchar NULL,
    "phone_number" varchar(255) NOT NULL,
    "company_number" varchar(255) NOT NULL,
    "whatsapp_number" varchar(255)  NOT NULL,
    "botim" varchar   NULL,
    "tawasal" varchar   NULL,
    "gender" bigint   NOT NULL,
    "all_languages_id" bigint[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    "cover_image_url" varchar   NULL,
    "nic_no" varchar NULL,
    "nic_image_url" varchar NULL,
    "passport_no" varchar NULL,
    "passport_image_url" varchar NULL,
    CONSTRAINT "pk_profiles" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_profiles_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "roles" (
    "id" bigserial   NOT NULL,
    "role" varchar(255)   NOT NULL,
    -- code varchar(255)
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_roles" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "user_types" (
    "id" bigserial   NOT NULL,
    "user_type" varchar(255)   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_user_types" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "users" (
    "id" bigserial   NOT NULL,
    "email" varchar(255)   NOT NULL,
    "username" varchar(255)   NOT NULL,
    "password" varchar(255) NOT NULL,
    "status" bigint   NOT NULL,
    "roles_id" bigint   NULL,
    "department" bigint   NULL,
    "profiles_id" bigint   NOT NULL,
    "user_types_id" bigint   NOT NULL,
    "social_login" varchar(255)   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- Assign permission to the specific user, permissions id list from permissions table
    "permissions_id" bigint[]   NOT NULL,
    "sub_section_permission" bigint[]   NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_users" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_users_email" UNIQUE (
        "email"
    ),
    CONSTRAINT "uc_users_username" UNIQUE (
        "username"
    )
);

CREATE TABLE "department" (
    "id" bigserial   NOT NULL,
    "title" varchar(255)   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_department" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "broker_companies_services" (
    "id" bigserial   NOT NULL,
    "broker_companies_id" bigint   NOT NULL,
    "services_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_broker_companies_services" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "developer_companies_branches_services" (
    "id" bigserial   NOT NULL,
    "developer_company_branches_id" bigint   NOT NULL,
    "services_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_developer_companies_branches_services" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "developer_companies_services" (
    "id" bigserial   NOT NULL,
    "developer_companies_id" bigint   NOT NULL,
    "services_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_developer_companies_services" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "services_companies_services" (
    "id" bigserial   NOT NULL,
    "services_companies_id" bigint   NOT NULL,
    "services_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_services_companies_services" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "company_types" (
    "id" bigserial   NOT NULL,
    -- company type 1=>broker company, 2 => developer company & 3 => service company
    "main_company_type_id" bigint   NOT NULL,
    "title" varchar(255)   NOT NULL,
    "description" varchar(255)   NOT NULL,
    "icon_url" varchar(255)   NULL,
    "image_url" varchar(255)   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_company_types" PRIMARY KEY (
        "id"
     )
);


CREATE TABLE "main_services" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "description" varchar   NULL,
    "icon_url" varchar   NULL,
    "image_url" varchar   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    -- ADDED BY CREENX 2024-04-19 1709
    "description_ar" varchar   NULL,
    -- added by creenx 2024-04-30 1351H as per design
    -- Global Tagging
    "tag_id" bigint[]   NULL,
    CONSTRAINT "pk_main_services" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "services" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "description" varchar   NULL,
    "icon_url" varchar   NULL,
    "image_url" varchar   NULL,
    "main_services_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    -- ADDED BY CREENX 2024-04-19 1709
    "description_ar" varchar   NULL,
    -- added by mansour 2024-04-24 1231H
    -- Global Tagging FK >- global_tagging.id
    "tag_id" bigint[]   NULL,
    "service_rank" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_services" PRIMARY KEY (
        "id"
     )
);

-- added by creenx 2024-04-19 1716
CREATE TABLE "services_media" (
    "id" bigserial   NOT NULL,
    "company_types_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "is_main_service" bool   NOT NULL,
    -- main service or sub service id
    "services_id" bigint   NOT NULL,
    "image_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "video360_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    -- added by creenx 2024-05-01 1013H
    -- gallery_type bigint
    "main_media_section" varchar   NOT NULL,
    CONSTRAINT "pk_services_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "payment_plans_packages" (
    "id" bigserial   NOT NULL,
    -- either this is project_properties, owner properties,broker_company_agent_properties etc
    "properties_id" bigint   NULL,
    -- the value will be 1 or 2 or 3 or 4 only
    "property" bigint   NULL,
    "option_no" bigint   NOT NULL,
    "percentage" varchar   NOT NULL,
    "date" timestamptz   NULL,
    "milestone" varchar   NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_property" bool   NOT NULL,
    "unit_id" bigint   NULL,
    "is_branch" bool   NOT NULL,
    -- agricultural, property hub, project, industrial ,units, etc
    "from_which_section" varchar   NOT NULL,
    CONSTRAINT "pk_payment_plans_packages" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "blog_categories" (
    "id" bigserial   NOT NULL,
    "category_title" varchar   NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "description" varchar NULL,
    CONSTRAINT "pk_blog_categories" PRIMARY KEY (
        "id"
     )
);

-- CREATE TABLE "blog" (
--     "id" bigserial   NOT NULL,
--     "company_id" bigint   NOT NULL,
--     -- either this is broker, developer or services company
--     "company_type" bigint   NOT NULL,
--     "blog_categories_id" bigint   NOT NULL,
--     "title" varchar   NOT NULL,
--     "description" varchar   NOT NULL,
--     "cover_image_url" varchar   NOT NULL,
--     "status" bigint   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     CONSTRAINT "pk_blog" PRIMARY KEY (
--         "id"
--      )
-- );
CREATE TABLE "sessions" (
    "id" bigserial   NOT NULL,
    "users_id" bigint   NOT NULL,
    "refresh_security" text   NOT NULL,
    "is_blocked" bool   NOT NULL,
    "expired_at" timestamptz   NOT NULL,
    "created_at" timestamptz   NOT NULL,
    "updated_at" timestamptz   NOT NULL,
    CONSTRAINT "pk_sessions" PRIMARY KEY (
        "id"
     )
);

-- permissions
-- --
-- id bigserial PK
-- title varchar
-- section_permissions
-- --
-- id bigserial PK
-- title varchar
-- permissions_id bigint[]
-- roles_permissions
-- --
-- id bigserial PK
-- roles_id bigint FK - roles.id
-- section_permissions_id bigint[]
-- section_permission
-- --
-- id bigserial PK
-- title varchar
-- sub_title varchar NULL
-- created_at timestamptz DEFAULT=NOW()
-- updated_at timestamptz DEFAULT=NOW()
-- permissions
-- --
-- id bigserial PK
-- title varchar
-- sub_title varchar NULL
-- section_permission_id bigint FK - section_permission.id
-- created_at timestamptz DEFAULT=NOW()
-- updated_at timestamptz DEFAULT=NOW()
-- secondary_permission
-- --
-- id bigserial PK
-- title varchar
-- sub_title varchar
-- permission_id bigint FK - permissions.id
-- created_at timestamptz DEFAULT=NOW()
-- updated_at timestamptz DEFAULT=NOW()
-- Ternary_permission
-- --
-- id bigserial PK
-- title varchar
-- sub_title varchar
-- secondary_permission_id bigint FK - secondary_permission.id
-- created_at timestamptz DEFAULT=NOW()
-- updated_at timestamptz DEFAULT=NOW()
CREATE TABLE "roles_permissions" (
    "id" bigserial   NOT NULL,
    "roles_id" bigint   NOT NULL,
    -- its list of permissions table
    "permissions_id" bigint[]   NOT NULL,
    "sub_section_permission" bigint[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_roles_permissions" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "freelancers_companies" (
    "id" bigserial   NOT NULL,
    "company_name" varchar   NOT NULL,
    "commercial_license_no" varchar   NOT NULL,
    "commercial_license_file" varchar   NOT NULL,
    "commercial_license_issue_date" timestamptz   NOT NULL,
    "commercial_license_expiry_date" timestamptz   NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_freelancers_companies" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "freelancers" (
    "id" bigserial   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "users_id" bigint   NOT NULL,
    -- freelancers_bank_account_details_id bigint NULL
    "about" varchar(255)   NULL,
    "about_arabic" varchar(255)   NULL,
    "nationalities" bigint[]   NOT NULL,
    "brn" varchar   NOT NULL,
    "br_file" varchar   NOT NULL,
    "facebook_profile_url" varchar   NULL,
    "instagram_profile_url" varchar   NULL,
    "linkedin_profile_url" varchar   NULL,
    "twitter_profile_url" varchar   NULL,
    "youtube" varchar   NULL,
    "status" bigint   NOT NULL,
    "noc_file" varchar   NOT NULL,
    "noc_expiry_date" timestamptz   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- Remove it later ....  FK >- freelancers_companies.id
    "freelancers_companies" bigint   NULL,
    CONSTRAINT "pk_freelancers" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "freelancers_bank_account_details" (
    "id" bigserial   NOT NULL,
    "account_name" varchar(255)   NOT NULL,
    "account_number" varchar(255)   NOT NULL,
    "iban" varchar(255)   NOT NULL,
    "countries_id" bigint   NOT NULL,
    "currency_id" bigint   NOT NULL,
    "bank_name" varchar(255)   NOT NULL,
    "branch" varchar(255)   NOT NULL,
    "swift_code" varchar(255)   NOT NULL,
    "freelancers_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_freelancers_bank_account_details" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "freelancers_properties" (
    "id" bigserial   NOT NULL,
    "property_title" varchar(255)   NOT NULL,
    "property_title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "property_rank" bigint  DEFAULT 1 NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "locations_id" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    -- remove this
    "profiles_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "facilities_id" bigint[]   NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    "freelancers_id" bigint   NOT NULL,
    "is_show_owner_info" bool  DEFAULT true NOT NULL,
    "property" bigint  DEFAULT 2 NOT NULL,
    -- facts_values json
    "countries_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "developer_company_name" varchar   NULL,
    "sub_developer_company_name" varchar   NULL,
    -- only Sale or Rent
    "category" varchar   NOT NULL,
    "investment" bool  DEFAULT false NOT NULL,
    "contract_start_datetime" timestamptz   NULL,
    "contract_end_datetime" timestamptz   NULL,
    "amount" float  DEFAULT 0.0 NOT NULL,
    -- ask_price bool DEFAULT=FALSE
    -- id's list of property_types
    "unit_types" bigint[]   NOT NULL,
    -- created by
    "users_id" bigint   NOT NULL,
    "property_name" varchar   NOT NULL,
    "list_of_date" timestamptz[]   NOT NULL,
    "list_of_notes" varchar[]   NOT NULL,
    "list_of_agent" bigint[]   NOT NULL,
    -- user id for user_type owner || owner of this property
    "owner_users_id" bigint   NULL,
    CONSTRAINT "pk_freelancers_properties" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_freelancers_properties_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "freelancers_properties_documents" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "freelancers_properties_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_freelancers_properties_documents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "freelancers_properties_media" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "freelancers_properties_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_freelancers_properties_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "properties_facts" (
    "id" bigserial   NOT NULL,
    -- for studio the value will be studio & for other than studio its 1,2,3 & so on..
    "bedroom" varchar NULL,
    "bathroom" bigint   NULL,
    "plot_area" float   NULL,
    "built_up_area" float   NULL,
    "view" bigint[]   NULL,
    "furnished" bigint   NULL,
    "ownership" bigint   NULL,
    "completion_status" bigint   NULL,
    "start_date" timestamptz   NULL,
    "completion_date" timestamptz   NULL,
    "handover_date" timestamptz   NULL,
    "no_of_floor" bigint   NULL,
    -- for project its means no of properties & for properties its means no of units
    "no_of_units" bigint   NULL,
    "min_area" float   NULL,
    "max_area" float   NULL,
    "service_charge" bigint   NULL,
    "parking" bigint   NULL,
    "ask_price" bool   NULL,
    "price" float   NULL,
    "rent_type" bigint   NULL,
    "no_of_payment" bigint   NULL,
    "no_of_retail" bigint   NULL,
    "no_of_pool" bigint   NULL,
    "elevator" bigint   NULL,
    "starting_price" bigint   NULL,
    "life_style" bigint   NULL,
    -- id of project properties, owner properties etc.
    "properties_id" bigint   NULL,
    -- either 1, 2,3 or 4
    "property" bigint   NOT NULL,
    -- true if broker agent property is branch
    "is_branch" bool   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "available_units" bigint   NULL,
    "commercial_tax" float   NULL,
    "municipality_tax" float   NULL,
    -- true for single phase project only
    "is_project_fact" bool  DEFAULT false NOT NULL,
    "project_id" bigint   NULL,
    -- only for off_plan, project, how many percent completed
    "completion_percentage" bigint   NULL,
    -- only for off_plan project, how many percent completed till this date
    "completion_percentage_date" timestamptz   NULL,
    -- unit_type
    "type_name_id" bigint   NULL,
    -- added for service_chargers currency & unit
    -- FK >- currency.id
    "sc_currency_id" bigint   NULL,
    "unit_of_measure" varchar   NULL,
    CONSTRAINT "pk_properties_facts" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "project_completion_history" (
    "id" bigserial   NOT NULL,
    "projects_id" bigint   NOT NULL,
    -- in case of multi-phase project
    "phases_id" bigint   NULL,
    "completion_percentage" float   NOT NULL,
    "completion_percentage_date" timestamptz   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_project_completion_history" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "unit_facts" (
    "id" bigserial   NOT NULL,
     -- for studio the value will be studio & for other than studio its 1,2,3 & so on..
    "bedroom" varchar NULL,
    "bathroom" bigint   NULL,
    "plot_area" float   NULL,
    "built_up_area" float   NULL,
    "view" bigint[]   NULL,
    "furnished" bigint   NULL,
    "ownership" bigint   NULL,
    "completion_status" bigint   NULL,
    "start_date" timestamptz   NULL,
    "completion_date" timestamptz   NULL,
    "handover_date" timestamptz   NULL,
    "no_of_floor" bigint   NULL,
    "no_of_units" bigint   NULL,
    "min_area" float   NULL,
    "max_area" float   NULL,
    "service_charge" bigint   NULL,
    "parking" bigint   NULL,
    "ask_price" bool   NOT NULL,
    "price" float   NULL,
    "rent_type" bigint   NULL,
    "no_of_payment" bigint   NULL,
    "no_of_retail" bigint   NULL,
    "no_of_pool" bigint   NULL,
    "elevator" bigint   NULL,
    "starting_price" bigint   NULL,
    "life_style" bigint   NULL,
    -- id of sale property unit, rent property unit, etc also from branch tables
    "unit_id" bigint   NOT NULL,
    -- either sale,rent or exchange
    "category" varchar   NOT NULL,
    -- true if the unit is branch
    "is_branch" bool   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "commercial_tax" float   NULL,
    "municipality_tax" float   NULL,
    -- added by creenx 2024-03-18 0920H
    -- FK >- currency.id
    "sc_currency_id" bigint NULL, 
    "unit_of_measure" varchar NULL, 
    CONSTRAINT "pk_unit_facts" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "xml_url" (
    "id" bigserial   NOT NULL,
    "url" varchar   NOT NULL,
    "company_id" bigint   NOT NULL,
    -- broker company or developer company or services company
    "company_type" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_xml_url" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "xml_ref_history" (
    "id" bigserial   NOT NULL,
    "xml_url_id" bigint   NOT NULL,
    -- reference number of the xml unit
    "ref_no" varchar   NOT NULL,
    -- unit_id bigint
    -- category varchar
    -- is_branch bool
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_xml_ref_history" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "exchange_offer_category" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "ref_id" varchar   NOT NULL,
    CONSTRAINT "pk_exchange_offer_category" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "exchange_offers" (
    "id" bigserial   NOT NULL,
    "expiry_date" timestamptz   NOT NULL,
    "description" varchar   NOT NULL,
    "offer_category_id" bigint   NOT NULL,
    "exchange_unit_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_exchange_offers" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "facilities_amenities_categories" (
    "id" bigserial   NOT NULL,
    "category" varchar   NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_facilities_amenities_categories" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "industrial_freelancer_properties" (
    "id" bigserial   NOT NULL,
    "property_title" varchar(255)   NOT NULL,
    "property_title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "property_rank" bigint  DEFAULT 1 NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "locations_id" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "facilities_id" bigint[]   NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    "freelancers_id" bigint   NOT NULL,
    "is_show_owner_info" bool  DEFAULT true NOT NULL,
    "property" bigint  DEFAULT 2 NOT NULL,
    "countries_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "developer_company_name" varchar   NULL,
    "sub_developer_company_name" varchar   NULL,
    -- only Sale or Rent
    "category" varchar   NOT NULL,
    "investment" bool  DEFAULT false NOT NULL,
    "contract_start_datetime" timestamptz   NULL,
    "contract_end_datetime" timestamptz   NULL,
    "amount" bigint  DEFAULT 0 NOT NULL,
    -- id's list of property_types
    "unit_types" bigint[]   NOT NULL,
    -- created by
    "users_id" bigint   NOT NULL,
    "property_name" varchar   NOT NULL,
    -- user id for user_type owner || owner of this property
    "owner_users_id" bigint   NULL,
    CONSTRAINT "pk_industrial_freelancer_properties" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_industrial_freelancer_properties_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "industrial_freelancer_properties_documents" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "industrial_freelancer_properties_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_industrial_freelancer_properties_documents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "industrial_freelancer_properties_media" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "industrial_freelancer_properties_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_industrial_freelancer_properties_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "industrial_broker_agent_properties" (
    "id" bigserial   NOT NULL,
    "property_title" varchar(255)   NOT NULL,
    "property_title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "property_rank" bigint  DEFAULT 1 NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "locations_id" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "facilities_id" bigint[]   NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    "broker_companies_id" bigint   NOT NULL,
    "broker_company_agents" bigint   NOT NULL,
    "is_show_owner_info" bool  DEFAULT true NOT NULL,
    "property" bigint  DEFAULT 3 NOT NULL,
    "countries_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "developer_company_name" varchar   NULL,
    "sub_developer_company_name" varchar   NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    -- only sale or rent
    "category" varchar   NOT NULL,
    "investment" bool  DEFAULT false NOT NULL,
    "contract_start_datetime" timestamptz   NULL,
    "contract_end_datetime" timestamptz   NULL,
    "amount" bigint  DEFAULT 0 NOT NULL,
    -- id's list of property_types
    "unit_types" bigint[]   NOT NULL,
    -- created_by
    "users_id" bigint   NOT NULL,
    "property_name" varchar   NOT NULL,
    -- is the data inserted from xml feed or not
    "from_xml" bool  DEFAULT false NOT NULL,
    -- user id for user_type owner || owner of this property
    "owner_users_id" bigint   NULL,
    CONSTRAINT "pk_industrial_broker_agent_properties" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_industrial_broker_agent_properties_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "industrial_broker_agent_properties_documents" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "industrial_broker_agent_properties_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_industrial_broker_agent_properties_documents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "industrial_broker_agent_properties_media" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "industrial_broker_agent_properties_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_industrial_broker_agent_properties_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "industrial_broker_agent_properties_branch" (
    "id" bigserial   NOT NULL,
    "property_title" varchar(255)   NOT NULL,
    "property_title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "property_rank" bigint  DEFAULT 1 NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "locations_id" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "facilities_id" bigint[]   NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    "broker_companies_branches_id" bigint   NOT NULL,
    "broker_company_branches_agents" bigint   NOT NULL,
    "is_show_owner_info" bool  DEFAULT true NOT NULL,
    "property" bigint  DEFAULT 3 NOT NULL,
    "countries_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "developer_company_name" varchar   NULL,
    "sub_developer_company_name" varchar   NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    -- only sale or rent
    "category" varchar   NOT NULL,
    "investment" bool  DEFAULT false NOT NULL,
    "contract_start_datetime" timestamptz   NULL,
    "contract_end_datetime" timestamptz   NULL,
    "amount" bigint  DEFAULT 0 NOT NULL,
    -- id's list of property_types
    "unit_types" bigint[]   NOT NULL,
    -- created_by
    "users_id" bigint   NOT NULL,
    "property_name" varchar   NOT NULL,
    -- is the data inserted from xml feed or not
    "from_xml" bool  DEFAULT false NOT NULL,
    -- user id for user_type owner || owner of this property
    "owner_users_id" bigint   NULL,
    CONSTRAINT "pk_industrial_broker_agent_properties_branch" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_industrial_broker_agent_properties_branch_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "industrial_broker_agent_properties_branch_document" (
    "id" bigserial   NOT NULL,
    -- FK - documents_category.id // we need to fix this issue it's creating same index somewhere else ...
    "documents_categories_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "industrial_broker_agent_properties_branch_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_industrial_broker_agent_properties_branch_document" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "industrial_broker_agent_properties_branch_media" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "industrial_broker_agent_properties_branch_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    CONSTRAINT "pk_industrial_broker_agent_properties_branch_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "industrial_owner_properties" (
    "id" bigserial   NOT NULL,
    "property_title" varchar(255)   NOT NULL,
    "property_title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "property_rank" bigint  DEFAULT 1 NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "locations_id" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    "facilities_id" bigint[]   NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_show_owner_info" bool  DEFAULT true NOT NULL,
    "property" bigint  DEFAULT 4 NOT NULL,
    "countries_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- only sale or rent
    "category" varchar   NOT NULL,
    "investment" bool  DEFAULT false NOT NULL,
    "contract_start_datetime" timestamptz   NULL,
    "contract_end_datetime" timestamptz   NULL,
    "amount" bigint  DEFAULT 0 NOT NULL,
    -- id's list of property_types
    "unit_types" bigint[]   NOT NULL,
    -- created by
    "users_id" bigint   NOT NULL,
    "property_name" varchar   NOT NULL,
    CONSTRAINT "pk_industrial_owner_properties" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_industrial_owner_properties_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "industrial_owner_properties_documents" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "industrial_owner_properties_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_industrial_owner_properties_documents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "industrial_owner_properties_media" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "industrial_owner_properties_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    CONSTRAINT "pk_industrial_owner_properties_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "industrial_properties_facts" (
    "id" bigserial   NOT NULL,
    -- for studio the value will be studio & for other than studio its 1,2,3 & so on..
    "bedroom" varchar NULL,
    "bathroom" bigint   NULL,
    "plot_area" bigint   NULL,
    "built_up_area" bigint   NULL,
    "view" bigint[]   NULL,
    "furnished" bigint   NULL,
    "ownership" bigint   NULL,
    "completion_status" bigint   NULL,
    "start_date" timestamptz   NULL,
    "completion_date" timestamptz   NULL,
    "handover_date" timestamptz   NULL,
    "no_of_floor" bigint   NULL,
    "no_of_units" bigint   NULL,
    "min_area" bigint   NULL,
    "max_area" bigint   NULL,
    "service_charge" bigint   NULL,
    "parking" bigint   NULL,
    "ask_price" bool   NOT NULL,
    "price" bigint   NULL,
    "rent_type" bigint   NULL,
    "no_of_payment" bigint   NULL,
    "no_of_retail" bigint   NULL,
    "no_of_pool" bigint   NULL,
    "elevator" bigint   NULL,
    "starting_price" bigint   NULL,
    "life_style" bigint   NULL,
    -- id of industrial broker properties, owner properties or freelancer.
    "properties_id" bigint   NOT NULL,
    -- either 1, 2,3 or 4
    "property" bigint   NOT NULL,
    -- true if broker agent property is branch
    "is_branch" bool   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "available_units" bigint   NULL,
    "commercial_tax" bigint   NULL,
    "municipality_tax" bigint   NULL,
    "workshop" bigint   NULL,
    "warehouse" bigint   NULL,
    "office" bigint   NULL,
    CONSTRAINT "pk_industrial_properties_facts" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "industrial_unit_types" (
    "id" bigserial   NOT NULL,
    "description" varchar   NULL,
    "image_url" varchar[]   NOT NULL,
    "min_area" float   NOT NULL,
    "max_area" float   NOT NULL,
    "min_price" float   NOT NULL,
    "max_price" float   NOT NULL,
    "parking" bigint  DEFAULT 0 NOT NULL,
    "balcony" bigint  DEFAULT 0 NOT NULL,
    "properties_id" bigint   NOT NULL,
    -- either this table is related to freelancer_properties, owener properties or any one of 2 other tables
    "property" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- Type A, Type B etc
    "title" varchar   NOT NULL,
    -- Studio, 1 Bedroom, until 11 then 12+
    "bedrooms" varchar   NULL,
    CONSTRAINT "pk_industrial_unit_types" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "industrial_unit_types_branch" (
    "id" bigserial   NOT NULL,
    "description" varchar   NULL,
    "image_url" varchar[]   NOT NULL,
    "min_area" float   NOT NULL,
    "max_area" float   NOT NULL,
    "min_price" float   NOT NULL,
    "max_price" float   NOT NULL,
    "parking" bigint  DEFAULT 0 NOT NULL,
    "balcony" bigint  DEFAULT 0 NOT NULL,
    -- branch table id's
    "properties_id" bigint   NOT NULL,
    -- either this table is related to freelancer_properties, owener properties or any one of 2 other tables
    "property" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- Type A, Type B etc
    "title" varchar   NOT NULL,
    -- Studio, 1 Bedroom, until 11 then 12+
    "bedrooms" varchar   NULL,
    CONSTRAINT "pk_industrial_unit_types_branch" PRIMARY KEY (
        "id"
     )
);

-- table for floor plan, master plan etc
CREATE TABLE "industrial_properties_plans" (
    "id" bigserial   NOT NULL,
    "img_url" varchar[]   NOT NULL,
    -- floor plan, master plan etc
    "title" varchar   NOT NULL,
    -- any one id from these tables owner properties, broker agent properties, freelancer properties
    "properties_id" bigint   NOT NULL,
    "property" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_industrial_properties_plans" PRIMARY KEY (
        "id"
     )
);

-- table for floor plan, master plan etc || branch data will be save
CREATE TABLE "industrial_properties_plans_branch" (
    "id" bigserial   NOT NULL,
    "img_url" varchar[]   NOT NULL,
    -- floor plan, master plan etc
    "title" varchar   NOT NULL,
    -- any one id from these tables owner properties, broker agent properties, freelancer properties
    "properties_id" bigint   NOT NULL,
    "property" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_industrial_properties_plans_branch" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "agricultural_freelancer_properties" (
    "id" bigserial   NOT NULL,
    "property_title" varchar(255)   NOT NULL,
    "property_title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "property_rank" bigint  DEFAULT 1 NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "locations_id" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "facilities_id" bigint[]   NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    "freelancers_id" bigint   NOT NULL,
    "is_show_owner_info" bool  DEFAULT true NOT NULL,
    "property" bigint  DEFAULT 2 NOT NULL,
    "countries_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "developer_company_name" varchar   NULL,
    "sub_developer_company_name" varchar   NULL,
    -- only Sale or Rent or exchange
    "category" varchar   NOT NULL,
    "investment" bool  DEFAULT false NOT NULL,
    "contract_start_datetime" timestamptz   NULL,
    "contract_end_datetime" timestamptz   NULL,
    "amount" bigint  DEFAULT 0 NOT NULL,
    -- id's list of property_types
    "unit_types" bigint[]   NOT NULL,
    -- created by
    "users_id" bigint   NOT NULL,
    "property_name" varchar   NOT NULL,
    -- user id for user_type owner || owner of this property
    "owner_users_id" bigint   NULL,
    CONSTRAINT "pk_agricultural_freelancer_properties" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_agricultural_freelancer_properties_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "agricultural_freelancer_properties_documents" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "agricultural_freelancer_properties_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_agricultural_freelancer_properties_documents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "agricultural_freelancer_properties_media" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "agricultural_freelancer_properties_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_agricultural_freelancer_properties_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "agricultural_broker_agent_properties" (
    "id" bigserial   NOT NULL,
    "property_title" varchar(255)   NOT NULL,
    "property_title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "property_rank" bigint  DEFAULT 1 NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "locations_id" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "facilities_id" bigint[]   NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    "broker_companies_id" bigint   NOT NULL,
    "broker_company_agents" bigint   NOT NULL,
    "is_show_owner_info" bool  DEFAULT true NOT NULL,
    "property" bigint  DEFAULT 3 NOT NULL,
    "countries_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "developer_company_name" varchar   NULL,
    "sub_developer_company_name" varchar   NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    -- only sale or rent
    "category" varchar   NOT NULL,
    "investment" bool  DEFAULT false NOT NULL,
    "contract_start_datetime" timestamptz   NULL,
    "contract_end_datetime" timestamptz   NULL,
    "amount" bigint  DEFAULT 0 NOT NULL,
    -- id's list of property_types
    "unit_types" bigint[]   NOT NULL,
    -- created_by
    "users_id" bigint   NOT NULL,
    "property_name" varchar   NOT NULL,
    -- is the data inserted from xml feed or not
    "from_xml" bool  DEFAULT false NOT NULL,
    -- user id for user_type owner || owner of this property
    "owner_users_id" bigint   NULL,
    CONSTRAINT "pk_agricultural_broker_agent_properties" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_agricultural_broker_agent_properties_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "agricultural_broker_agent_properties_documents" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "agricultural_broker_agent_properties_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_agricultural_broker_agent_properties_documents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "agricultural_broker_agent_properties_media" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "agricultural_broker_agent_properties_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_agricultural_broker_agent_properties_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "agricultural_broker_agent_properties_branch" (
    "id" bigserial   NOT NULL,
    "property_title" varchar(255)   NOT NULL,
    "property_title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "property_rank" bigint  DEFAULT 1 NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "locations_id" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "facilities_id" bigint[]   NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    "broker_companies_branches_id" bigint   NOT NULL,
    "broker_company_branches_agents" bigint   NOT NULL,
    "is_show_owner_info" bool  DEFAULT true NOT NULL,
    "property" bigint  DEFAULT 3 NOT NULL,
    "countries_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "developer_company_name" varchar   NULL,
    "sub_developer_company_name" varchar   NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    -- only sale or rent
    "category" varchar   NOT NULL,
    "investment" bool  DEFAULT false NOT NULL,
    "contract_start_datetime" timestamptz   NULL,
    "contract_end_datetime" timestamptz   NULL,
    "amount" bigint  DEFAULT 0 NOT NULL,
    -- id's list of property_types
    "unit_types" bigint[]   NOT NULL,
    -- created_by
    "users_id" bigint   NOT NULL,
    "property_name" varchar   NOT NULL,
    -- is the data inserted from xml feed or not
    "from_xml" bool  DEFAULT false NOT NULL,
    -- user id for user_type owner || owner of this property
    "owner_users_id" bigint   NULL,
    CONSTRAINT "pk_agricultural_broker_agent_properties_branch" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_agricultural_broker_agent_properties_branch_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "agricultural_broker_agent_properties_branch_document" (
    "id" bigserial   NOT NULL,
    -- FK - documents_category.id // we need to fix this issue it's creating same index somewhere else ...
    "documents_categories_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "agricultural_broker_agent_properties_branch_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_agricultural_broker_agent_properties_branch_document" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "agricultural_broker_agent_properties_branch_media" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "agricultural_broker_agent_properties_branch_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    CONSTRAINT "pk_agricultural_broker_agent_properties_branch_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "agricultural_owner_properties" (
    "id" bigserial   NOT NULL,
    "property_title" varchar(255)   NOT NULL,
    "property_title_arabic" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "property_rank" bigint  DEFAULT 1 NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "locations_id" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    "facilities_id" bigint[]   NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_show_owner_info" bool  DEFAULT true NOT NULL,
    "property" bigint  DEFAULT 4 NOT NULL,
    "countries_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- only sale or rent
    "category" varchar   NOT NULL,
    "investment" bool  DEFAULT false NOT NULL,
    "contract_start_datetime" timestamptz   NULL,
    "contract_end_datetime" timestamptz   NULL,
    "amount" bigint  DEFAULT 0 NOT NULL,
    -- id's list of property_types
    "unit_types" bigint[]   NOT NULL,
    -- created by
    "users_id" bigint   NOT NULL,
    "property_name" varchar   NOT NULL,
    CONSTRAINT "pk_agricultural_owner_properties" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_agricultural_owner_properties_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "agricultural_owner_properties_documents" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "agricultural_owner_properties_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_agricultural_owner_properties_documents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "agricultural_owner_properties_media" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "agricultural_owner_properties_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    CONSTRAINT "pk_agricultural_owner_properties_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "agricultural_properties_facts" (
    "id" bigserial   NOT NULL,
    -- for studio the value will be studio & for other than studio its 1,2,3 & so on..
    "bedroom" varchar NULL,
    "bathroom" bigint   NULL,
    "plot_area" bigint   NULL,
    "built_up_area" bigint   NULL,
    "view" bigint[]   NULL,
    "furnished" bigint   NULL,
    "ownership" bigint   NULL,
    "completion_status" bigint   NULL,
    "start_date" timestamptz   NULL,
    "completion_date" timestamptz   NULL,
    "handover_date" timestamptz   NULL,
    "no_of_floor" bigint   NULL,
    "no_of_units" bigint   NULL,
    "min_area" bigint   NULL,
    "max_area" bigint   NULL,
    "service_charge" bigint   NULL,
    "parking" bigint   NULL,
    "ask_price" bool   NOT NULL,
    "price" bigint   NULL,
    "rent_type" bigint   NULL,
    "no_of_payment" bigint   NULL,
    "no_of_retail" bigint   NULL,
    "no_of_pool" bigint   NULL,
    "elevator" bigint   NULL,
    "starting_price" bigint   NULL,
    "life_style" bigint   NULL,
    -- id of agricultural broker properties, owner properties or freelancer.
    "properties_id" bigint   NOT NULL,
    -- either 1, 2,3 or 4
    "property" bigint   NOT NULL,
    -- true if broker agent property is branch
    "is_branch" bool   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "available_units" bigint   NULL,
    "commercial_tax" bigint   NULL,
    "municipality_tax" bigint   NULL,
    "no_of_tree" bigint   NULL,
    "no_of_water_well" bigint   NULL,
    "no_of_workers_house" bigint   NULL,
    CONSTRAINT "pk_agricultural_properties_facts" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "agricultural_unit_types" (
    "id" bigserial   NOT NULL,
    "description" varchar   NULL,
    "image_url" varchar[]   NOT NULL,
    "min_area" float   NOT NULL,
    "max_area" float   NOT NULL,
    "min_price" float   NOT NULL,
    "max_price" float   NOT NULL,
    "parking" bigint  DEFAULT 0 NOT NULL,
    "balcony" bigint  DEFAULT 0 NOT NULL,
    "properties_id" bigint   NOT NULL,
    -- either this table is related to freelancer_properties, owener properties or any one of 2 other tables
    "property" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- Type A, Type B etc
    "title" varchar   NOT NULL,
    -- Studio, 1 Bedroom, until 11 then 12+
    "bedrooms" varchar   NULL,
    CONSTRAINT "pk_agricultural_unit_types" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "agricultural_unit_types_branch" (
    "id" bigserial   NOT NULL,
    "description" varchar   NULL,
    "image_url" varchar[]   NOT NULL,
    "min_area" float   NOT NULL,
    "max_area" float   NOT NULL,
    "min_price" float   NOT NULL,
    "max_price" float   NOT NULL,
    "parking" bigint  DEFAULT 0 NOT NULL,
    "balcony" bigint  DEFAULT 0 NOT NULL,
    -- branch table id's
    "properties_id" bigint   NOT NULL,
    -- either this table is related to freelancer_properties, owener properties or any one of 2 other tables
    "property" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- Type A, Type B etc
    "title" varchar   NOT NULL,
    -- Studio, 1 Bedroom, until 11 then 12+
    "bedrooms" varchar   NULL,
    CONSTRAINT "pk_agricultural_unit_types_branch" PRIMARY KEY (
        "id"
     )
);

-- table for floor plan, master plan etc
CREATE TABLE "agricultural_properties_plans" (
    "id" bigserial   NOT NULL,
    "img_url" varchar[]   NOT NULL,
    -- floor plan, master plan etc
    "title" varchar   NOT NULL,
    -- any one id from these tables owner properties, broker agent properties, freelancer properties
    "properties_id" bigint   NOT NULL,
    "property" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_agricultural_properties_plans" PRIMARY KEY (
        "id"
     )
);

-- table for floor plan, master plan etc || branch data will be save
CREATE TABLE "agricultural_properties_plans_branch" (
    "id" bigserial   NOT NULL,
    "img_url" varchar[]   NOT NULL,
    -- floor plan, master plan etc
    "title" varchar   NOT NULL,
    -- any one id from these tables owner properties, broker agent properties, freelancer properties
    "properties_id" bigint   NOT NULL,
    "property" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_agricultural_properties_plans_branch" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "property_unit_likes" (
    "id" bigserial   NOT NULL,
    "property_unit_id" bigint   NOT NULL,
    -- it will be either sale, or sale_branch, rent or rent_branch, exchange or exchange_branch or any other ...
    "which_property_unit" bigint   NOT NULL,
    -- propertyhub related keys
    "which_propertyhub_key" bigint   NULL,
    "is_branch" boolean  DEFAULT false NOT NULL,
    "is_liked" boolean  DEFAULT false NOT NULL,
    "like_reaction_id" bigint   NOT NULL,
    "users_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_property_unit_likes" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "property_unit_saved" (
    "id" bigserial   NOT NULL,
    "property_unit_id" bigint   NOT NULL,
    -- it will be either sale, or sale_branch, rent or rent_branch, exchange or exchange_branch or any other ...
    "which_property_unit" bigint   NOT NULL,
    -- propertyhub related keys
    "which_propertyhub_key" bigint   NULL,
    "is_branch" boolean  DEFAULT false NOT NULL,
    "is_saved" boolean  DEFAULT false NOT NULL,
    "collection_name_id" bigint   NOT NULL,
    "users_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_property_unit_saved" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "collection_name" (
    "id" bigserial   NOT NULL,
    "name" varchar   NOT NULL,
    "image_url" varchar   NOT NULL,
    "access_type" bigint   NOT NULL,
    "access_granted_users" bigint[]   NOT NULL,
    "users_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_collection_name" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "property_unit_comments" (
    "id" bigserial   NOT NULL,
    "property_unit_id" bigint   NOT NULL,
    "which_property_unit" bigint   NOT NULL,
    -- propertyhub related keys
    "which_propertyhub_key" bigint   NULL,
    "is_branch" boolean  DEFAULT false NOT NULL,
    "users_id" bigint   NOT NULL,
    "comment" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_property_unit_comments" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "leaders" (
    "id" bigserial   NOT NULL,
    "name" varchar   NOT NULL,
    "position" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "image_url" varchar   NOT NULL,
    "is_branch" boolean   NOT NULL,
    -- 1 => broker company , 2 => developer , 3 => service company
    "company_type" bigint   NOT NULL,
    "company_id" bigint   NOT NULL,
    -- create by user id ...
    "users_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- added for verification
    "is_verified" bool  DEFAULT false NOT NULL,
    CONSTRAINT "pk_leaders" PRIMARY KEY (
        "id"
     )
);

-- the users will be added by company admin
CREATE TABLE "company_users" (
    "id" bigserial   NOT NULL,
    "users_id" bigint   NOT NULL,
    -- this user related to the company, primary key of broker_companies, developer_companies or services_companies table & also branches companies
    "company_id" bigint   NOT NULL,
    -- type of a company, either broker company, developer company or services company 1 or 2 or 3
    "company_type" bigint   NOT NULL,
    -- either the company is parent or branch
    "is_branch" bool   NOT NULL,
    "designation" varchar   NOT NULL,
    -- created by user id ...
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "description" varchar NULL,
    CONSTRAINT "pk_company_users" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "professions" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NOT NULL,
    CONSTRAINT "pk_professions" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "contacts" (
    "id" bigserial   NOT NULL,
    "users_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- Static Value 1 - Company, 2 - Individual
    "contact_category_id" bigint   NOT NULL,
    -- company_id bigint
    -- which_company bigint
    -- static values Mr. ---
    "salutation" varchar   NOT NULL,
    "name" varchar   NOT NULL,
    "lastname" varchar   NOT NULL,
    -- it can be multiple
    "all_languages_id" bigint[]   NOT NULL,
    "ejari" varchar   NOT NULL,
    "assigned_to" bigint[]   NOT NULL,
    "shared_with" bigint[]   NOT NULL,
    "remarks" varchar   NOT NULL,
    "is_blockedlisted" boolean   NOT NULL,
    "is_vip" boolean   NOT NULL,
    "correspondence" varchar   NOT NULL,
    "direct_markerting" int[]   NOT NULL,
    "status" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
    "contact_platform" bigint[]   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_by" bigint   NULL,
    CONSTRAINT "pk_contacts" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_contacts_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "shareable_contact_details" (
    "id" bigserial   NOT NULL,
    "contacts_id" bigint   NOT NULL,
    "mobile" varchar   NOT NULL,
    "mobile_share" boolean   NOT NULL,
    "mobile2" varchar   NOT NULL,
    "mobile2_share" boolean   NOT NULL,
    "landline" varchar   NOT NULL,
    "landline_share" boolean   NOT NULL,
    "fax" varchar   NOT NULL,
    "fax_share" boolean   NOT NULL,
    "email" varchar   NOT NULL,
    "email_share" boolean   NOT NULL,
    "second_email" varchar   NOT NULL,
    "second_email_share" boolean   NOT NULL,
    "added_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_shareable_contact_details" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "contacts_individual_details" (
    "id" bigserial   NOT NULL,
    "contacts_id" bigint   NOT NULL,
    -- to be connected to companies table
    "comapanies_id" bigint   NOT NULL,
    -- Static: 1 - Broker, 2 - Developer, 3 - Service
    "company_category" bigint   NOT NULL,
    -- company branch or not
    "is_branch" bool   NOT NULL,
    "date_of_birth" timestamptz   NULL,
    "professions_id" bigint   NULL,
    -- Static male Female Other
    "gender" varchar   NULL,
    -- Static values Single, married
    "marital_status" bigint   NULL,
    "nationality" bigint   NULL,
    "id_type" bigint   NULL,
    "id_number" varchar   NULL,
    -- to be connected  to countries.id
    "id_country_id" bigint   NULL,
    "id_issued_date" timestamptz   NULL,
    "id_expiry_date" timestamptz   NULL,
    "passport_number" varchar   NULL,
    -- to be connected to countries.id
    "passport_country_id" bigint   NULL,
    "passport_issued_date" timestamptz   NULL,
    "passport_expiry_date" timestamptz   NULL,
    "interests" varchar   NULL,
    CONSTRAINT "pk_contacts_individual_details" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "contacts_company_details" (
    "id" bigserial   NOT NULL,
    "contacts_id" bigint   NOT NULL,
    -- to be connected to companies table
    "companies_id" bigint   NOT NULL,
    -- to validate which company
    "company_category" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "no_of_employees" bigint   NULL,
    "industry_id" bigint   NULL,
    "no_local_business" bigint   NULL,
    "retail_category_id" bigint   NULL,
    "no_remote_business" bigint   NULL,
    "nationality" bigint   NULL,
    "license" varchar   NULL,
    "issued_date" timestamptz   NULL,
    "expiry_date" timestamptz   NULL,
    "external_id" varchar   NULL,
    CONSTRAINT "pk_contacts_company_details" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "contacts_address" (
    "id" bigserial   NOT NULL,
    "contacts_id" bigint   NOT NULL,
    -- 1 - Residence, 2 -Company
    "address_type_id" bigint   NOT NULL,
    "address1" varchar   NOT NULL,
    "address2" varchar   NOT NULL,
    "countries_id" bigint   NOT NULL,
    "states_id" bigint   NULL,
    "cities_id" bigint   NULL,
    "community_id" bigint   NULL,
    "sub_community_id" bigint   NULL,
    "postal_code" bigint   NOT NULL,
    CONSTRAINT "pk_contacts_address" PRIMARY KEY (
        "id"
     )
);

-- correspondence varchar NULL REMOVED
-- direct_markerting bigint[] REMOVED
CREATE TABLE "contacts_other_contact" (
    "id" bigserial   NOT NULL,
    "contacts_id" bigint   NOT NULL,
    "relationship" varchar   NOT NULL,
    "other_contacts_id" bigint   NOT NULL,
    "date_added" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_contacts_other_contact" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "contacts_unit" (
    "id" bigserial   NOT NULL,
    "contacts_id" bigint   NOT NULL,
    -- Sales, Rent, Exchange, Properties, etc
    "property_unit" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    -- forign key depends on property_unit
    "unit_id" bigint   NOT NULL,
    CONSTRAINT "pk_contacts_unit" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "contacts_projects" (
    "id" bigserial   NOT NULL,
    "contacts_id" bigint   NOT NULL,
    "project_id" bigint   NOT NULL,
    CONSTRAINT "pk_contacts_projects" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "contacts_document" (
    "id" bigserial   NOT NULL,
    "contacts_id" bigint   NULL,
    "document_category_id" bigint   NOT NULL,
    "expiry_date" timestamptz   NOT NULL,
    "is_private" boolean   NOT NULL,
    "document_url" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    "description" varchar   NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "title" varchar NOT NULL,
    CONSTRAINT "pk_contacts_document" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "contacts_transaction" (
    "id" bigserial   NOT NULL,
    "contacts_id" bigint  NULL,
    "leads_id" bigint   NOT NULL,
    -- // 1 - Owner, 2 - Buyer, 3 - Seller
    "contact_type" bigint   NOT NULL,
    -- unit_category varchar changed
    "category" varchar   NOT NULL,
    -- is_branch bool removed
    -- foreign key depend on property
    "property_ref_no" varchar   NOT NULL,
    "unit_ref_no" varchar   NOT NULL,
    "transaction_date" timestamptz   NOT NULL,
    CONSTRAINT "pk_contacts_transaction" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "contacts_activity_header" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "created_by" bigint   NOT NULL,
    "assigned_to" bigint[]   NOT NULL,
    "contacts_activity_type" bigint   NOT NULL,
    -- /*
    -- Contact Activity Types
    -- 1 - Outgoing Call
    -- 2 - Data Entry
    -- 3 - Checked
    -- 4 - Enter Unit
    -- 5 - Location
    -- 6 - Incoming Call
    -- */
    "reference_no" varchar   NOT NULL,
    "moving_date" timestamp   NOT NULL,
    "phone_number" varchar   NOT NULL,
    "email" varchar   NOT NULL,
    "subject" varchar   NOT NULL,
    "comments" varchar   NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- added by creenx 2024-03-19 1254H
    -- if its null so no need of reference than
    -- FK >-  contacts.id
    "contacts_id" bigint  NULL,
    CONSTRAINT "pk_contacts_activity_header" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "contacts_activity_details" (
    "id" bigserial   NOT NULL,
    "contacts_activity_header_id" bigint   NOT NULL,
    "contacts_activity_type" bigint   NOT NULL,
    -- /*
    -- Contact Activity Types
    -- 1 - Outgoing Call
    -- 2 - Data Entry
    -- 3 - Checked
    -- 4 - Enter Unit
    -- 5 - Location
    -- 6 - Incoming Call
    -- */
    "interval" bigint   NOT NULL,
    "interval_type" bigint   NOT NULL,
    CONSTRAINT "pk_contacts_activity_details" PRIMARY KEY (
        "id"
     )
);

-- /*
-- Interval Types
-- 1 - Seconds
-- 2 - Minutes
-- 3 - Hours
-- 4 - Days
-- 5 - Weeks
-- 6 - Months
-- 7 - Years
-- */
CREATE TABLE "contacts_access" (
    "id" bigserial   NOT NULL,
    "contacts_id" bigint  NULL,
    "access_name" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NULL,
    CONSTRAINT "pk_contacts_access" PRIMARY KEY (
        "id"
     )
);
 
CREATE TABLE "leads" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "contacts_id" bigint   NOT NULL,
    "lead_source" bigint   NULL,
    "media_name" bigint   NULL,
    "lead_type" bigint   NOT NULL,
    "contact_type" bigint   NOT NULL,
    -- connected to countries
    "languages" bigint[]   NOT NULL,
    "property_category" bigint   NOT NULL,
    "is_property" bool   NULL,
    -- Sale, Rent, Exchange, Property, etc...
    "unit_category" varchar   NULL,
    "property_type_id" bigint   NULL,
    "is_luxury" bool   NULL,
    -- ID of the property/unit
    "property_unit_id" bigint   NULL,
    "property_statuses_id" bigint   NULL,
    "purpose_id" bigint   NULL,
    "min_budget" float   NULL,
    "max_budget" float   NULL,
    "min_area" float   NULL,
    "max_area" float   NULL,
    "bedroom" bigint   NULL,
    "bathroom" bigint   NULL,
    "countries_id" bigint   NOT NULL,
    "states_id" bigint   NOT NULL,
    "cities_id" bigint   NOT NULL,
    "community_id" bigint[]   NOT NULL,
    "subcommunity_id" bigint[]   NOT NULL,
    "lat" varchar   NULL,
    "lng" varchar   NULL,
    "assigned_to" bigint   NULL,
    "residential_status" bigint   NULL,
    "referred_to" bigint   NULL,
    "is_exclusive" bool   NULL,
    "priority_level" bigint   NULL,
    "is_finance" bool   NULL,
    "mortgage_bank_id" bigint   NULL,
    -- Visible for Sale Lead Types
    "mortgage_status" bigint   NULL,
    "required_start" timestamptz   NULL,
    "required_end" timestamptz   NULL,
    -- will be filled if the status is closed
    "closing_remarks" varchar   NULL,
    "internal_notes" varchar   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "leads_won" bool NULL,
    -- added by creenx 2024-04-27 1351H
    "with_reference" bool NULL,
    "is_property_branch" bool NULL,
    "property_reference_name" varchar NULL,
    "social_media_name" varchar NULL,
    "section_type" bigint[] NOT NULL,
    CONSTRAINT "pk_leads" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_leads_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "leads_progress" (
    "id" bigserial   NOT NULL,
    "leads_id" bigint   NOT NULL,
    "progress_date" timestamptz  DEFAULT now() NOT NULL,
    "progress_status" bigint   NOT NULL,
    "lead_status" bigint   NOT NULL,
    CONSTRAINT "pk_leads_progress" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "leads_notification" (
    "id" bigserial   NOT NULL,
    "leads_id" bigint   NOT NULL,
    "agent_sms" boolean   NOT NULL,
    "agent_mail" boolean   NOT NULL,
    "agent_whatsapp" boolean   NOT NULL,
    "agent_system_notofication" boolean   NOT NULL,
    "lead_sms" boolean   NOT NULL,
    "lead_mail" boolean   NOT NULL,
    "lead_whatsapp" boolean   NOT NULL,
    "lead_system_notification" boolean   NOT NULL,
    "follow_up_email" boolean   NOT NULL,
    "closed_lost_email" boolean   NOT NULL,
    "closed_lost_sms" boolean   NOT NULL,
    "closed_lost_whatsapp" boolean   NOT NULL,
    "closed_won_email" boolean   NOT NULL,
    "closed_won_sms" boolean   NOT NULL,
    "closed_won_whatsapp" boolean   NOT NULL,
    CONSTRAINT "pk_leads_notification" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "leads_properties" (
    "id" bigserial   NOT NULL,
    -- FK >- leads.id
    "leads_id" bigint   NULL,
    "properies_type_id" bigint   NULL,
    "property_id" bigint   NULL,
    "unit_category" varchar   NULL,
    "unit_id" bigint   NULL,
    "is_branch" bool   NOT NULL,
    "date_added" timestamptz  DEFAULT now() NOT NULL,
    "is_property" bool   NOT NULL,
    CONSTRAINT "pk_leads_properties" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "leads_document" (
    "id" bigserial   NOT NULL,
    "leads_id" bigint   NULL,
    -- to be connectede to documents_category table
    "document_category_id" bigint   NOT NULL,
    "title" varchar   NOT NULL,
    "is_private" boolean   NOT NULL,
    "document_url" varchar   NOT NULL,
    "date_added" timestamptz  DEFAULT now() NOT NULL,
    "expiry_date" timestamptz   NULL,
    "description" varchar   NOT NULL,
    "entered_by" bigint   NOT NULL,
    CONSTRAINT "pk_leads_document" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "contact_preferences" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NOT NULL,
    CONSTRAINT "pk_contact_preferences" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "retail_category" (
    "id" bigserial   NOT NULL,
    -- FK - retail_category.id
    "parent_retail_id" bigint   NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NOT NULL,
    CONSTRAINT "pk_retail_category" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "lead_general_requests" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "contact_id" bigint   NOT NULL,
    "lead_id" bigint   NOT NULL,
    "request_type" bigint   NOT NULL,
    "view_appointment_id" bigint   NULL,
    "request_date" timestamptz  DEFAULT now() NOT NULL,
    "request_status" bigint   NOT NULL,
    CONSTRAINT "pk_lead_general_requests" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_lead_general_requests_ref_no" UNIQUE (
        "ref_no"
    )
);

-- // Property  Statuses REMOVE PLS.!!!
-- // Booking OPen, Available, Booked, On-Lease, Sale, Sold, Cancel
CREATE TABLE "industry" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NOT NULL,
    CONSTRAINT "pk_industry" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "document_categories" (
    "id" bigserial   NOT NULL,
    "parent_category_id" bigint   NOT NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NOT NULL,
    CONSTRAINT "pk_document_categories" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "leads_creation" (
    "id" bigserial   NOT NULL,
    "leads_id" bigint   NOT NULL,
    "lead_details" bool   NOT NULL,
    "reference_details" bool   NOT NULL,
    "notification" bool   NOT NULL,
    "documents" bool   NOT NULL,
    "internal_notes" bool   NOT NULL,
    "properties" bool DEFAULT false NOT NULL,
    CONSTRAINT "pk_leads_creation" PRIMARY KEY (
        "id"
     )
);

-- main_section
-- --
-- id bigint PK
-- main_section_name varchar
-- main_section_name_constanct varchar
-- section_permissions
-- --
-- id bigint PK
-- section_name varchar
-- section_name_constant varchar
-- main_section_id bigint FK - main_section.id
CREATE TABLE "section_permission" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "sub_title" varchar   NULL,
    "indicator" bigint  DEFAULT 0 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_section_permission" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "permissions" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "sub_title" varchar   NULL,
    "indicator" bigint  DEFAULT 0 NOT NULL,
    "section_permission_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_permissions" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "sub_section" (
    "id" bigserial   NOT NULL,
    "sub_section_name" varchar   NOT NULL,
    "sub_section_name_constant" varchar   NOT NULL,
    "permissions_id" bigint   NOT NULL,
    "indicator" bigint  DEFAULT 0 NOT NULL,
    "sub_section_button_id" bigint   NOT NULL,
    "sub_section_button_action" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_sub_section" PRIMARY KEY (
        "id","sub_section_button_id"
     )
);

-- 1 - Transactions
-- 2 - File View
-- 3 - Portal View
CREATE TABLE "activity_changes" (
    "id" bigserial   NOT NULL,
    "section_id" bigint   NOT NULL,
    "activities_id" bigint   NOT NULL,
    "field_name" varchar   NULL,
    "before" varchar   NULL,
    "after" varchar   NULL,
    "activity_date" timestamptz   NULL,
    CONSTRAINT "pk_activity_changes" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "property_hub_activities" (
    "id" bigserial   NOT NULL,
    "company_types_id" bigint   NULL,
    "companies_id" bigint   NULL,
    "is_branch" bool   NULL,
    "is_property" bool   NOT NULL,
    "is_property_branch" bool   NOT NULL,
    "unit_category" varchar   NULL,
    -- Property ID or Unit ID
    "property_unit_id" bigint   NULL,
    "module_name" varchar   NOT NULL,
    "activity_type" bigint   NOT NULL,
    "file_category" bigint   NULL,
    "file_url" varchar   NULL,
    "portal_url" varchar   NULL,
    "activity" varchar   NOT NULL,
    "user_id" bigint   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_property_hub_activities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "units_activities" (
    "id" bigserial   NOT NULL,
    "company_types_id" bigint   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "is_unit_branch" bool   NOT NULL,
    "is_property" bool   NOT NULL,
    "is_property_branch" bool   NOT NULL,
    "unit_category" varchar   NOT NULL,
    "property_unit_id" bigint   NOT NULL,
    "module_name" varchar   NOT NULL,
    "activity_type" bigint   NOT NULL,
    "file_category" bigint   NULL,
    "portal_url" varchar   NULL,
    "file_url" varchar   NULL,
    "actvity" varchar   NOT NULL,
    "user_id" bigint   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_units_activities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "companies_activities" (
    "id" bigserial   NOT NULL,
    "activity_type" bigint   NOT NULL,
    -- 1 - Transactions
    -- 2 - File View
    -- 3 - Portal View
    "portal_url" varchar   NULL,
    -- connected to company type
    "company_type_id" bigint   NOT NULL,
    -- [ref: > companies.id]
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    -- null if transactions and portal view
    "file_category" bigint   NULL,
    -- 1 - Media
    -- 2 - Plans
    -- 3 - Documents
    -- null if transactions and portal view
    "file_url" varchar   NULL,
    "activity" varchar   NOT NULL,
    "user_id" bigint   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    -- added by asim b/c it was required
    "ref_no" varchar   NOT NULL,
    CONSTRAINT "pk_companies_activities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "agents_activities" (
    "id" bigserial   NOT NULL,
    "company_types_id" bigint   NOT NULL,
    -- [ref: >  companies.id]
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "activity_type" bigint   NOT NULL,
    -- 1 - Transactions
    -- 2 - File View
    -- 3 - Portal View
    -- connected to company user id
    "company_users_id" bigint   NOT NULL,
    "field_name" varchar[]   NULL,
    -- null if transactions and portal view
    "file_category" bigint   NULL,
    -- 1 - Media
    -- 2 - Plans
    -- 3 - Documents
    "file_url" varchar   NOT NULL,
    "activity" varchar   NOT NULL,
    "users_id" bigint   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    -- added by creenx
    "ref_activity_id" bigint   NOT NULL,
    CONSTRAINT "pk_agents_activities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "products_services_activities" (
    "id" bigserial   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    "activity_type" bigint   NOT NULL,
    -- 1 - Transactions
    -- 2 - File View
    -- 3 - Portal View
    "portal_url" varchar   NULL,
    -- [ref: > companies.id]
    "companies_id" bigint   NOT NULL,
    "company_types" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    -- true if services, false if products
    "is_products" bool   NOT NULL,
    -- products_id if products, service_id if service
    "product_service_id" bigint   NOT NULL,
    -- If Activity Type is File View
    -- FK >- company_products_gallery.id
    "product_gallery_id" bigint   NOT NULL,
    "activity" varchar   NOT NULL,
    -- [ref: users.id]
    "users_id" bigint   NOT NULL,
    -- added by creenx
    "ref_activity_id" bigint   NOT NULL,
    CONSTRAINT "pk_products_services_activities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "aqary_media_activities" (
    "id" bigserial   NOT NULL,
    "aqary_media_type" bigint   NOT NULL,
    -- 1 - Posts
    -- 2 - Ads
    "activity_type" bigint   NOT NULL,
    -- 1 - Transactions
    -- 2 - File View
    -- 3 - Portal View
    "companies_types_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "activity" varchar   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    "users_id" bigint   NOT NULL,
    -- added by creenx
    "ref_activity_id" bigint   NOT NULL,
    CONSTRAINT "pk_aqary_media_activities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "banner_ads_activities" (
    "id" bigserial   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    "activity_type" bigint   NOT NULL,
    -- 1 - Transactions
    -- 2 - File View
    -- 3 - Portal View
    "company_types_id" bigint   NOT NULL,
    -- [ref: >  companies.id]
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "banner_ads_type" bigint   NULL,
    -- Ad Types
    -- 1 - Banner
    -- 2 - Company Videos
    -- 3 - Project Videos
    -- 4 - Tower Project Videos
    -- 5 - Tower Property Videos
    -- FK >- banners.id
    "banners_ads_id" bigint   NOT NULL,
    -- For File View Category
    "banner_ads_media_url" varchar   NOT NULL,
    -- if Ad Type is banner
    "banner_url" varchar   NOT NULL,
    "activity" varchar   NOT NULL,
    "users_id" bigint   NOT NULL,
    -- added by creenx
    "ref_activity_id" bigint   NOT NULL,
    CONSTRAINT "pk_banner_ads_activities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "network_activities" (
    "id" bigserial   NOT NULL,
    "company_types_id" bigint   NULL,
    -- [ref: >  companies.id]
    "companies_id" bigint   NULL,
    "is_branch" bool   NULL,
    "activity_type" bigint   NOT NULL,
    "module_name" varchar   NULL,
    "file_url" varchar   NULL,
    "portal_url" varchar   NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    "activity" varchar   NOT NULL,
    "users_id" bigint   NOT NULL,
    -- added by creenx
    "ref_activity_id" bigint   NOT NULL
);

CREATE TABLE "blogs_activities" (
    "id" bigserial   NOT NULL,
    "company_types_id" bigint   NOT NULL,
    -- [ref: >  companies.id]
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "activity_type" bigint   NOT NULL,
    -- 1 - Transactions
    -- 2 - File View
    -- blogs or blog category
    "blog_module" varchar   NOT NULL,
    -- Blog ID or Blog Category ID
    "ref_id" bigint   NOT NULL,
    -- If Blogs
    "blog_media_url" varchar   NOT NULL,
    "title" varchar   NOT NULL,
    "field_name" varchar[]   NULL,
    "activity" varchar   NOT NULL,
    -- [ref: > users.id]
    "users_id" bigint   NOT NULL,
    "activity_date" timestamptz   NOT NULL,
    -- added by creenx
    "ref_activity_id" bigint   NOT NULL,
    CONSTRAINT "pk_blogs_activities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "community_guides_activities" (
    "id" bigserial   NOT NULL,
    "activity_type" bigint   NOT NULL,
    -- 1 - Transactions
    -- 2 - File View
    "module_name" varchar   NOT NULL,
    -- 1 - Community
    -- 2 - Tower Image
    -- 3 - Publish Status
    "file_url" varchar   NOT NULL,
    "activity_date" timestamptz   NOT NULL,
    "activity" varchar   NOT NULL,
    "user_id" bigint   NOT NULL,
    -- added by creenx
    "ref_activity_id" bigint   NOT NULL,
    CONSTRAINT "pk_community_guides_activities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "management_activities" (
    "id" bigserial   NOT NULL,
    "activity_type" bigint   NOT NULL,
    -- !Transaction only
    "company_types_id" bigint   NOT NULL,
    -- [ref: >  companies.id]
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "module_name" varchar   NOT NULL,
    "activity" varchar   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    "user_id" bigint   NOT NULL,
    CONSTRAINT "pk_management_activities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "careers_activities" (
    "id" bigserial   NOT NULL,
    "activity_type" bigint   NOT NULL,
    "company_types_id" bigint   NOT NULL,
    -- [ref: >  companies.id]
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "module_name" varchar   NOT NULL,
    "activity" varchar   NOT NULL,
    -- NULL If activity type is not File view
    "file_url" varchar   NULL,
    "actvitiy_date" timestamptz   NOT NULL,
    "user_id" bigint   NOT NULL,
    -- added by creenx
    "ref_activity_id" bigint   NOT NULL,
    CONSTRAINT "pk_careers_activities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "settings_activities" (
    "id" bigserial   NOT NULL,
    "company_types_id" bigint   NOT NULL,
    -- [ref: >  companies.id]
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "activity_type" bigint   NOT NULL,
    "module_name" varchar   NOT NULL,
    "activity" varchar   NOT NULL,
    "activity_date" timestamptz   NOT NULL,
    "user_id" bigint   NOT NULL,
    -- added by creenx
    "ref_activity_id" bigint   NOT NULL,
    CONSTRAINT "pk_settings_activities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "booking_activities" (
    "id" bigserial   NOT NULL,
    "company_types_id" bigint   NOT NULL,
    -- [ref: >  companies.id]
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "booking_type" bigint   NOT NULL,
    "activity_type" bigint   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    "ref_activity_id" bigint   NOT NULL,
    "module_name" varchar   NULL,
    "file_url" varchar   NULL,
    "portal_url" varchar   NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_booking_activities" PRIMARY KEY (
        "id"
     )
);

-- added by creenx 2024-05-28 1403H
CREATE TABLE "tax_management_activities" (
    "id" bigserial   NOT NULL,
    "ref_activity_id" bigint   NOT NULL,
    "company_types_id" bigint   NOT NULL,
    -- [ref: >  companies.id]
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "activity_type" bigint   NOT NULL,
    "module_name" varchar   NOT NULL,
    "activity" varchar   NOT NULL,
    "activity_date" timestamptz   NOT NULL,
    "user_id" bigint   NOT NULL,
    CONSTRAINT "pk_tax_management_activities" PRIMARY KEY (
        "id"
     )
);

-- 1 - Reported
-- 2 - Resolving
-- 3 - Resolved
-- 4 - Closed
-- 5 - Cancelled
CREATE TABLE "problem_reports" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_type_id" bigint   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "problem_categories_id" bigint   NOT NULL,
    -- 1 - Facilities
    -- 2 - Amenities
    -- 3 - Product and Services
    -- 4 - Unit / Properties
    -- 5 - Application
    -- 6 - Agents
    -- 7 - Others
    -- If Problem is from 1 - 4
    "is_project" bool   NOT NULL,
    "is_project_branch" bool   NOT NULL,
    "is_property" bool   NOT NULL,
    "is_property_branch" bool   NOT NULL,
    -- Sale, Rent, Exchange
    "property_category" varchar   NULL,
    "is_unit_branch" bool   NULL,
    -- ID of the property or unit
    "property_unit_id" bigint   NULL,
    -- If problem is Agents
    -- connected to agent id
    "agents_id" bigint   NULL,
    -- If problem category is application or others
    "module_name" varchar   NULL,
    -- If Problem Category is Products and services
    -- true if products
    "is_products" bool   NULL,
    -- ID of Product or Service
    "product_service_id" bigint   NULL,
    "problems" varchar   NOT NULL,
    "reasons_resolutions" varchar   NULL,
    "reported_by" bigint   NOT NULL,
    "reported_date" timestamptz  DEFAULT now() NOT NULL,
    "problem_status" bigint  DEFAULT 1 NOT NULL,
    -- 1 - Reported
    -- 2 - Resolved
    -- 4 - Closed
    -- 5 - Cancelled
    "cancelled_date" timestamptz  DEFAULT now() NOT NULL,
    "resolved_date" timestamptz  DEFAULT now() NOT NULL,
    "assigned_to" bigint   NOT NULL,
    CONSTRAINT "pk_problem_reports" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_problem_reports_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "social_reactions" (
    "id" bigserial   NOT NULL,
    "social_categories_id" bigint   NOT NULL,
    "reacted_to" bigint   NOT NULL,
    CONSTRAINT "pk_social_reactions" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "social_reactions_details" (
    "id" bigserial   NOT NULL,
    "social_reactions_id" bigint   NOT NULL,
    "reacted_by" bigint   NOT NULL,
    "reaction_types_id" bigint   NOT NULL,
    "reaction_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_social_reactions_details" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "connections_settings" (
    "id" bigserial   NOT NULL,
    "user_id" bigint   NOT NULL,
    "connection_request" bigint   NOT NULL,
    "follow_me" bigint   NOT NULL,
    "post_and_comments" bigint   NOT NULL,
    "gallery" bigint   NOT NULL,
    "public_profile_info" bigint   NOT NULL,
    "messaging" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NOT NULL,
    CONSTRAINT "pk_connections_settings" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "social_connections" (
    "id" bigserial   NOT NULL,
    -- connection_request_id bigint FK >- connection_requests.id
    "user_id" bigint   NOT NULL,
    -- can be companies.id or users.id
    "requested_by" bigint   NOT NULL,
    "request_date" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    -- added by creenx 2024-03-13 1048H
    "remarks" varchar   NOT NULL,
    "connection_status_id" bigint   NOT NULL,
    -- added by creenx 2024-04-01 1026H
    "request_company_type" bigint   NULL,
    "request_is_branch" bool   NULL,
    CONSTRAINT "pk_social_connections" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "company_connections" (
    "id" bigserial   NOT NULL,
    "company_type" bigint   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    -- FK >- users.id
    "requested_by" bigint   NOT NULL,
    "request_date" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    -- added by creenx 2024-03-14 1020H
    "remarks" varchar   NULL,
    "connection_status_id" bigint   NOT NULL,
    CONSTRAINT "pk_company_connections" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_connections_requested_by" UNIQUE (
        "requested_by"
    )
);

CREATE TABLE "followers" (
    "id" bigserial   NOT NULL,
    "user_id" bigint   NOT NULL,
    -- FK >- users.id
    "followers_id" bigint   NOT NULL,
    "follow_date" timestamptz  DEFAULT now() NOT NULL,
    -- added by creenx 2024-04-01 0949H
    "follower_company_type" bigint   NULL,
    "follower_is_branch" bool   NULL,
    CONSTRAINT "pk_followers" PRIMARY KEY (
        "id"
     )
);

-- added by creenx 2024-03-30 1449H
CREATE TABLE "company_followers" (
    "id" bigserial   NOT NULL,
    -- company type of the company that been follwed
    "company_types_id" bigint   NOT NULL,
    -- branch of the company that been followed
    "is_branch" bool   NULL,
    -- company that been followed
    "companies_id" bigint   NOT NULL,
    "follower_company_type" bigint   NULL,
    "follower_is_branch" bool   NULL,
    "follower_id" bigint   NOT NULL,
    "date_followed" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_company_followers" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "social_notifications" (
    "id" bigserial   NOT NULL,
    "users_id" bigint   NOT NULL,
    "notification_type" bigint   NOT NULL,
    "notification_details" varchar   NOT NULL,
    "notification_ref_id" bigint   NOT NULL,
    "notification_from" bigint   NOT NULL,
    "notification_date" timestamptz  DEFAULT now() NOT NULL,
    "is_read" bool   NOT NULL,
    CONSTRAINT "pk_social_notifications" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "tags" (
    "id" bigserial   NOT NULL,
    "tag_name" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_tags" PRIMARY KEY (
        "id"
     )
);

-- aqary_posts
-- ---
-- id bigserial PK
-- ref_no varchar unique
-- company_types_id bigint
-- companies_id bigint
-- is_branch bool
-- title varchar
-- is_project bool default=false
-- project_id bigint null
-- is_property_branch bool
-- property_id bigint null
-- is_unit_branch bool
-- unit_id bigint
-- post_category varchar
-- media_types bigint[]
-- media_url varchar[]
-- description varchar
-- post_schema varchar
-- tags bigint[]
-- posted_by bigint FK >- users.id
-- date_posted timestamptz DEFAULT=NOW()
-- is_public bool
-- s_verified bool
-- ost_status bigint default=1
CREATE TABLE "post_followers" (
    "id" bigserial   NOT NULL,
    "company_types_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "aqary_project_posts_id" bigint   NOT NULL,
    "followers_id" bigint[]   NOT NULL,
    "follow_date" timestamptz[]   NOT NULL,
    CONSTRAINT "pk_post_followers" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "posts_projects_comments" (
    "id" bigserial   NOT NULL,
    "parent_post_comments" bigint   NULL,
    "company_types_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "aqary_project_posts_id" bigint   NOT NULL,
    "comments" varchar   NOT NULL,
    "imoji" varchar[]   NULL,
    "commented_by" bigint   NOT NULL,
    "comment_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_posts_projects_comments" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "aqary_property_posts" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_types_id" int   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "title" varchar   NOT NULL,
    "property_unit_id" bigint   NOT NULL,
    "post_category" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "tags" bigint[]   NOT NULL,
    "posted_by" bigint   NOT NULL,
    "date_posted" timestamptz  DEFAULT now() NOT NULL,
    "is_property_branch" bool   NOT NULL,
    "is_verified" bool   NULL,
    "post_schema" varchar   NOT NULL,
    "property_hub_category" bigint   NULL,
    "is_public" bool   NULL,
    CONSTRAINT "pk_aqary_property_posts" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_aqary_property_posts_ref_no" UNIQUE (
        "ref_no"
    )
);

-- added by dreamer
-- FYI Creenx
CREATE TABLE "aqary_property_post_media" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "aqary_property_posts_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_aqary_property_post_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "aqary_project_posts" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_types_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "title" varchar   NOT NULL,
    "project_id" bigint   NOT NULL,
    "is_project_branch" bool   NOT NULL,
    "description" varchar   NOT NULL,
    "post_schema" varchar   NOT NULL,
    "tags" bigint[]   NOT NULL,
    "posted_by" bigint   NOT NULL,
    "date_posted" timestamptz  DEFAULT now() NOT NULL,
    "is_public" bool   NOT NULL,
    "is_verified" bool   NOT NULL,
    CONSTRAINT "pk_aqary_project_posts" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_aqary_project_posts_ref_no" UNIQUE (
        "ref_no"
    )
);

-- added by dreamer
-- FYI Creenx
CREATE TABLE "aqary_project_post_media" (
    "id" bigserial   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "aqary_project_posts" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_aqary_project_post_media" PRIMARY KEY (
        "id"
     )
);

-- aqary_property_posts_medias
-- --
-- id bigserial PK
-- aqary_posts_id bigint  FK >- aqary_posts.id
-- media_type bigint[]
-- media_url varchar[]
-- upload_date timestamptz DEFAULT=NOW()
-- is_deleted bool
-- aqary_property_posts_id bigint
-- this is wrong
-- aqary_project_posts_medias
-- --
-- id bigserial PK
-- aqary_project_posts_id bigint  FK >- aqary_project_posts.id
-- media_type bigint[]
-- media_url varchar[]
-- upload_date timestamptz DEFAULT=NOW()
-- is_deleted bool
CREATE TABLE "aqary_ads" (
    "id" bigserial   NOT NULL,
    "company_types_id" bigint   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "title" varchar   NOT NULL,
    -- Sale, Rent, Exchange, etc
    "ads_category" varchar   NOT NULL,
    "is_project" bool  DEFAULT false NOT NULL,
    "project_id" bigint   NULL,
    "is_project_branch" bool  DEFAULT false NOT NULL,
    "is_property" bool  DEFAULT false NOT NULL,
    "properties_id" bigint   NULL,
    "is_property_branch" bool   NOT NULL,
    "unit_id" bigint   NULL,
    "is_unit_branch" bool   NOT NULL,
    "media_types" bigint[]   NOT NULL,
    "media_url" varchar[]   NOT NULL,
    "ads_schema" varchar   NOT NULL,
    "ads_status" bigint  DEFAULT 1 NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "is_public" bool   NOT NULL,
    "is_verified" bool   NOT NULL,
    "tags" bigint[]   NOT NULL,
    CONSTRAINT "pk_aqary_ads" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "aqary_project_ads" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "project_id" bigint   NOT NULL,
    -- Sale, Rent, Exchange, etc
    "ads_category" varchar   NOT NULL,
    "company_types_id" bigint   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "is_project_branch" bool   NOT NULL,
    "ads_status" bigint   NOT NULL,
    "ads_schema" varchar   NOT NULL,
    -- Ads Status (This will be based on the company subscription)
    -- 1 - Draft
    -- 2 - Posted
    -- 3 - Suspended
    -- 4 - Deleted
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "is_public" bool   NOT NULL,
    "is_verified" bool   NOT NULL,
    "tags" bigint[]   NOT NULL,
    CONSTRAINT "pk_aqary_project_ads" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "aqary_property_ads" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "project_id" bigint   NULL,
    -- Sale, Rent, Exchange, etc
    "ads_category" varchar   NOT NULL,
    "company_types_id" bigint   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "is_project_branch" bool   NOT NULL,
    "is_property" bool   NOT NULL,
    "is_property_branch" bool   NOT NULL,
    "property_unit_id" bigint   NOT NULL,
    "ads_status" bigint   NOT NULL,
    "ads_schema" varchar   NOT NULL,
    -- Ads Status (This will be based on the company subscription)
    -- 1 - Draft
    -- 2 - Posted
    -- 3 - Suspended
    -- 4 - Deleted
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "is_public" bool   NOT NULL,
    "is_verified" bool   NOT NULL,
    "tags" bigint[]   NOT NULL,
    "is_property_unit_branch" bool   NOT NULL,
    "property_hub_category" bigint   NULL,
    CONSTRAINT "pk_aqary_property_ads" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "aqary_property_ads_media" (
    "id" bigserial   NOT NULL,
    "aqary_property_ads" bigint   NOT NULL,
    "media_type" bigint   NOT NULL,
    -- Media Type
    -- 1 - image
    -- 2 - video
    "media_url" varchar   NOT NULL,
    "upload_date" timestamptz  DEFAULT now() NOT NULL,
    "is_deleted" bool   NOT NULL,
    CONSTRAINT "pk_aqary_property_ads_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "aqary_project_ads_media" (
    "id" bigserial   NOT NULL,
    "aqary_project_ads" bigint   NOT NULL,
    "media_type" bigint   NOT NULL,
    -- Media Type
    -- 1 - image
    -- 2 - video
    "media_url" varchar   NOT NULL,
    "upload_date" timestamptz  DEFAULT now() NOT NULL,
    "is_deleted" bool   NOT NULL,
    CONSTRAINT "pk_aqary_project_ads_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "aqary_media_likes" (
    "id" bigserial   NOT NULL,
    "property_unit_id" bigint   NOT NULL,
    -- it will be either sale, or sale_branch, rent or rent_branch, exchange or exchange_branch or any other ... || propertyhub properties
    "which_property_unit" bigint   NOT NULL,
    -- propertyhub related keys
    "which_propertyhub_key" bigint   NULL,
    "is_branch" boolean  DEFAULT false NOT NULL,
    "is_liked" boolean  DEFAULT false NOT NULL,
    "like_reaction_id" bigint   NOT NULL,
    "users_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_aqary_media_likes" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "careers" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "job_title" varchar   NOT NULL,
    "job_title_ar" varchar   NULL,
    "employment_types" bigint[]   NOT NULL,
    "job_categories" bigint   NOT NULL,
    "career_level" bigint   NOT NULL,
    -- company_type bigint NULL
    -- companies_id bigint NULL
    -- is_branch bool NULL
    "countries_id" bigint   NOT NULL,
    "city_id" bigint   NULL,
    "state_id" bigint   NULL,
    "community_id" bigint   NULL,
    "subcommunity_id" bigint   NULL,
    "is_urgent" boolean   NOT NULL,
    "job_description" varchar   NOT NULL,
    "vacancies" bigint   NOT NULL,
    "years_of_experience" bigint   NOT NULL,
    "gender" bigint   NOT NULL,
    "nationality_id" bigint[]   NOT NULL,
    "min_salary" float   NOT NULL,
    "max_salary" float   NOT NULL,
    "uploaded_by" bigint   NOT NULL,
    "date_posted" timestamptz   NOT NULL,
    "date_expired" timestamptz   NOT NULL,
    "career_status" bigint   NOT NULL,
    "education_level" bigint[]   NOT NULL,
    "job_image" varchar   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- the company which is not registered in aqary system
    -- company_name varchar NULL
    "languages" bigint[]   NULL,
    -- added by creenx 2024-03-27 1330H
    "employers_id" bigint   NOT NULL,
    "benefits" bigint[]   NULL,
    -- added by creenx 2024-04-02 1056H
    -- atleast 1 specialization
    "specialization" bigint[]   NOT NULL,
    -- added by majd 2024-07-13 0301H
    -- at least 1 skill
    "skills" bigint[]   NULL,
    -- added by creenx 2024-04-25 1128H - tagging
    -- FK >- global_tagging.id
    "global_tagging_id" bigint[]   NOT NULL,
    -- added by creenx 2024-04-30 1510H
    -- "field_of_studies" varchar[] NULL,
     "field_of_studies" bigint[]   NULL,
    "job_description_ar" varchar NULL,
    CONSTRAINT "pk_careers" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_careers_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "benefits" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NULL,
    "icon_url" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NULL,
    "is_default" bool NULL,
    -- added by creenx 2024-03-29 1012H
    "employer_id" bigint NULL,
    -- added by creenx 2024-04-02 1431H
    "status" bigint DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_benefits" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "employers" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_type" bigint   NULL,
    "company_id" bigint   NULL,
    "is_branch" bool   NULL,
    "company_name" varchar   NOT NULL,
    -- null if the company is registered on system
    "industry_id" bigint   NULL,
    "company_size" bigint   NOT NULL,
    "license_number" varchar   NULL,
    "website" varchar   NULL,
    "email_address" varchar   NOT NULL,
    "mobile_number" varchar   NOT NULL,
    "is_verified" bool   NOT NULL,
    "countries_id" bigint   NOT NULL,
    "states_id" bigint   NOT NULL,
    "cities_id" bigint   NOT NULL,
    "community_id" bigint   NOT NULL,
    "subcommunity_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_employers" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_employers_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "job_categories" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- if its null so no need of reference than
    -- FK >- job_categories.id
    "parent_category_id" bigint   NULL,
    "category_name" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "company_types_id" bigint   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "category_image" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "company_name" varchar   NULL,
    "updated_at" timestamptz NULL,
    CONSTRAINT "pk_job_categories" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_job_categories_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "career_articles" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- company_types_id bigint
    -- companies_id bigint
    -- is_branch bool
    "title" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    -- added for arabic description
    "description_ar" varchar   NULL,
    "cover_image" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    -- the company which is not registered in aqary system
    -- company_name varchar NULL
    -- added by creenx 2024-03-27 1407H
    "employers_id" bigint   NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_career_articles" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_career_articles_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "applicants" (
    "id" bigserial   NOT NULL,
    "firstname" varchar   NOT NULL,
    "lastname" varchar   NOT NULL,
    "email_address" varchar   NOT NULL,
    "mobile_number" varchar   NOT NULL,
    "cv_url" varchar   NOT NULL,
    "cover_letter" varchar   NULL,
    "applicant_info" varchar   NOT NULL,
    -- If the applicant is a registered user to Aqary System
    "users_id" bigint   NULL,
    "is_verified" bool   NOT NULL,
    "expected_salary" float   NULL,
    "highest_education" bigint   NOT NULL,
    "years_of_experience" bigint   NOT NULL,
    "languages" bigint[]   NULL,
    "applicant_photo" varchar   NULL,
    -- added by creenx 2024-04-02 1058H
    -- atleast 1 specialization
    "specialization" bigint[]   NOT NULL,
    -- at least 1 skill
    "skills" bigint[]   NOT NULL,
    -- field of study 
    "field_of_study" varchar NULL,
    "created_at" timestamptz DEFAULT now() NOT NULL,
    "updated_at" timestamptz NULL,
    CONSTRAINT "pk_applicants" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "candidates" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "careers_id" bigint   NOT NULL,
    "applicants_id" bigint   NOT NULL,
    "application_date" timestamptz  DEFAULT now() NOT NULL,
    "application_status" bigint   NOT NULL,
    CONSTRAINT "pk_candidates" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_candidates_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "candidates_milestone" (
    "id" bigserial   NOT NULL,
    "candidates_id" bigint   NOT NULL,
    "application_status" bigint   NOT NULL,
    "status_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_candidates_milestone" PRIMARY KEY (
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

-- added by creenx 2024-04-24 1740h
CREATE TABLE "job_portals" (
    "id" bigserial   NOT NULL,
    "portal_name" varchar   NOT NULL,
    "portal_url" varchar   NOT NULL,
    "portal_logo" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    -- added by creenx 2024-04-26 1137H
    "status" bigint   NOT NULL,
    "updated_at" timestamptz NULL,
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
    -- added by creenx 2024-04-26 1137H
    "status" bigint   NOT NULL,
    CONSTRAINT "pk_posted_career_portal" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_posted_career_portal_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "field_of_studies" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NULL,
    "created_at" timestamptz DEFAULT now() NOT NULL,
    "updated_at" timestamptz NULL,
    CONSTRAINT "pk_field_of_studies" PRIMARY KEY (
        "id"
     )
);


CREATE TABLE "webportals" (
    "id" bigserial   NOT NULL,
    -- company_type_id bigint
    -- companies_id bigint
    -- is_branch bool
    "portal_name" varchar   NOT NULL,
    "contact_person" varchar   NOT NULL,
    "portal_url" varchar   NOT NULL,
    "portal_subscription" bigint   NOT NULL,
    "publish_status" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "is_favorite" bool   NOT NULL,
    "xml_structure" bigint   NOT NULL,
    "xml_file_url" varchar   NOT NULL,
    "portal_logo_url" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    CONSTRAINT "pk_webportals" PRIMARY KEY (
        "id"
     )
);



 



CREATE TABLE "internal_sharing" (
    "id" bigserial   NOT NULL,
    "company_types_id" bigint   NULL,
    "companies_id" bigint   NULL,
    "is_branch" bool  DEFAULT false NULL,
    "is_project" bool   NULL,
    "project_id" bigint   NULL,
    -- is_project_branch bool
    "is_property" bool   NULL,
    "is_property_branch" bool   NULL,
    -- is_unit_branch bool
    "property_id" bigint   NULL,
    "property_key" bigint   NULL,
    -- owners_info bool DEFAULT=FALSE
    "is_unit" bool   NULL,
    "unit_id" bigint   NULL,
    "unit_category" varchar   NULL,
    "price" bool  DEFAULT false NOT NULL,
    -- documents bigint[]
    -- internal_shared_doc_id bigint[]
    "shared_to" bigint[]   NOT NULL,
    "is_enabled" bool[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    -- if phases in case of project
    "phase_id" bigint   NULL,
    CONSTRAINT "pk_internal_sharing" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "shared_doc" (
    "id" bigserial   NOT NULL,
    -- this id can be from internal or external sharing
    "sharing_id" bigint   NOT NULL,
    -- from here you are gonna know which foriegn key it is if true then it will be from internal other wise external
    "is_internal" bool  DEFAULT false NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_project" bool   NULL,
    "project_id" bigint   NULL,
    -- is_project_branch bool DEFAULT=FALSE
    "is_property" bool   NULL,
    "is_property_branch" bool   NULL,
    -- is_unit_branch bool DEFAULT=FALSE
    "property_id" bigint   NULL,
    "property_key" bigint   NULL,
    -- owners_info bool DEFAULT=FALSE
    "is_unit" bool   NULL,
    "unit_id" bigint   NULL,
    "unit_category" varchar   NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    -- it can shared to company or user i.e external company id  or shared_to   // TODO: we have to change it to the array
    "shared_to" bigint   NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    "phase_id" bigint   NULL,
    CONSTRAINT "pk_shared_doc" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "external_sharing" (
    "id" bigserial   NOT NULL,
    "company_types_id" bigint   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    "is_project" bool   NULL,
    "project_id" bigint   NULL,
    -- is_project_branch bool DEFAULT=FALSE
    "is_property" bool   NULL,
    "is_property_branch" bool   NULL,
    -- is_unit_branch bool DEFAULT=FALSE
    "property_id" bigint   NULL,
    "property_key" bigint   NULL,
    -- owners_info bool DEFAULT=FALSE
    "is_unit" bool   NULL,
    "unit_id" bigint   NULL,
    "unit_category" varchar   NULL,
    "price" bool  DEFAULT false NOT NULL,
    -- documents bigint[]
    "external_company_type" bigint[]   NOT NULL,
    "external_is_branch" bool[]   NOT NULL,
    "external_company_id" bigint[]   NOT NULL,
    "external_is_enabled" bool[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    -- if phases in case of project
    "phase_id" bigint   NULL,
    CONSTRAINT "pk_external_sharing" PRIMARY KEY (
        "id"
     )
);

-- -------------- Testing       ---------------------
-- -------------  Do Not Remove ---------------------
CREATE TABLE "publish_listing" (
    "id" bigserial   NOT NULL,
    "is_project" bool   NULL,
    "project_id" int   NULL,
    "phase_id" bigint   NULL,
    "is_property" bool   NULL,
    "property_key" int   NULL,
    "property_id" int   NULL,
    "is_unit" bool   NULL,
    "unit_id" int   NULL,
    "unit_category" varchar   NULL,
    -- if publish came from share then we will check in the shared table other wise all other tables respectively
    "share_id" int   NULL,
    "is_internal" bool  DEFAULT false NOT NULL,
    "title" varchar   NOT NULL,
    "description" text   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    "webportal_id" bigint   NOT NULL,
    "is_enabled" bool   NULL,
    CONSTRAINT "pk_publish_listing" PRIMARY KEY (
        "id"
     )
);



CREATE TABLE "publish_gallery" (
    "id" bigserial   NOT NULL,
    "publish_listing_id" bigint  NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_publish_gallery" PRIMARY KEY (
        "id"
     )
);



CREATE TABLE "publish_plan" (
    "id" bigserial   NOT NULL,
    "publish_listing_id" bigint   NOT NULL,
    "title" varchar   NOT NULL,
    "plan_url" varchar[]   NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_publish_plan" PRIMARY KEY (
        "id"
     )
);



CREATE TABLE "publish_info" (
    "id" bigserial   NOT NULL,
    "company_types_id" bigint   NULL,
    "companies_id" bigint   NULL,
    "is_branch" bool  DEFAULT false NULL,
    "is_project" bool  DEFAULT false NOT NULL,
    "project_id" bigint   NULL,
    -- is_project_branch bool DEFAULT=FALSE
    "is_property" bool  DEFAULT false NOT NULL,
    "is_property_branch" bool  DEFAULT false NOT NULL,
    "is_unit_branch" bool  DEFAULT false NOT NULL,
    "unit_id" bigint   NULL,
    "owners_info" bool  DEFAULT false NOT NULL,
    "unit_no" bool  DEFAULT false NOT NULL,
    "price" bool  DEFAULT false NOT NULL,
    -- documents bigint[]
    -- Social Media Platform
    "social_media_platfrom" varchar[]   NULL,
    "web_portals" bigint[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    -- if phases in case of project
    "phase_id" bigint   NULL,
    "is_enabled" bool[]   NOT NULL,
    "property_id" bigint   NULL,
    CONSTRAINT "pk_publish_info" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "published_doc" (
    "id" bigserial   NOT NULL,
    -- this id can be from publish_info
    "publish_info_id" bigint   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- FK - projects.id
    "projects_id" bigint   NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    -- in case of property
    "property_id" bigint   NULL,
    CONSTRAINT "pk_published_doc" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "banks" (
    "id" bigserial   NOT NULL,
    "bank_name" varchar   NOT NULL,
    "bank_logo_url" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_banks" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "bank_branches" (
    "id" bigserial   NOT NULL,
    "banks_id" bigint   NOT NULL,
    "branch_name" varchar   NOT NULL,
    "countries_id" bigint   NOT NULL,
    "state_id" bigint   NOT NULL,
    "cities_id" bigint   NOT NULL,
    "communities_id" bigint   NOT NULL,
    "sub_communities_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_bank_branches" PRIMARY KEY (
        "id"
     )
);


CREATE TABLE "subscriptions_price" (
    "id" bigserial   NOT NULL,
    -- ref_no varchar unique
    "countries_id" bigint   NOT NULL,
    "subscription_name" varchar   NOT NULL,
    "price" float   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_subscriptions_price" PRIMARY KEY (
        "id"
     )
);


CREATE TABLE "subscription_cost" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "countries_id" int   NOT NULL,
    "featured" float   NOT NULL,
    "premium" float   NOT NULL,
    "standard" float   NOT NULL,
    "deal_of_week" float   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    CONSTRAINT "pk_subscription_cost" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_subscription_cost_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "modules" (
    "id" bigserial   NOT NULL,
    "parent_module_id" bigint   NULL,
    "menu_name" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    CONSTRAINT "pk_modules" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "menu_country_wise" (
    "id" bigserial   NOT NULL,
    "countries_id" bigint   NOT NULL,
    "modules" int[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    CONSTRAINT "pk_menu_country_wise" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "phases_plans" (
    "id" bigserial   NOT NULL,
    -- projects_id bigint
    -- is_branch bool
    "phases_id" bigint   NOT NULL,
    -- floor plan, master plan etc
    "title" varchar   NOT NULL,
    "plan_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "uploaded_by" bigint   NOT NULL,
    "updated_by" bigint   NOT NULL,
    CONSTRAINT "pk_phases_plans" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "phases_facts" (
    "id" bigserial   NOT NULL,
    "phases_id" bigint   NOT NULL,
    "completion_status" bigint   NULL,
    "plot_area" float   NULL,
    "built_up_area" float   NULL,
    "furnished" bigint   NULL,
    "no_of_properties" bigint   NULL,
    "lifestyle" bigint   NULL,
    "ownership" bigint   NULL,
    "start_date" timestamptz   NULL,
    "completion_date" timestamptz   NULL,
    "handover_date" timestamptz   NULL,
    "service_charge" float   NULL,
    "no_of_parkings" bigint   NULL,
    "no_of_retails" bigint   NULL,
    "no_of_pools" bigint   NULL,
    "no_of_elevators" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "update_at" timestamptz  DEFAULT now() NOT NULL,
    -- only for off_plan, project, how many percent completed
    "completion_percentage" float   NULL,
    -- only for off_plan project, how many percent completed till this date
    "completion_percentage_date" timestamptz   NULL,
    -- added for service_chargers currency & unit
    -- FK >- currency.id
    "sc_currency_id" bigint   NULL,
    "unit_of_measure" varchar   NULL,
    "starting_price" bigint NULL,
    CONSTRAINT "pk_phases_facts" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "phases_documents" (
    "id" bigserial   NOT NULL,
    -- projects_id bigint FK >- projects.id
    -- is_branch bool
    "phases_id" bigint   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    "updated_by" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_phases_documents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "financial_providers" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "project_id" bigint   NOT NULL,
    "phases_id" bigint   NULL,
    "provider_company_type" bigint   NOT NULL,
    "is_provider_branch" bool   NOT NULL,
    "provider_companies_id" bigint   NOT NULL,
    CONSTRAINT "pk_financial_providers" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_financial_providers_ref_no" UNIQUE (
        "ref_no"
    )
);


CREATE TABLE "project_plans" (
    "id" bigserial   NOT NULL,
    "projects_id" bigint   NOT NULL,
    -- is_branch bool
    -- floor plan, master plan etc
    "title" varchar   NOT NULL,
    "plan_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "uploaded_by" bigint   NOT NULL,
    "updated_by" bigint   NOT NULL,
    CONSTRAINT "pk_project_plans" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "exhibitions" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- company_type_id bigint
    -- companies_id bigint
    -- is_branch bool
    "is_verified" bool  DEFAULT false NOT NULL,
    "self_hosted" bool   NOT NULL,
    "hosted_by_id" bigint   NULL,
    "is_host_branch" bool   NOT NULL,
    "exhibition_type" bigint   NOT NULL,
    "exhibition_category" bigint   NOT NULL,
    "title" varchar   NOT NULL,
    "start_date" timestamptz   NOT NULL,
    "end_date" timestamptz   NOT NULL,
    "countries_id" bigint   NOT NULL,
    "states_id" bigint   NOT NULL,
    "cities_id" bigint   NOT NULL,
    "community_id" bigint   NOT NULL,
    "specific_address" varchar   NOT NULL,
    -- lat float
    -- lng float
    "mobile" varchar   NOT NULL,
    "email" varchar   NOT NULL,
    "whatsapp" varchar   NOT NULL,
    "registration_link" varchar   NOT NULL,
    "registration_fees" float  DEFAULT 0.00 NULL,
    "event_banner_url" varchar   NOT NULL,
    "event_logo_url" varchar   NOT NULL,
    "promotion_video" varchar   NULL,
    "description" varchar   NOT NULL,
    "description_ar" varchar   NULL,
    "event_status" bigint  DEFAULT 1 NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "hosted_company_type" bigint   NOT NULL,
    -- added by 2024-06-21 1042
    "facilities" bigint[]   NOT NULL,
    -- added by reyan 2024-07-17 1049H
    "no_of_booths" bigint   NULL,
    "sub_communities_id" bigint   NOT NULL,
    "no_of_floors" bigint   NULL,
    "location_url" varchar   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    CONSTRAINT "pk_exhibitions" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_exhibitions_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "exhibitions_media" (
    "id" bigserial   NOT NULL,
    "exhibitions_id" bigint   NOT NULL,
    "video_url" varchar[]   NULL,
    "image_gallery" varchar[]   NULL,
    "brochure" varchar[]   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    CONSTRAINT "pk_exhibitions_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "exhibition_collaborators" (
    "id" bigserial   NOT NULL,
    "collaborator_type" bigint   NOT NULL,
    "exhibitions_id" bigint   NOT NULL,
    "company_name" varchar   NOT NULL,
    "company_website" varchar   NULL,
    "company_logo" varchar   NOT NULL,
    "cover_image" varchar   NULL,
    "is_deleted" bool  DEFAULT false NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "booth_no" varchar NULL,
    CONSTRAINT "pk_exhibition_collaborators" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "exhibition_clients" (
    "id" bigserial   NOT NULL,
    "exhibitions_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "client_name" varchar   NOT NULL,
    "client_email" varchar   NOT NULL,
    "website" varchar   NULL,
    "logo_url" varchar   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "added_by" bigint   NOT NULL,
    CONSTRAINT "pk_exhibition_clients" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_exhibition_clients_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "exhibition_registration" (
    "id" bigserial   NOT NULL,
    "registration_no" varchar   NOT NULL,
    "exhibitions_id" bigint   NOT NULL,
    "date_registered" timestamptz   NOT NULL,
    "firstname" varchar   NOT NULL,
    "lastname" varchar   NOT NULL,
    "mobile" varchar   NOT NULL,
    "email" varchar   NOT NULL,
    "remarks" varchar   NULL,
    "registration_status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_exhibition_registration" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_exhibition_registration_registration_no" UNIQUE (
        "registration_no"
    )
);

CREATE TABLE "exhibition_queries" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "exhibitions_id" bigint   NOT NULL,
    "firstname" varchar   NOT NULL,
    "lastname" varchar   NOT NULL,
    "mobile" varchar   NOT NULL,
    "email" varchar   NOT NULL,
    "subject" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "response" varchar   NULL,
    -- FK >- users.id
    "responded_by" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_exhibition_queries" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_exhibition_queries_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "exhibition_services" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "service_name" varchar   NOT NULL,
    "image_url" varchar   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "exhibitions_id" bigint   NOT NULL,
    CONSTRAINT "pk_exhibition_services" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_exhibition_services_ref_no" UNIQUE (
        "ref_no"
    )
);

-- added by creenx 2024-05-31 1031H
CREATE TABLE "exhibition_booths" (
    "id" bigserial   NOT NULL,
    "exhibitions_id" bigint   NOT NULL,
    "floor_no" varchar   NULL,
    "no_of_booths" bigint   NULL,
    "interactive_link" varchar   NULL,
    CONSTRAINT "pk_exhibition_booths" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "sale_price_history" (
    "id" bigserial   NOT NULL,
    "unit_facts_id" bigint   NOT NULL,
    "price" float   NOT NULL,
    "effectivity_date" timestamptz   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_sale_price_history" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "rental_contract_history" (
    "id" bigserial   NOT NULL,
    "company_type_id" bigint   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "is_property" bool   NOT NULL,
    "is_property_branch" bool   NOT NULL,
    "properties_id" bigint   NULL,
    "unit_id" bigint   NULL,
    "annual_price" float   NOT NULL,
    "payment_type" bigint   NOT NULL,
    "contract_start" timestamptz   NOT NULL,
    "contract_end" timestamptz   NOT NULL,
    "is_terminated" bool   NOT NULL,
    CONSTRAINT "pk_rental_contract_history" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "project_appointment_views" (
    "id" bigserial   NOT NULL,
    "appointment_no" varchar   NOT NULL,
    "appointmet_type" bigint   NOT NULL,
    "project_appointment_slot_id" bigint   NOT NULL,
    "users_id" bigint   NULL,
    "remarks" varchar   NULL,
    "request_date" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    "appointment_status" bigint   NOT NULL,
    "fullname" varchar   NULL,
    "email" varchar   NULL,
    "mobile" varchar   NULL,
    "id_number" varchar   NULL,
    "id_document_url" varchar   NULL,

    CONSTRAINT "uc_project_appointment_views_appointment_no" UNIQUE (
        "appointment_no"
    )
);

CREATE TABLE "project_appointment_slots" (
    "id" bigserial   NOT NULL,
    "project_open_house_id" bigint   NOT NULL,
    "agent_id" bigint   NOT NULL,
    "slot_start" timestamptz   NOT NULL,
    "slot_end" timestamptz   NOT NULL,
    "is_booked" bool  DEFAULT false NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_project_appointment_slots" PRIMARY KEY (
        "id"
     )
);

-- added by creenx 2024-04-17
CREATE TABLE "project_open_house" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "project_id" bigint   NULL,
    "phase_id" bigint   NULL,
    "property_id" bigint   NOT NULL,
    "interval" bigint   NOT NULL,
    "interval_type" bigint   NOT NULL,
    "start_date" timestamptz   NOT NULL,
    "end_date" timestamptz   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_project_open_house" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_project_open_house_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "product_categories" (
    "id" bigserial   NOT NULL,
    "parent_categories_id" bigint   NOT NULL,
    "category_name" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "icon_url" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_product_categories" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "companies_products" (
    "id" bigserial   NOT NULL,
    "product_code" varchar   NOT NULL,
    "model_number" varchar   NOT NULL,
    "serial_number" varchar   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "products_categories_id" bigint   NOT NULL,
    "product_name" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "price" decimal   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool DEFAULT false NULL,
    CONSTRAINT "pk_companies_products" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_companies_products_product_code" UNIQUE (
        "product_code"
    )
);

CREATE TABLE "companies_products_promotions" (
    "id" bigserial   NOT NULL,
    "promotion_title" varchar   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "companies_products_id" bigint   NOT NULL,
    "discount" decimal   NOT NULL,
    "discounted_price" decimal   NOT NULL,
    "promotion_start" timestamptz   NOT NULL,
    "promotion_end" timestamptz   NOT NULL,
    "remarks" varchar   NOT NULL,
    "promotion_status" int   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_companies_products_promotions" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "companies_products_gallery" (
    "id" bigserial   NOT NULL,
    "companies_products_id" bigint   NOT NULL,
    "image_url" varchar[]   NOT NULL,
    "video_url" varchar[]   NOT NULL,
    "image360_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_companies_products_gallery" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "products_inventory" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "companies_products_id" bigint   NOT NULL,
    "quantity" bigint   NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    CONSTRAINT "pk_products_inventory" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_products_inventory_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "product_inbounds" (
    "id" bigserial   NOT NULL,
    "delivery_no" varchar   NOT NULL,
    "date_received" timestamptz   NOT NULL,
    "companies_products_id" bigint   NOT NULL,
    "quantity" int   NOT NULL,
    "received_from" varchar   NOT NULL,
    "processed_by" bigint   NOT NULL,
    "inbound_status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_product_inbounds" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "product_outbounds" (
    "id" bigserial   NOT NULL,
    "issuance_no" varchar   NOT NULL,
    "issuance_date" timestamptz   NOT NULL,
    "product_order_requests_id" bigint   NOT NULL,
    "quantity" int   NOT NULL,
    "delivery_date" timestamptz   NOT NULL,
    "issued_by" bigint   NOT NULL,
    "outbound_status" int   NOT NULL,
    "remarks" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_product_outbounds" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_product_outbounds_issuance_no" UNIQUE (
        "issuance_no"
    )
);

CREATE TABLE "product_order_requests" (
    "id" bigserial   NOT NULL,
    "request_code" varchar   NOT NULL,
    "request_date" timestamptz   NOT NULL,
    "companies_products_id" bigint   NOT NULL,
    "quantity" bigint   NOT NULL,
    "requested_by" bigint   NOT NULL,
    "assigned_to" bigint   NOT NULL,
    "product_transactions_id" bigint   NOT NULL,
    "order_status" bigint   NOT NULL,
    "remarks" varchar   NOT NULL,
    CONSTRAINT "pk_product_order_requests" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_product_order_requests_request_code" UNIQUE (
        "request_code"
    )
);

CREATE TABLE "product_reviews" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "companies_products_id" bigint   NOT NULL,
    "review_date" timestamptz   NOT NULL,
    "review_quality" int   NOT NULL,
    "review_price" int   NOT NULL,
    "customer_service" int   NOT NULL,
    "order_experience" int   NOT NULL,
    "description" varchar   NOT NULL,
    "reviewer" bigint   NOT NULL,
    -- added by creenx 2024-05-13 1215
    "proof_images" varchar[]   NULL,
    "title" varchar  NULL,
    CONSTRAINT "pk_product_reviews" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_product_reviews_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "product_review_comments" (
    "id" bigserial   NOT NULL,
    "product_reviews_id" bigint   NOT NULL,
    "comment_date" timestamptz  DEFAULT now() NOT NULL,
    "commented_by" bigint   NOT NULL,
    "comment" varchar   NOT NULL,
    CONSTRAINT "pk_product_review_comments" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "product_comments_reactions" (
    "id" bigserial   NOT NULL,
    "review_comments_id" bigint   NOT NULL,
    "reaction_types_id" int   NOT NULL,
    "users_id" bigint   NOT NULL,
    "reaction_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_product_comments_reactions" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "companies_products_reactions" (
    "id" bigserial   NOT NULL,
    "companies_product_id" bigint   NOT NULL,
    "reaction_types_id" int   NOT NULL,
    "users_id" bigint   NOT NULL,
    "reaction_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_companies_products_reactions" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "holiday_home_categories" (
    "id" bigserial   NOT NULL,
    "holiday_home_type" bigint   NOT NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_holiday_home_categories" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "booking_portals" (
    "id" bigserial   NOT NULL,
    "portal_name" varchar   NOT NULL,
    "portal_url" varchar   NOT NULL,
    "portal_logo" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_booking_portals" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "holiday_home_portals" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "holiday_home_id" bigint   NOT NULL,
    "booking_portals_id" bigint   NOT NULL,
    "listing_url" varchar   NOT NULL,
    "price" float   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_holiday_home_portals" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_holiday_home_portals_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "holiday_home" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_types_id" bigint   NULL,
    "is_branch" bool   NULL,
    "companies_id" bigint   NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NULL,
    "holiday_home_categories" bigint[]   NOT NULL,
    "countries_id" bigint   NOT NULL,
    "states_id" bigint   NOT NULL,
    "cities_id" bigint   NOT NULL,
    "communities_id" bigint   NOT NULL,
    "subcommunity_id" bigint   NOT NULL,
    "lat" float   NOT NULL,
    "lng" float   NOT NULL,
    "ranking" bigint   NOT NULL,
    "no_of_hours" bigint   NULL,
    "no_of_rooms" bigint   NULL,
    "no_of_bathrooms" bigint   NULL,
    "views" bigint[]   NULL,
    "facilities" bigint[]   NULL,
    "holiday_package_inclusions" bigint[]   NOT NULL,
    "description" varchar   NOT NULL,
    "description_ar" varchar   NULL,
    "posted_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    "holiday_home_type" bigint NOT NULL,
    "no_of_guest" bigint   NULL,
    "price_per_night" float   NULL,
    "price_per_adults" float   NULL,
    "price_per_children" float   NULL,
    "amenities" bigint[]   NULL,
    CONSTRAINT "pk_holiday_home" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_holiday_home_ref_no" UNIQUE (
        "ref_no"
    ),
    CONSTRAINT "uc_holiday_home_title" UNIQUE (
        "title"
    )
);

CREATE TABLE "holiday_media" (
    "id" bigserial   NOT NULL,
    "holiday_home_id" bigint   NOT NULL,
    "image_url" varchar[]   NULL,
    "image360_url" varchar[]   NULL,
    "video_url" varchar[]   NULL,
    "panaroma_url" varchar[]   NULL,
    "main_media_section" varchar   NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_holiday_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "holiday_package_inclusions" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NULL,
    "icon_url" varchar   NOT NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    -- added creenx 2024-05-10 1140H
    "holiday_home_type" bigint  NOT NULL,
    --  Holiday Types
    -- 1 - Stay
    -- 2 - Experience
    CONSTRAINT "pk_holiday_package_inclusions" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "holiday_home_bookings" (
    "id" bigserial   NOT NULL,
    "booking_ref_no" varchar   NOT NULL,
    "book_date" timestamptz  DEFAULT now() NOT NULL,
    "holiday_home_id" bigint   NOT NULL,
    -- holiday_home_promo bigint FK >- holiday_home_promo.id
    "check_in" timestamptz   NULL,
    "check_out" timestamptz   NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "customer_name" varchar NOT NULL,
    "portal_id" bigint NULL,
    CONSTRAINT "pk_holiday_home_bookings" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "holiday_stay_reviews" (
    "id" bigserial   NOT NULL,
    -- id of the Stay Type Holiday Home
    "holiday_home_id" bigint   NOT NULL,
    "review_date" timestamptz  DEFAULT now() NOT NULL,
    "user_id" bigint   NOT NULL,
    "comfortness" float   NOT NULL,
    "communications" float   NOT NULL,
    "cleanliness" float   NOT NULL,
    "location" float   NOT NULL,
    "title" varchar   NOT NULL,
    "review" varchar   NOT NULL,
    CONSTRAINT "pk_holiday_stay_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "holiday_experience_reviews" (
    "id" bigserial   NOT NULL,
    -- id of the Stay Type Holiday Home
    "holiday_home_id" bigint   NOT NULL,
    "review_date" timestamptz  DEFAULT now() NOT NULL,
    "user_id" bigint   NOT NULL,
    "package" float   NOT NULL,
    "adventure" float   NOT NULL,
    "place" float   NOT NULL,
    "travel" float   NOT NULL,
    "title" varchar   NOT NULL,
    "review" varchar   NOT NULL,
    CONSTRAINT "pk_holiday_experience_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "holiday_home_comments" (
    "id" bigserial   NOT NULL,
    "parent_comment" bigint   NULL,
    "holiday_home_id" bigint   NOT NULL,
    "users_id" bigint   NOT NULL,
    "comment_date" timestamptz  DEFAULT now() NOT NULL,
    "comment" varchar   NOT NULL,
    "reaction_type_id" bigint[]   NOT NULL,
    "reacted_by" bigint[]   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_holiday_home_comments" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "holiday_home_promo" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "holiday_home_id" bigint   NOT NULL,
    "booking_portal_id" bigint   NOT NULL,
    "promo_code" varchar   NOT NULL,
    "price" float   NOT NULL,
    "promo_start" timestamptz   NOT NULL,
    "promo_end" timestamptz   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "holiday_home_portals_id" bigint   NOT NULL,
    CONSTRAINT "pk_holiday_home_promo" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_holiday_home_promo_ref_no" UNIQUE (
        "ref_no"
    ),
    CONSTRAINT "uc_holiday_home_promo_promo_code" UNIQUE (
        "promo_code"
    )
);

CREATE TABLE "holiday_experience_schedule" (
    "id" bigserial   NOT NULL,
    "holiday_home_id" bigint   NOT NULL,
    "day_of_week" varchar   NOT NULL,
    "start_time" timestamptz   NOT NULL,
    "end_time" timestamptz   NOT NULL,
    -- added by creenx 2024-05-10 1103H
    "pick_up_time" timestamptz[]   NULL,
    CONSTRAINT "pk_holiday_experience_schedule" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "room_types" (
    "id" bigserial   NOT NULL,
    "company_types_id" bigint   NULL,
    "is_branch" bool   NULL,
    "companies_id" bigint   NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NULL,
    "smart_room" bool   NOT NULL,
    "is_luxury" bool   NOT NULL,
    "views" bigint[]   NOT NULL,
    "facilities" bigint[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_room_types" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "hotel_booking_categories" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_hotel_booking_categories" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "hotel_booking_portal" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "hotel_rooms_id" bigint   NOT NULL,
    "booking_portals_id" bigint   NOT NULL,
    "listing_url" varchar   NOT NULL,
    "price_night" float   NOT NULL,
    "hotel_booking_promo_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_hotel_booking_portal" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_hotel_booking_portal_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "hotel_booking_promo" (
    "id" bigserial   NOT NULL,
    "company_types_id" bigint   NULL,
    "companies_id" bigint   NULL,
    "is_branch" bool   NULL,
    "ref_no" varchar   NOT NULL,
    "promo_code" varchar   NOT NULL,
    "promo_start" timestamptz   NOT NULL,
    "promo_end" timestamptz   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_hotel_booking_promo" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_hotel_booking_promo_ref_no" UNIQUE (
        "ref_no"
    ),
    CONSTRAINT "uc_hotel_booking_promo_promo_code" UNIQUE (
        "promo_code"
    )
);

CREATE TABLE "posted_hotel_bookings" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_types_id" bigint   NULL,
    "is_branch" bool   NULL,
    "company_id" bigint   NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NULL,
    "countries_id" bigint   NOT NULL,
    "states_id" bigint   NOT NULL,
    "cities_id" bigint   NOT NULL,
    "community_id" bigint   NOT NULL,
    "subcommunity_id" bigint   NOT NULL,
    "lat" float   NOT NULL,
    "lng" float   NOT NULL,
    "ranking" bigint   NOT NULL,
    "no_of_rooms" bigint   NOT NULL,
    "facilities" varchar[]   NOT NULL,
    "amenities" varchar[]   NOT NULL,
    "views" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    "is_property" bool  DEFAULT false NOT NULL,
    "properties_id" bigint   NULL,
    "is_property_branch" bool  DEFAULT false NOT NULL,
    "unit_id" bigint   NULL,
    "posted_by" bigint   NOT NULL,
    "booking_categories_id" bigint   NOT NULL,
    "description" varchar   NOT NULL,
    "description_ar" varchar   NULL,
    "booking_expiration" timestamptz   NULL,
    "free_parking" bool   NULL,
    "free_breakfast" bool   NULL,
    "buffet_dinner" bool   NULL,
    "pay_at_property" bool   NULL,
    "pets_allowed" bool   NULL,
    "self_check_in" bool   NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_posted_hotel_bookings" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_posted_hotel_bookings_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "posted_hotel_media" (
    "id" bigserial   NOT NULL,
    "posted_hotel_id" bigint   NOT NULL,
    "image_url" varchar[]   NOT NULL,
    "video_url" varchar[]   NOT NULL,
    "video_360_url" varchar[]   NOT NULL,
    CONSTRAINT "pk_posted_hotel_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "hotel_rooms" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "posted_hotel_id" bigint   NOT NULL,
    "room_types_id" bigint   NOT NULL,
    "room_number" varchar   NOT NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NULL,
    "description" varchar   NOT NULL,
    "description_ar" varchar   NULL,
    "price_night" float   NOT NULL,
    "is_booked" bool   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    "max_pax" bigint   NOT NULL,
    "bedrooms" bigint   NOT NULL,
    "common_bathroom" bigint   NOT NULL,
    "private_bathroom" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_hotel_rooms" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_hotel_rooms_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "hotel_rooms_media" (
    "id" bigserial   NOT NULL,
    "hotel_rooms_id" bigint   NOT NULL,
    "image_url" varchar[]   NOT NULL,
    "video_url" varchar[]   NOT NULL,
    "video_360_url" varchar[]   NOT NULL,
    CONSTRAINT "pk_hotel_rooms_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "hotel_bookings" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "booking_ref_no" varchar   NOT NULL,
    "hotel_rooms_id" bigint   NOT NULL,
    "book_date" timestamptz   NOT NULL,
    "check_in" timestamptz   NOT NULL,
    "check_out" timestamptz   NOT NULL,
    "hotel_booking_portals_id" bigint   NOT NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    "customer_name" varchar NOT NULL,
    CONSTRAINT "pk_hotel_bookings" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_hotel_bookings_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "hotel_booking_reviews" (
    "id" bigserial   NOT NULL,
    "posted_hotel_booking" bigint   NOT NULL,
    "review_date" timestamptz  DEFAULT now() NOT NULL,
    "user_id" bigint   NOT NULL,
    "comfort" float   NOT NULL,
    "rooms" float   NOT NULL,
    "cleanliness" float   NOT NULL,
    "building" float   NOT NULL,
    "title" varchar   NOT NULL,
    "review" varchar   NOT NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_hotel_booking_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "posted_hotel_comments" (
    "id" bigserial   NOT NULL,
    "parent_comment" bigint   NULL,
    "posted_hotel_booking" bigint   NOT NULL,
    "users_id" bigint   NOT NULL,
    "comment_date" timestamptz  DEFAULT now() NOT NULL,
    "comment" varchar   NOT NULL,
    "reaction_type_id" bigint[]   NOT NULL,
    "reacted_by" bigint[]   NOT NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_posted_hotel_comments" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "contracts" (
    "id" bigserial   NOT NULL,
    "company_type" bigint   NOT NULL,
    "company_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "file_url" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_contracts" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "service_request" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- should be a service company
    "company_types_id" bigint   NULL,
    "is_branch" bool   NULL,
    "companies_id" bigint   NULL,
    "request_date" timestamptz  DEFAULT now() NOT NULL,
    "services_id" bigint   NOT NULL,
    "requested_by" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    CONSTRAINT "pk_service_request" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_service_request_ref_no" UNIQUE (
        "ref_no"
    )
);

-- Status
CREATE TABLE "service_request_history" (
    "id" bigserial   NOT NULL,
    "service_request_id" bigint   NOT NULL,
    "history_date" timestamptz  DEFAULT now() NOT NULL,
    "reason" varchar   NULL,
    "status" bigint   NOT NULL,
    -- Status
    "updated_by" bigint   NOT NULL,
    CONSTRAINT "pk_service_request_history" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "global_tagging" (
    "id" bigserial   NOT NULL,
    "section" varchar   NOT NULL,
    "tag_name" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_global_tagging" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_global_tagging_tag_name" UNIQUE (
        "tag_name"
    )
);

CREATE TABLE "blog" (
    "id" bigserial   NOT NULL,
    "company_types_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    -- // FK >- companies.id
    "companies_id" bigint   NOT NULL,
    "blog_categories_id" bigint   NOT NULL,
    "title" varchar   NOT NULL,
    "sub_title" varchar   NULL,
    "blog_article" varchar   NOT NULL,
    "is_public" bool   NOT NULL,
    "status" bigint   NOT NULL,
    -- Blog Status
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "media_type_id" bigint   NOT NULL,
    -- Media Type
    "media_url" varchar   NOT NULL,
    CONSTRAINT "pk_blog" PRIMARY KEY (
        "id"
     )
);

-- blogs_media
-- --
-- id bigserial PK
-- media_title varchar
-- media_type_id int
-- Media Type
-- media_url varchar
-- blog_id bigint FK >- blog.id
-- is_cover bool
-- is_thumbnail bool
-- date_uploaded timestamptz default=now()
CREATE TABLE "blogs_comments" (
    "id" bigserial   NOT NULL,
    "blog_id" bigint   NOT NULL,
    -- FK >- blog_comments.id
    "parent_comments_id" bigint   NULL,
    "comments" varchar   NOT NULL,
    "comment_date" timestamptz  DEFAULT now() NOT NULL,
    "user_id" bigint   NOT NULL,
    CONSTRAINT "pk_blogs_comments" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "service_reviews" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- to be connected for company service
    "company_service_id" bigint   NOT NULL,
    "review_date" timestamptz  DEFAULT now() NOT NULL,
    "service_quality" int   NOT NULL,
    "service_expertise" int   NOT NULL,
    "service_facilities" int   NOT NULL,
    "service_responsiveness" int   NOT NULL,
    "review" varchar   NOT NULL,
    "reviewer" bigint   NOT NULL,
    -- added by creenx 2024-05-13 1215
    "proof_images" varchar[]   NULL,
    "title" varchar   NULL,
    CONSTRAINT "pk_service_reviews" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_service_reviews_ref_no" UNIQUE (
        "ref_no"
    )
);

-- AGENT REVIEWS
CREATE TABLE "agent_reviews" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "agent_id" bigint   NOT NULL,
    "agent_knowledge" int   NOT NULL,
    "agent_expertise" int   NOT NULL,
    "agent_responsiveness" int   NOT NULL,
    "agent_negotiation" int   NOT NULL,
    "review" varchar   NOT NULL,
    "reviewer" bigint   NOT NULL,
    -- added by creenx 2024-05-13 1215
    "proof_images" varchar[]   NULL,
    "title" varchar   NULL,
    CONSTRAINT "pk_agent_reviews" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_agent_reviews_ref_no" UNIQUE (
        "ref_no"
    )
);

-- COMPANY REVIEWS
CREATE TABLE "company_reviews" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_type_id" int   NOT NULL,
    "is_branch" bool   NOT NULL,
    "company_id" bigint   NOT NULL,
    "customer_service" int   NOT NULL,
    "staff_courstesy" int   NOT NULL,
    "implementation" int   NOT NULL,
    "properties_quality" int   NOT NULL,
    "description" varchar   NOT NULL,
    "reviewer" bigint   NOT NULL,
    -- added by creenx 2024-05-13 1215
    "proof_images" varchar[]   NULL,
    "title" varchar   NULL,
    CONSTRAINT "pk_company_reviews" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_reviews_ref_no" UNIQUE (
        "ref_no"
    )
);

-- PROJECT REVIEWS
CREATE TABLE "project_reviews" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "is_project" bool  DEFAULT true NOT NULL,
    "projects_id" bigint   NOT NULL,
    "project_clean" float8   NOT NULL,
    "project_location" float8   NOT NULL,
    "project_facilities" float8   NOT NULL,
    "project_securities" float8   NOT NULL,
    "description" varchar   NOT NULL,
    "reviewer" bigint   NOT NULL,
    -- added by creenx 2024-05-10 1121H
    "review_date" timestamptz  DEFAULT now() NOT NULL,
    -- added by creenx 2024-05-13 1215
    "proof_images" varchar[]   NULL,
    "title" varchar   NULL,
    CONSTRAINT "pk_project_reviews" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_project_reviews_ref_no" UNIQUE (
        "ref_no"
    )
);

-- PROJECT PROPERTY REVIEWS
CREATE TABLE "properties_reviews" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "projects_id" bigint   NOT NULL,
    "phases_id" bigint   NULL,
    "properties_id" bigint   NOT NULL,
    "project_clean" int   NOT NULL,
    "project_location" int   NOT NULL,
    "project_facilities" int   NOT NULL,
    "project_securities" int   NOT NULL,
    "description" varchar   NOT NULL,
    "reviewer" bigint   NOT NULL,
    -- added by creenx 2024-05-10 1121H
    "review_date" timestamptz  DEFAULT now() NOT NULL,
    -- added by creenx 2024-05-13 1215
    "proof_images" varchar[]   NULL,
    "title" varchar   NULL,
    CONSTRAINT "pk_properties_reviews" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_properties_reviews_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "units_reviews" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- projects_id bigint NULL
    -- properties_id bigint NULL
    "units_id" bigint   NOT NULL,
    -- changed for global usage
    "clean" int   NOT NULL,
    -- changed for global usage
    "location" bigint   NOT NULL,
    -- changed for global usage
    "facilities" bigint   NOT NULL,
    -- changed for global usage
    "securities" int   NOT NULL,
    "description" varchar   NOT NULL,
    "reviewer" bigint   NOT NULL,
    -- added by creenx 2024-05-10 1121H
    "review_date" timestamptz  DEFAULT now() NOT NULL,
    -- added by creenx 2024-05-13 1215
    "proof_images" varchar[]   NULL,
    "title" varchar   NULL,
    CONSTRAINT "pk_units_reviews" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_units_reviews_ref_no" UNIQUE (
        "ref_no"
    )
);

-- PROPERTY REVIEWS
CREATE TABLE "property_reviews" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "property_unit_category" varchar   NOT NULL,
    "is_branch" bool   NOT NULL,
    "property_unit_id" bigint   NOT NULL,
    "property_clean" int   NOT NULL,
    "property_location" int   NOT NULL,
    "property_facilities" int   NOT NULL,
    "property_security" int   NOT NULL,
    "review" varchar   NOT NULL,
    "reviewer" bigint   NOT NULL,
    CONSTRAINT "pk_property_reviews" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_property_reviews_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "review_comments" (
    "id" bigserial   NOT NULL,
    "parent_review_comments" bigint   NULL,
    "review_comment_category" int   NOT NULL,
    -- Review Comments Categories
    "reviews_id" bigint   NOT NULL,
    "comment_date" timestamptz  DEFAULT now() NOT NULL,
    "commented_by" bigint   NOT NULL,
    "comment" varchar   NOT NULL,
    CONSTRAINT "pk_review_comments" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "review_comment_reactions" (
    "id" bigserial   NOT NULL,
    "comments_id" bigint   NOT NULL,
    "reaction_types_id" int   NOT NULL,
    "users_id" bigint   NOT NULL,
    "reaction_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_review_comment_reactions" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "community_guides" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- FK >- companies.id
    "companies_id" bigint   NOT NULL,
    "countries_id" int   NOT NULL,
    "states_id" int   NOT NULL,
    "cities_id" int   NOT NULL,
    "community_id" int   NOT NULL,
    "subcommunity_id" int   NOT NULL,
    "title" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_ar" varchar   NULL,
    "image_url" varchar   NOT NULL,
    "video_url" varchar   NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NULL,
    "is_publish" bool DEFAULT true  NOT NULL,
    CONSTRAINT "pk_community_guides" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_community_guides_ref_no" UNIQUE (
        "ref_no"
    )
);

-- Status
CREATE TABLE "community_guides_media" (
    "id" bigserial   NOT NULL,
    "community_guides_id" bigint   NOT NULL,
    "image_url" varchar[]   NOT NULL,
    "date_uploaded" timestamptz  DEFAULT now() NOT NULL,
    "uploaded_by" bigint   NOT NULL,
    CONSTRAINT "pk_community_guides_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "towers" (
    "id" bigserial   NOT NULL,
    "countries_id" bigint   NOT NULL,
    "states_id" bigint   NOT NULL,
    "cities_id" bigint   NOT NULL,
    "community_id" int   NOT NULL,
    "subcommunity_id" int   NOT NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NULL,
    "description" varchar   NOT NULL,
    "description_ar" varchar   NULL,
    "image_url" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    "is_publish" bool DEFAULT true   NOT NULL,
    "created_by" bigint   NOT NULL,
    CONSTRAINT "pk_towers" PRIMARY KEY (
        "id"
     )
    -- CONSTRAINT "uc_towers_ref_no" UNIQUE (
    --     "ref_no"
    -- )
);

-- Status
CREATE TABLE "tower_media" (
    "id" bigserial   NOT NULL,
    "towers_id" bigint   NOT NULL,
    "image_url" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_by" bigint   NOT NULL,
    CONSTRAINT "pk_tower_media" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "product_companies" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "subcompany_type" bigint   NOT NULL,
    "company_name" varchar(255)   NOT NULL,
    "tag_line" varchar(255)   NOT NULL,
    "commercial_license_no" varchar(255)   NOT NULL,
    "commercial_license_file_url" varchar(255)   NOT NULL,
    -- when the commercial license registered for the first time
    "commercial_license_registration_date" timestamptz  DEFAULT now() NOT NULL,
    "commercial_license_issue_date" timestamptz  DEFAULT now() NOT NULL,
    "commercial_license_expiry" timestamptz   NOT NULL,
    "extra_license_names" varchar[]   NOT NULL,
    "extra_license_files" varchar[]   NOT NULL,
    "extra_license_nos" varchar[]   NOT NULL,
    "vat_no" varchar(255)   NOT NULL,
    "vat_status" bigint   NOT NULL,
    "vat_file_url" varchar(255)   NOT NULL,
    "companies_billing_info_id" bigint   NOT NULL,
    "facebook_profile_url" varchar(255)   NOT NULL,
    "instagram_profile_url" varchar(255)   NOT NULL,
    "linkedin_profile_url" varchar(255)   NOT NULL,
    "twitter_profile_url" varchar(255)   NOT NULL,
    "youtube_profile_url" varchar   NULL,
    "users_id" bigint   NOT NULL,
    "companies_subscription_id" bigint   NOT NULL,
    "companies_bank_account_details_id" bigint   NOT NULL,
    "main_services_id" bigint   NULL,
    "no_of_employees" bigint   NOT NULL,
    "logo_url" varchar(255)   NOT NULL,
    "cover_image_url" varchar(255)   NOT NULL,
    "description" varchar(255)   NOT NULL,
    "is_verified" bool   NOT NULL,
    "website_url" varchar(255)   NOT NULL,
    "phone_number" varchar(255)   NOT NULL,
    "email" varchar(255)   NOT NULL,
    "whatsapp_number" varchar(255)   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "company_rank" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "country_id" bigint   NOT NULL,
    "company_type" bigint  DEFAULT 2 NOT NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_product_companies" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_product_companies_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "product_companies_branches" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "subcompany_type" bigint   NOT NULL,
    "company_name" varchar(255)   NOT NULL,
    "tag_line" varchar(255)   NOT NULL,
    "commercial_license_no" varchar(255)   NOT NULL,
    "commercial_license_file_url" varchar(255)   NOT NULL,
    -- when the commercial license registered for the first time
    "commercial_license_registration_date" timestamptz  DEFAULT now() NOT NULL,
    "commercial_license_issue_date" timestamptz  DEFAULT now() NOT NULL,
    "commercial_license_expiry" timestamptz   NOT NULL,
    "extra_license_names" varchar[]   NOT NULL,
    "extra_license_files" varchar[]   NOT NULL,
    "extra_license_nos" varchar[]   NOT NULL,
    "vat_no" varchar(255)   NOT NULL,
    "vat_status" bigint   NOT NULL,
    "vat_file_url" varchar(255)   NOT NULL,
    "company_billing_info_id" bigint   NOT NULL,
    "facebook_profile_url" varchar(255)   NOT NULL,
    "instagram_profile_url" varchar(255)   NOT NULL,
    "linkedin_profile_url" varchar(255)   NOT NULL,
    "twitter_profile_url" varchar(255)   NOT NULL,
    "youtube_profile_url" varchar   NULL,
    "users_id" bigint   NOT NULL,
    "companies_subscription_id" bigint   NOT NULL,
    "companies_bank_account_details_id" bigint   NOT NULL,
    "main_services_id" bigint   NULL,
    "no_of_employees" bigint   NOT NULL,
    "logo_url" varchar(255)   NOT NULL,
    "cover_image_url" varchar(255)   NOT NULL,
    "description" varchar(255)   NOT NULL,
    "is_verified" bool   NOT NULL,
    "website_url" varchar(255)   NOT NULL,
    "phone_number" varchar(255)   NOT NULL,
    "email" varchar(255)   NOT NULL,
    "whatsapp_number" varchar(255)   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "product_companies_id" bigint   NOT NULL,
    "company_rank" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "country_id" bigint   NOT NULL,
    "company_type" bigint  DEFAULT 2 NOT NULL,
    "is_branch" bool  DEFAULT true NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_product_companies_branches" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_product_companies_branches_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "product_companies_billing_info" (
    "id" bigserial   NOT NULL,
    "office_address" varchar(255)   NOT NULL,
    "billing_reference" varchar(255)   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_product_companies_billing_info" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "product_companies_subscription" (
    "id" bigserial   NOT NULL,
    "subscription_duration" varchar(255)   NOT NULL,
    "start_date" timestamptz   NULL,
    "end_date" timestamptz   NULL,
    "standard_units" bigint   NOT NULL,
    "standard_unit_price" bigint   NOT NULL,
    "standard_discount" varchar(255)   NOT NULL,
    "featured_units" bigint   NOT NULL,
    "featured_unit_price" bigint   NOT NULL,
    "featured_discount" varchar(255)   NOT NULL,
    "premium_units" bigint   NOT NULL,
    "premium_unit_price" bigint   NOT NULL,
    "premium_discount" varchar(255)   NOT NULL,
    "topdeal_units" bigint   NOT NULL,
    "topdeal_unit_price" bigint   NOT NULL,
    "topdeal_discount" varchar(255)   NOT NULL,
    "status" bigint   NOT NULL,
    "total_price" varchar  DEFAULT 0 NOT NULL,
    "total_unit" bigint  DEFAULT 0 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "subscription_mode" bigint  DEFAULT 1 NOT NULL,
    "company_type" bigint  DEFAULT 1 NOT NULL,
    "is_branch" bool   NOT NULL,
    "order_no" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_product_companies_subscription" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "product_companies_bank_details" (
    "id" bigserial   NOT NULL,
    "account_name" varchar(255)   NOT NULL,
    "account_number" varchar(255)   NOT NULL,
    "iban" varchar(255)   NOT NULL,
    "countries_id" bigint   NOT NULL,
    "currency_id" bigint   NOT NULL,
    "bank_name" varchar(255)   NOT NULL,
    "branch" varchar(255)   NOT NULL,
    "swift_code" varchar(255)   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_product_companies_bank_details" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "product_company_directors" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "profile_image" varchar(255)   NOT NULL,
    "name" varchar(255)   NOT NULL,
    "description" varchar(255)   NOT NULL,
    "director_designations_id" bigint   NOT NULL,
    "product_companies_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_product_company_directors" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_product_company_directors_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "product_company_branch_directors" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "profile_image" varchar(255)   NOT NULL,
    "name" varchar(255)   NOT NULL,
    "description" varchar(255)   NOT NULL,
    "director_designations_id" bigint   NOT NULL,
    "product_companies_branches_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_product_company_branch_directors" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_product_company_branch_directors_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "product_companies_reviews" (
    "id" bigserial   NOT NULL,
    "rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "review" varchar(255)   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "product_companies_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_product_companies_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "product_companies_branches_reviews" (
    "id" bigserial   NOT NULL,
    "rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "review" varchar(255)   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "product_companies_branches_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_product_companies_branches_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "product_companies_directors_reviews" (
    "id" bigserial   NOT NULL,
    "rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "review" varchar(255)   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "product_company_directors_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_product_companies_directors_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "product_companies_branch_directors_reviews" (
    "id" bigserial   NOT NULL,
    "rating" varchar(255)  DEFAULT '0.0' NOT NULL,
    "review" varchar(255)   NOT NULL,
    "profiles_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "product_company_branch_directors_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "users_id" bigint   NOT NULL,
    CONSTRAINT "pk_product_companies_branch_directors_reviews" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "tax_management" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_types_id" bigint   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "countries_id" bigint   NULL,
    "states_id" bigint   NULL,
    "tax_code" varchar(255)   NOT NULL,
    "tax_category_id" bigint   NULL,
    "tax_category_type" bigint   NOT NULL,
    -- vat
    -- civil tax
    "tax_title" varchar(255)   NOT NULL,
    "tax_percentage" float   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_branch" bool   NOT NULL,
    "created_by" bigint   NOT NULL,
    CONSTRAINT "pk_tax_management" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_tax_management_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "tax_category" (
    "id" bigserial   NOT NULL,
    "tax_code" varchar   NULL,
    "tax_title" varchar(255)   NOT NULL,
    "tax_description" varchar(255)   NOT NULL,
    CONSTRAINT "pk_tax_category" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "banner_sections" (
    "id" bigserial   NOT NULL,
    "parent_banner_section" bigint   NOT NULL,
    "title" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    CONSTRAINT "pk_banner_sections" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "banner_types" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NOT NULL,
    CONSTRAINT "pk_banner_types" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "banners" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_types" bigint   NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    -- FK >- companies.id
    "companies_id" bigint   NOT NULL,
    "title" varchar   NOT NULL,
    "sub_title" varchar   NULL,
    "banner_sections_id" bigint   NOT NULL,
    "banner_types_id" bigint   NOT NULL,
    "end_date_time" timestamptz   NOT NULL,
    "banner_url" varchar   NOT NULL,
    "is_deleted" bool   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "target_url" varchar NOT NULL,
    "is_publish" bool DEFAULT false NOT NULL,
    CONSTRAINT "pk_banners" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_banners_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "company_videos" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_types" bigint   NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    -- FK >- companies.id
    "companies_id" bigint   NOT NULL,
    "video_url" varchar   NOT NULL,
    "is_deleted" bool  DEFAULT false NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz   NOT NULL,
    "title" varchar NOT NULL,
    CONSTRAINT "pk_company_videos" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_videos_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "project_videos" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_types" bigint   NULL,
    "is_branch" bool   NOT NULL,
    -- FK >- companies.id
    "companies_id" bigint   NOT NULL,
    "project_id" bigint   NOT NULL,
    "title" varchar   NOT NULL,
    "video_url" varchar   NOT NULL,
    "is_deleted" bool  DEFAULT false NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_project_videos" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_project_videos_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "properties_videos" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_types" bigint   NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    -- FK >- companies.id
    "companies_id" bigint   NOT NULL,
    "projects_id" bigint   NULL,
    "phases_id" bigint   NULL,
    -- ID of the property
    "properties_id" bigint   NOT NULL,
    "title" varchar   NOT NULL,
    "is_deleted" bool  DEFAULT false NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "video_url" varchar NOT NULL,
    CONSTRAINT "pk_properties_videos" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_properties_videos_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "map_searches" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_types" bigint   NULL,
    "is_branch" bool  DEFAULT false NOT NULL,
    "companies_id" bigint   NOT NULL,
    "map_search_type" bigint   NOT NULL,
    -- Map Search Type
    "video_url" varchar   NULL,
    "banner_types_id" bigint   NULL,
    "banner_url" varchar   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    "target_url" varchar NULL,
    "description" varchar NULL,
    "is_deleted" bool DEFAULT false NOT NULL,
    CONSTRAINT "pk_map_searches" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_map_searches_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "units" (
    "id" bigserial   NOT NULL,
    "unit_no" varchar   NULL,
    "unitno_is_public" bool  DEFAULT false NOT NULL,
    "notes" varchar   NULL,
    "notes_arabic" varchar   NULL,
    "notes_public" bool  DEFAULT false NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    "property_unit_rank" bigint  DEFAULT 1 NOT NULL,
    "properties_id" bigint   NULL,
    "property" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "countries_id" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
    "property_name" varchar   NOT NULL,
    -- project, property hub, agricultural, industrial, unit etc
    "section" varchar   NOT NULL,
    "type_name_id" bigint   NULL,
    -- actual owner of the unit, for transfer ownership
    "owner_users_id" bigint   NULL,
    "from_xml" bool DEFAULT false NOT NULL,
    "is_branch" bool DEFAULT false NOT NULL,
    CONSTRAINT "pk_units" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_units_ref_no" UNIQUE (
        "ref_no"
    )
);

-- added by creenx 2024-05-28 1022
CREATE TABLE "unit_payment_plans" (
    "id" bigserial   NOT NULL,
    "unit_id" bigint   NOT NULL,
    "payment_plans_id" bigint   NOT NULL,
    "is_enabled" bool   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_unit_payment_plans" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "sale_unit" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "title_arabic" varchar   NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NULL,
    "unit_id" bigint   NOT NULL,
    "unit_facts_id" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "contract_start_datetime" timestamptz   NULL,
    "contract_end_datetime" timestamptz   NULL,
    -- contract amount
    "contract_amount" bigint   NULL,
    -- currency id
    "contract_currency" bigint   NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_sale_unit" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "rent_unit" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "title_arabic" varchar   NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NULL,
    "unit_id" bigint   NOT NULL,
    "unit_facts_id" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_rent_unit" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "units_status_history" (
    "id" bigserial   NOT NULL,
    "units_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "change_date" timestamptz  DEFAULT now() NOT NULL,
    "change_reason" varchar   NOT NULL,
    CONSTRAINT "pk_units_status_history" PRIMARY KEY (
        "id"
     )
);

-- CREATE TABLE "unit_media" (
--     "id" bigserial   NOT NULL,
--     "image_url" varchar[]   NULL,
--     "image360_url" varchar[]   NULL,
--     "video_url" varchar[]   NULL,
--     "panaroma_url" varchar[]   NULL,
--     "main_media_section" varchar   NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "units_id" bigint   NOT NULL,
--     CONSTRAINT "pk_unit_media" PRIMARY KEY (
--         "id"
--      )
-- );

CREATE TABLE "unit_plans" (
    "id" bigserial   NOT NULL,
    "img_url" varchar[]   NOT NULL,
    -- floor plan, master plan etc
    "title" varchar   NOT NULL,
    "units_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_unit_plans" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "units_documents" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "units_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_units_documents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "openhouse" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- developer company
    "created_by" bigint   NOT NULL,
    -- project_id bigint FK - projects.id
    "project_properties_id" bigint   NOT NULL,
    "start_date" timestamptz   NOT NULL,
    "end_date" timestamptz   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_openhouse" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_openhouse_ref_no" UNIQUE (
        "ref_no"
    )
);

-- interval_type bigint
-- 1 Minute
-- 2 Hour
-- interval_time bigint
-- max_clients bigint
CREATE TABLE "timeslots" (
    "id" bigserial   NOT NULL,
    "date" timestamptz   NOT NULL,
    "start_time" timestamptz   NOT NULL,
    "end_time" timestamptz   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    -- 1 - Available
    -- 2 - Not Avaiable
    "openhouse_id" bigint   NOT NULL,
    CONSTRAINT "pk_timeslots" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "appointment" (
    "id" bigserial   NOT NULL,
    "openhouse_id" bigint   NOT NULL,
    "timeslots_id" bigint   NOT NULL,
    "agent_id" bigint   NULL,
    -- broker company or client
    "created_by" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "client_id" bigint   NULL,
    -- If Only for Rejected or Rescheduled
    "remarks" varchar   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "appointment_type" bigint   NOT NULL,
    "background_color" bigint DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_appointment" PRIMARY KEY (
        "id"
     )
);

-- Subscribers (Newsletter) *****
CREATE TABLE "newsletter_subscribers" (
    "id" bigserial   NOT NULL,
    "subscriber" bigint   NOT NULL,
    "interest" bigint[]   NULL,
    -- Subscriber Interests
    "subcribe_date" timestamptz  DEFAULT now() NOT NULL,
    "is_active" bool  DEFAULT true NOT NULL,
    CONSTRAINT "pk_newsletter_subscribers" PRIMARY KEY (
        "id"
     )
);

-- --------------------------- Pages Section ---------------------------------
-- --------------------------- creenx 2024-05-25 1555H -----------------------
CREATE TABLE "pages" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "page_category" bigint   NOT NULL,
    -- Page Category
    "page_type" bigint   NOT NULL,
    -- Page Type
    "wysiwyg" varchar   NOT NULL,
    "status" bigint   NOT NULL,
    -- Status
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NULL,
    CONSTRAINT "pk_pages" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "advertisements" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "pages_id" bigint   NOT NULL,
    "description" varchar   NOT NULL,
    "is_active" bool   NOT NULL,
    CONSTRAINT "pk_advertisements" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "page_contents" (
    "id" bigserial   NOT NULL,
    "content_category" bigint   NOT NULL,
    -- Content Category
    -- id of Projects, property hub, etc...
    "content_ref_id" bigint   NOT NULL,
    "title" varchar   NOT NULL,
    "contents" varchar   NOT NULL,
    "media_type" bigint   NULL,
    -- Media Type
    -- Except Exhibition and Auctions
    "media_url" varchar   NULL,
    "status" bigint   NOT NULL,
    CONSTRAINT "pk_page_contents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "activities" (
    "id" bigserial   NOT NULL,
    "module_name" varchar   NOT NULL,
    "previous" varchar   NULL,
    "current" varchar  NULL,
    "activity" varchar   NOT NULL,
    "created_by" bigint   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_activities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "project_activities" (
    "id" bigserial   NOT NULL,
    "activities_id" bigint   NOT NULL,
    "is_project" bool  DEFAULT false NOT NULL,
    -- FK - projects.id
    "projects_id" bigint   NULL,
    "is_phase" bool  DEFAULT false NOT NULL,
    -- FK - phases.id
    "phases_id" bigint   NULL,
    "is_property" bool  DEFAULT false NOT NULL,
    -- FK - project_properties.id
    "project_properties_id" bigint   NULL,
    "is_unit" bool  DEFAULT false NOT NULL,
    -- FK - units.id
    "units_id" bigint   NULL,
    "gallery_id" bigint   NULL,
    "document_id" bigint   NULL,
    "plans_id" bigint   NULL,
    "financial_providers_id" bigint   NULL,
    "promotions_id" bigint   NULL,
    "reviews_id" bigint   NULL,
    "payment_plans_id" bigint   NULL,
    "unit_types_id" bigint   NULL,
    "openhouse_id" bigint   NULL,
    CONSTRAINT "pk_project_activities" PRIMARY KEY (
        "id"
     )
);

-- --                 FOR SETTINGS SECTION                    --
-- --                      2024-06-12                         --
CREATE TABLE "image_categories" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- companies_id bigint [ref: > companies.id]
    "is_branch" bool   NOT NULL,
    "category_name" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    CONSTRAINT "pk_image_categories" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_image_categories_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "international_content" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "section_name" varchar   NOT NULL,
    "content" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    CONSTRAINT "pk_international_content" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_international_content_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "dropdown_categories" (
    "id" bigserial   NOT NULL,
    "category_name" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_dropdown_categories" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_dropdown_categories_category_name" UNIQUE (
        "category_name"
    )
);

CREATE TABLE "dropdown_items" (
    "id" bigserial   NOT NULL,
    -- User Input / To group dropdown items by categories
    "category_id" bigint   NOT NULL,
    "icon_url" varchar   NULL,
    "item_name" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    CONSTRAINT "pk_dropdown_items" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "sub_communities" ADD CONSTRAINT "fk_sub_communities_communities_id" FOREIGN KEY("communities_id")
REFERENCES "communities" ("id");

ALTER TABLE "communities" ADD CONSTRAINT "fk_communities_cities_id" FOREIGN KEY("cities_id")
REFERENCES "cities" ("id");

ALTER TABLE "cities" ADD CONSTRAINT "fk_cities_states_id" FOREIGN KEY("states_id")
REFERENCES "states" ("id");

ALTER TABLE "states" ADD CONSTRAINT "fk_states_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "addresses" ADD CONSTRAINT "fk_addresses_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "addresses" ADD CONSTRAINT "fk_addresses_states_id" FOREIGN KEY("states_id")
REFERENCES "states" ("id");

ALTER TABLE "addresses" ADD CONSTRAINT "fk_addresses_cities_id" FOREIGN KEY("cities_id")
REFERENCES "cities" ("id");

ALTER TABLE "addresses" ADD CONSTRAINT "fk_addresses_communities_id" FOREIGN KEY("communities_id")
REFERENCES "communities" ("id");

ALTER TABLE "addresses" ADD CONSTRAINT "fk_addresses_sub_communities_id" FOREIGN KEY("sub_communities_id")
REFERENCES "sub_communities" ("id");

ALTER TABLE "addresses" ADD CONSTRAINT "fk_addresses_locations_id" FOREIGN KEY("locations_id")
REFERENCES "locations" ("id");

ALTER TABLE "facilities" ADD CONSTRAINT "fk_facilities_category_id" FOREIGN KEY("category_id")
REFERENCES "facilities_amenities_categories" ("id");

ALTER TABLE "amenities" ADD CONSTRAINT "fk_amenities_category_id" FOREIGN KEY("category_id")
REFERENCES "facilities_amenities_categories" ("id");

ALTER TABLE "broker_company_agents" ADD CONSTRAINT "fk_broker_company_agents_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "broker_company_agents" ADD CONSTRAINT "fk_broker_company_agents_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "agent_subscription_quota" ADD CONSTRAINT "fk_agent_subscription_quota_broker_company_agents_id" FOREIGN KEY("broker_company_agents_id")
REFERENCES "broker_company_agents" ("id");

ALTER TABLE "agent_subscription_quota_branch" ADD CONSTRAINT "fk_agent_subscription_quota_branch_broker_company_branches_agents_id" FOREIGN KEY("broker_company_branches_agents_id")
REFERENCES "broker_company_branches_agents" ("id");

ALTER TABLE "broker_agent_reviews" ADD CONSTRAINT "fk_broker_agent_reviews_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "broker_agent_reviews" ADD CONSTRAINT "fk_broker_agent_reviews_services_id" FOREIGN KEY("services_id")
REFERENCES "services" ("id");

ALTER TABLE "broker_agent_reviews" ADD CONSTRAINT "fk_broker_agent_reviews_broker_company_agents_id" FOREIGN KEY("broker_company_agents_id")
REFERENCES "broker_company_agents" ("id");

ALTER TABLE "broker_agent_reviews" ADD CONSTRAINT "fk_broker_agent_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "developer_companies" ADD CONSTRAINT "fk_developer_companies_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "developer_companies" ADD CONSTRAINT "fk_developer_companies_bank_account_details_id" FOREIGN KEY("bank_account_details_id")
REFERENCES "bank_account_details" ("id");

ALTER TABLE "developer_companies" ADD CONSTRAINT "fk_developer_companies_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "developer_companies" ADD CONSTRAINT "fk_developer_companies_country_id" FOREIGN KEY("country_id")
REFERENCES "countries" ("id");

ALTER TABLE "developer_companies" ADD CONSTRAINT "fk_developer_companies_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "broker_companies_branches" ADD CONSTRAINT "fk_broker_companies_branches_broker_companies_id" FOREIGN KEY("broker_companies_id")
REFERENCES "broker_companies" ("id");

ALTER TABLE "broker_companies_branches" ADD CONSTRAINT "fk_broker_companies_branches_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "broker_companies_branches" ADD CONSTRAINT "fk_broker_companies_branches_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "broker_companies_branches" ADD CONSTRAINT "fk_broker_companies_branches_bank_account_details_id" FOREIGN KEY("bank_account_details_id")
REFERENCES "bank_account_details" ("id");

ALTER TABLE "broker_companies_branches" ADD CONSTRAINT "fk_broker_companies_branches_country_id" FOREIGN KEY("country_id")
REFERENCES "countries" ("id");

ALTER TABLE "broker_companies_branches" ADD CONSTRAINT "fk_broker_companies_branches_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "broker_company_branches_agents" ADD CONSTRAINT "fk_broker_company_branches_agents_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "broker_company_branches_agents" ADD CONSTRAINT "fk_broker_company_branches_agents_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "broker_branch_agent_reviews" ADD CONSTRAINT "fk_broker_branch_agent_reviews_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "broker_branch_agent_reviews" ADD CONSTRAINT "fk_broker_branch_agent_reviews_services_id" FOREIGN KEY("services_id")
REFERENCES "services" ("id");

ALTER TABLE "broker_branch_agent_reviews" ADD CONSTRAINT "fk_broker_branch_agent_reviews_broker_company_branches_agents_id" FOREIGN KEY("broker_company_branches_agents_id")
REFERENCES "broker_company_branches_agents" ("id");

ALTER TABLE "broker_branch_agent_reviews" ADD CONSTRAINT "fk_broker_branch_agent_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

-- ALTER TABLE "broker_companies_branches_services" ADD CONSTRAINT "fk_broker_companies_branches_services_broker_companies_branches_id" FOREIGN KEY("broker_companies_branches_id")
-- REFERENCES "broker_companies_branches" ("id");

-- ALTER TABLE "broker_companies_branches_services" ADD CONSTRAINT "fk_broker_companies_branches_services_services_id" FOREIGN KEY("services_id")
-- REFERENCES "services" ("id");

ALTER TABLE "broker_branch_company_reviews" ADD CONSTRAINT "fk_broker_branch_company_reviews_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "broker_branch_company_reviews" ADD CONSTRAINT "fk_broker_branch_company_reviews_broker_companies_branches_id" FOREIGN KEY("broker_companies_branches_id")
REFERENCES "broker_companies_branches" ("id");

ALTER TABLE "broker_branch_company_reviews" ADD CONSTRAINT "fk_broker_branch_company_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "developer_company_branches" ADD CONSTRAINT "fk_developer_company_branches_developer_companies_id" FOREIGN KEY("developer_companies_id")
REFERENCES "developer_companies" ("id");

ALTER TABLE "developer_company_branches" ADD CONSTRAINT "fk_developer_company_branches_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "developer_company_branches" ADD CONSTRAINT "fk_developer_company_branches_bank_account_details_id" FOREIGN KEY("bank_account_details_id")
REFERENCES "bank_account_details" ("id");

ALTER TABLE "developer_company_branches" ADD CONSTRAINT "fk_developer_company_branches_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "developer_company_branches" ADD CONSTRAINT "fk_developer_company_branches_country_id" FOREIGN KEY("country_id")
REFERENCES "countries" ("id");

ALTER TABLE "developer_company_branches" ADD CONSTRAINT "fk_developer_company_branches_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "developer_company_directors" ADD CONSTRAINT "fk_developer_company_directors_director_designations_id" FOREIGN KEY("director_designations_id")
REFERENCES "designations" ("id");

ALTER TABLE "developer_company_directors" ADD CONSTRAINT "fk_developer_company_directors_developer_companies_id" FOREIGN KEY("developer_companies_id")
REFERENCES "developer_companies" ("id");

ALTER TABLE "developer_branch_company_directors" ADD CONSTRAINT "fk_developer_branch_company_directors_director_designations_id" FOREIGN KEY("director_designations_id")
REFERENCES "designations" ("id");

ALTER TABLE "developer_branch_company_directors" ADD CONSTRAINT "fk_developer_branch_company_directors_developer_company_branches" FOREIGN KEY("developer_company_branches")
REFERENCES "developer_company_branches" ("id");

ALTER TABLE "developer_company_reviews" ADD CONSTRAINT "fk_developer_company_reviews_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "developer_company_reviews" ADD CONSTRAINT "fk_developer_company_reviews_developer_companies_id" FOREIGN KEY("developer_companies_id")
REFERENCES "developer_companies" ("id");

ALTER TABLE "developer_company_reviews" ADD CONSTRAINT "fk_developer_company_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "services_companies_reviews" ADD CONSTRAINT "fk_services_companies_reviews_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "services_companies_reviews" ADD CONSTRAINT "fk_services_companies_reviews_services_companies_id" FOREIGN KEY("services_companies_id")
REFERENCES "services_companies" ("id");

ALTER TABLE "services_companies_reviews" ADD CONSTRAINT "fk_services_companies_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "developer_branch_company_reviews" ADD CONSTRAINT "fk_developer_branch_company_reviews_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "developer_branch_company_reviews" ADD CONSTRAINT "fk_developer_branch_company_reviews_developer_company_branches_id" FOREIGN KEY("developer_company_branches_id")
REFERENCES "developer_company_branches" ("id");

ALTER TABLE "developer_branch_company_reviews" ADD CONSTRAINT "fk_developer_branch_company_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "developer_branch_company_directors_reviews" ADD CONSTRAINT "fk_developer_branch_company_directors_reviews_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "developer_branch_company_directors_reviews" ADD CONSTRAINT "fk_developer_branch_company_directors_reviews_developer_branch_company_directors_id" FOREIGN KEY("developer_branch_company_directors_id")
REFERENCES "developer_branch_company_directors" ("id");

ALTER TABLE "developer_branch_company_directors_reviews" ADD CONSTRAINT "fk_developer_branch_company_directors_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "service_branch_company_reviews" ADD CONSTRAINT "fk_service_branch_company_reviews_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "service_branch_company_reviews" ADD CONSTRAINT "fk_service_branch_company_reviews_service_company_branches_id" FOREIGN KEY("service_company_branches_id")
REFERENCES "service_company_branches" ("id");

ALTER TABLE "service_branch_company_reviews" ADD CONSTRAINT "fk_service_branch_company_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "developer_company_directors_reviews" ADD CONSTRAINT "fk_developer_company_directors_reviews_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "developer_company_directors_reviews" ADD CONSTRAINT "fk_developer_company_directors_reviews_developer_company_directors_id" FOREIGN KEY("developer_company_directors_id")
REFERENCES "developer_company_directors" ("id");

ALTER TABLE "developer_company_directors_reviews" ADD CONSTRAINT "fk_developer_company_directors_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "broker_companies" ADD CONSTRAINT "fk_broker_companies_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "broker_companies" ADD CONSTRAINT "fk_broker_companies_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "broker_companies" ADD CONSTRAINT "fk_broker_companies_bank_account_details_id" FOREIGN KEY("bank_account_details_id")
REFERENCES "bank_account_details" ("id");

ALTER TABLE "broker_companies" ADD CONSTRAINT "fk_broker_companies_country_id" FOREIGN KEY("country_id")
REFERENCES "countries" ("id");

ALTER TABLE "broker_companies" ADD CONSTRAINT "fk_broker_companies_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "services_companies" ADD CONSTRAINT "fk_services_companies_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "services_companies" ADD CONSTRAINT "fk_services_companies_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "services_companies" ADD CONSTRAINT "fk_services_companies_bank_account_details_id" FOREIGN KEY("bank_account_details_id")
REFERENCES "bank_account_details" ("id");

ALTER TABLE "services_companies" ADD CONSTRAINT "fk_services_companies_country_id" FOREIGN KEY("country_id")
REFERENCES "countries" ("id");

ALTER TABLE "services_companies" ADD CONSTRAINT "fk_services_companies_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "service_company_branches" ADD CONSTRAINT "fk_service_company_branches_services_companies_id" FOREIGN KEY("services_companies_id")
REFERENCES "services_companies" ("id");

ALTER TABLE "service_company_branches" ADD CONSTRAINT "fk_service_company_branches_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "service_company_branches" ADD CONSTRAINT "fk_service_company_branches_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "service_company_branches" ADD CONSTRAINT "fk_service_company_branches_bank_account_details_id" FOREIGN KEY("bank_account_details_id")
REFERENCES "bank_account_details" ("id");

ALTER TABLE "service_company_branches" ADD CONSTRAINT "fk_service_company_branches_country_id" FOREIGN KEY("country_id")
REFERENCES "countries" ("id");

ALTER TABLE "service_company_branches" ADD CONSTRAINT "fk_service_company_branches_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

-- ALTER TABLE "developer_companies_branches_services" ADD CONSTRAINT "fk_developer_companies_branches_services_developer_company_branches_id" FOREIGN KEY("developer_company_branches_id")
-- REFERENCES "developer_company_branches" ("id");

-- ALTER TABLE "developer_companies_branches_services" ADD CONSTRAINT "fk_developer_companies_branches_services_services_id" FOREIGN KEY("services_id")
-- REFERENCES "services" ("id");

ALTER TABLE "bank_account_details" ADD CONSTRAINT "fk_bank_account_details_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "bank_account_details" ADD CONSTRAINT "fk_bank_account_details_currency_id" FOREIGN KEY("currency_id")
REFERENCES "currency" ("id");

ALTER TABLE "broker_company_reviews" ADD CONSTRAINT "fk_broker_company_reviews_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "broker_company_reviews" ADD CONSTRAINT "fk_broker_company_reviews_broker_companies_id" FOREIGN KEY("broker_companies_id")
REFERENCES "broker_companies" ("id");

ALTER TABLE "broker_company_reviews" ADD CONSTRAINT "fk_broker_company_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "sale_property_media" ADD CONSTRAINT "fk_sale_property_media_sale_property_units_id" FOREIGN KEY("sale_property_units_id")
REFERENCES "sale_property_units" ("id");

ALTER TABLE "sale_property_media_branch" ADD CONSTRAINT "fk_sale_property_media_branch_sale_property_units_branch_id" FOREIGN KEY("sale_property_units_branch_id")
REFERENCES "sale_property_units_branch" ("id");

ALTER TABLE "sale_property_unit_plans" ADD CONSTRAINT "fk_sale_property_unit_plans_sale_property_units_id" FOREIGN KEY("sale_property_units_id")
REFERENCES "sale_property_units" ("id");

ALTER TABLE "sale_property_unit_plans_branch" ADD CONSTRAINT "fk_sale_property_unit_plans_branch_sale_property_units_branch_id" FOREIGN KEY("sale_property_units_branch_id")
REFERENCES "sale_property_units_branch" ("id");

ALTER TABLE "rent_property_unit_plans" ADD CONSTRAINT "fk_rent_property_unit_plans_rent_property_units_id" FOREIGN KEY("rent_property_units_id")
REFERENCES "rent_property_units" ("id");

ALTER TABLE "rent_property_unit_plans_branch" ADD CONSTRAINT "fk_rent_property_unit_plans_branch_rent_property_units_branch_id" FOREIGN KEY("rent_property_units_branch_id")
REFERENCES "rent_property_units_branch" ("id");

ALTER TABLE "rent_property_media" ADD CONSTRAINT "fk_rent_property_media_rent_property_units_id" FOREIGN KEY("rent_property_units_id")
REFERENCES "rent_property_units" ("id");

ALTER TABLE "rent_property_media_branch" ADD CONSTRAINT "fk_rent_property_media_branch_rent_property_units_branch_id" FOREIGN KEY("rent_property_units_branch_id")
REFERENCES "rent_property_units_branch" ("id");

-- ALTER TABLE "project_property_media" ADD CONSTRAINT "fk_project_property_media_projects_id" FOREIGN KEY("projects_id")
-- REFERENCES "projects" ("id");

-- ALTER TABLE "project_property_media" ADD CONSTRAINT "fk_project_property_media_project_properties_id" FOREIGN KEY("project_properties_id")
-- REFERENCES "project_properties" ("id");

ALTER TABLE "projects" ADD CONSTRAINT "fk_projects_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "projects" ADD CONSTRAINT "fk_projects_developer_companies_id" FOREIGN KEY("developer_companies_id")
REFERENCES "developer_companies" ("id");

ALTER TABLE "projects" ADD CONSTRAINT "fk_projects_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "projects" ADD CONSTRAINT "fk_projects_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

-- ALTER TABLE "project_media" ADD CONSTRAINT "fk_project_media_projects_id" FOREIGN KEY("projects_id")
-- REFERENCES "projects" ("id");

-- ALTER TABLE "phases_media" ADD CONSTRAINT "fk_phases_media_phases_id" FOREIGN KEY("phases_id")
-- REFERENCES "phases" ("id");

ALTER TABLE "project_promotions" ADD CONSTRAINT "fk_project_promotions_promotion_types_id" FOREIGN KEY("promotion_types_id")
REFERENCES "promotion_types" ("id");

ALTER TABLE "project_promotions" ADD CONSTRAINT "fk_project_promotions_projects_id" FOREIGN KEY("projects_id")
REFERENCES "projects" ("id");

ALTER TABLE "project_requests" ADD CONSTRAINT "fk_project_requests_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "project_requests" ADD CONSTRAINT "fk_project_requests_projects_id" FOREIGN KEY("projects_id")
REFERENCES "projects" ("id");

ALTER TABLE "project_requests" ADD CONSTRAINT "fk_project_requests_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "building_reviews" ADD CONSTRAINT "fk_building_reviews_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "building_reviews" ADD CONSTRAINT "fk_building_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "documents_subcategory" ADD CONSTRAINT "fk_documents_subcategory_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "project_documents" ADD CONSTRAINT "fk_project_documents_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "project_documents" ADD CONSTRAINT "fk_project_documents_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "project_documents" ADD CONSTRAINT "fk_project_documents_projects_id" FOREIGN KEY("projects_id")
REFERENCES "projects" ("id");

ALTER TABLE "phases" ADD CONSTRAINT "fk_phases_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "phases" ADD CONSTRAINT "fk_phases_projects_id" FOREIGN KEY("projects_id")
REFERENCES "projects" ("id");

ALTER TABLE "phases" ADD CONSTRAINT "composite_unique_phase_name_projects_id" UNIQUE (phase_name, projects_id);

ALTER TABLE "project_properties" ADD CONSTRAINT "fk_project_properties_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "project_properties" ADD CONSTRAINT "fk_project_properties_projects_id" FOREIGN KEY("projects_id")
REFERENCES "projects" ("id");

ALTER TABLE "project_properties" ADD CONSTRAINT "fk_project_properties_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "project_properties" ADD CONSTRAINT "fk_project_properties_developer_companies_id" FOREIGN KEY("developer_companies_id")
REFERENCES "developer_companies" ("id");

ALTER TABLE "project_properties" ADD CONSTRAINT "fk_project_properties_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "project_properties_documents" ADD CONSTRAINT "fk_project_properties_documents_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "project_properties_documents" ADD CONSTRAINT "fk_project_properties_documents_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "project_properties_documents" ADD CONSTRAINT "fk_project_properties_documents_project_properties_id" FOREIGN KEY("project_properties_id")
REFERENCES "project_properties" ("id");

ALTER TABLE "unit_types" ADD CONSTRAINT "fk_unit_types_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "unit_types_branch" ADD CONSTRAINT "fk_unit_types_branch_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "broker_company_agent_properties" ADD CONSTRAINT "fk_broker_company_agent_properties_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "broker_company_agent_properties" ADD CONSTRAINT "fk_broker_company_agent_properties_locations_id" FOREIGN KEY("locations_id")
REFERENCES "locations" ("id");

ALTER TABLE "broker_company_agent_properties" ADD CONSTRAINT "fk_broker_company_agent_properties_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "broker_company_agent_properties" ADD CONSTRAINT "fk_broker_company_agent_properties_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "broker_company_agent_properties" ADD CONSTRAINT "fk_broker_company_agent_properties_broker_companies_id" FOREIGN KEY("broker_companies_id")
REFERENCES "broker_companies" ("id");

ALTER TABLE "broker_company_agent_properties" ADD CONSTRAINT "fk_broker_company_agent_properties_broker_company_agents" FOREIGN KEY("broker_company_agents")
REFERENCES "broker_company_agents" ("id");

ALTER TABLE "broker_company_agent_properties" ADD CONSTRAINT "fk_broker_company_agent_properties_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "broker_company_agent_properties" ADD CONSTRAINT "fk_broker_company_agent_properties_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "broker_company_agent_properties_branch" ADD CONSTRAINT "fk_broker_company_agent_properties_branch_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "broker_company_agent_properties_branch" ADD CONSTRAINT "fk_broker_company_agent_properties_branch_locations_id" FOREIGN KEY("locations_id")
REFERENCES "locations" ("id");

ALTER TABLE "broker_company_agent_properties_branch" ADD CONSTRAINT "fk_broker_company_agent_properties_branch_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "broker_company_agent_properties_branch" ADD CONSTRAINT "fk_broker_company_agent_properties_branch_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "broker_company_agent_properties_branch" ADD CONSTRAINT "fk_broker_company_agent_properties_branch_broker_companies_branches_id" FOREIGN KEY("broker_companies_branches_id")
REFERENCES "broker_companies_branches" ("id");

ALTER TABLE "broker_company_agent_properties_branch" ADD CONSTRAINT "fk_broker_company_agent_properties_branch_broker_company_branches_agents" FOREIGN KEY("broker_company_branches_agents")
REFERENCES "broker_company_branches_agents" ("id");

ALTER TABLE "broker_company_agent_properties_branch" ADD CONSTRAINT "fk_broker_company_agent_properties_branch_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "broker_company_agent_properties_branch" ADD CONSTRAINT "fk_broker_company_agent_properties_branch_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "broker_company_agent_properties_media" ADD CONSTRAINT "fk_broker_company_agent_properties_media_broker_company_agent_properties_id" FOREIGN KEY("broker_company_agent_properties_id")
REFERENCES "broker_company_agent_properties" ("id");

ALTER TABLE "broker_company_agent_properties_media_branch" ADD CONSTRAINT "fk_broker_company_agent_properties_media_branch_broker_company_agent_properties_branch_id" FOREIGN KEY("broker_company_agent_properties_branch_id")
REFERENCES "broker_company_agent_properties_branch" ("id");

ALTER TABLE "broker_company_agent_properties_documents" ADD CONSTRAINT "fk_broker_company_agent_properties_documents_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "broker_company_agent_properties_documents" ADD CONSTRAINT "fk_broker_company_agent_properties_documents_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "broker_company_agent_properties_documents" ADD CONSTRAINT "fk_broker_company_agent_properties_documents_broker_company_agent_properties_id" FOREIGN KEY("broker_company_agent_properties_id")
REFERENCES "broker_company_agent_properties" ("id");

ALTER TABLE "broker_company_agent_properties_documents_branch" ADD CONSTRAINT "fk_broker_company_agent_properties_documents_branch_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "broker_company_agent_properties_documents_branch" ADD CONSTRAINT "fk_broker_company_agent_properties_documents_branch_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "broker_company_agent_properties_documents_branch" ADD CONSTRAINT "fk_broker_company_agent_properties_documents_branch_broker_company_agent_properties_branch_id" FOREIGN KEY("broker_company_agent_properties_branch_id")
REFERENCES "broker_company_agent_properties_branch" ("id");

ALTER TABLE "owner_properties" ADD CONSTRAINT "fk_owner_properties_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "owner_properties" ADD CONSTRAINT "fk_owner_properties_locations_id" FOREIGN KEY("locations_id")
REFERENCES "locations" ("id");

ALTER TABLE "owner_properties" ADD CONSTRAINT "fk_owner_properties_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "owner_properties" ADD CONSTRAINT "fk_owner_properties_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "owner_properties" ADD CONSTRAINT "fk_owner_properties_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "owner_properties" ADD CONSTRAINT "fk_owner_properties_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "owner_properties_media" ADD CONSTRAINT "fk_owner_properties_media_owner_properties_id" FOREIGN KEY("owner_properties_id")
REFERENCES "owner_properties" ("id");

ALTER TABLE "owner_properties_documents" ADD CONSTRAINT "fk_owner_properties_documents_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "owner_properties_documents" ADD CONSTRAINT "fk_owner_properties_documents_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "owner_properties_documents" ADD CONSTRAINT "fk_owner_properties_documents_owner_properties_id" FOREIGN KEY("owner_properties_id")
REFERENCES "owner_properties" ("id");

ALTER TABLE "sale_property_units" ADD CONSTRAINT "fk_sale_property_units_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "sale_property_units" ADD CONSTRAINT "fk_sale_property_units_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "sale_property_units" ADD CONSTRAINT "fk_sale_property_units_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "sale_property_units" ADD CONSTRAINT "fk_sale_property_units_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "sale_property_units_branch" ADD CONSTRAINT "fk_sale_property_units_branch_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "sale_property_units_branch" ADD CONSTRAINT "fk_sale_property_units_branch_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "sale_property_units_branch" ADD CONSTRAINT "fk_sale_property_units_branch_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "sale_property_units_branch" ADD CONSTRAINT "fk_sale_property_units_branch_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "sale_property_units_documents" ADD CONSTRAINT "fk_sale_property_units_documents_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "sale_property_units_documents" ADD CONSTRAINT "fk_sale_property_units_documents_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "sale_property_units_documents" ADD CONSTRAINT "fk_sale_property_units_documents_sale_property_units_id" FOREIGN KEY("sale_property_units_id")
REFERENCES "sale_property_units" ("id");

ALTER TABLE "sale_property_units_documents_branch" ADD CONSTRAINT "fk_sale_property_units_documents_branch_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "sale_property_units_documents_branch" ADD CONSTRAINT "fk_sale_property_units_documents_branch_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "sale_property_units_documents_branch" ADD CONSTRAINT "fk_sale_property_units_documents_branch_sale_property_units_branch_id" FOREIGN KEY("sale_property_units_branch_id")
REFERENCES "sale_property_units_branch" ("id");

ALTER TABLE "sale_property_units_reviews" ADD CONSTRAINT "fk_sale_property_units_reviews_sale_property_units_id" FOREIGN KEY("sale_property_units_id")
REFERENCES "sale_property_units" ("id");

ALTER TABLE "sale_property_units_reviews" ADD CONSTRAINT "fk_sale_property_units_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "sale_property_units_branch_reviews" ADD CONSTRAINT "fk_sale_property_units_branch_reviews_sale_property_units_branch_id" FOREIGN KEY("sale_property_units_branch_id")
REFERENCES "sale_property_units_branch" ("id");

ALTER TABLE "sale_property_units_branch_reviews" ADD CONSTRAINT "fk_sale_property_units_branch_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "rent_property_units" ADD CONSTRAINT "fk_rent_property_units_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "rent_property_units" ADD CONSTRAINT "fk_rent_property_units_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "rent_property_units" ADD CONSTRAINT "fk_rent_property_units_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "rent_property_units" ADD CONSTRAINT "fk_rent_property_units_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "rent_property_units_branch" ADD CONSTRAINT "fk_rent_property_units_branch_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "rent_property_units_branch" ADD CONSTRAINT "fk_rent_property_units_branch_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "rent_property_units_branch" ADD CONSTRAINT "fk_rent_property_units_branch_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "rent_property_units_branch" ADD CONSTRAINT "fk_rent_property_units_branch_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "rent_property_units_reviews" ADD CONSTRAINT "fk_rent_property_units_reviews_rent_property_units_id" FOREIGN KEY("rent_property_units_id")
REFERENCES "rent_property_units" ("id");

ALTER TABLE "rent_property_units_reviews" ADD CONSTRAINT "fk_rent_property_units_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "rent_property_units_branch_reviews" ADD CONSTRAINT "fk_rent_property_units_branch_reviews_rent_property_units_branch_id" FOREIGN KEY("rent_property_units_branch_id")
REFERENCES "rent_property_units_branch" ("id");

ALTER TABLE "rent_property_units_branch_reviews" ADD CONSTRAINT "fk_rent_property_units_branch_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "rent_property_units_documents" ADD CONSTRAINT "fk_rent_property_units_documents_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "rent_property_units_documents" ADD CONSTRAINT "fk_rent_property_units_documents_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "rent_property_units_documents" ADD CONSTRAINT "fk_rent_property_units_documents_rent_property_units_id" FOREIGN KEY("rent_property_units_id")
REFERENCES "rent_property_units" ("id");

ALTER TABLE "rent_property_units_documents_branch" ADD CONSTRAINT "fk_rent_property_units_documents_branch_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "rent_property_units_documents_branch" ADD CONSTRAINT "fk_rent_property_units_documents_branch_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "rent_property_units_documents_branch" ADD CONSTRAINT "fk_rent_property_units_documents_branch_rent_property_units_branch_id" FOREIGN KEY("rent_property_units_branch_id")
REFERENCES "rent_property_units_branch" ("id");

ALTER TABLE "exchange_property_units" ADD CONSTRAINT "fk_exchange_property_units_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "exchange_property_units" ADD CONSTRAINT "fk_exchange_property_units_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "exchange_property_units" ADD CONSTRAINT "fk_exchange_property_units_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "exchange_property_units" ADD CONSTRAINT "fk_exchange_property_units_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "exchange_property_units_branch" ADD CONSTRAINT "fk_exchange_property_units_branch_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "exchange_property_units_branch" ADD CONSTRAINT "fk_exchange_property_units_branch_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "exchange_property_units_branch" ADD CONSTRAINT "fk_exchange_property_units_branch_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "exchange_property_units_branch" ADD CONSTRAINT "fk_exchange_property_units_branch_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "exchange_property_units_reviews" ADD CONSTRAINT "fk_exchange_property_units_reviews_exchange_property_units_id" FOREIGN KEY("exchange_property_units_id")
REFERENCES "exchange_property_units" ("id");

ALTER TABLE "exchange_property_units_reviews" ADD CONSTRAINT "fk_exchange_property_units_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "exchange_property_units_branch_reviews" ADD CONSTRAINT "fk_exchange_property_units_branch_reviews_exchange_property_units_branch_id" FOREIGN KEY("exchange_property_units_branch_id")
REFERENCES "exchange_property_units_branch" ("id");

ALTER TABLE "exchange_property_units_branch_reviews" ADD CONSTRAINT "fk_exchange_property_units_branch_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "exchange_property_units_documents" ADD CONSTRAINT "fk_exchange_property_units_documents_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "exchange_property_units_documents" ADD CONSTRAINT "fk_exchange_property_units_documents_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "exchange_property_units_documents" ADD CONSTRAINT "fk_exchange_property_units_documents_exchange_property_units_id" FOREIGN KEY("exchange_property_units_id")
REFERENCES "exchange_property_units" ("id");

ALTER TABLE "exchange_property_units_documents_branch" ADD CONSTRAINT "fk_exchange_property_units_documents_branch_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "exchange_property_units_documents_branch" ADD CONSTRAINT "fk_exchange_property_units_documents_branch_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "exchange_property_units_documents_branch" ADD CONSTRAINT "fk_exchange_property_units_documents_branch_exchange_property_units_branch_id" FOREIGN KEY("exchange_property_units_branch_id")
REFERENCES "exchange_property_units_branch" ("id");

ALTER TABLE "listing_problems_report" ADD CONSTRAINT "fk_listing_problems_report_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "listing_problems_report" ADD CONSTRAINT "fk_listing_problems_report_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "exchange_property_media" ADD CONSTRAINT "fk_exchange_property_media_exchange_property_units_id" FOREIGN KEY("exchange_property_units_id")
REFERENCES "exchange_property_units" ("id");

ALTER TABLE "exchange_property_media_branch" ADD CONSTRAINT "fk_exchange_property_media_branch_exchange_property_units_branch_id" FOREIGN KEY("exchange_property_units_branch_id")
REFERENCES "exchange_property_units_branch" ("id");

ALTER TABLE "exchange_property_unit_plans" ADD CONSTRAINT "fk_exchange_property_unit_plans_exchange_property_units_id" FOREIGN KEY("exchange_property_units_id")
REFERENCES "exchange_property_units" ("id");

ALTER TABLE "exchange_property_unit_plans_branch" ADD CONSTRAINT "fk_exchange_property_unit_plans_branch_exchange_property_units_branch_id" FOREIGN KEY("exchange_property_units_branch_id")
REFERENCES "exchange_property_units_branch" ("id");

ALTER TABLE "desired_exchange_unit" ADD CONSTRAINT "fk_desired_exchange_unit_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "desired_exchange_unit" ADD CONSTRAINT "fk_desired_exchange_unit_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "profiles" ADD CONSTRAINT "fk_profiles_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "users" ADD CONSTRAINT "fk_users_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "users" ADD CONSTRAINT "fk_users_user_types_id" FOREIGN KEY("user_types_id")
REFERENCES "user_types" ("id");

ALTER TABLE "broker_companies_services" ADD CONSTRAINT "fk_broker_companies_services_broker_companies_id" FOREIGN KEY("broker_companies_id")
REFERENCES "broker_companies" ("id");

ALTER TABLE "broker_companies_services" ADD CONSTRAINT "fk_broker_companies_services_services_id" FOREIGN KEY("services_id")
REFERENCES "services" ("id");

ALTER TABLE "broker_companies_branches_services" ADD CONSTRAINT "fk_broker_companies_branches_services_broker_companies_branches_id" FOREIGN KEY("broker_companies_branches_id")
REFERENCES "broker_companies_branches" ("id");

ALTER TABLE "broker_companies_branches_services" ADD CONSTRAINT "fk_broker_companies_branches_services_services_id" FOREIGN KEY("services_id")
REFERENCES "services" ("id");

-- ALTER TABLE "developer_companies_branches_services" ADD CONSTRAINT "fk_developer_companies_branches_services_services_id" FOREIGN KEY("services_id")
-- REFERENCES "services" ("id");

ALTER TABLE "developer_companies_services" ADD CONSTRAINT "fk_developer_companies_services_developer_companies_id" FOREIGN KEY("developer_companies_id")
REFERENCES "developer_companies" ("id");

ALTER TABLE "developer_companies_services" ADD CONSTRAINT "fk_developer_companies_services_services_id" FOREIGN KEY("services_id")
REFERENCES "services" ("id");

ALTER TABLE "developer_companies_branches_services" ADD CONSTRAINT "fk_developer_companies_branches_services_developer_company_branches_id" FOREIGN KEY("developer_company_branches_id")
REFERENCES "developer_company_branches" ("id");

ALTER TABLE "developer_companies_branches_services" ADD CONSTRAINT "fk_developer_companies_branches_services_services_id" FOREIGN KEY("services_id")
REFERENCES "services" ("id");

ALTER TABLE "services_companies_services" ADD CONSTRAINT "fk_services_companies_services_services_companies_id" FOREIGN KEY("services_companies_id")
REFERENCES "services_companies" ("id");

ALTER TABLE "services_companies_services" ADD CONSTRAINT "fk_services_companies_services_services_id" FOREIGN KEY("services_id")
REFERENCES "services" ("id");

ALTER TABLE "services_branch_companies_services" ADD CONSTRAINT "fk_services_branch_companies_services_service_company_branches_id" FOREIGN KEY("service_company_branches_id")
REFERENCES "service_company_branches" ("id");

ALTER TABLE "services_branch_companies_services" ADD CONSTRAINT "fk_services_branch_companies_services_services_id" FOREIGN KEY("services_id")
REFERENCES "services" ("id");

ALTER TABLE "services" ADD CONSTRAINT "fk_services_main_services_id" FOREIGN KEY("main_services_id")
REFERENCES "main_services" ("id");

-- ALTER TABLE "blog" ADD CONSTRAINT "fk_blog_blog_categories_id" FOREIGN KEY("blog_categories_id")
-- REFERENCES "blog_categories" ("id");

ALTER TABLE "sessions" ADD CONSTRAINT "fk_sessions_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "roles_permissions" ADD CONSTRAINT "fk_roles_permissions_roles_id" FOREIGN KEY("roles_id")
REFERENCES "roles" ("id");

ALTER TABLE "freelancers" ADD CONSTRAINT "fk_freelancers_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "freelancers" ADD CONSTRAINT "fk_freelancers_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "freelancers_bank_account_details" ADD CONSTRAINT "fk_freelancers_bank_account_details_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "freelancers_bank_account_details" ADD CONSTRAINT "fk_freelancers_bank_account_details_currency_id" FOREIGN KEY("currency_id")
REFERENCES "currency" ("id");

ALTER TABLE "freelancers_bank_account_details" ADD CONSTRAINT "fk_freelancers_bank_account_details_freelancers_id" FOREIGN KEY("freelancers_id")
REFERENCES "freelancers" ("id");

ALTER TABLE "freelancers_properties" ADD CONSTRAINT "fk_freelancers_properties_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "freelancers_properties" ADD CONSTRAINT "fk_freelancers_properties_locations_id" FOREIGN KEY("locations_id")
REFERENCES "locations" ("id");

ALTER TABLE "freelancers_properties" ADD CONSTRAINT "fk_freelancers_properties_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "freelancers_properties" ADD CONSTRAINT "fk_freelancers_properties_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "freelancers_properties" ADD CONSTRAINT "fk_freelancers_properties_freelancers_id" FOREIGN KEY("freelancers_id")
REFERENCES "freelancers" ("id");

ALTER TABLE "freelancers_properties" ADD CONSTRAINT "fk_freelancers_properties_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "freelancers_properties" ADD CONSTRAINT "fk_freelancers_properties_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "freelancers_properties_documents" ADD CONSTRAINT "fk_freelancers_properties_documents_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "freelancers_properties_documents" ADD CONSTRAINT "fk_freelancers_properties_documents_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "freelancers_properties_documents" ADD CONSTRAINT "fk_freelancers_properties_documents_freelancers_properties_id" FOREIGN KEY("freelancers_properties_id")
REFERENCES "freelancers_properties" ("id");

ALTER TABLE "freelancers_properties_media" ADD CONSTRAINT "fk_freelancers_properties_media_freelancers_properties_id" FOREIGN KEY("freelancers_properties_id")
REFERENCES "freelancers_properties" ("id");

ALTER TABLE "xml_ref_history" ADD CONSTRAINT "fk_xml_ref_history_xml_url_id" FOREIGN KEY("xml_url_id")
REFERENCES "xml_url" ("id");

ALTER TABLE "exchange_offers" ADD CONSTRAINT "fk_exchange_offers_offer_category_id" FOREIGN KEY("offer_category_id")
REFERENCES "exchange_offer_category" ("id");

ALTER TABLE "exchange_offers" ADD CONSTRAINT "fk_exchange_offers_exchange_unit_id" FOREIGN KEY("exchange_unit_id")
REFERENCES "exchange_property_units" ("id");

ALTER TABLE "industrial_freelancer_properties" ADD CONSTRAINT "fk_industrial_freelancer_properties_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "industrial_freelancer_properties" ADD CONSTRAINT "fk_industrial_freelancer_properties_locations_id" FOREIGN KEY("locations_id")
REFERENCES "locations" ("id");

ALTER TABLE "industrial_freelancer_properties" ADD CONSTRAINT "fk_industrial_freelancer_properties_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "industrial_freelancer_properties" ADD CONSTRAINT "fk_industrial_freelancer_properties_freelancers_id" FOREIGN KEY("freelancers_id")
REFERENCES "freelancers" ("id");

ALTER TABLE "industrial_freelancer_properties" ADD CONSTRAINT "fk_industrial_freelancer_properties_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "industrial_freelancer_properties" ADD CONSTRAINT "fk_industrial_freelancer_properties_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "industrial_freelancer_properties_documents" ADD CONSTRAINT "fk_industrial_freelancer_properties_documents_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "industrial_freelancer_properties_documents" ADD CONSTRAINT "fk_industrial_freelancer_properties_documents_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "industrial_freelancer_properties_documents" ADD CONSTRAINT "fk_industrial_freelancer_properties_documents_industrial_freelancer_properties_id" FOREIGN KEY("industrial_freelancer_properties_id")
REFERENCES "industrial_freelancer_properties" ("id");

ALTER TABLE "industrial_freelancer_properties_media" ADD CONSTRAINT "fk_industrial_freelancer_properties_media_industrial_freelancer_properties_id" FOREIGN KEY("industrial_freelancer_properties_id")
REFERENCES "industrial_freelancer_properties" ("id");

ALTER TABLE "project_completion_history" ADD CONSTRAINT "fk_project_completion_history_projects_id" FOREIGN KEY("projects_id")
REFERENCES "projects" ("id");

ALTER TABLE "industrial_broker_agent_properties" ADD CONSTRAINT "fk_industrial_broker_agent_properties_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "industrial_broker_agent_properties" ADD CONSTRAINT "fk_industrial_broker_agent_properties_locations_id" FOREIGN KEY("locations_id")
REFERENCES "locations" ("id");

ALTER TABLE "industrial_broker_agent_properties" ADD CONSTRAINT "fk_industrial_broker_agent_properties_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "industrial_broker_agent_properties" ADD CONSTRAINT "fk_industrial_broker_agent_properties_broker_companies_id" FOREIGN KEY("broker_companies_id")
REFERENCES "broker_companies" ("id");

ALTER TABLE "industrial_broker_agent_properties" ADD CONSTRAINT "fk_industrial_broker_agent_properties_broker_company_agents" FOREIGN KEY("broker_company_agents")
REFERENCES "broker_company_agents" ("id");

ALTER TABLE "industrial_broker_agent_properties" ADD CONSTRAINT "fk_industrial_broker_agent_properties_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "industrial_broker_agent_properties" ADD CONSTRAINT "fk_industrial_broker_agent_properties_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "industrial_broker_agent_properties_documents" ADD CONSTRAINT "fk_industrial_broker_agent_properties_documents_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "industrial_broker_agent_properties_documents" ADD CONSTRAINT "fk_industrial_broker_agent_properties_documents_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "industrial_broker_agent_properties_documents" ADD CONSTRAINT "fk_industrial_broker_agent_properties_documents_industrial_broker_agent_properties_id" FOREIGN KEY("industrial_broker_agent_properties_id")
REFERENCES "industrial_broker_agent_properties" ("id");

ALTER TABLE "industrial_broker_agent_properties_media" ADD CONSTRAINT "fk_industrial_broker_agent_properties_media_industrial_broker_agent_properties_id" FOREIGN KEY("industrial_broker_agent_properties_id")
REFERENCES "industrial_broker_agent_properties" ("id");

ALTER TABLE "industrial_broker_agent_properties_branch" ADD CONSTRAINT "fk_industrial_broker_agent_properties_branch_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "industrial_broker_agent_properties_branch" ADD CONSTRAINT "fk_industrial_broker_agent_properties_branch_locations_id" FOREIGN KEY("locations_id")
REFERENCES "locations" ("id");

ALTER TABLE "industrial_broker_agent_properties_branch" ADD CONSTRAINT "fk_industrial_broker_agent_properties_branch_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "industrial_broker_agent_properties_branch" ADD CONSTRAINT "fk_industrial_broker_agent_properties_branch_broker_companies_branches_id" FOREIGN KEY("broker_companies_branches_id")
REFERENCES "broker_companies_branches" ("id");

ALTER TABLE "industrial_broker_agent_properties_branch" ADD CONSTRAINT "fk_industrial_broker_agent_properties_branch_broker_company_branches_agents" FOREIGN KEY("broker_company_branches_agents")
REFERENCES "broker_company_branches_agents" ("id");

ALTER TABLE "industrial_broker_agent_properties_branch" ADD CONSTRAINT "fk_industrial_broker_agent_properties_branch_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "industrial_broker_agent_properties_branch" ADD CONSTRAINT "fk_industrial_broker_agent_properties_branch_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "industrial_broker_agent_properties_branch_document" ADD CONSTRAINT "fk_industrial_broker_agent_properties_branch_document_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "industrial_broker_agent_properties_branch_document" ADD CONSTRAINT "fk_industrial_broker_agent_properties_branch_document_industrial_broker_agent_properties_branch_id" FOREIGN KEY("industrial_broker_agent_properties_branch_id")
REFERENCES "industrial_broker_agent_properties_branch" ("id");

ALTER TABLE "industrial_broker_agent_properties_branch_media" ADD CONSTRAINT "fk_industrial_broker_agent_properties_branch_media_industrial_broker_agent_properties_branch_id" FOREIGN KEY("industrial_broker_agent_properties_branch_id")
REFERENCES "industrial_broker_agent_properties_branch" ("id");

ALTER TABLE "industrial_owner_properties" ADD CONSTRAINT "fk_industrial_owner_properties_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "industrial_owner_properties" ADD CONSTRAINT "fk_industrial_owner_properties_locations_id" FOREIGN KEY("locations_id")
REFERENCES "locations" ("id");

ALTER TABLE "industrial_owner_properties" ADD CONSTRAINT "fk_industrial_owner_properties_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "industrial_owner_properties" ADD CONSTRAINT "fk_industrial_owner_properties_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "industrial_owner_properties" ADD CONSTRAINT "fk_industrial_owner_properties_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "industrial_owner_properties_documents" ADD CONSTRAINT "fk_industrial_owner_properties_documents_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "industrial_owner_properties_documents" ADD CONSTRAINT "fk_industrial_owner_properties_documents_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "industrial_owner_properties_documents" ADD CONSTRAINT "fk_industrial_owner_properties_documents_industrial_owner_properties_id" FOREIGN KEY("industrial_owner_properties_id")
REFERENCES "industrial_owner_properties" ("id");

ALTER TABLE "industrial_owner_properties_media" ADD CONSTRAINT "fk_industrial_owner_properties_media_industrial_owner_properties_id" FOREIGN KEY("industrial_owner_properties_id")
REFERENCES "industrial_owner_properties" ("id");

ALTER TABLE "industrial_unit_types" ADD CONSTRAINT "fk_industrial_unit_types_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "industrial_unit_types_branch" ADD CONSTRAINT "fk_industrial_unit_types_branch_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "agricultural_freelancer_properties" ADD CONSTRAINT "fk_agricultural_freelancer_properties_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "agricultural_freelancer_properties" ADD CONSTRAINT "fk_agricultural_freelancer_properties_locations_id" FOREIGN KEY("locations_id")
REFERENCES "locations" ("id");

ALTER TABLE "agricultural_freelancer_properties" ADD CONSTRAINT "fk_agricultural_freelancer_properties_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "agricultural_freelancer_properties" ADD CONSTRAINT "fk_agricultural_freelancer_properties_freelancers_id" FOREIGN KEY("freelancers_id")
REFERENCES "freelancers" ("id");

ALTER TABLE "agricultural_freelancer_properties" ADD CONSTRAINT "fk_agricultural_freelancer_properties_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "agricultural_freelancer_properties" ADD CONSTRAINT "fk_agricultural_freelancer_properties_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "agricultural_freelancer_properties_documents" ADD CONSTRAINT "fk_agricultural_freelancer_properties_documents_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "agricultural_freelancer_properties_documents" ADD CONSTRAINT "fk_agricultural_freelancer_properties_documents_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "agricultural_freelancer_properties_documents" ADD CONSTRAINT "fk_agricultural_freelancer_properties_documents_agricultural_freelancer_properties_id" FOREIGN KEY("agricultural_freelancer_properties_id")
REFERENCES "agricultural_freelancer_properties" ("id");

ALTER TABLE "agricultural_freelancer_properties_media" ADD CONSTRAINT "fk_agricultural_freelancer_properties_media_agricultural_freelancer_properties_id" FOREIGN KEY("agricultural_freelancer_properties_id")
REFERENCES "agricultural_freelancer_properties" ("id");

ALTER TABLE "agricultural_broker_agent_properties" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "agricultural_broker_agent_properties" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_locations_id" FOREIGN KEY("locations_id")
REFERENCES "locations" ("id");

ALTER TABLE "agricultural_broker_agent_properties" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "agricultural_broker_agent_properties" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_broker_companies_id" FOREIGN KEY("broker_companies_id")
REFERENCES "broker_companies" ("id");

ALTER TABLE "agricultural_broker_agent_properties" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_broker_company_agents" FOREIGN KEY("broker_company_agents")
REFERENCES "broker_company_agents" ("id");

ALTER TABLE "agricultural_broker_agent_properties" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "agricultural_broker_agent_properties" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "agricultural_broker_agent_properties_documents" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_documents_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "agricultural_broker_agent_properties_documents" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_documents_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "agricultural_broker_agent_properties_documents" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_documents_agricultural_broker_agent_properties_id" FOREIGN KEY("agricultural_broker_agent_properties_id")
REFERENCES "agricultural_broker_agent_properties" ("id");

ALTER TABLE "agricultural_broker_agent_properties_media" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_media_agricultural_broker_agent_properties_id" FOREIGN KEY("agricultural_broker_agent_properties_id")
REFERENCES "agricultural_broker_agent_properties" ("id");

ALTER TABLE "agricultural_broker_agent_properties_branch" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_branch_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "agricultural_broker_agent_properties_branch" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_branch_locations_id" FOREIGN KEY("locations_id")
REFERENCES "locations" ("id");

ALTER TABLE "agricultural_broker_agent_properties_branch" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_branch_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "agricultural_broker_agent_properties_branch" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_branch_broker_companies_branches_id" FOREIGN KEY("broker_companies_branches_id")
REFERENCES "broker_companies_branches" ("id");

ALTER TABLE "agricultural_broker_agent_properties_branch" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_branch_broker_company_branches_agents" FOREIGN KEY("broker_company_branches_agents")
REFERENCES "broker_company_branches_agents" ("id");

ALTER TABLE "agricultural_broker_agent_properties_branch" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_branch_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "agricultural_broker_agent_properties_branch" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_branch_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "agricultural_broker_agent_properties_branch_document" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_branch_document_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "agricultural_broker_agent_properties_branch_document" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_branch_document_agricultural_broker_agent_properties_branch_id" FOREIGN KEY("agricultural_broker_agent_properties_branch_id")
REFERENCES "agricultural_broker_agent_properties_branch" ("id");

ALTER TABLE "agricultural_broker_agent_properties_branch_media" ADD CONSTRAINT "fk_agricultural_broker_agent_properties_branch_media_agricultural_broker_agent_properties_branch_id" FOREIGN KEY("agricultural_broker_agent_properties_branch_id")
REFERENCES "agricultural_broker_agent_properties_branch" ("id");

ALTER TABLE "agricultural_owner_properties" ADD CONSTRAINT "fk_agricultural_owner_properties_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "agricultural_owner_properties" ADD CONSTRAINT "fk_agricultural_owner_properties_locations_id" FOREIGN KEY("locations_id")
REFERENCES "locations" ("id");

ALTER TABLE "agricultural_owner_properties" ADD CONSTRAINT "fk_agricultural_owner_properties_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "agricultural_owner_properties" ADD CONSTRAINT "fk_agricultural_owner_properties_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "agricultural_owner_properties" ADD CONSTRAINT "fk_agricultural_owner_properties_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "agricultural_owner_properties_documents" ADD CONSTRAINT "fk_agricultural_owner_properties_documents_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "agricultural_owner_properties_documents" ADD CONSTRAINT "fk_agricultural_owner_properties_documents_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "agricultural_owner_properties_documents" ADD CONSTRAINT "fk_agricultural_owner_properties_documents_agricultural_owner_properties_id" FOREIGN KEY("agricultural_owner_properties_id")
REFERENCES "agricultural_owner_properties" ("id");

ALTER TABLE "agricultural_owner_properties_media" ADD CONSTRAINT "fk_agricultural_owner_properties_media_agricultural_owner_properties_id" FOREIGN KEY("agricultural_owner_properties_id")
REFERENCES "agricultural_owner_properties" ("id");

ALTER TABLE "agricultural_unit_types" ADD CONSTRAINT "fk_agricultural_unit_types_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "agricultural_unit_types_branch" ADD CONSTRAINT "fk_agricultural_unit_types_branch_property_types_id" FOREIGN KEY("property_types_id")
REFERENCES "property_types" ("id");

ALTER TABLE "property_unit_likes" ADD CONSTRAINT "fk_property_unit_likes_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "property_unit_saved" ADD CONSTRAINT "fk_property_unit_saved_collection_name_id" FOREIGN KEY("collection_name_id")
REFERENCES "collection_name" ("id");

ALTER TABLE "property_unit_saved" ADD CONSTRAINT "fk_property_unit_saved_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "collection_name" ADD CONSTRAINT "fk_collection_name_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "property_unit_comments" ADD CONSTRAINT "fk_property_unit_comments_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "leaders" ADD CONSTRAINT "fk_leaders_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "company_users" ADD CONSTRAINT "fk_company_users_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "company_users" ADD CONSTRAINT "fk_company_users_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "contacts" ADD CONSTRAINT "fk_contacts_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "shareable_contact_details" ADD CONSTRAINT "fk_shareable_contact_details_contacts_id" FOREIGN KEY("contacts_id")
REFERENCES "contacts" ("id");

ALTER TABLE "shareable_contact_details" ADD CONSTRAINT "fk_shareable_contact_details_added_by" FOREIGN KEY("added_by")
REFERENCES "users" ("id");

ALTER TABLE "contacts_individual_details" ADD CONSTRAINT "fk_contacts_individual_details_contacts_id" FOREIGN KEY("contacts_id")
REFERENCES "contacts" ("id");

ALTER TABLE "contacts_individual_details" ADD CONSTRAINT "fk_contacts_individual_details_id_country_id" FOREIGN KEY("id_country_id")
REFERENCES "countries" ("id");

ALTER TABLE "contacts_individual_details" ADD CONSTRAINT "fk_contacts_individual_details_passport_country_id" FOREIGN KEY("passport_country_id")
REFERENCES "countries" ("id");

ALTER TABLE "contacts_company_details" ADD CONSTRAINT "fk_contacts_company_details_contacts_id" FOREIGN KEY("contacts_id")
REFERENCES "contacts" ("id");

ALTER TABLE "contacts_address" ADD CONSTRAINT "fk_contacts_address_contacts_id" FOREIGN KEY("contacts_id")
REFERENCES "contacts" ("id");

ALTER TABLE "contacts_address" ADD CONSTRAINT "fk_contacts_address_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "contacts_other_contact" ADD CONSTRAINT "fk_contacts_other_contact_contacts_id" FOREIGN KEY("contacts_id")
REFERENCES "contacts" ("id");

ALTER TABLE "contacts_other_contact" ADD CONSTRAINT "fk_contacts_other_contact_other_contacts_id" FOREIGN KEY("other_contacts_id")
REFERENCES "contacts" ("id");

ALTER TABLE "contacts_unit" ADD CONSTRAINT "fk_contacts_unit_contacts_id" FOREIGN KEY("contacts_id")
REFERENCES "contacts" ("id");

ALTER TABLE "contacts_projects" ADD CONSTRAINT "fk_contacts_projects_contacts_id" FOREIGN KEY("contacts_id")
REFERENCES "contacts" ("id");

ALTER TABLE "contacts_projects" ADD CONSTRAINT "fk_contacts_projects_project_id" FOREIGN KEY("project_id")
REFERENCES "projects" ("id");

ALTER TABLE "contacts_document" ADD CONSTRAINT "fk_contacts_document_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "contacts_transaction" ADD CONSTRAINT "fk_contacts_transaction_leads_id" FOREIGN KEY("leads_id")
REFERENCES "leads" ("id");

ALTER TABLE "contacts_activity_header" ADD CONSTRAINT "fk_contacts_activity_header_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "contacts_activity_details" ADD CONSTRAINT "fk_contacts_activity_details_contacts_activity_header_id" FOREIGN KEY("contacts_activity_header_id")
REFERENCES "contacts_activity_header" ("id");

ALTER TABLE "leads" ADD CONSTRAINT "fk_leads_contacts_id" FOREIGN KEY("contacts_id")
REFERENCES "contacts" ("id");

ALTER TABLE "leads" ADD CONSTRAINT "fk_leads_property_type_id" FOREIGN KEY("property_type_id")
REFERENCES "property_types" ("id");

ALTER TABLE "leads" ADD CONSTRAINT "fk_leads_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "leads" ADD CONSTRAINT "fk_leads_states_id" FOREIGN KEY("states_id")
REFERENCES "states" ("id");

ALTER TABLE "leads" ADD CONSTRAINT "fk_leads_cities_id" FOREIGN KEY("cities_id")
REFERENCES "cities" ("id");

ALTER TABLE "leads" ADD CONSTRAINT "fk_leads_assigned_to" FOREIGN KEY("assigned_to")
REFERENCES "users" ("id");

ALTER TABLE "leads" ADD CONSTRAINT "fk_leads_referred_to" FOREIGN KEY("referred_to")
REFERENCES "users" ("id");

ALTER TABLE "leads_progress" ADD CONSTRAINT "fk_leads_progress_leads_id" FOREIGN KEY("leads_id")
REFERENCES "leads" ("id");

ALTER TABLE "leads_notification" ADD CONSTRAINT "fk_leads_notification_leads_id" FOREIGN KEY("leads_id")
REFERENCES "leads" ("id");

ALTER TABLE "leads_document" ADD CONSTRAINT "fk_leads_document_entered_by" FOREIGN KEY("entered_by")
REFERENCES "users" ("id");

ALTER TABLE "lead_general_requests" ADD CONSTRAINT "fk_lead_general_requests_contact_id" FOREIGN KEY("contact_id")
REFERENCES "contacts" ("id");

ALTER TABLE "lead_general_requests" ADD CONSTRAINT "fk_lead_general_requests_lead_id" FOREIGN KEY("lead_id")
REFERENCES "leads" ("id");

ALTER TABLE "leads_creation" ADD CONSTRAINT "fk_leads_creation_leads_id" FOREIGN KEY("leads_id")
REFERENCES "leads" ("id");

ALTER TABLE "permissions" ADD CONSTRAINT "fk_permissions_section_permission_id" FOREIGN KEY("section_permission_id")
REFERENCES "section_permission" ("id");

ALTER TABLE "sub_section" ADD CONSTRAINT "fk_sub_section_permissions_id" FOREIGN KEY("permissions_id")
REFERENCES "permissions" ("id");

ALTER TABLE "property_hub_activities" ADD CONSTRAINT "fk_property_hub_activities_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "units_activities" ADD CONSTRAINT "fk_units_activities_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "companies_activities" ADD CONSTRAINT "fk_companies_activities_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "agents_activities" ADD CONSTRAINT "fk_agents_activities_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "aqary_media_activities" ADD CONSTRAINT "fk_aqary_media_activities_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "banner_ads_activities" ADD CONSTRAINT "fk_banner_ads_activities_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "network_activities" ADD CONSTRAINT "fk_network_activities_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "community_guides_activities" ADD CONSTRAINT "fk_community_guides_activities_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "booking_activities" ADD CONSTRAINT "fk_booking_activities_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "tax_management_activities" ADD CONSTRAINT "fk_tax_management_activities_ref_activity_id" FOREIGN KEY("ref_activity_id")
REFERENCES "tax_management" ("id");

ALTER TABLE "tax_management_activities" ADD CONSTRAINT "fk_tax_management_activities_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "problem_reports" ADD CONSTRAINT "fk_problem_reports_reported_by" FOREIGN KEY("reported_by")
REFERENCES "users" ("id");

ALTER TABLE "problem_reports" ADD CONSTRAINT "fk_problem_reports_assigned_to" FOREIGN KEY("assigned_to")
REFERENCES "users" ("id");

ALTER TABLE "social_reactions_details" ADD CONSTRAINT "fk_social_reactions_details_social_reactions_id" FOREIGN KEY("social_reactions_id")
REFERENCES "social_reactions" ("id");

ALTER TABLE "social_reactions_details" ADD CONSTRAINT "fk_social_reactions_details_reacted_by" FOREIGN KEY("reacted_by")
REFERENCES "users" ("id");

ALTER TABLE "connections_settings" ADD CONSTRAINT "fk_connections_settings_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "social_connections" ADD CONSTRAINT "fk_social_connections_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "social_connections" ADD CONSTRAINT "fk_social_connections_requested_by" FOREIGN KEY("requested_by")
REFERENCES "users" ("id");

ALTER TABLE "followers" ADD CONSTRAINT "fk_followers_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "social_notifications" ADD CONSTRAINT "fk_social_notifications_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "social_notifications" ADD CONSTRAINT "fk_social_notifications_notification_from" FOREIGN KEY("notification_from")
REFERENCES "users" ("id");

ALTER TABLE "post_followers" ADD CONSTRAINT "fk_post_followers_aqary_project_posts_id" FOREIGN KEY("aqary_project_posts_id")
REFERENCES "aqary_project_posts" ("id");

ALTER TABLE "posts_projects_comments" ADD CONSTRAINT "fk_posts_projects_comments_parent_post_comments" FOREIGN KEY("parent_post_comments")
REFERENCES "posts_projects_comments" ("id");

ALTER TABLE "posts_projects_comments" ADD CONSTRAINT "fk_posts_projects_comments_commented_by" FOREIGN KEY("commented_by")
REFERENCES "users" ("id");

ALTER TABLE "aqary_property_posts" ADD CONSTRAINT "fk_aqary_property_posts_posted_by" FOREIGN KEY("posted_by")
REFERENCES "users" ("id");

ALTER TABLE "aqary_property_post_media" ADD CONSTRAINT "fk_aqary_property_post_media_aqary_property_posts_id" FOREIGN KEY("aqary_property_posts_id")
REFERENCES "aqary_property_posts" ("id");

ALTER TABLE "aqary_project_posts" ADD CONSTRAINT "fk_aqary_project_posts_posted_by" FOREIGN KEY("posted_by")
REFERENCES "users" ("id");

ALTER TABLE "aqary_project_post_media" ADD CONSTRAINT "fk_aqary_project_post_media_aqary_project_posts" FOREIGN KEY("aqary_project_posts")
REFERENCES "aqary_project_posts" ("id");

ALTER TABLE "aqary_ads" ADD CONSTRAINT "fk_aqary_ads_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "aqary_project_ads" ADD CONSTRAINT "fk_aqary_project_ads_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "aqary_property_ads" ADD CONSTRAINT "fk_aqary_property_ads_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "aqary_property_ads_media" ADD CONSTRAINT "fk_aqary_property_ads_media_aqary_property_ads" FOREIGN KEY("aqary_property_ads")
REFERENCES "aqary_property_ads" ("id");

ALTER TABLE "aqary_project_ads_media" ADD CONSTRAINT "fk_aqary_project_ads_media_aqary_project_ads" FOREIGN KEY("aqary_project_ads")
REFERENCES "aqary_project_ads" ("id");

ALTER TABLE "aqary_media_likes" ADD CONSTRAINT "fk_aqary_media_likes_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "careers" ADD CONSTRAINT "fk_careers_job_categories" FOREIGN KEY("job_categories")
REFERENCES "job_categories" ("id");

ALTER TABLE "careers" ADD CONSTRAINT "fk_careers_uploaded_by" FOREIGN KEY("uploaded_by")
REFERENCES "users" ("id");

ALTER TABLE "careers" ADD CONSTRAINT "fk_careers_employers_id" FOREIGN KEY("employers_id")
REFERENCES "employers" ("id");

ALTER TABLE "employers" ADD CONSTRAINT "fk_employers_industry_id" FOREIGN KEY("industry_id")
REFERENCES "industry" ("id");

ALTER TABLE "employers" ADD CONSTRAINT "fk_employers_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "job_categories" ADD CONSTRAINT "fk_job_categories_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "career_articles" ADD CONSTRAINT "fk_career_articles_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "career_articles" ADD CONSTRAINT "fk_career_articles_employers_id" FOREIGN KEY("employers_id")
REFERENCES "employers" ("id");

ALTER TABLE "candidates" ADD CONSTRAINT "fk_candidates_careers_id" FOREIGN KEY("careers_id")
REFERENCES "careers" ("id");

ALTER TABLE "candidates" ADD CONSTRAINT "fk_candidates_applicants_id" FOREIGN KEY("applicants_id")
REFERENCES "applicants" ("id");

ALTER TABLE "candidates_milestone" ADD CONSTRAINT "fk_candidates_milestone_candidates_id" FOREIGN KEY("candidates_id")
REFERENCES "candidates" ("id");

ALTER TABLE "posted_career_portal" ADD CONSTRAINT "fk_posted_career_portal_careers_id" FOREIGN KEY("careers_id")
REFERENCES "careers" ("id");

ALTER TABLE "posted_career_portal" ADD CONSTRAINT "fk_posted_career_portal_job_portals_id" FOREIGN KEY("job_portals_id")
REFERENCES "job_portals" ("id");

ALTER TABLE "webportals" ADD CONSTRAINT "fk_webportals_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "internal_sharing" ADD CONSTRAINT "fk_internal_sharing_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "shared_doc" ADD CONSTRAINT "fk_shared_doc_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "shared_doc" ADD CONSTRAINT "fk_shared_doc_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");



-- //! this alteration  has a problem 
-- ALTER TABLE "shared_doc" ADD CONSTRAINT "fk_shared_doc_projects_id" FOREIGN KEY("projects_id")
-- REFERENCES "projects" ("id");

ALTER TABLE "external_sharing" ADD CONSTRAINT "fk_external_sharing_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "publish_info" ADD CONSTRAINT "fk_publish_info_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "published_doc" ADD CONSTRAINT "fk_published_doc_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "published_doc" ADD CONSTRAINT "fk_published_doc_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "bank_branches" ADD CONSTRAINT "fk_bank_branches_banks_id" FOREIGN KEY("banks_id")
REFERENCES "banks" ("id");

-- ALTER TABLE "subscriptions" ADD CONSTRAINT "fk_subscriptions_countries_id" FOREIGN KEY("countries_id")
-- REFERENCES "countries" ("id");

-- ALTER TABLE "subscriptions" ADD CONSTRAINT "fk_subscriptions_created_by" FOREIGN KEY("created_by")
-- REFERENCES "users" ("id");

ALTER TABLE "subscription_cost" ADD CONSTRAINT "fk_subscription_cost_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "subscription_cost" ADD CONSTRAINT "fk_subscription_cost_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "modules" ADD CONSTRAINT "fk_modules_parent_module_id" FOREIGN KEY("parent_module_id")
REFERENCES "modules" ("id");



-- //! this has table has a problem

-- ALTER TABLE "menu_country_wise" ADD CONSTRAINT "fk_menu_country_wise_countries_id" FOREIGN KEY("countries_id")
-- REFERENCES "countries" ("id");

-- ALTER TABLE "menu_country_wise" ADD CONSTRAINT "fk_menu_country_wise_modules" FOREIGN KEY("modules")
-- REFERENCES "modules" ("id");

-- ALTER TABLE "menu_country_wise" ADD CONSTRAINT "fk_menu_country_wise_created_by" FOREIGN KEY("created_by")
-- REFERENCES "users" ("id");

ALTER TABLE "phases_plans" ADD CONSTRAINT "fk_phases_plans_phases_id" FOREIGN KEY("phases_id")
REFERENCES "phases" ("id");

ALTER TABLE "phases_plans" ADD CONSTRAINT "fk_phases_plans_uploaded_by" FOREIGN KEY("uploaded_by")
REFERENCES "users" ("id");

ALTER TABLE "phases_plans" ADD CONSTRAINT "fk_phases_plans_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "phases_facts" ADD CONSTRAINT "fk_phases_facts_phases_id" FOREIGN KEY("phases_id")
REFERENCES "phases" ("id");

ALTER TABLE "phases_documents" ADD CONSTRAINT "fk_phases_documents_phases_id" FOREIGN KEY("phases_id")
REFERENCES "phases" ("id");

ALTER TABLE "phases_documents" ADD CONSTRAINT "fk_phases_documents_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "phases_documents" ADD CONSTRAINT "fk_phases_documents_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "phases_documents" ADD CONSTRAINT "fk_phases_documents_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "phases_documents" ADD CONSTRAINT "fk_phases_documents_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

-- ALTER TABLE "project_plans" ADD CONSTRAINT "fk_project_plans_projects_id" FOREIGN KEY("projects_id")
-- REFERENCES "projects" ("id");

ALTER TABLE "project_plans" ADD CONSTRAINT "fk_project_plans_uploaded_by" FOREIGN KEY("uploaded_by")
REFERENCES "users" ("id");

ALTER TABLE "project_plans" ADD CONSTRAINT "fk_project_plans_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "exhibitions" ADD CONSTRAINT "fk_exhibitions_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "exhibitions" ADD CONSTRAINT "fk_exhibitions_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "exhibitions_media" ADD CONSTRAINT "fk_exhibitions_media_exhibitions_id" FOREIGN KEY("exhibitions_id")
REFERENCES "exhibitions" ("id");

ALTER TABLE "exhibition_collaborators" ADD CONSTRAINT "fk_exhibition_collaborators_exhibitions_id" FOREIGN KEY("exhibitions_id")
REFERENCES "exhibitions" ("id");

ALTER TABLE "exhibition_clients" ADD CONSTRAINT "fk_exhibition_clients_exhibitions_id" FOREIGN KEY("exhibitions_id")
REFERENCES "exhibitions" ("id");

ALTER TABLE "exhibition_clients" ADD CONSTRAINT "fk_exhibition_clients_added_by" FOREIGN KEY("added_by")
REFERENCES "users" ("id");

ALTER TABLE "exhibition_registration" ADD CONSTRAINT "fk_exhibition_registration_exhibitions_id" FOREIGN KEY("exhibitions_id")
REFERENCES "exhibitions" ("id");

ALTER TABLE "exhibition_queries" ADD CONSTRAINT "fk_exhibition_queries_exhibitions_id" FOREIGN KEY("exhibitions_id")
REFERENCES "exhibitions" ("id");

ALTER TABLE "exhibition_services" ADD CONSTRAINT "fk_exhibition_services_exhibitions_id" FOREIGN KEY("exhibitions_id")
REFERENCES "exhibitions" ("id");

ALTER TABLE "exhibition_booths" ADD CONSTRAINT "fk_exhibition_booths_exhibitions_id" FOREIGN KEY("exhibitions_id")
REFERENCES "exhibitions" ("id");

ALTER TABLE "sale_price_history" ADD CONSTRAINT "fk_sale_price_history_unit_facts_id" FOREIGN KEY("unit_facts_id")
REFERENCES "unit_facts" ("id");

ALTER TABLE "sale_price_history" ADD CONSTRAINT "fk_sale_price_history_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "project_appointment_views" ADD CONSTRAINT "fk_project_appointment_views_project_appointment_slot_id" FOREIGN KEY("project_appointment_slot_id")
REFERENCES "project_appointment_slots" ("id");

ALTER TABLE "project_appointment_views" ADD CONSTRAINT "fk_project_appointment_views_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "project_appointment_slots" ADD CONSTRAINT "fk_project_appointment_slots_project_open_house_id" FOREIGN KEY("project_open_house_id")
REFERENCES "project_open_house" ("id");

ALTER TABLE "companies_products" ADD CONSTRAINT "fk_companies_products_products_categories_id" FOREIGN KEY("products_categories_id")
REFERENCES "product_categories" ("id");

ALTER TABLE "companies_products_promotions" ADD CONSTRAINT "fk_companies_products_promotions_companies_products_id" FOREIGN KEY("companies_products_id")
REFERENCES "companies_products" ("id");

ALTER TABLE "companies_products_promotions" ADD CONSTRAINT "fk_companies_products_promotions_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "products_inventory" ADD CONSTRAINT "fk_products_inventory_companies_products_id" FOREIGN KEY("companies_products_id")
REFERENCES "companies_products" ("id");

ALTER TABLE "product_inbounds" ADD CONSTRAINT "fk_product_inbounds_companies_products_id" FOREIGN KEY("companies_products_id")
REFERENCES "companies_products" ("id");

ALTER TABLE "product_inbounds" ADD CONSTRAINT "fk_product_inbounds_processed_by" FOREIGN KEY("processed_by")
REFERENCES "users" ("id");

ALTER TABLE "product_outbounds" ADD CONSTRAINT "fk_product_outbounds_product_order_requests_id" FOREIGN KEY("product_order_requests_id")
REFERENCES "product_order_requests" ("id");

ALTER TABLE "product_outbounds" ADD CONSTRAINT "fk_product_outbounds_issued_by" FOREIGN KEY("issued_by")
REFERENCES "users" ("id");

ALTER TABLE "product_order_requests" ADD CONSTRAINT "fk_product_order_requests_companies_products_id" FOREIGN KEY("companies_products_id")
REFERENCES "companies_products" ("id");

ALTER TABLE "product_order_requests" ADD CONSTRAINT "fk_product_order_requests_requested_by" FOREIGN KEY("requested_by")
REFERENCES "users" ("id");

ALTER TABLE "product_order_requests" ADD CONSTRAINT "fk_product_order_requests_assigned_to" FOREIGN KEY("assigned_to")
REFERENCES "users" ("id");

ALTER TABLE "product_order_requests" ADD CONSTRAINT "fk_product_order_requests_product_transactions_id" FOREIGN KEY("product_transactions_id")
REFERENCES "product_outbounds" ("id");

ALTER TABLE "product_reviews" ADD CONSTRAINT "fk_product_reviews_companies_products_id" FOREIGN KEY("companies_products_id")
REFERENCES "companies_products" ("id");

ALTER TABLE "product_reviews" ADD CONSTRAINT "fk_product_reviews_reviewer" FOREIGN KEY("reviewer")
REFERENCES "users" ("id");

ALTER TABLE "product_review_comments" ADD CONSTRAINT "fk_product_review_comments_product_reviews_id" FOREIGN KEY("product_reviews_id")
REFERENCES "product_reviews" ("id");

ALTER TABLE "product_review_comments" ADD CONSTRAINT "fk_product_review_comments_commented_by" FOREIGN KEY("commented_by")
REFERENCES "users" ("id");

ALTER TABLE "product_comments_reactions" ADD CONSTRAINT "fk_product_comments_reactions_review_comments_id" FOREIGN KEY("review_comments_id")
REFERENCES "product_review_comments" ("id");

ALTER TABLE "product_comments_reactions" ADD CONSTRAINT "fk_product_comments_reactions_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "companies_products_reactions" ADD CONSTRAINT "fk_companies_products_reactions_companies_product_id" FOREIGN KEY("companies_product_id")
REFERENCES "companies_products" ("id");

ALTER TABLE "holiday_home_portals" ADD CONSTRAINT "fk_holiday_home_portals_holiday_home_id" FOREIGN KEY("holiday_home_id")
REFERENCES "holiday_home" ("id");

ALTER TABLE "holiday_home_portals" ADD CONSTRAINT "fk_holiday_home_portals_booking_portals_id" FOREIGN KEY("booking_portals_id")
REFERENCES "booking_portals" ("id");

ALTER TABLE "holiday_home" ADD CONSTRAINT "fk_holiday_home_posted_by" FOREIGN KEY("posted_by")
REFERENCES "users" ("id");

ALTER TABLE "holiday_media" ADD CONSTRAINT "fk_holiday_media_holiday_home_id" FOREIGN KEY("holiday_home_id")
REFERENCES "holiday_home" ("id");

ALTER TABLE "holiday_home_bookings" ADD CONSTRAINT "fk_holiday_home_bookings_holiday_home_id" FOREIGN KEY("holiday_home_id")
REFERENCES "holiday_home" ("id");

ALTER TABLE "holiday_stay_reviews" ADD CONSTRAINT "fk_holiday_stay_reviews_holiday_home_id" FOREIGN KEY("holiday_home_id")
REFERENCES "holiday_home" ("id");

ALTER TABLE "holiday_stay_reviews" ADD CONSTRAINT "fk_holiday_stay_reviews_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "holiday_experience_reviews" ADD CONSTRAINT "fk_holiday_experience_reviews_holiday_home_id" FOREIGN KEY("holiday_home_id")
REFERENCES "holiday_home" ("id");

ALTER TABLE "holiday_experience_reviews" ADD CONSTRAINT "fk_holiday_experience_reviews_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "holiday_home_comments" ADD CONSTRAINT "fk_holiday_home_comments_holiday_home_id" FOREIGN KEY("holiday_home_id")
REFERENCES "holiday_home" ("id");

ALTER TABLE "holiday_home_comments" ADD CONSTRAINT "fk_holiday_home_comments_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "holiday_home_promo" ADD CONSTRAINT "fk_holiday_home_promo_holiday_home_id" FOREIGN KEY("holiday_home_id")
REFERENCES "holiday_home" ("id");

ALTER TABLE "holiday_home_promo" ADD CONSTRAINT "fk_holiday_home_promo_booking_portal_id" FOREIGN KEY("booking_portal_id")
REFERENCES "booking_portals" ("id");

ALTER TABLE "holiday_home_promo" ADD CONSTRAINT "fk_holiday_home_promo_holiday_home_portals_id" FOREIGN KEY("holiday_home_portals_id")
REFERENCES "holiday_home_portals" ("id");

ALTER TABLE "holiday_experience_schedule" ADD CONSTRAINT "fk_holiday_experience_schedule_holiday_home_id" FOREIGN KEY("holiday_home_id")
REFERENCES "holiday_home" ("id");

ALTER TABLE "hotel_rooms" ADD CONSTRAINT "fk_hotel_rooms_posted_hotel_id" FOREIGN KEY("posted_hotel_id")
REFERENCES "posted_hotel_bookings" ("id");

-- ALTER TABLE "hotel_rooms" ADD CONSTRAINT "fk_hotel_rooms_room_types_id" FOREIGN KEY("room_types_id")
-- REFERENCES "room_types" ("id");

ALTER TABLE "hotel_booking_portal" ADD CONSTRAINT "fk_hotel_booking_portal_hotel_rooms_id" FOREIGN KEY("hotel_rooms_id")
REFERENCES "hotel_rooms" ("id");

ALTER TABLE "hotel_booking_portal" ADD CONSTRAINT "fk_hotel_booking_portal_booking_portals_id" FOREIGN KEY("booking_portals_id")
REFERENCES "booking_portals" ("id");

ALTER TABLE "hotel_booking_portal" ADD CONSTRAINT "fk_hotel_booking_portal_hotel_booking_promo_id" FOREIGN KEY("hotel_booking_promo_id")
REFERENCES "hotel_booking_promo" ("id");

ALTER TABLE "posted_hotel_bookings" ADD CONSTRAINT "fk_posted_hotel_bookings_posted_by" FOREIGN KEY("posted_by")
REFERENCES "users" ("id");

ALTER TABLE "posted_hotel_bookings" ADD CONSTRAINT "fk_posted_hotel_bookings_booking_categories_id" FOREIGN KEY("booking_categories_id")
REFERENCES "hotel_booking_categories" ("id");

ALTER TABLE "posted_hotel_media" ADD CONSTRAINT "fk_posted_hotel_media_posted_hotel_id" FOREIGN KEY("posted_hotel_id")
REFERENCES "posted_hotel_bookings" ("id");

-- ALTER TABLE "hotel_rooms" ADD CONSTRAINT "fk_hotel_rooms_posted_hotel_id" FOREIGN KEY("posted_hotel_id")
-- REFERENCES "posted_hotel_bookings" ("id");

ALTER TABLE "hotel_rooms" ADD CONSTRAINT "fk_hotel_rooms_room_types_id" FOREIGN KEY("room_types_id")
REFERENCES "room_types" ("id");

ALTER TABLE "hotel_rooms_media" ADD CONSTRAINT "fk_hotel_rooms_media_hotel_rooms_id" FOREIGN KEY("hotel_rooms_id")
REFERENCES "hotel_rooms" ("id");

ALTER TABLE "hotel_bookings" ADD CONSTRAINT "fk_hotel_bookings_hotel_rooms_id" FOREIGN KEY("hotel_rooms_id")
REFERENCES "hotel_rooms" ("id");

ALTER TABLE "hotel_bookings" ADD CONSTRAINT "fk_hotel_bookings_hotel_booking_portals_id" FOREIGN KEY("hotel_booking_portals_id")
REFERENCES "hotel_booking_portal" ("id");

ALTER TABLE "hotel_booking_reviews" ADD CONSTRAINT "fk_hotel_booking_reviews_posted_hotel_booking" FOREIGN KEY("posted_hotel_booking")
REFERENCES "posted_hotel_bookings" ("id");

ALTER TABLE "hotel_booking_reviews" ADD CONSTRAINT "fk_hotel_booking_reviews_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "posted_hotel_comments" ADD CONSTRAINT "fk_posted_hotel_comments_posted_hotel_booking" FOREIGN KEY("posted_hotel_booking")
REFERENCES "posted_hotel_bookings" ("id");

ALTER TABLE "posted_hotel_comments" ADD CONSTRAINT "fk_posted_hotel_comments_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "service_request" ADD CONSTRAINT "fk_service_request_requested_by" FOREIGN KEY("requested_by")
REFERENCES "users" ("id");

ALTER TABLE "service_request_history" ADD CONSTRAINT "fk_service_request_history_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "blog" ADD CONSTRAINT "fk_blog_blog_categories_id" FOREIGN KEY("blog_categories_id")
REFERENCES "blog_categories" ("id");

ALTER TABLE "blog" ADD CONSTRAINT "fk_blog_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "blogs_comments" ADD CONSTRAINT "fk_blogs_comments_blog_id" FOREIGN KEY("blog_id")
REFERENCES "blog" ("id");

ALTER TABLE "blogs_comments" ADD CONSTRAINT "fk_blogs_comments_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "service_reviews" ADD CONSTRAINT "fk_service_reviews_reviewer" FOREIGN KEY("reviewer")
REFERENCES "users" ("id");

ALTER TABLE "agent_reviews" ADD CONSTRAINT "fk_agent_reviews_reviewer" FOREIGN KEY("reviewer")
REFERENCES "users" ("id");

ALTER TABLE "company_reviews" ADD CONSTRAINT "fk_company_reviews_reviewer" FOREIGN KEY("reviewer")
REFERENCES "users" ("id");

-- ALTER TABLE "project_reviews" ADD CONSTRAINT "fk_project_reviews_projects_id" FOREIGN KEY("projects_id")
-- REFERENCES "projects" ("id");

ALTER TABLE "project_reviews" ADD CONSTRAINT "fk_project_reviews_reviewer" FOREIGN KEY("reviewer")
REFERENCES "users" ("id");

-- ALTER TABLE "properties_reviews" ADD CONSTRAINT "fk_properties_reviews_projects_id" FOREIGN KEY("projects_id")
-- REFERENCES "projects" ("id");

ALTER TABLE "properties_reviews" ADD CONSTRAINT "fk_properties_reviews_properties_id" FOREIGN KEY("properties_id")
REFERENCES "project_properties" ("id");

ALTER TABLE "properties_reviews" ADD CONSTRAINT "fk_properties_reviews_reviewer" FOREIGN KEY("reviewer")
REFERENCES "users" ("id");

ALTER TABLE "units_reviews" ADD CONSTRAINT "fk_units_reviews_units_id" FOREIGN KEY("units_id")
REFERENCES "units" ("id");

ALTER TABLE "units_reviews" ADD CONSTRAINT "fk_units_reviews_reviewer" FOREIGN KEY("reviewer")
REFERENCES "users" ("id");

ALTER TABLE "property_reviews" ADD CONSTRAINT "fk_property_reviews_reviewer" FOREIGN KEY("reviewer")
REFERENCES "users" ("id");

ALTER TABLE "review_comments" ADD CONSTRAINT "fk_review_comments_commented_by" FOREIGN KEY("commented_by")
REFERENCES "users" ("id");

ALTER TABLE "review_comment_reactions" ADD CONSTRAINT "fk_review_comment_reactions_comments_id" FOREIGN KEY("comments_id")
REFERENCES "review_comments" ("id");

ALTER TABLE "review_comment_reactions" ADD CONSTRAINT "fk_review_comment_reactions_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "community_guides" ADD CONSTRAINT "fk_community_guides_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "community_guides" ADD CONSTRAINT "fk_community_guides_states_id" FOREIGN KEY("states_id")
REFERENCES "states" ("id");

ALTER TABLE "community_guides" ADD CONSTRAINT "fk_community_guides_cities_id" FOREIGN KEY("cities_id")
REFERENCES "cities" ("id");

ALTER TABLE "community_guides" ADD CONSTRAINT "fk_community_guides_community_id" FOREIGN KEY("community_id")
REFERENCES "communities" ("id");

ALTER TABLE "community_guides" ADD CONSTRAINT "fk_community_guides_subcommunity_id" FOREIGN KEY("subcommunity_id")
REFERENCES "sub_communities" ("id");

ALTER TABLE "community_guides" ADD CONSTRAINT "fk_community_guides_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "community_guides_media" ADD CONSTRAINT "fk_community_guides_media_community_guides_id" FOREIGN KEY("community_guides_id")
REFERENCES "community_guides" ("id");

ALTER TABLE "community_guides_media" ADD CONSTRAINT "fk_community_guides_media_uploaded_by" FOREIGN KEY("uploaded_by")
REFERENCES "users" ("id");

ALTER TABLE "towers" ADD CONSTRAINT "fk_towers_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "towers" ADD CONSTRAINT "fk_towers_states_id" FOREIGN KEY("states_id")
REFERENCES "states" ("id");

ALTER TABLE "towers" ADD CONSTRAINT "fk_towers_cities_id" FOREIGN KEY("cities_id")
REFERENCES "cities" ("id");

ALTER TABLE "towers" ADD CONSTRAINT "fk_towers_community_id" FOREIGN KEY("community_id")
REFERENCES "communities" ("id");

ALTER TABLE "towers" ADD CONSTRAINT "fk_towers_subcommunity_id" FOREIGN KEY("subcommunity_id")
REFERENCES "sub_communities" ("id");

ALTER TABLE "towers" ADD CONSTRAINT "fk_towers_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "tower_media" ADD CONSTRAINT "fk_tower_media_towers_id" FOREIGN KEY("towers_id")
REFERENCES "towers" ("id");

ALTER TABLE "tower_media" ADD CONSTRAINT "fk_tower_media_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "product_companies" ADD CONSTRAINT "fk_product_companies_subcompany_type" FOREIGN KEY("subcompany_type")
REFERENCES "company_types" ("id");

ALTER TABLE "product_companies" ADD CONSTRAINT "fk_product_companies_companies_billing_info_id" FOREIGN KEY("companies_billing_info_id")
REFERENCES "product_companies_billing_info" ("id");

ALTER TABLE "product_companies" ADD CONSTRAINT "fk_product_companies_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "product_companies" ADD CONSTRAINT "fk_product_companies_companies_subscription_id" FOREIGN KEY("companies_subscription_id")
REFERENCES "product_companies_subscription" ("id");

ALTER TABLE "product_companies" ADD CONSTRAINT "fk_product_companies_companies_bank_account_details_id" FOREIGN KEY("companies_bank_account_details_id")
REFERENCES "product_companies_bank_details" ("id");

ALTER TABLE "product_companies" ADD CONSTRAINT "fk_product_companies_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "product_companies" ADD CONSTRAINT "fk_product_companies_country_id" FOREIGN KEY("country_id")
REFERENCES "countries" ("id");

ALTER TABLE "product_companies_branches" ADD CONSTRAINT "fk_product_companies_branches_subcompany_type" FOREIGN KEY("subcompany_type")
REFERENCES "company_types" ("id");

ALTER TABLE "product_companies_branches" ADD CONSTRAINT "fk_product_companies_branches_company_billing_info_id" FOREIGN KEY("company_billing_info_id")
REFERENCES "product_companies_billing_info" ("id");

ALTER TABLE "product_companies_branches" ADD CONSTRAINT "fk_product_companies_branches_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "product_companies_branches" ADD CONSTRAINT "fk_product_companies_branches_companies_subscription_id" FOREIGN KEY("companies_subscription_id")
REFERENCES "product_companies_subscription" ("id");

ALTER TABLE "product_companies_branches" ADD CONSTRAINT "fk_product_companies_branches_companies_bank_account_details_id" FOREIGN KEY("companies_bank_account_details_id")
REFERENCES "product_companies_bank_details" ("id");

ALTER TABLE "product_companies_branches" ADD CONSTRAINT "fk_product_companies_branches_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "product_companies_branches" ADD CONSTRAINT "fk_product_companies_branches_product_companies_id" FOREIGN KEY("product_companies_id")
REFERENCES "product_companies" ("id");

ALTER TABLE "product_companies_branches" ADD CONSTRAINT "fk_product_companies_branches_country_id" FOREIGN KEY("country_id")
REFERENCES "countries" ("id");

ALTER TABLE "product_companies_billing_info" ADD CONSTRAINT "fk_product_companies_billing_info_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "product_companies_bank_details" ADD CONSTRAINT "fk_product_companies_bank_details_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "product_companies_bank_details" ADD CONSTRAINT "fk_product_companies_bank_details_currency_id" FOREIGN KEY("currency_id")
REFERENCES "currency" ("id");

ALTER TABLE "product_company_directors" ADD CONSTRAINT "fk_product_company_directors_director_designations_id" FOREIGN KEY("director_designations_id")
REFERENCES "designations" ("id");

ALTER TABLE "product_company_directors" ADD CONSTRAINT "fk_product_company_directors_product_companies_id" FOREIGN KEY("product_companies_id")
REFERENCES "product_companies" ("id");

ALTER TABLE "product_company_branch_directors" ADD CONSTRAINT "fk_product_company_branch_directors_director_designations_id" FOREIGN KEY("director_designations_id")
REFERENCES "designations" ("id");

ALTER TABLE "product_company_branch_directors" ADD CONSTRAINT "fk_product_company_branch_directors_product_companies_branches_id" FOREIGN KEY("product_companies_branches_id")
REFERENCES "product_companies_branches" ("id");

ALTER TABLE "product_companies_reviews" ADD CONSTRAINT "fk_product_companies_reviews_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "product_companies_reviews" ADD CONSTRAINT "fk_product_companies_reviews_product_companies_id" FOREIGN KEY("product_companies_id")
REFERENCES "product_companies" ("id");

ALTER TABLE "product_companies_reviews" ADD CONSTRAINT "fk_product_companies_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "product_companies_branches_reviews" ADD CONSTRAINT "fk_product_companies_branches_reviews_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "product_companies_branches_reviews" ADD CONSTRAINT "fk_product_companies_branches_reviews_product_companies_branches_id" FOREIGN KEY("product_companies_branches_id")
REFERENCES "product_companies_branches" ("id");

ALTER TABLE "product_companies_branches_reviews" ADD CONSTRAINT "fk_product_companies_branches_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "product_companies_directors_reviews" ADD CONSTRAINT "fk_product_companies_directors_reviews_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "product_companies_directors_reviews" ADD CONSTRAINT "fk_product_companies_directors_reviews_product_company_directors_id" FOREIGN KEY("product_company_directors_id")
REFERENCES "product_company_directors" ("id");

ALTER TABLE "product_companies_directors_reviews" ADD CONSTRAINT "fk_product_companies_directors_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "product_companies_branch_directors_reviews" ADD CONSTRAINT "fk_product_companies_branch_directors_reviews_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "product_companies_branch_directors_reviews" ADD CONSTRAINT "fk_product_companies_branch_directors_reviews_product_company_branch_directors_id" FOREIGN KEY("product_company_branch_directors_id")
REFERENCES "product_company_branch_directors" ("id");

ALTER TABLE "product_companies_branch_directors_reviews" ADD CONSTRAINT "fk_product_companies_branch_directors_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "tax_management" ADD CONSTRAINT "fk_tax_management_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "tax_management" ADD CONSTRAINT "fk_tax_management_states_id" FOREIGN KEY("states_id")
REFERENCES "states" ("id");

ALTER TABLE "tax_management" ADD CONSTRAINT "fk_tax_management_tax_category_id" FOREIGN KEY("tax_category_id")
REFERENCES "tax_category" ("id");

ALTER TABLE "tax_management" ADD CONSTRAINT "fk_tax_management_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "banner_sections" ADD CONSTRAINT "fk_banner_sections_parent_banner_section" FOREIGN KEY("parent_banner_section")
REFERENCES "banner_sections" ("id");

ALTER TABLE "banner_sections" ADD CONSTRAINT "fk_banner_sections_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "banners" ADD CONSTRAINT "fk_banners_banner_sections_id" FOREIGN KEY("banner_sections_id")
REFERENCES "banner_sections" ("id");

ALTER TABLE "banners" ADD CONSTRAINT "fk_banners_banner_types_id" FOREIGN KEY("banner_types_id")
REFERENCES "banner_types" ("id");

ALTER TABLE "banners" ADD CONSTRAINT "fk_banners_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "company_videos" ADD CONSTRAINT "fk_company_videos_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "project_videos" ADD CONSTRAINT "fk_project_videos_project_id" FOREIGN KEY("project_id")
REFERENCES "projects" ("id");

ALTER TABLE "project_videos" ADD CONSTRAINT "fk_project_videos_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "properties_videos" ADD CONSTRAINT "fk_properties_videos_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "map_searches" ADD CONSTRAINT "fk_map_searches_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "units" ADD CONSTRAINT "fk_units_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "unit_payment_plans" ADD CONSTRAINT "fk_unit_payment_plans_unit_id" FOREIGN KEY("unit_id")
REFERENCES "units" ("id");

ALTER TABLE "sale_unit" ADD CONSTRAINT "fk_sale_unit_unit_id" FOREIGN KEY("unit_id")
REFERENCES "units" ("id");

ALTER TABLE "rent_unit" ADD CONSTRAINT "fk_rent_unit_unit_id" FOREIGN KEY("unit_id")
REFERENCES "units" ("id");

ALTER TABLE "units_status_history" ADD CONSTRAINT "fk_units_status_history_units_id" FOREIGN KEY("units_id")
REFERENCES "units" ("id");

-- ALTER TABLE "unit_media" ADD CONSTRAINT "fk_unit_media_units_id" FOREIGN KEY("units_id")
-- REFERENCES "units" ("id");

ALTER TABLE "unit_plans" ADD CONSTRAINT "fk_unit_plans_units_id" FOREIGN KEY("units_id")
REFERENCES "units" ("id");

ALTER TABLE "units_documents" ADD CONSTRAINT "fk_units_documents_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "units_documents" ADD CONSTRAINT "fk_units_documents_documents_subcategory_id" FOREIGN KEY("documents_subcategory_id")
REFERENCES "documents_subcategory" ("id");

ALTER TABLE "units_documents" ADD CONSTRAINT "fk_units_documents_units_id" FOREIGN KEY("units_id")
REFERENCES "units" ("id");

ALTER TABLE "openhouse" ADD CONSTRAINT "fk_openhouse_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "openhouse" ADD CONSTRAINT "fk_openhouse_project_properties_id" FOREIGN KEY("project_properties_id")
REFERENCES "project_properties" ("id");

ALTER TABLE "timeslots" ADD CONSTRAINT "fk_timeslots_openhouse_id" FOREIGN KEY("openhouse_id")
REFERENCES "openhouse" ("id");

ALTER TABLE "appointment" ADD CONSTRAINT "fk_appointment_openhouse_id" FOREIGN KEY("openhouse_id")
REFERENCES "openhouse" ("id");

ALTER TABLE "appointment" ADD CONSTRAINT "fk_appointment_timeslots_id" FOREIGN KEY("timeslots_id")
REFERENCES "timeslots" ("id");

ALTER TABLE "appointment" ADD CONSTRAINT "fk_appointment_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "newsletter_subscribers" ADD CONSTRAINT "fk_newsletter_subscribers_subscriber" FOREIGN KEY("subscriber")
REFERENCES "users" ("id");

ALTER TABLE "advertisements" ADD CONSTRAINT "fk_advertisements_pages_id" FOREIGN KEY("pages_id")
REFERENCES "pages" ("id");

ALTER TABLE "activities" ADD CONSTRAINT "fk_activities_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "project_activities" ADD CONSTRAINT "fk_project_activities_activities_id" FOREIGN KEY("activities_id")
REFERENCES "activities" ("id");

ALTER TABLE "image_categories" ADD CONSTRAINT "fk_image_categories_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "international_content" ADD CONSTRAINT "fk_international_content_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "dropdown_items" ADD CONSTRAINT "fk_dropdown_items_category_id" FOREIGN KEY("category_id")
REFERENCES "dropdown_categories" ("id");

ALTER TABLE "dropdown_items" ADD CONSTRAINT "fk_dropdown_items_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

CREATE INDEX "idx_timeslots_openhouse_id"
ON "timeslots" ("openhouse_id");

CREATE INDEX "idx_appointment_client_id"
ON "appointment" ("client_id");

-- ! PLEASE DO NOT  DELETE THIS 
CREATE MATERIALIZED VIEW autocomplete_view AS
SELECT 
    sub_community AS name,
    'sub_community' AS type
FROM sub_communities
UNION ALL
SELECT 
    community,
    'community'
FROM communities
UNION ALL
SELECT 
    city,
    'city'
FROM cities
UNION ALL
SELECT 
    state,
    'state'
FROM states
UNION ALL
SELECT 
    country,
    'country'
FROM countries;

CREATE MATERIALIZED VIEW section_permission_mv AS
SELECT * FROM section_permission;

CREATE MATERIALIZED VIEW permissions_mv AS
SELECT * FROM permissions;

CREATE MATERIALIZED VIEW sub_section_mv AS
SELECT * FROM sub_section;


CREATE TABLE "project_property_units" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- main category
    "unit_category_id" bigint   NOT NULL,
    -- Unit Categories
    "is_branch" bool   NOT NULL,
    "project_id" bigint   NOT NULL,
    "phase_id" bigint   NULL,
    "properties_id" bigint   NULL,
    "is_verified" bool   NOT NULL,
    "property_unit_rank" bigint   NOT NULL,
    "broker_company_agents_id" bigint   NULL,
    "sale_title" varchar   NULL,
    "sale_title_ar" varchar   NULL,
    "rent_title" varchar   NULL,
    "rent_title_ar" varchar   NULL,
    "booking_title" varchar   NULL,
    "booking_title_ar" varchar   NULL,
    "description" varchar   NOT NULL,
    "description_ar" varchar   NULL,
    "notes" varchar   NOT NULL,
    "notes_ar" varchar   NULL,
    "notes_public" bool   NOT NULL,
    "countries_id" bigint   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "property_types_id" bigint   NOT NULL,
    "property_type_name" varchar   NOT NULL,
    "unit_no" varchar   NULL,
    "unitno_is_public" bool  DEFAULT false NOT NULL,
    "amenities_id" bigint[]   NOT NULL,
    "facilities_id" bigint[]   NOT NULL,
    "available_for" bigint[]   NULL,
    -- Added For
    -- For Sale
    "completion_status" bigint   NULL,
    "service_charge" float  DEFAULT 0 NOT NULL,
    "investment" bool   NULL,
    "contract_start_date" timestamptz   NULL,
    "contract_end_date" timestamptz   NULL,
    -- For Rent
    "rent_type" bigint   NULL,
    -- Rent Types
    "no_of_payments" bigint   NULL,
    "is_request_video" bool   NULL,
    "from_xml" bool   NOT NULL,
    "users_id" bigint   NOT NULL,
    "owners_user_id" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    "status" bigint   NOT NULL,
    "tags_id" bigint[]   NOT NULL
 
);

 
CREATE TABLE "subscription" (
    "id" bigserial   NOT NULL,
    "subscription_duration" varchar(255)   NOT NULL,
    "start_date" timestamptz   NULL,
    "end_date" timestamptz   NULL,
    "standard_units" bigint   NOT NULL,
    "standard_units_price" float   NOT NULL,
    "standard_units_actual_price" float   NOT NULL,
    "standard_discount" varchar(255)   NOT NULL,
    "standard_units_price_after_discount" float   NOT NULL,
    "featured_units" bigint   NOT NULL,
    "featured_units_price" float   NOT NULL,
    "featured_units_actual_price" float   NOT NULL,
    "featured_discount" varchar(255)   NOT NULL,
    "featured_units_price_after_discount" float   NOT NULL,
    "premium_units" bigint   NOT NULL,
    "premium_units_price" float   NOT NULL,
    "premium_units_actual_price" float   NOT NULL,
    "premium_discount" varchar(255)   NOT NULL,
    "premium_units_price_after_discount" float   NOT NULL,
    "topdeal_units" bigint   NOT NULL,
    "topdeal_unit_price" float   NOT NULL,
    "topdeal_unit_actual_price" float   NOT NULL,
    "topdeal_discount" varchar(255)   NOT NULL,
    "topdeal_units_price_after_discount" float   NOT NULL,
    "status" bigint   NOT NULL,
    "total_price" varchar  DEFAULT 0 NOT NULL,
    "total_unit" bigint  DEFAULT 0 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "subscription_mode" bigint  DEFAULT 1 NOT NULL,
    "company_type" bigint  DEFAULT 1 NOT NULL,
    "company_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "order_no" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    -- added by creenx 2024-05-10 1644
    -- initial value will be same as the total_unit
    "remaining_units" bigint   NOT NULL,
    CONSTRAINT "pk_subscription" PRIMARY KEY (
        "id"
     )
);




CREATE TABLE "companies_reviews" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "customer_service" int   NOT NULL,
    "staff_courstesy" int   NOT NULL,
    "implementation" int   NOT NULL,
    "properties_quality" int   NOT NULL,
    "description" varchar   NOT NULL,
    "reviewer" bigint   NOT NULL,
    "review_date" timestamptz  DEFAULT now() NOT NULL,
    "proof_images" varchar[]   NULL,
    "title" varchar   NULL,
    CONSTRAINT "pk_companies_reviews" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_companies_reviews_ref_no" UNIQUE (
        "ref_no"
    )
);




CREATE TABLE "quality_score_policies" (
    "id" bigserial   NOT NULL,
    "policy_name" varchar   NOT NULL,
    "policy_type" varchar   NOT NULL,
    "parameter_name" varchar   NOT NULL,
    "parameter_value" varchar   NOT NULL,
    CONSTRAINT "pk_policies" PRIMARY KEY (
        "id"
     )
);
-- default data
INSERT INTO quality_score_policies(policy_name, policy_type, parameter_name, parameter_value) VALUES
('title', 'char', 'min', '40'),
('title', 'char', 'max', '60'),
('description', 'char', 'min', '750'),
('description', 'char', 'max', '2000'),
('address', 'field', 'required', 'country,state,city,community'),
('media', 'file', 'min', '5'),
('media', 'file', 'max', '30');




CREATE TABLE "companies" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_name" varchar   NOT NULL,
    "tag_line" varchar   NULL,
    "description" varchar   NULL,
    "logo_url" varchar   NOT NULL,
    "email" varchar   NULL,
    "phone_number" varchar   NULL,
    "whatsapp_number" varchar   NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "website_url" varchar   NULL,
    "cover_image_url" varchar   NULL,
    "no_of_employees" bigint   NULL,
    "company_rank" bigint  DEFAULT 1 NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "facebook_profile_url" varchar   NULL,
    "instagram_profile_url" varchar   NULL,
    "twitter_profile_url" varchar   NULL,
    "linkedin_profile_url" varchar   NULL,
    "youtube_profile_url" varchar   NULL,
    "other_social_media" varchar[]   NULL,
    -- 1 => broker_companies, 2 => developer_companies & 3 => services_companies
    "company_type" bigint   NOT NULL,
    "companies_licenses_id" bigint   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    -- admin of the company
    "users_id" bigint   NOT NULL,
    "country_id" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
    "bank_account_details_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_companies" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_companies_ref_no" UNIQUE (
        "ref_no"
    ),
    CONSTRAINT "uc_companies_company_name" UNIQUE (
        "company_name"
    )
);

CREATE TABLE "companies_licenses" (
    "id" bigserial   NOT NULL,
    "commercial_license_no" varchar   NOT NULL,
    "commercial_license_file_url" varchar   NOT NULL,
    "commercial_license_issue_date" timestamptz   NULL,
    "commercial_license_expiry" timestamptz   NOT NULL,
    -- when the commercial license registered for the first time
    "commercial_license_registration_date" timestamptz   NULL,
    "rera_no" varchar   NULL,
    "rera_file_url" varchar   NULL,
    "rera_issue_date" timestamptz   NULL,
    "rera_expiry" timestamptz   NULL,
    -- when the rera registered for the first time
    "rera_registration_date" timestamptz   NULL,
    "vat_no" varchar   NULL,
    "vat_status" bigint   NULL,
    "vat_file_url" varchar   NULL,
    "extra_license_names" varchar[]   NULL,
    "extra_license_files" varchar[]   NULL,
    "extra_license_nos" varchar[]   NULL,
    "extra_license_issue_date" timestamptz[]   NULL,
    "extra_license_expiry_date" timestamptz[]   NULL,
    "orn_license_no" varchar   NULL,
    "orn_license_file_url" varchar   NULL,
    "orn_registration_date" timestamptz   NULL,
    "orn_license_expiry" timestamptz   NULL,
    -- only for dubai
    "trakhees_permit_no" varchar   NULL,
    -- only for dubai
    "license_dcci_no" varchar   NULL,
    -- only for dubai
    "register_no" varchar   NULL,
    CONSTRAINT "pk_companies_licenses" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_companies_licenses_commercial_license_no" UNIQUE (
        "commercial_license_no"
    ),
    CONSTRAINT "uc_companies_licenses_rera_no" UNIQUE (
        "rera_no"
    )
);

CREATE TABLE "branch_companies" (
    "id" bigserial   NOT NULL,
    "parent_companies_id" bigint   NOT NULL,
    "companies_id" bigint   NOT NULL,
    CONSTRAINT "pk_branch_companies" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "companies_services" (
    "id" bigserial   NOT NULL,
    "companies_id" bigint   NOT NULL,
    "services_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_companies_services" PRIMARY KEY (
        "id"
     )
);




CREATE TABLE "companies_leadership" (
    "id" bigserial   NOT NULL,
    "name" varchar   NOT NULL,
    "position" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "image_url" varchar   NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "companies_id" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_companies_leadership" PRIMARY KEY (
        "id"
     )
);



 

CREATE TABLE "company_rejects" (
    "id" bigserial   NOT NULL,
    "reason" text   NOT NULL,
    -- 1,2,3 => broker, developer, service companies
    "company_type" bigint   NOT NULL,
    "company_id" bigint   NOT NULL,
    "is_branch" bool   NOT NULL,
    "rejected_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_company_rejects" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_companies_licenses_id" FOREIGN KEY("companies_licenses_id")
REFERENCES "companies_licenses" ("id");

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_country_id" FOREIGN KEY("country_id")
REFERENCES "countries" ("id");

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_bank_account_details_id" FOREIGN KEY("bank_account_details_id")
REFERENCES "bank_account_details" ("id");

ALTER TABLE "branch_companies" ADD CONSTRAINT "fk_branch_companies_parent_companies_id" FOREIGN KEY("parent_companies_id")
REFERENCES "companies" ("id");

ALTER TABLE "branch_companies" ADD CONSTRAINT "fk_branch_companies_companies_id" FOREIGN KEY("companies_id")
REFERENCES "companies" ("id");

ALTER TABLE "companies_services" ADD CONSTRAINT "fk_companies_services_companies_id" FOREIGN KEY("companies_id")
REFERENCES "companies" ("id");

ALTER TABLE "companies_services" ADD CONSTRAINT "fk_companies_services_services_id" FOREIGN KEY("services_id")
REFERENCES "services" ("id");


COMMENT ON TABLE companies IS 'table for company information';
COMMENT ON COLUMN companies.company_rank IS 'rank of the company i.e. standard,featured, premium,top deal etc.';
COMMENT ON COLUMN companies.users_id IS 'admin user of the company';
COMMENT ON COLUMN companies.company_type IS 'describe type of a company, 1 for broker companies,2 for developer companies & 3 for services companies';

COMMENT ON TABLE companies_licenses IS 'table for all types of licenses for company';
COMMENT ON COLUMN companies_licenses.commercial_license_registration_date IS 'when the commercial license registered for the first time';
COMMENT ON COLUMN companies_licenses.rera_no IS 'only for company type 1 (broker companies)';
COMMENT ON COLUMN companies_licenses.rera_file_url IS 'only for company type 1 (broker companies)';
COMMENT ON COLUMN companies_licenses.rera_expiry IS 'only for company type 1 (broker companies)';
COMMENT ON COLUMN companies_licenses.rera_issue_date IS 'only for company type 1 (broker companies)';
COMMENT ON COLUMN companies_licenses.rera_registration_date IS 'only for company type 1 (broker companies), when the rera registered for the first time';
COMMENT ON COLUMN companies_licenses.trakhees_permit_no IS 'only for company type 1 (broker companies) for only dubai city in UAE';
COMMENT ON COLUMN companies_licenses.license_dcci_no IS 'only for company type 1 (broker companies) for only dubai city in UAE';
COMMENT ON COLUMN companies_licenses.register_no IS 'only for company type 1 (broker companies) for only dubai city in UAE';

COMMENT ON TABLE branch_companies IS 'table for branch companies instances, link with parent company & define type of a company';
COMMENT ON COLUMN branch_companies.parent_companies_id IS 'link with parent company,point to companies table';
COMMENT ON COLUMN branch_companies.companies_id IS 'point to a company table';

COMMENT ON TABLE companies_services IS 'assign services to company';

ALTER TABLE "company_rejects" ADD CONSTRAINT "fk_company_rejects_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");

ALTER TABLE "company_rejects" ADD CONSTRAINT "fk_company_rejects_rejected_by" FOREIGN KEY("rejected_by")
REFERENCES "users" ("id");


ALTER TABLE "companies_reviews" ADD CONSTRAINT "fk_companies_reviews_companies_id" FOREIGN KEY("companies_id")
REFERENCES "companies" ("id");

ALTER TABLE "companies_reviews" ADD CONSTRAINT "fk_companies_reviews_reviewer" FOREIGN KEY("reviewer")
REFERENCES "users" ("id");



ALTER TABLE "companies_leadership" ADD CONSTRAINT "fk_companies_leadership_companies_id" FOREIGN KEY("companies_id")
REFERENCES "companies" ("id");

ALTER TABLE "companies_leadership" ADD CONSTRAINT "fk_companies_leadership_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");


CREATE TABLE "skills" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "title_ar" varchar   NULL,
    CONSTRAINT "pk_skills" PRIMARY KEY (
        "id"
     )
);