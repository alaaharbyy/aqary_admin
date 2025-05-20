-- -- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- -- Link to schema: https://app.quickdatabasediagrams.com/#/d/D5efbj
-- -- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

CREATE TABLE "facts" (
    	"id" bigserial   NOT NULL,
	"title" varchar     NOT NULL,
	"icon_url" varchar     NOT NULL,
    "title_ar" varchar NOT NULL,
       CONSTRAINT "pk_facts" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "sub_communities" (
    "id" bigserial   NOT NULL,
    "sub_community" varchar(255)   NOT NULL,
    "communities_id" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "lng" float   NULL,
    "lat" float   NULL,
    "status" bigint NOT NULL,
    "deleted_at" timestamptz NULL,
    "updated_by" bigint NOT NULL,
    "sub_community_ar" varchar NULL,
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
    "status" bigint NOT NULL,
    "deleted_at" timestamptz NULL,
    "updated_by" bigint NOT NULL,
    "community_ar" varchar NULL,
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
    "status" bigint NOT NULL,
    "deleted_at" timestamptz NULL,
    "updated_by" bigint NOT NULL,
    "city_ar" varchar NULL,
    "cover_image" TEXT NULL,
    "description" TEXT NULL,
    CONSTRAINT "pk_cities" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "states" (
    "id" bigserial   NOT NULL,
    "state" varchar(255)   NOT NULL,
    "countries_id" bigint   NULL,
    "is_capital" BOOLEAN DEFAULT FALSE,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "lat" float   NULL,
    "lng" float   NULL,
    "status" bigint NOT NULL,
    "deleted_at" timestamptz NULL,
    "updated_by" bigint NOT NULL,
    "state_ar" varchar NULL,
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
    "name" varchar NOT NULL,
    "numcode" bigint NULL,
    "default_settings" jsonb NULL,
    "status" bigint NOT NULL,
    "deleted_at" timestamptz NULL,
    "updated_by" bigint NOT NULL,
    "country_ar" varchar NULL,
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
    "property_map_location_id" bigint NULL,
    "full_address" varchar NULL,
    "full_address_ar" varchar NULL,
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

-- CREATE TABLE "facilities" (
--     "id" bigserial   NOT NULL,
--     "icon_url" varchar(255)   NULL,
--     "title" varchar(255)   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     "category_id" bigint   NOT NULL,
--     CONSTRAINT "pk_facilities" PRIMARY KEY (
--         "id"
--      )
-- );

-- CREATE TABLE "amenities" (
--     "id" bigserial   NOT NULL,
--     "icon_url" varchar(255)   NULL,
--     "title" varchar(255)   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     "category_id" bigint   NOT NULL,
--     CONSTRAINT "pk_amenities" PRIMARY KEY (
--         "id"
--      )
-- );

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
    "currency_rate" float8 NOT NULL,
    "status" bigint NOT NULL,
    "deleted_at" timestamptz NULL,
    "updated_by" bigint NOT NULL,
    CONSTRAINT "pk_currency" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_currency_currency" UNIQUE (
        "currency"
    ),
    CONSTRAINT "uc_currency_code" UNIQUE (
        "code"
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
    "bank_branch" varchar   NOT NULL,
    "swift_code" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    -- fk - users.id
    "updated_by" bigint   NULL,
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
    "status" bigint NOT NULL,
    "icon"  varchar NULL, 
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "title_ar" varchar NULL,
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
    "developer_companies_id" bigint   NOT NULL,  -- > new company table 
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
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NULL,
    "rating" float  DEFAULT 0.0 NOT NULL,
    "polygon_coords" jsonb   NOT NULL,
    "facts" jsonb NOT NULL,
    "exclusive" boolean NOT NULL DEFAULT false,
    "start_date" DATE NULL,
    "end_date" DATE NULL,
    "slug" varchar(255) NOT NULL,
    "deleted_at" timestamptz NULL,
    "bank_name" VARCHAR NULL,
    "registration_date" DATE NULL,
    "escrow_number" VARCHAR NULL,
    "refreshed_at"timestamptz NULL,
    CONSTRAINT "pk_projects" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_projects_ref_number" UNIQUE (
        "ref_number"
    )
);

CREATE TABLE "project_media" (
    "id" bigserial   NOT NULL,
    "file_urls" varchar[]   NOT NULL,
    "gallery_type" varchar   NOT NULL,
    "media_type" bigint   NOT NULL,
    "projects_id" bigint   NULL,
    "phases_id" bigint   NULL,
    "project_properties_id" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_project_media" PRIMARY KEY (
        "id"
     )
);

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
    "category_ar" varchar NULL,
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
    "sub_category_ar" varchar NULL,
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
    "rating" float  DEFAULT 0.0 NOT NULL,
    "description" varchar   NOT NULL,
    "description_ar" varchar   NULL,
    "polygon_coords" jsonb   NOT NULL,
    "facts" jsonb NOT NULL,
    "exclusive" boolean NOT NULL DEFAULT false,
    "start_date" DATE NULL,
    "end_date" DATE NULL,
    "bank_name" VARCHAR NOT NULL,
    "registration_date" DATE NOT NULL,
    "escrow_number" VARCHAR NOT NULL,
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
    "owner_users_id" bigint  NULL,
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

CREATE TABLE "unit_type_detail" (
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

-- new changes
CREATE TABLE "profiles" (
    "id" bigserial   NOT NULL,
    "first_name" varchar   NOT NULL,
    "last_name" varchar   NOT NULL,
    -- email varchar unique
    "addresses_id" bigint   NOT NULL,
    "profile_image_url" varchar   NULL,
    "secondary_number" varchar   NULL,
    "whatsapp_number" varchar   NULL,
    "show_whatsapp_number" bool   NULL,
    "botim_number" varchar   NULL,
    "show_botim_number" bool   NULL,
    "tawasal_number" varchar   NULL,
    "show_tawasal_number" bool   NULL,
    -- better using enum
    "gender" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "ref_no" varchar   NOT NULL,
    "cover_image_url" varchar   NULL,
    -- noc_no varchar
    -- noc_image_url varchar
    -- noc_expiry_date timestamptz
    -- added by Reyan 4-Sep-2024
    "passport_no" varchar   NULL,
    -- added by Reyan 4-Sep-2024
    "passport_image_url" varchar   NULL,
    "passport_expiry_date" timestamptz NULL,
     "about" varchar   NULL,
    "about_arabic" varchar   NULL,
    "users_id" bigint NOT NULL,
    "telegram_number" varchar NULL,
    CONSTRAINT "pk_profiles" PRIMARY KEY (
        "id"
    )
);

-- CREATE TABLE "roles" (
--     "id" bigserial   NOT NULL,
--     "role" varchar(255)   NOT NULL,
--     -- code varchar(255)
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     CONSTRAINT "pk_roles" PRIMARY KEY (
--         "id"
--      )
-- );

CREATE TABLE "user_types" (
    "id" bigserial   NOT NULL,
    "user_type" varchar(255)   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "user_type_ar" varchar NULL,
    CONSTRAINT "pk_user_types" PRIMARY KEY (
        "id"
     )
);



CREATE TABLE "users" (
    "id" bigserial   NOT NULL,
    -- saif -should have another email in profile 26/09/2024
    "email" varchar   NOT NULL,
    "username" varchar   NOT NULL,
    "password" varchar   NOT NULL,
    "status" bigint   NOT NULL,
    -- FK >- roles.id
    "roles_id" bigint   NULL,
    "user_types_id" bigint   NOT NULL,
    "social_login" varchar   NULL,
    -- added by Reyan 5-Sep-2024
    "show_hide_details" bool  DEFAULT false NOT NULL,
    -- prefers_language varchar default=US-EN
    "experience_since" timestamptz   NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "phone_number" varchar NULL, -- must be unique from code side, if there is phone number
    "is_phone_verified" bool DEFAULT false NOT NULL,
    "is_email_verified" bool DEFAULT false NOT NULL,
    "active_company" bigint NULL,
    "country_code" bigint NULL,
    "profile_views" bigint DEFAULT 0 NOT NULL,
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




-- CREATE TABLE "department" (
--     "id" bigserial   NOT NULL,
--     "title" varchar(255)   NOT NULL,
--     "status" bigint  DEFAULT 1 NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     CONSTRAINT "pk_department" PRIMARY KEY (
--         "id"
--      )
-- );


-- CREATE TABLE "company_types" (
--     "id" bigserial   NOT NULL,
--     -- main_company_type_id bigint
--     "title" varchar   NOT NULL,
--     "description" varchar   NULL,
--     "icon_url" varchar   NULL,
--     "image_url" varchar   NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     CONSTRAINT "pk_company_types" PRIMARY KEY (
--         "id"
--      ),
--     CONSTRAINT "uc_company_types_title" UNIQUE (
--         "title"
--     )
-- );

CREATE TABLE "company_types" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    -- Title -->
    "image_url" varchar   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "title_ar" varchar NULL,
    CONSTRAINT "pk_company_types" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_types_title" UNIQUE (
        "title"
    )
);

-- default data -- don't remove
INSERT INTO company_types(
    title
)VALUES('Broker Company'),('Developer Company'),('Services Company'),('Product Company');


CREATE TABLE "company_activities" (
    "id" bigserial   NOT NULL, 
    "company_category_id" bigint   NOT NULL,
    "activity_name" varchar   NOT NULL,
    "icon_url" varchar   NULL,
    -- FK >-  tags.id
    "tags" varchar[]   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- fk - users.id
    "updated_by" bigint   NULL,
    "description" varchar   NULL,
    "description_ar" varchar   NULL,
    "status" bigint DEFAULT 2 NOT NULL,
    "activity_name_ar" varchar NULL,
    CONSTRAINT "pk_company_activities" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_activities_company_category_id_activity_name" UNIQUE (
        "company_category_id","activity_name"
    )
);

CREATE TABLE "services" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_id" bigint   NOT NULL,
    "company_activities_id" bigint   NOT NULL,
    "service_name" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_ar" varchar   NOT NULL,
    "price" float   NOT NULL,
    "tag_id" bigint[]   NOT NULL,
    "service_rank" int   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    "slug" varchar(255) NOT NULL,
    "service_name_ar" varchar NULL,
    CONSTRAINT "pk_services" PRIMARY KEY (
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
    "category_title_ar" varchar NULL,
    "description_ar" varchar NULL,
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
    "refresh_token" text   NOT NULL,
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
    "contact_email" varchar NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "last_update" timestamptz NULL,
    "last_report" varchar NULL,
    CONSTRAINT "pk_xml_url" PRIMARY KEY (
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



-- CREATE TABLE "facilities_amenities_categories" (
--     "id" bigserial   NOT NULL,
--     "category" varchar   NOT NULL,
--     "status" bigint   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     CONSTRAINT "pk_facilities_amenities_categories" PRIMARY KEY (
--         "id"
--      )
-- );

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

-- CREATE TABLE "company_users" (
--     "id" bigserial   NOT NULL,
--     -- get type
--     "users_id" bigint   NOT NULL,
--     "company_id" bigint   NOT NULL,
--     "company_department" bigint  NOT NULL,
--     "company_roles" bigint   NOT NULL,
--     "user_rank" bigint   NOT NULL,
--     -- status bigint
--     "is_verified" bool   NOT NULL,
--     -- profiles_id bigint FK >- profiles.id
--     "created_by" bigint   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     CONSTRAINT "pk_company_users" PRIMARY KEY (
--         "id"
--      )
-- );
CREATE TABLE "company_users" (
    "id" bigserial   NOT NULL,
    -- get type
    "users_id" bigint   NOT NULL,
    "company_id" bigint   NOT NULL,
    "company_department" bigint  NULL,
    "company_roles" bigint   NULL,
    "user_rank" bigint   NOT NULL,
    "leader_id" bigint NULL,
    -- status bigint
    "is_verified" bool   NOT NULL,
    -- profiles_id bigint FK >- profiles.id
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "active_listings" BIGINT DEFAULT 0,
    CONSTRAINT "pk_company_users" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "company_users" ADD CONSTRAINT "fk_company_users_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "company_users" ADD CONSTRAINT "fk_company_users_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");

ALTER TABLE "company_users" ADD CONSTRAINT "fk_company_users_company_department" FOREIGN KEY("company_department")
REFERENCES "department" ("id");

ALTER TABLE "company_users" ADD CONSTRAINT "fk_company_users_company_roles" FOREIGN KEY("company_roles")
REFERENCES "roles" ("id");

ALTER TABLE "company_users" ADD CONSTRAINT "fk_company_users_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");




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
    -- "users_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    -- Static Value 1 - Company, 2 - Individual
    -- "contact_category_id" bigint   NOT NULL,
    -- which_company bigint
    -- static values Mr. ---
    "salutation" varchar   NOT NULL,
    "firstname" varchar   NOT NULL,
    "lastname" varchar   NOT NULL,
    -- it can be multiple
    -- "all_languages_id" bigint[]   NOT NULL,
    -- "ejari" varchar   NOT NULL,
    -- "assigned_to" bigint[]   NOT NULL,
    -- "shared_with" bigint[]   NOT NULL,
    -- "remarks" varchar   NOT NULL,
    -- "is_blockedlisted" boolean   NOT NULL,
    -- "is_vip" boolean   NOT NULL,
    -- "correspondence" varchar   NOT NULL,
    -- "direct_markerting" int[]   NOT NULL,
    "status" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
    -- "contact_platform" bigint[]   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_by" bigint   NULL,
    "entity_id" bigint NOT NULL,
    "entity_type_id" bigint NOT NULL,
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
    "activity" varchar   NOT NULL,
    "activity_date" timestamptz   NOT NULL,
    "user_id" bigint   NOT NULL,
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
    "companies_id" bigint   NOT NULL,
    "requested_by" bigint   NOT NULL,
    "request_date" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NULL,
    "remarks" varchar   NOT NULL,
    -- Requested - Accepted - Rejected - Blocked
    "connection_status_id" bigint   NOT NULL,
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
    "type_name_ar" varchar NULL,
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

-- CREATE TABLE "careers" (
--     "id" bigserial   NOT NULL,
--     "ref_no" varchar   NOT NULL,
--     "job_title" varchar   NOT NULL,
--     "job_title_ar" varchar   NULL,
--     "employment_types" bigint[]   NOT NULL,
--     "job_categories" bigint   NOT NULL,
--     "career_level" bigint   NOT NULL,
--     -- company_type bigint NULL
--     -- companies_id bigint NULL
--     -- is_branch bool NULL
--     "countries_id" bigint   NOT NULL,
--     "city_id" bigint   NULL,
--     "state_id" bigint   NULL,
--     "community_id" bigint   NULL,
--     "subcommunity_id" bigint   NULL,
--     "is_urgent" boolean   NOT NULL,
--     "job_description" varchar   NOT NULL,
--     "vacancies" bigint   NOT NULL,
--     "years_of_experience" bigint   NOT NULL,
--     "gender" bigint   NOT NULL,
--     "nationality_id" bigint[]   NOT NULL,
--     "min_salary" float   NOT NULL,
--     "max_salary" float   NOT NULL,
--     "uploaded_by" bigint   NOT NULL,
--     "date_posted" timestamptz   NOT NULL,
--     "date_expired" timestamptz   NOT NULL,
--     "career_status" bigint   NOT NULL,
--     "education_level" bigint[]   NOT NULL,
--     "job_image" varchar   NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     -- the company which is not registered in aqary system
--     -- company_name varchar NULL
--     "languages" bigint[]   NULL,
--     -- added by creenx 2024-03-27 1330H
--     "employers_id" bigint   NOT NULL,
--     "benefits" bigint[]   NULL,
--     -- added by creenx 2024-04-02 1056H
--     -- atleast 1 specialization
--     "specialization" bigint[]   NOT NULL,
--     -- added by majd 2024-07-13 0301H
--     -- at least 1 skill
--     "skills" bigint[]   NULL,
--     -- added by creenx 2024-04-25 1128H - tagging
--     -- FK >- global_tagging.id
--     "global_tagging_id" bigint[]   NOT NULL,
--     -- added by creenx 2024-04-30 1510H
--     -- "field_of_studies" varchar[] NULL,
--      "field_of_studies" bigint[]   NULL,
--     "job_description_ar" varchar NULL,
--     CONSTRAINT "pk_careers" PRIMARY KEY (
--         "id"
--      ),
--     CONSTRAINT "uc_careers_ref_no" UNIQUE (
--         "ref_no"
--     )
-- );

-- CREATE TABLE "benefits" (
--     "id" bigserial   NOT NULL,
--     "title" varchar   NOT NULL,
--     "title_ar" varchar   NULL,
--     "icon_url" varchar   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz   NULL,
--     "is_default" bool NULL,
--     -- added by creenx 2024-03-29 1012H
--     "employer_id" bigint NULL,
--     -- added by creenx 2024-04-02 1431H
--     "status" bigint DEFAULT 1 NOT NULL,
--     CONSTRAINT "pk_benefits" PRIMARY KEY (
--         "id"
--      )
-- );

-- CREATE TABLE "employers" (
--     "id" bigserial   NOT NULL,
--     "ref_no" varchar   NOT NULL,
--     "company_type" bigint   NULL,
--     "company_id" bigint   NULL,
--     "is_branch" bool   NULL,
--     "company_name" varchar   NOT NULL,
--     -- null if the company is registered on system
--     "industry_id" bigint   NULL,
--     "company_size" bigint   NOT NULL,
--     "license_number" varchar   NULL,
--     "website" varchar   NULL,
--     "email_address" varchar   NOT NULL,
--     "mobile_number" varchar   NOT NULL,
--     "is_verified" bool   NOT NULL,
--     "countries_id" bigint   NOT NULL,
--     "states_id" bigint   NOT NULL,
--     "cities_id" bigint   NOT NULL,
--     "community_id" bigint   NOT NULL,
--     "subcommunity_id" bigint   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "users_id" bigint   NOT NULL,
--     CONSTRAINT "pk_employers" PRIMARY KEY (
--         "id"
--      ),
--     CONSTRAINT "uc_employers_ref_no" UNIQUE (
--         "ref_no"
--     )
-- );

-- CREATE TABLE "job_categories" (
--     "id" bigserial   NOT NULL,
--     "ref_no" varchar   NOT NULL,
--     -- if its null so no need of reference than
--     -- FK >- job_categories.id
--     "parent_category_id" bigint   NULL,
--     "category_name" varchar   NOT NULL,
--     "description" varchar   NOT NULL,
--     "company_types_id" bigint   NOT NULL,
--     "companies_id" bigint   NOT NULL,
--     "is_branch" bool   NOT NULL,
--     "category_image" varchar   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "created_by" bigint   NOT NULL,
--     "status" bigint   NOT NULL,
--     "company_name" varchar   NULL,
--     "updated_at" timestamptz NULL,
--     CONSTRAINT "pk_job_categories" PRIMARY KEY (
--         "id"
--      ),
--     CONSTRAINT "uc_job_categories_ref_no" UNIQUE (
--         "ref_no"
--     )
-- );

-- CREATE TABLE "career_articles" (
--     "id" bigserial   NOT NULL,
--     "ref_no" varchar   NOT NULL,
--     -- company_types_id bigint
--     -- companies_id bigint
--     -- is_branch bool
--     "title" varchar   NOT NULL,
--     "description" varchar   NOT NULL,
--     -- added for arabic description
--     "description_ar" varchar   NULL,
--     "cover_image" varchar   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "created_by" bigint   NOT NULL,
--     "status" bigint   NOT NULL,
--     -- the company which is not registered in aqary system
--     -- company_name varchar NULL
--     -- added by creenx 2024-03-27 1407H
--     "employers_id" bigint   NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     CONSTRAINT "pk_career_articles" PRIMARY KEY (
--         "id"
--      ),
--     CONSTRAINT "uc_career_articles_ref_no" UNIQUE (
--         "ref_no"
--     )
-- );

-- CREATE TABLE "applicants" (
--     "id" bigserial   NOT NULL,
--     "firstname" varchar   NOT NULL,
--     "lastname" varchar   NOT NULL,
--     "email_address" varchar   NOT NULL,
--     "mobile_number" varchar   NOT NULL,
--     "cv_url" varchar   NOT NULL,
--     "cover_letter" varchar   NULL,
--     "applicant_info" varchar   NOT NULL,
--     -- If the applicant is a registered user to Aqary System
--     "users_id" bigint   NULL,
--     "is_verified" bool   NOT NULL,
--     "expected_salary" float   NULL,
--     "highest_education" bigint   NOT NULL,
--     "years_of_experience" bigint   NOT NULL,
--     "languages" bigint[]   NULL,
--     "applicant_photo" varchar   NULL,
--     -- added by creenx 2024-04-02 1058H
--     -- atleast 1 specialization
--     "specialization" bigint[]   NOT NULL,
--     -- at least 1 skill
--     "skills" bigint[]   NOT NULL,
--     -- field of study 
--     "field_of_study" varchar NULL,
--     "created_at" timestamptz DEFAULT now() NOT NULL,
--     "updated_at" timestamptz NULL,
--     CONSTRAINT "pk_applicants" PRIMARY KEY (
--         "id"
--      )
-- );

-- CREATE TABLE "candidates" (
--     "id" bigserial   NOT NULL,
--     "ref_no" varchar   NOT NULL,
--     "careers_id" bigint   NOT NULL,
--     "applicants_id" bigint   NOT NULL,
--     "application_date" timestamptz  DEFAULT now() NOT NULL,
--     "application_status" bigint   NOT NULL,
--     CONSTRAINT "pk_candidates" PRIMARY KEY (
--         "id"
--      ),
--     CONSTRAINT "uc_candidates_ref_no" UNIQUE (
--         "ref_no"
--     )
-- );

CREATE TABLE "candidates_milestone" (
    "id" bigserial   NOT NULL,
    "candidates_id" bigint   NOT NULL,
    "application_status" bigint   NOT NULL,
    "status_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_candidates_milestone" PRIMARY KEY (
        "id"
     )
);

-- CREATE TABLE "specialization" (
--     "id" bigserial   NOT NULL,
--     "title" varchar   NOT NULL,
--     "title_ar" varchar   NULL,
--     CONSTRAINT "pk_specialization" PRIMARY KEY (
--         "id"
--      )
-- );

-- -- added by creenx 2024-04-24 1740h
-- CREATE TABLE "job_portals" (
--     "id" bigserial   NOT NULL,
--     "portal_name" varchar   NOT NULL,
--     "portal_url" varchar   NOT NULL,
--     "portal_logo" varchar   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     -- added by creenx 2024-04-26 1137H
--     "status" bigint   NOT NULL,
--     "updated_at" timestamptz NULL,
--     CONSTRAINT "pk_job_portals" PRIMARY KEY (
--         "id"
--      )
-- );

-- CREATE TABLE "posted_career_portal" (
--     "id" bigserial   NOT NULL,
--     "ref_no" varchar   NOT NULL,
--     "careers_id" bigint   NOT NULL,
--     "job_portals_id" bigint   NOT NULL,
--     "career_url" varchar   NOT NULL,
--     "expiry_date" timestamptz   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     -- added by creenx 2024-04-26 1137H
--     "status" bigint   NOT NULL,
--     CONSTRAINT "pk_posted_career_portal" PRIMARY KEY (
--         "id"
--      ),
--     CONSTRAINT "uc_posted_career_portal_ref_no" UNIQUE (
--         "ref_no"
--     )
-- );

-- CREATE TABLE "field_of_studies" (
--     "id" bigserial   NOT NULL,
--     "title" varchar   NOT NULL,
--     "title_ar" varchar   NULL,
--     "created_at" timestamptz DEFAULT now() NOT NULL,
--     "updated_at" timestamptz NULL,
--     CONSTRAINT "pk_field_of_studies" PRIMARY KEY (
--         "id"
--      )
-- );


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


CREATE TABLE "single_share_doc" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar  NOT NULL,
    "is_allowed" bool   NOT NULL,
    CONSTRAINT "pk_single_share_doc" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "shared_doc" (
    "id" bigint   NOT NULL,
    -- this id can be from internal or external sharing
    "sharing_id" bigint   NOT NULL,
    -- from here you are gonna know which foriegn key it is if true then it will be from internal other wise external
    "is_internal" bool  DEFAULT false NOT NULL,
    -- it will be an array of single share doc table
    "single_share_docs" bigint[]   NOT NULL,
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
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
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
    -- "is_project" bool   NULL,
    -- "project_id" int   NULL,
    -- "phase_id" bigint   NULL,
    -- "is_property" bool   NULL,
    -- "property_key" int   NULL,
    -- "property_id" int   NULL,
    -- "is_unit" bool   NULL,
    -- "unit_id" int   NULL,
    -- "unit_category" varchar   NULL,
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
    "entity_type_id" bigint NOT NULL,
    "entity_id" bigint NOT NULL,
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

-- CREATE TABLE "bank_branches" (
--     "id" bigserial   NOT NULL,
--     "banks_id" bigint   NOT NULL,
--     "branch_name" varchar   NOT NULL,
--     "countries_id" bigint   NOT NULL,
--     "state_id" bigint   NOT NULL,
--     "cities_id" bigint   NOT NULL,
--     "communities_id" bigint   NOT NULL,
--     "sub_communities_id" bigint   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     CONSTRAINT "pk_bank_branches" PRIMARY KEY (
--         "id"
--      )
-- );


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


-- CREATE TABLE "subscription_cost" (
--     "id" bigserial   NOT NULL,
--     "ref_no" varchar   NOT NULL,
--     "countries_id" int   NOT NULL,
--     "featured" float   NOT NULL,
--     "premium" float   NOT NULL,
--     "standard" float   NOT NULL,
--     "deal_of_week" float   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "created_by" bigint   NOT NULL,
--     CONSTRAINT "pk_subscription_cost" PRIMARY KEY (
--         "id"
--      ),
--     CONSTRAINT "uc_subscription_cost_ref_no" UNIQUE (
--         "ref_no"
--     )
-- );

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
    "gallery_type" bigint   NOT NULL,
    "media_type" bigint   NOT NULL,
    "media_url" varchar[]   NOT NULL,
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

CREATE TABLE "exhibition_reviews" (
    "id" bigserial   NOT NULL,
    "exhibition_id" bigint   NOT NULL,
    "reviewer" bigint   NOT NULL,
    "clean" int   NOT NULL,
    "location" int   NOT NULL,
    "facilities" int   NOT NULL,
    "securities" int   NOT NULL,
    "title" varchar   NOT NULL,
    "review" varchar   NOT NULL,
    "review_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_exhibition_reviews" PRIMARY KEY (
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
    "subcommunity_id" bigint   NULL,
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
    "location_url" varchar NOT NULL,
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
    "service" bigint   NOT NULL,
    "service_quality" int   NOT NULL,
    "service_expertise" int   NOT NULL,
    "service_facilities" int   NOT NULL,
    "service_responsiveness" int   NOT NULL,
    "review_description" varchar   NOT NULL,
    "proof_images" varchar[]   NOT NULL,
    "reviewed_by" int   NOT NULL,
    "reviewed_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_service_reviews" PRIMARY KEY (
        "id"
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
-- CREATE TABLE "company_reviews" (
--     "id" bigserial   NOT NULL,
--     "ref_no" varchar   NOT NULL,
--     "company_type_id" int   NOT NULL,
--     "is_branch" bool   NOT NULL,
--     "company_id" bigint   NOT NULL,
--     "customer_service" int   NOT NULL,
--     "staff_courstesy" int   NOT NULL,
--     "implementation" int   NOT NULL,
--     "properties_quality" int   NOT NULL,
--     "description" varchar   NOT NULL,
--     "reviewer" bigint   NOT NULL,
--     -- added by creenx 2024-05-13 1215
--     "proof_images" varchar[]   NULL,
--     "title" varchar   NULL,
--     CONSTRAINT "pk_company_reviews" PRIMARY KEY (
--         "id"
--      ),
--     CONSTRAINT "uc_company_reviews_ref_no" UNIQUE (
--         "ref_no"
--     )
-- );

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

-- CREATE TABLE "units" (
--     "id" bigserial   NOT NULL,
--     "unit_no" varchar   NULL,
--     "unitno_is_public" bool  DEFAULT false NOT NULL,
--     "notes" varchar   NULL,
--     "notes_arabic" varchar   NULL,
--     "notes_public" bool  DEFAULT false NOT NULL,
--     "is_verified" bool  DEFAULT false NOT NULL,
--     "amenities_id" bigint[]   NOT NULL,
--     "property_unit_rank" bigint  DEFAULT 1 NOT NULL,
--     "properties_id" bigint   NULL,
--     "property" bigint   NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     "ref_no" varchar   NOT NULL,
--     "addresses_id" bigint   NOT NULL,
--     "countries_id" bigint   NOT NULL,
--     "property_types_id" bigint   NOT NULL,
--     "created_by" bigint   NOT NULL,
--     "property_name" varchar   NOT NULL,
--     -- project, property hub, agricultural, industrial, unit etc
--     "section" varchar   NOT NULL,
--     "type_name_id" bigint   NULL,
--     -- actual owner of the unit, for transfer ownership
--     "owner_users_id" bigint   NULL,
--     "from_xml" bool DEFAULT false NOT NULL,
--     "is_branch" bool DEFAULT false NOT NULL,
--     CONSTRAINT "pk_units" PRIMARY KEY (
--         "id"
--      ),
--     CONSTRAINT "uc_units_ref_no" UNIQUE (
--         "ref_no"
--     )
-- );

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

CREATE TABLE "unit_media" (
    "id" bigserial   NOT NULL,
    "file_urls" varchar[]   NOT NULL,
    "gallery_type" varchar   NOT NULL,
    "media_type" bigint   NOT NULL,
    "units_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_unit_media" PRIMARY KEY (
        "id"
     )
);

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
    "created_by" bigint   NOT NULL,
    "property_id" bigint   NOT NULL,
    "start_date" timestamptz   NOT NULL,
    "end_date" timestamptz   NOT NULL,
    -- status bigint DEFAULT=1
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "sessions" jsonb   NOT NULL,
    CONSTRAINT "pk_openhouse" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_openhouse_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "timeslots" (
    "id" bigserial   NOT NULL,
    "date" timestamptz   NOT NULL,
    "start_time" timestamptz   NOT NULL,
    "end_time" timestamptz   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    CONSTRAINT "pk_timeslots" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "appointment" (
    "id" bigserial   NOT NULL,
    "timeslots_id" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "client_id" bigint   NULL,
    "remarks" varchar   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "background_color" varchar   NOT NULL,
    "appoinment_type" BIGINT NOT NULL,
    "appoinment_app" BIGINT  NULL,
    "valid_id" BIGINT NOT NULL,
    CONSTRAINT "pk_appointment" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "schedule_view" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "created_by" bigint   NOT NULL,
    "owner_id" bigint   NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "start_date" timestamptz   NOT NULL,
    "end_date" timestamptz   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "interval_time" bigint   NOT NULL,
    "sessions" jsonb   NOT NULL,
    "lat" varchar NOT NULL,
    "lng" varchar NOT NULL,
    CONSTRAINT "pk_schedule_view" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_schedule_view_ref_no" UNIQUE (
        "ref_no"
    )
);

-- -- Subscribers (Newsletter) *****
-- CREATE TABLE "newsletter_subscribers" (
--     "id" bigserial   NOT NULL,
--     "subscriber" bigint   NOT NULL,
--     "interest" bigint[]   NULL,
--     -- Subscriber Interests
--     "subcribe_date" timestamptz  DEFAULT now() NOT NULL,
--     "is_active" bool  DEFAULT true NOT NULL,
--     CONSTRAINT "pk_newsletter_subscribers" PRIMARY KEY (
--         "id"
--      )
-- );

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






-- CREATE TABLE "companies_reviews" (
--     "id" bigserial   NOT NULL,
--     "ref_no" varchar   NOT NULL,
--     "companies_id" bigint   NOT NULL,
--     "customer_service" int   NOT NULL,
--     "staff_courstesy" int   NOT NULL,
--     "implementation" int   NOT NULL,
--     "properties_quality" int   NOT NULL,
--     "description" varchar   NOT NULL,
--     "reviewer" bigint   NOT NULL,
--     "review_date" timestamptz  DEFAULT now() NOT NULL,
--     "proof_images" varchar[]   NULL,
--     "title" varchar   NULL,
--     CONSTRAINT "pk_companies_reviews" PRIMARY KEY (
--         "id"
--      ),
--     CONSTRAINT "uc_companies_reviews_ref_no" UNIQUE (
--         "ref_no"
--     )
-- );




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
-- default data -- don't remove
INSERT INTO quality_score_policies(policy_name, policy_type, parameter_name, parameter_value) VALUES
('title', 'char', 'min', '40'),
('title', 'char', 'max', '60'),
('description', 'char', 'min', '750'),
('description', 'char', 'max', '2000'),
('address', 'field', 'required', 'country,state,city,community'),
('media', 'file', 'min', '5'),
('media', 'file', 'max', '30');




-- CREATE TABLE "companies" (
--     "id" bigserial   NOT NULL,
--     "ref_no" varchar   NOT NULL,
--     "company_name" varchar   NOT NULL,
--     "tag_line" varchar   NULL,
--     "description" varchar   NULL,
--     "logo_url" varchar   NOT NULL,
--     "email" varchar   NULL,
--     "phone_number" varchar   NULL,
--     "whatsapp_number" varchar   NULL,
--     "is_verified" bool  DEFAULT false NOT NULL,
--     "website_url" varchar   NULL,
--     "cover_image_url" varchar   NULL,
--     "no_of_employees" bigint   NULL,
--     "company_rank" bigint  DEFAULT 1 NOT NULL,
--     "status" bigint  DEFAULT 1 NOT NULL,
--     "facebook_profile_url" varchar   NULL,
--     "instagram_profile_url" varchar   NULL,
--     "twitter_profile_url" varchar   NULL,
--     "linkedin_profile_url" varchar   NULL,
--     "youtube_profile_url" varchar   NULL,
--     "other_social_media" varchar[]   NULL,
--     -- 1 => broker_companies, 2 => developer_companies & 3 => services_companies
--     "company_type" bigint   NOT NULL,
--     "addresses_id" bigint   NOT NULL,
--     -- admin of the company
--     "users_id" bigint   NOT NULL,
--     "country_id" bigint   NOT NULL,
--     "created_by" bigint   NOT NULL,
--     "bank_account_details_id" bigint   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     "description_ar" varchar NULL,
--     CONSTRAINT "pk_companies" PRIMARY KEY (
--         "id"
--      ),
--     CONSTRAINT "uc_companies_ref_no" UNIQUE (
--         "ref_no"
--     ),
--     CONSTRAINT "uc_companies_company_name" UNIQUE (
--         "company_name"
--     )
-- );

-- CREATE TABLE "branch_companies" (
--     "id" bigserial   NOT NULL,
--     "parent_companies_id" bigint   NOT NULL,
--     "companies_id" bigint   NOT NULL,
--     CONSTRAINT "pk_branch_companies" PRIMARY KEY (
--         "id"
--      )
-- );

CREATE TABLE "companies" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_name" varchar   NOT NULL,
    -- company_category_id bigint FK >-  company_category.id
    -- FK >-  company_activities.id
    "company_activities_id" bigint[]   NOT NULL,
    -- self-reference
    "company_parent_id" bigint   NULL,
    "tag_line" varchar   NULL,
    "description" varchar   NOT NULL,
    "description_ar" varchar   NULL,
    "logo_url" varchar   NOT NULL,
    "email" varchar   NOT NULL,
    "phone_number" varchar   NOT NULL,
    "whatsapp_number" varchar   NULL,
    "is_verified" bool   NOT NULL,
    "website_url" varchar   NULL,
    "cover_image_url" varchar   NOT NULL,
    "no_of_employees" bigint   NULL,
    "company_rank" bigint  DEFAULT 1 NOT NULL,
    "status" bigint   NOT NULL,
    "company_type" bigint   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "users_id" bigint   NOT NULL,
    -- country_id bigint FK >- countries.id
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- FK - users.id
    "updated_by" bigint   NULL,
    "location_url" varchar NULL,
    "vat_no" varchar NULL,
    "vat_status" bigint NULL,
    "vat_file_url" varchar NULL,
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

-- CREATE TABLE "companies_services" (
--     "id" bigserial   NOT NULL,
--     "companies_id" bigint   NOT NULL,
--     "services_id" bigint   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     CONSTRAINT "pk_companies_services" PRIMARY KEY (
--         "id"
--      )
-- );




CREATE TABLE "companies_leadership" (
    "id" bigserial   NOT NULL,
    "name" varchar   NOT NULL,
    "position" varchar   NOT NULL,
    "description_ar" varchar NULL,
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

-- ALTER TABLE "facilities" ADD CONSTRAINT "fk_facilities_category_id" FOREIGN KEY("category_id")
-- REFERENCES "facilities_amenities_categories" ("id");

-- ALTER TABLE "amenities" ADD CONSTRAINT "fk_amenities_category_id" FOREIGN KEY("category_id")
-- REFERENCES "facilities_amenities_categories" ("id");

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

ALTER TABLE "broker_companies_branches_services" ADD CONSTRAINT "fk_broker_companies_branches_services_broker_companies_branches_id" FOREIGN KEY("broker_companies_branches_id")
REFERENCES "broker_companies_branches" ("id");

ALTER TABLE "broker_companies_branches_services" ADD CONSTRAINT "fk_broker_companies_branches_services_services_id" FOREIGN KEY("services_id")
REFERENCES "services" ("id");

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

ALTER TABLE "bank_account_details" ADD CONSTRAINT "fk_bank_account_details_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "bank_account_details" ADD CONSTRAINT "fk_bank_account_details_currency_id" FOREIGN KEY("currency_id")
REFERENCES "currency" ("id");

ALTER TABLE "bank_account_details" ADD CONSTRAINT "fk_bank_account_details_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE "broker_company_reviews" ADD CONSTRAINT "fk_broker_company_reviews_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "broker_company_reviews" ADD CONSTRAINT "fk_broker_company_reviews_broker_companies_id" FOREIGN KEY("broker_companies_id")
REFERENCES "broker_companies" ("id");

ALTER TABLE "broker_company_reviews" ADD CONSTRAINT "fk_broker_company_reviews_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

-- ALTER TABLE "project_property_media" ADD CONSTRAINT "fk_project_property_media_projects_id" FOREIGN KEY("projects_id")
-- REFERENCES "projects" ("id");

-- ALTER TABLE "project_property_media" ADD CONSTRAINT "fk_project_property_media_project_properties_id" FOREIGN KEY("project_properties_id")
-- REFERENCES "project_properties" ("id");

ALTER TABLE "projects" ADD CONSTRAINT "fk_projects_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "projects" ADD CONSTRAINT "fk_projects_developer_companies_id" FOREIGN KEY("developer_companies_id")
REFERENCES "companies" ("id");

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
REFERENCES "companies" ("id");

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

ALTER TABLE "listing_problems_report" ADD CONSTRAINT "fk_listing_problems_report_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "listing_problems_report" ADD CONSTRAINT "fk_listing_problems_report_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "profiles" ADD CONSTRAINT "fk_profiles_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "profiles" ADD CONSTRAINT "fk_profiles_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "users" ADD CONSTRAINT "fk_users_user_types_id" FOREIGN KEY("user_types_id")
REFERENCES "user_types" ("id");

ALTER TABLE "broker_companies_branches_services" ADD CONSTRAINT "fk_broker_companies_branches_services_broker_companies_branches_id" FOREIGN KEY("broker_companies_branches_id")
REFERENCES "broker_companies_branches" ("id");

ALTER TABLE "broker_companies_branches_services" ADD CONSTRAINT "fk_broker_companies_branches_services_services_id" FOREIGN KEY("services_id")
REFERENCES "services" ("id");

ALTER TABLE "services_branch_companies_services" ADD CONSTRAINT "fk_services_branch_companies_services_service_company_branches_id" FOREIGN KEY("service_company_branches_id")
REFERENCES "service_company_branches" ("id");

ALTER TABLE "services_branch_companies_services" ADD CONSTRAINT "fk_services_branch_companies_services_services_id" FOREIGN KEY("services_id")
REFERENCES "services" ("id");

ALTER TABLE "services" ADD CONSTRAINT "fk_services_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");

ALTER TABLE "services" ADD CONSTRAINT "fk_services_company_activities_id" FOREIGN KEY("company_activities_id")
REFERENCES "company_activities" ("id");

ALTER TABLE "services" ADD CONSTRAINT "fk_services_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

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

ALTER TABLE "social_connections" ADD CONSTRAINT "fk_social_connections_companies_id" FOREIGN KEY("companies_id")
REFERENCES "companies" ("id");

ALTER TABLE "social_connections" ADD CONSTRAINT "fk_social_connections_requested_by" FOREIGN KEY("requested_by")
REFERENCES "companies" ("id");

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

-- ALTER TABLE "careers" ADD CONSTRAINT "fk_careers_job_categories" FOREIGN KEY("job_categories")
-- REFERENCES "job_categories" ("id");

-- ALTER TABLE "careers" ADD CONSTRAINT "fk_careers_uploaded_by" FOREIGN KEY("uploaded_by")
-- REFERENCES "users" ("id");

-- ALTER TABLE "careers" ADD CONSTRAINT "fk_careers_employers_id" FOREIGN KEY("employers_id")
-- REFERENCES "employers" ("id");

-- ALTER TABLE "employers" ADD CONSTRAINT "fk_employers_industry_id" FOREIGN KEY("industry_id")
-- REFERENCES "industry" ("id");

-- ALTER TABLE "employers" ADD CONSTRAINT "fk_employers_users_id" FOREIGN KEY("users_id")
-- REFERENCES "users" ("id");

-- ALTER TABLE "job_categories" ADD CONSTRAINT "fk_job_categories_created_by" FOREIGN KEY("created_by")
-- REFERENCES "users" ("id");

-- ALTER TABLE "career_articles" ADD CONSTRAINT "fk_career_articles_created_by" FOREIGN KEY("created_by")
-- REFERENCES "users" ("id");

-- ALTER TABLE "career_articles" ADD CONSTRAINT "fk_career_articles_employers_id" FOREIGN KEY("employers_id")
-- REFERENCES "employers" ("id");

-- ALTER TABLE "candidates" ADD CONSTRAINT "fk_candidates_careers_id" FOREIGN KEY("careers_id")
-- REFERENCES "careers" ("id");

-- ALTER TABLE "candidates" ADD CONSTRAINT "fk_candidates_applicants_id" FOREIGN KEY("applicants_id")
-- REFERENCES "applicants" ("id");

ALTER TABLE "candidates_milestone" ADD CONSTRAINT "fk_candidates_milestone_candidates_id" FOREIGN KEY("candidates_id")
REFERENCES "candidates" ("id");

-- ALTER TABLE "posted_career_portal" ADD CONSTRAINT "fk_posted_career_portal_careers_id" FOREIGN KEY("careers_id")
-- REFERENCES "careers" ("id");

-- ALTER TABLE "posted_career_portal" ADD CONSTRAINT "fk_posted_career_portal_job_portals_id" FOREIGN KEY("job_portals_id")
-- REFERENCES "job_portals" ("id");

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

-- ALTER TABLE "bank_branches" ADD CONSTRAINT "fk_bank_branches_banks_id" FOREIGN KEY("banks_id")
-- REFERENCES "banks" ("id");

ALTER TABLE "subscriptions" ADD CONSTRAINT "fk_subscriptions_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "subscriptions" ADD CONSTRAINT "fk_subscriptions_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

-- ALTER TABLE "subscription_cost" ADD CONSTRAINT "fk_subscription_cost_countries_id" FOREIGN KEY("countries_id")
-- REFERENCES "countries" ("id");

-- ALTER TABLE "subscription_cost" ADD CONSTRAINT "fk_subscription_cost_created_by" FOREIGN KEY("created_by")
-- REFERENCES "users" ("id");

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

ALTER TABLE "exhibition_reviews" ADD CONSTRAINT "fk_exhibition_reviews_exhibition_id" FOREIGN KEY("exhibition_id")
REFERENCES "exhibitions" ("id");

ALTER TABLE "exhibition_reviews" ADD CONSTRAINT "fk_exhibition_reviews_reviewer" FOREIGN KEY("reviewer")
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

ALTER TABLE "service_reviews" ADD CONSTRAINT "fk_service_reviews_service" FOREIGN KEY("service")
REFERENCES "services" ("id");

ALTER TABLE "service_reviews" ADD CONSTRAINT "fk_service_reviews_reviewed_by" FOREIGN KEY("reviewed_by")
REFERENCES "users" ("id");

ALTER TABLE "agent_reviews" ADD CONSTRAINT "fk_agent_reviews_reviewer" FOREIGN KEY("reviewer")
REFERENCES "users" ("id");

-- ALTER TABLE "company_reviews" ADD CONSTRAINT "fk_company_reviews_reviewer" FOREIGN KEY("reviewer")
-- REFERENCES "users" ("id");

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

ALTER TABLE "sale_unit" ADD CONSTRAINT "fk_sale_unit_unit_id" FOREIGN KEY("unit_id")
REFERENCES "units" ("id");

ALTER TABLE "rent_unit" ADD CONSTRAINT "fk_rent_unit_unit_id" FOREIGN KEY("unit_id")
REFERENCES "units" ("id");

ALTER TABLE "units_status_history" ADD CONSTRAINT "fk_units_status_history_units_id" FOREIGN KEY("units_id")
REFERENCES "units" ("id");

ALTER TABLE "unit_media" ADD CONSTRAINT "fk_unit_media_units_id" FOREIGN KEY("units_id")
REFERENCES "units" ("id");

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

ALTER TABLE "openhouse" ADD CONSTRAINT "fk_openhouse_property_id" FOREIGN KEY("property_id")
REFERENCES "property" ("id");

ALTER TABLE "timeslots" ADD CONSTRAINT "fk_timeslots_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE "appointment" ADD CONSTRAINT "fk_appointment_timeslots_id" FOREIGN KEY("timeslots_id")
REFERENCES "timeslots" ("id");

ALTER TABLE "appointment" ADD CONSTRAINT "fk_appointment_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "schedule_view" ADD CONSTRAINT "fk_schedule_view_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "schedule_view" ADD CONSTRAINT "fk_schedule_view_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

-- ALTER TABLE "newsletter_subscribers" ADD CONSTRAINT "fk_newsletter_subscribers_subscriber" FOREIGN KEY("subscriber")
-- REFERENCES "users" ("id");

ALTER TABLE "advertisements" ADD CONSTRAINT "fk_advertisements_pages_id" FOREIGN KEY("pages_id")
REFERENCES "pages" ("id");

ALTER TABLE "image_categories" ADD CONSTRAINT "fk_image_categories_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "international_content" ADD CONSTRAINT "fk_international_content_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "dropdown_items" ADD CONSTRAINT "fk_dropdown_items_category_id" FOREIGN KEY("category_id")
REFERENCES "dropdown_categories" ("id");

ALTER TABLE "dropdown_items" ADD CONSTRAINT "fk_dropdown_items_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

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


 
-- ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_addresses_id" FOREIGN KEY("addresses_id")
-- REFERENCES "addresses" ("id");

-- ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_users_id" FOREIGN KEY("users_id")
-- REFERENCES "users" ("id");

-- ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_country_id" FOREIGN KEY("country_id")
-- REFERENCES "countries" ("id");

-- ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_created_by" FOREIGN KEY("created_by")
-- REFERENCES "users" ("id");

-- ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_bank_account_details_id" FOREIGN KEY("bank_account_details_id")
-- REFERENCES "bank_account_details" ("id");

-- ALTER TABLE "branch_companies" ADD CONSTRAINT "fk_branch_companies_parent_companies_id" FOREIGN KEY("parent_companies_id")
-- REFERENCES "companies" ("id");

-- ALTER TABLE "branch_companies" ADD CONSTRAINT "fk_branch_companies_companies_id" FOREIGN KEY("companies_id")
-- REFERENCES "companies" ("id");

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_company_type" FOREIGN KEY("company_type")
REFERENCES "company_types" ("id");

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

-- ALTER TABLE "companies_services" ADD CONSTRAINT "fk_companies_services_companies_id" FOREIGN KEY("companies_id")
-- REFERENCES "companies" ("id");

-- ALTER TABLE "companies_services" ADD CONSTRAINT "fk_companies_services_services_id" FOREIGN KEY("services_id")
-- REFERENCES "services" ("id");


COMMENT ON TABLE companies IS 'table for company information';
COMMENT ON COLUMN companies.company_rank IS 'rank of the company i.e. standard,featured, premium,top deal etc.';
COMMENT ON COLUMN companies.users_id IS 'admin user of the company';

-- COMMENT ON TABLE companies_licenses IS 'table for all types of licenses for company';
-- COMMENT ON COLUMN companies_licenses.commercial_license_registration_date IS 'when the commercial license registered for the first time';
-- COMMENT ON COLUMN companies_licenses.rera_no IS 'only for company type 1 (broker companies)';
-- COMMENT ON COLUMN companies_licenses.rera_file_url IS 'only for company type 1 (broker companies)';
-- COMMENT ON COLUMN companies_licenses.rera_expiry IS 'only for company type 1 (broker companies)';
-- COMMENT ON COLUMN companies_licenses.rera_issue_date IS 'only for company type 1 (broker companies)';
-- COMMENT ON COLUMN companies_licenses.rera_registration_date IS 'only for company type 1 (broker companies), when the rera registered for the first time';
-- COMMENT ON COLUMN companies_licenses.trakhees_permit_no IS 'only for company type 1 (broker companies) for only dubai city in UAE';
-- COMMENT ON COLUMN companies_licenses.license_dcci_no IS 'only for company type 1 (broker companies) for only dubai city in UAE';
-- COMMENT ON COLUMN companies_licenses.register_no IS 'only for company type 1 (broker companies) for only dubai city in UAE';

CREATE TABLE "company_rejects" (
    "id" bigserial   NOT NULL,
    "reason" text   NOT NULL,
    -- company_type bigint
    "company_id" bigint   NOT NULL,
    -- is_branch bool
    "rejected_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_company_rejects" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "company_rejects" ADD CONSTRAINT "fk_company_rejects_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");

ALTER TABLE "company_rejects" ADD CONSTRAINT "fk_company_rejects_rejected_by" FOREIGN KEY("rejected_by")
REFERENCES "users" ("id");


-- ALTER TABLE "companies_reviews" ADD CONSTRAINT "fk_companies_reviews_companies_id" FOREIGN KEY("companies_id")
-- REFERENCES "companies" ("id");

-- ALTER TABLE "companies_reviews" ADD CONSTRAINT "fk_companies_reviews_reviewer" FOREIGN KEY("reviewer")
-- REFERENCES "users" ("id");



ALTER TABLE "companies_leadership" ADD CONSTRAINT "fk_companies_leadership_companies_id" FOREIGN KEY("companies_id")
REFERENCES "companies" ("id");

ALTER TABLE "companies_leadership" ADD CONSTRAINT "fk_companies_leadership_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

COMMENT ON COLUMN project_media.media_type IS '1=>image,2=>image_360,3=>video,4=>panaroma,5=>pdf';
COMMENT ON COLUMN unit_media.media_type IS '1=>image,2=>image_360,3=>video,4=>panaroma,5=>pdf';



CREATE TABLE "properties_media" (
    "id" bigserial   NOT NULL,
    "file_urls" varchar[]   NOT NULL,
    "gallery_type" varchar   NOT NULL,
    "media_type" bigint   NOT NULL,
    -- id from any properties  table broker, project ,owner,freelancer properties.
    "properties_id" bigint   NOT NULL,
    -- keys 1 => project property,2=> freelancer property, 3 => broker property, 4=>owner property
    "property" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_properties_media" PRIMARY KEY (
        "id"
     )
);

CREATE INDEX "idx_properties_media_properties_id_property" 
ON "properties_media" ("properties_id", "property");

COMMENT ON COLUMN properties_media.media_type IS '1=>image,2=>image_360,3=>video,4=>panaroma,5=>pdf';

COMMENT ON COLUMN properties_media.properties_id IS 'id from any properties  table broker, project ,owner,freelancer properties';
COMMENT ON COLUMN properties_media.property IS 'keys 1 => project property,2=> freelancer property, 3 => broker property, 4=>owner property';

CREATE TABLE "project_activities_history" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "module_name" varchar   NOT NULL,
    -- field_name, previous value & current value
    "field_value" jsonb  NULL,
    "created_by" bigint   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_project_activities_history" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "project_activities_history" ADD CONSTRAINT "fk_project_activities_history_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

COMMENT ON COLUMN project_activities_history.title IS 'its name of project, unit, property etc';
COMMENT ON COLUMN project_activities_history.module_name IS 'name of side bar or action buttons, like add project, local projects, manage units etc';
COMMENT ON COLUMN project_activities_history.field_value IS 'its json obj for storing field name on which the activity perform & current & previous value';

CREATE TABLE "project_fileview_history" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    -- downloaded or viewed
    "activity" varchar   NOT NULL,
    "file_url" varchar   NOT NULL,
    "created_by" bigint   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_project_fileview_history" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "project_fileview_history" ADD CONSTRAINT "fk_project_fileview_history_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

COMMENT ON COLUMN project_fileview_history.activity IS 'either the file is downloaded or viewed';

CREATE TABLE "companies_activities_history" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "module_name" varchar   NOT NULL,
    -- field_name, previous value & current value
    "field_value" jsonb  NULL,
    "created_by" bigint   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_companies_activities_history" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "companies_fileview_history" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    -- downloaded or viewed
    "activity" varchar   NOT NULL,
    "file_url" varchar   NOT NULL,
    "created_by" bigint   NOT NULL,
    "activity_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_companies_fileview_history" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "companies_activities_history" ADD CONSTRAINT "fk_companies_activities_history_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "companies_fileview_history" ADD CONSTRAINT "fk_companies_fileview_history_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");


CREATE TABLE "financial_providers" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "provider_type" bigint   NOT NULL,
    "provider_name" varchar   NOT NULL,
    "logo_url" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_financial_providers" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_financial_providers_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "project_financial_provider" (
    "id" bigserial   NOT NULL,
    "projects_id" bigint   NOT NULL,
    "phases_id" bigint   NULL,
    -- FK >- financial_providers.id
    "financial_providers_id" bigint[]   NULL,
    CONSTRAINT "pk_project_financial_provider" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "project_financial_provider" ADD CONSTRAINT "fk_project_financial_provider_projects_id" FOREIGN KEY("projects_id")
REFERENCES "projects" ("id");


COMMENT ON COLUMN financial_providers.provider_type IS '1 => Bank & 2 => Financial Institution';
COMMENT ON COLUMN project_financial_provider.financial_providers_id IS 'foriegn key ids of table financial_providers';


CREATE TABLE IF NOT EXISTS trigger_status (
    table_name TEXT PRIMARY KEY,
    is_active BOOLEAN NOT NULL DEFAULT false
);

-- CREATE TABLE "skills" (
--     "id" bigserial   NOT NULL,
--     "title" varchar   NOT NULL,
--     "title_ar" varchar   NULL,
--     CONSTRAINT "pk_skills" PRIMARY KEY (
--         "id"
--      )
-- );




CREATE TABLE "routing_triggers" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "lead_activity" bigint   NOT NULL,
    "next_activity" bigint   NOT NULL,
    -- Activities
    "interval" bigint   NOT NULL,
    "interval_type" bigint   NOT NULL,
    "added_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_routing_triggers" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "agent_routes" (
    "id" bigserial   NOT NULL,
    "leads_id" bigint   NOT NULL,
    "assigned_to" bigint   NOT NULL,
    "routed_to" bigint   NOT NULL,
    "reason" varchar   NOT NULL,
    "routed_date" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_agent_routes" PRIMARY KEY (
        "id"
     )
);



ALTER TABLE "routing_triggers" ADD CONSTRAINT "fk_routing_triggers_added_by" FOREIGN KEY("added_by")
REFERENCES "users" ("id");

ALTER TABLE "agent_routes" ADD CONSTRAINT "fk_agent_routes_leads_id" FOREIGN KEY("leads_id")
REFERENCES "leads" ("id");

ALTER TABLE "agent_routes" ADD CONSTRAINT "fk_agent_routes_assigned_to" FOREIGN KEY("assigned_to")
REFERENCES "users" ("id");

ALTER TABLE "agent_routes" ADD CONSTRAINT "fk_agent_routes_routed_to" FOREIGN KEY("routed_to")
REFERENCES "users" ("id");




------------- Auction Section -----------------------

-- Create auction table
CREATE TABLE IF NOT EXISTS auctions_property_types (
  id BIGSERIAL PRIMARY KEY
);
 
CREATE TABLE IF NOT EXISTS auctions_users (
  id BIGSERIAL PRIMARY KEY,
  user_name VARCHAR NULL,
  company_id BIGINT NOT NULL REFERENCES companies(id)
);
 
CREATE TABLE  IF NOT EXISTS auctions_companies (
    id BIGSERIAL PRIMARY KEY,
    logo_url VARCHAR,
    website_url VARCHAR,
    company_name VARCHAR,
    is_verified BOOL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NULL,
    deleted_at TIMESTAMPTZ
);
 
CREATE TABLE IF NOT EXISTS auctions_tags (
  id BIGSERIAL PRIMARY KEY
);
 
CREATE TABLE IF NOT EXISTS auctions_addresses (
   id BIGSERIAL PRIMARY KEY,
   country BIGINT NOT NULL,
   state BIGINT NOT NULL,
   city BIGINT NOT NULL,
   community BIGINT,
   sub_community BIGINT,
   location_url TEXT,
   lat FLOAT,
   lng FLOAT,
   created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
   updated_at TIMESTAMPTZ,
   deleted_at TIMESTAMPTZ
);
 
CREATE TABLE IF NOT EXISTS auctions_properties (
    id BIGSERIAL PRIMARY KEY,
    companies_id BIGINT NOT NULL,
    property_title VARCHAR(255) NOT NULL,
    property_title_arabic VARCHAR NOT NULL,
    description VARCHAR NOT NULL,
    description_arabic VARCHAR NOT NULL,
    is_verified BOOL DEFAULT false,
    property_rank BIGINT DEFAULT 1,
    addresses_id BIGINT NOT NULL REFERENCES addresses(id),
    property_types_id BIGINT NOT NULL REFERENCES property_types(id),
    status BIGINT DEFAULT 1,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    facilities_id BIGINT[] NULL,
    amenities_id BIGINT[] NOT NULL,
    is_show_owner_info BOOL DEFAULT true,
    property BIGINT DEFAULT 3,
    ref_no VARCHAR UNIQUE NOT NULL,
    category BIGINT NOT NULL,
    /*
      1 - Sale
      2 - Rent
      3 - Swap
      4 - Auction
    */
    investment BOOL DEFAULT false,
    contract_start_datetime TIMESTAMPTZ NULL,
    contract_end_datetime TIMESTAMPTZ NULL,
    amount FLOAT DEFAULT 0.0,
    unit_types BIGINT[] NOT NULL,
    property_name VARCHAR NOT NULL,
    from_xml BOOL DEFAULT false,
    list_of_date TIMESTAMPTZ[] NOT NULL,
    list_of_notes VARCHAR[] NOT NULL,
    list_of_agent BIGINT[] NOT NULL,
    owner_users_id BIGINT NULL
);
 
CREATE TABLE IF NOT EXISTS auctions_properties_facts (
    id BIGSERIAL PRIMARY KEY,
    bedroom VARCHAR NULL,
    plot_area FLOAT NULL,
    built_up_area FLOAT NULL,
    view BIGINT[] NULL,
    furnished BIGINT NULL,
    ownership BIGINT NULL,
    completion_status BIGINT NULL,
    start_date TIMESTAMPTZ NULL,
    completion_date TIMESTAMPTZ NULL,
    handover_date TIMESTAMPTZ NULL,
    no_of_floor BIGINT NULL,
    no_of_units BIGINT NULL,
    min_area FLOAT NULL,
    max_area FLOAT NULL,
    service_charge BIGINT NULL,
    parking BIGINT NULL,
    ask_price BOOL NULL,
    price FLOAT NULL,
    rent_type BIGINT NULL,
    no_of_payment BIGINT NULL,
    no_of_retail BIGINT NULL,
    no_of_pool BIGINT NULL,
    elevator BIGINT NULL,
    starting_price BIGINT NULL,
    life_style BIGINT NULL,
    properties_id BIGINT NULL,
    property BIGINT NOT NULL, -- either 1, 2, 3, or 4
    is_branch BOOL NOT NULL,
    available_units BIGINT NULL,
    commercial_tax FLOAT NULL,
    municipality_tax FLOAT NULL,
    is_project_fact BOOL DEFAULT FALSE,
    project_id BIGINT NULL,
    completion_percentage BIGINT NULL,
    completion_percentage_date TIMESTAMPTZ NULL,
    type_name_id BIGINT NULL,
    sc_currency_id BIGINT NULL,
    unit_of_measure VARCHAR NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
 
 
CREATE TABLE IF NOT EXISTS auctions_units (
    id BIGSERIAL PRIMARY KEY,
    unit_no VARCHAR NULL,
    unitno_is_public BOOL DEFAULT false,
    notes VARCHAR NULL,
    notes_arabic VARCHAR NULL,
    notes_public BOOL DEFAULT false,
    is_verified BOOL DEFAULT false,
    amenities_id BIGINT[] NOT NULL,
    property_unit_rank BIGINT DEFAULT 1,
    properties_id BIGINT NULL,
    property BIGINT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    ref_no VARCHAR UNIQUE,
    addresses_id BIGINT NOT NULL,
    countries_id BIGINT NOT NULL,
    property_types_id BIGINT NOT NULL,
    created_by BIGINT REFERENCES users(id),
    property_name VARCHAR NOT NULL,
    section VARCHAR NOT NULL,  -- project, property hub, agricultural, industrial, unit etc
    type_name_id BIGINT NULL,
    owner_users_id BIGINT NULL -- actual owner of the unit, for transfer ownership
);
 
CREATE TABLE IF NOT EXISTS auctions_unit_facts (
    id BIGSERIAL PRIMARY KEY,
    bedroom VARCHAR NULL,
    bathroom BIGINT NULL,
    plot_area FLOAT NULL,
    built_up_area FLOAT NULL,
    view BIGINT[] NULL,
    furnished BIGINT NULL,
    ownership BIGINT NULL,
    completion_status BIGINT NULL,
    start_date TIMESTAMPTZ NULL,
    completion_date TIMESTAMPTZ NULL,
    handover_date TIMESTAMPTZ NULL,
    no_of_floor BIGINT NULL,
    no_of_units BIGINT NULL,
    min_area FLOAT NULL,
    max_area FLOAT NULL,
    service_charge BIGINT NULL,
    parking BIGINT NULL,
    ask_price BOOL NOT NULL,
    price FLOAT NULL,
    rent_type BIGINT NULL,
    no_of_payment BIGINT NULL,
    no_of_retail BIGINT NULL,
    no_of_pool BIGINT NULL,
    elevator BIGINT NULL,
    starting_price BIGINT NULL,
    life_style BIGINT NULL,
    unit_id BIGINT NOT NULL,
    category VARCHAR NOT NULL,
    is_branch BOOL NOT NULL,
    commercial_tax FLOAT NULL,
    municipality_tax FLOAT NULL,
    sc_currency_id BIGINT NULL,
    unit_of_measure VARCHAR NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
 
 
CREATE TABLE IF NOT EXISTS auctions (
    id BIGSERIAL PRIMARY KEY,
    ref_no VARCHAR UNIQUE,
    auction_title VARCHAR UNIQUE,
    auction_description VARCHAR(255),
    auction_category BIGINT,
    -- Categories (Constant)
    -- 1 - On-site
    -- 2 - Online
    companies_id BIGINT REFERENCES companies(id),
    mobile_number VARCHAR,
    email_address VARCHAR,
    whatsapp VARCHAR,
    select_type BIGINT NOT NULL,
    property_name VARCHAR,
    property_category BIGINT,
    -- Property Types (Constant)
    -- 1 - Residential
    -- 2 - Commercial
    -- 3 - Agriculture
    -- 4 - Industrial
    property_usage BIGINT REFERENCES property_types(id),
    properties_unites_id BIGINT,
    -- either Properties.id or units.id
    plot_no VARCHAR NOT NULL,
    sector_no VARCHAR NOT NULL,
    has_tenants BOOL DEFAULT FALSE,
    lat FLOAT,
    lng FLOAT,
    prebid_start_date TIMESTAMPTZ,
    start_date TIMESTAMPTZ,
    end_date TIMESTAMPTZ,
    min_bid_amount FLOAT,
    min_increment_amount FLOAT,
    winning_bid_amount FLOAT,
    auction_url VARCHAR,
    -- for online auction
    auction_type BIGINT,
    -- If it is open for International or For that particular country only
    -- 1 - local
    -- 2 - international
    description VARCHAR NOT NULL,
    description_ar VARCHAR,
    addresses_id BIGINT,
    -- [ref: > addresses.id]
    location_url VARCHAR,
    -- Google Map Link
    ownership_id BIGINT,
    -- Ownerships
    -- 1 - Freehold
    -- 2 - GCC
    -- 3 - Local
    -- 4 - Leasehold
    -- 5 - USUFRUCT
    -- 6 - Freezone
    -- 7 - Others
    auction_status BIGINT,
    -- AUCTION STATUS (CONSTANT)
    -- 1 - DRAFT
    -- 2 - LIVE
    -- 3 - PUBLISHED
    -- 4 - ENDED
    -- 5 - CANCELLED
    -- 6 - DELETED
    tags_id BIGINT[],
    -- [ref: > tags.id]
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ
);
 
CREATE TABLE IF NOT EXISTS auctions_pre_bids (
    id BIGSERIAL PRIMARY KEY,
    ref_no VARCHAR UNIQUE NOT NULL,
    auction_id BIGINT NOT NULL REFERENCES auctions(id),
    amount FLOAT NOT NULL,
    bidder_id BIGINT NOT NULL REFERENCES users(id),
    placed_date TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NULL,
    deleted_at TIMESTAMPTZ
);
 
 
CREATE TABLE IF NOT EXISTS auctions_plans (
    id BIGSERIAL PRIMARY KEY,
    auction_id BIGINT REFERENCES auctions(id),
    plan_title BIGINT,
    plan_url VARCHAR[] NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NULL,
    deleted_at TIMESTAMPTZ
);
 
CREATE TABLE IF NOT EXISTS auctions_documents (
    id BIGSERIAL PRIMARY KEY,
    auction_id BIGINT REFERENCES auctions(id),
    document_type BIGINT,
    document_url VARCHAR[] NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NULL,
    deleted_at TIMESTAMPTZ
);
 
CREATE TABLE IF NOT EXISTS auctions_media (
    id BIGSERIAL PRIMARY KEY,
    auction_id BIGINT NOT NULL REFERENCES auctions(id),
    gallery_type BIGINT NOT NULL,
    media_type BIGINT NOT NULL,
    media_url VARCHAR[] NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NULL,
    deleted_at TIMESTAMPTZ
);
 
CREATE TABLE IF NOT EXISTS auctions_faqs (
    id BIGSERIAL PRIMARY KEY,
    ref_no VARCHAR UNIQUE,
    question VARCHAR(255),
    answer VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ
);
 
CREATE TABLE IF NOT EXISTS auctions_partners (
    id BIGSERIAL PRIMARY KEY,
    ref_no VARCHAR UNIQUE,
    auction_id BIGINT NOT NULL REFERENCES auctions(id),
    partner_name VARCHAR NOT NULL,
    partner_logo VARCHAR NOT NULL,
    website VARCHAR NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ
);
 
CREATE TABLE IF NOT EXISTS auctions_reviews (
    id BIGSERIAL PRIMARY KEY,
    ref_no VARCHAR UNIQUE NOT NULL,
    auction_id BIGINT NOT NULL REFERENCES auctions(id),
    facilities INT NOT NULL,
    securities INT NOT NULL,
    accuracy INT NOT NULL,
    location INT NOT NULL,
    description VARCHAR,
    reviewer BIGINT NOT NULL REFERENCES users(id),
    review_date TIMESTAMPTZ NOT NULL DEFAULT now(),
    title VARCHAR,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ
);
 
CREATE TABLE IF NOT EXISTS auctions_activities (
    id BIGSERIAL PRIMARY KEY,
    auction_id BIGINT NOT NULL REFERENCES auctions(id),
    activity_type BIGINT NOT NULL,
    /*
    ## Activity Types
    ### 1 - Transactions
    ### 2 - File View
    ### 3 - Portal View
    */
    file_category BIGINT NULL,
    /*
    ## File Category
    ### 1 - Media
    ### 2 - Plans
    ### 3 - Documents
    */
    file_url VARCHAR NULL,
    portal_url VARCHAR NULL,
    activity VARCHAR NOT NULL,
    user_id BIGINT NOT NULL REFERENCES users(id),
    activity_date TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);
 
CREATE TABLE IF NOT EXISTS auctions_activity_changes (
    id BIGSERIAL PRIMARY KEY,
    section_id BIGINT NOT NULL,
    /*
    ## Activity Tables
    ### 15 - auctions
    */
    activities_id BIGINT NOT NULL,
    field_name VARCHAR NULL,
    before VARCHAR NULL,
    after VARCHAR NULL,
    activity_date TIMESTAMPTZ NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

-------- End of Auction Section ---------------------


ALTER TABLE projects ADD CONSTRAINT uc_projects_project_name_countries_id UNIQUE (project_name, countries_id);
ALTER TABLE projects ADD CONSTRAINT uc_projects_project_no_countries_id UNIQUE (project_no, countries_id);
ALTER TABLE projects ADD CONSTRAINT uc_projects_license_no_countries_id UNIQUE (license_no, countries_id);



 
 

-- ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_company_type" FOREIGN KEY("company_type")
-- REFERENCES "company_types" ("id");

-- CREATE TABLE "companies_licenses" (
--     "id" bigserial   NOT NULL,
--     "company_id" bigint   NOT NULL,
--     "commercial_license_no" varchar   NOT NULL,
--     "commercial_license_file_url" varchar   NOT NULL,
--     "commercial_license_issue_date" timestamptz   NULL,
--     "commercial_license_expiry" timestamptz   NOT NULL,
--     -- when the commercial license registered for the first time
--     "commercial_license_registration_date" timestamptz   NULL,
--     "rera_no" varchar   NULL,
--     "rera_file_url" varchar   NULL,
--     "rera_issue_date" timestamptz   NULL,
--     "rera_expiry" timestamptz   NULL,
--     -- when the rera registered for the first time
--     "rera_registration_date" timestamptz   NULL,
--     "vat_no" varchar   NULL,
--     "vat_status" bigint   NULL,
--     "vat_file_url" varchar   NULL,
--     "orn_license_no" varchar   NULL,
--     "orn_license_file_url" varchar   NULL,
--     "orn_registration_date" timestamptz   NULL,
--     "orn_license_expiry" timestamptz   NULL,
--     -- only for dubai
--     "trakhees_permit_no" varchar   NULL,
--     -- only for dubai
--     "license_dcci_no" varchar   NULL,
--     -- only for dubai
--     "register_no" varchar   NULL,
--     -- extra_license_id bigint FK >- extra_license.id
--     "extra_license" jsonb  NULL,
--     CONSTRAINT "pk_companies_licenses" PRIMARY KEY (
--         "id"
--      ),
--     CONSTRAINT "uc_companies_licenses_commercial_license_no" UNIQUE (
--         "commercial_license_no"
--     ),
--     CONSTRAINT "uc_companies_licenses_rera_no" UNIQUE (
--         "rera_no"
--     )
-- );

-- ALTER TABLE "companies_licenses" ADD CONSTRAINT "fk_companies_licenses_company_id" FOREIGN KEY("company_id")
-- REFERENCES "companies" ("id");



ALTER TABLE "careers_activities" ADD CONSTRAINT "fk_careers_activities_user_id" FOREIGN KEY("user_id")
REFERENCES "company_users" ("id");

ALTER TABLE "careers_activities" ADD CONSTRAINT "fk_careers_activities_ref_activity_id" FOREIGN KEY("ref_activity_id")
REFERENCES "careers" ("id");



CREATE TABLE "user_company_permissions" (
    "id" bigserial   NOT NULL,
    "user_id" bigint   NOT NULL,
    "company_id" bigint,
    "permissions_id" bigint[],
    "sub_sections_id" bigint[],
    CONSTRAINT "pk_user_company_permissions" PRIMARY KEY (
        "id"
     )
);
ALTER TABLE "user_company_permissions" ADD CONSTRAINT "fk_user_company_permissions_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");
ALTER TABLE "user_company_permissions" ADD CONSTRAINT "fk_user_company_permissions_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");


-- TODO: Need to remove this later 
CREATE TABLE user_company_permissions_test (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    company_id BIGINT NULL,
    permission_id BIGINT REFERENCES permissions(id),
    sub_section_id BIGINT REFERENCES sub_section(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- property hub changes
-- CREATE TABLE "unit_type" (
--     "id" bigserial   NOT NULL,
--     "type" varchar   NOT NULL,
--     "code" varchar   NOT NULL,
--     "unit_facts_id" bigint[]   NOT NULL,
--     "usage" bigint   NOT NULL,
--     -- is_project bool default=false
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL,
--     "status" bigint  DEFAULT 1 NOT NULL,
--     "icon" varchar   NULL,
--     CONSTRAINT "pk_unit_type" PRIMARY KEY (
--         "id"
--      )
-- );

CREATE TABLE "property" (
    "id" bigserial   NOT NULL,
    "company_id" bigint  NULL,
    "property_type_id" bigint   NOT NULL,
    "unit_type_id" bigint[]   NULL,
    "property_title" varchar  NOT NULL,
    "property_title_arabic" varchar  NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    -- "property_rank" bigint  DEFAULT 1 NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "is_show_owner_info" bool  DEFAULT true NOT NULL,
    "property_name" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar  NULL,
    "owner_users_id" bigint   NULL,
    "user_id" bigint  NOT NULL,
    "updated_by" bigint  NOT NULL,
    "from_xml" bool  DEFAULT false NOT NULL,
    "facts" jsonb NOT NULL,
    "notes" varchar  NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "notes_ar" varchar NULL,
    "is_public_note" boolean NOT NULL DEFAULT false,
    "is_project_property" boolean NOT NULL DEFAULT false,
    "exclusive" boolean NOT NULL DEFAULT false,
    "start_date" DATE NULL,
    "end_date" DATE NULL,
    CONSTRAINT "pk_property" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "property" ADD CONSTRAINT "fk_property_property_type_id" FOREIGN KEY("property_type_id")
REFERENCES "global_property_type" ("id");	

ALTER TABLE "property" ADD CONSTRAINT "fk_property_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "property" ADD CONSTRAINT "fk_property_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "property" ADD CONSTRAINT "fk_property_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");



CREATE TABLE "property_facts" (
    "id" bigserial   NOT NULL,
    "plot_area" float   NULL,
    "built_up_area" float   NULL,
    "view" bigint[]   NULL,
    "furnished" bigint   NULL,
    "ownership" bigint   NULL,
    "completion_status" bigint   NULL,
    "bedroom" varchar   NULL,
    "bathroom" bigint   NULL,
    "start_date" timestamptz   NULL,
    "completion_date" timestamptz   NULL,
    "handover_date" timestamptz   NOT NULL,
    "no_of_floor" bigint   NULL,
    "no_of_units" bigint   NULL,
    "min_area" float   NULL,
    "max_area" float   NULL,
    "service_charge" bigint   NULL,
    -- need to replace with no_of_parking
    "parking" bigint   NULL,
    "ask_price" bool   NULL,
    "price" bigint   NULL,
    "rent_type" bigint   NULL,
    "no_of_payment" bigint   NULL,
    "no_of_retail" bigint   NULL,
    "no_of_pool" bigint  NULL,
    "elevator" bigint   NULL,
    "starting_price" bigint   NULL,
    "life_style" bigint   NULL,
    -- usage bigint
    "is_branch" bool   NOT NULL,
    "available_units" bigint   NULL,
    "commercial_tax" float   NULL,
    "municipality_tax" float   NULL,
    "is_project_fact" bool  DEFAULT false NOT NULL,
    "project_id" bigint   NULL,
    "completion_percentage" bigint   NULL,
    "completion_percentage_date" timestamptz   NULL,
    "type_name_id" bigint   NULL,
    "sc_currency_id" bigint   NULL,
    "unit_of_measure" varchar   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "worksop" bigint   NULL,
    "warehouse" bigint   NULL,
    "office" bigint   NULL,
    "sector_no" bigint   NOT NULL,
    "plot_no" bigint   NOT NULL,
    "property_no" bigint   NOT NULL,
    "no_of_tree" bigint   NULL,
    "no_of_water_well" bigint   NULL,
    "investment" bool  DEFAULT false NOT NULL,
    "contract_start_datetime" timestamptz   NULL,
    "contract_end_datetime" timestamptz   NULL,
    "contract_amount" bigint   NULL,
    "contract_currency" bigint   NULL,
    CONSTRAINT "pk_property_facts" PRIMARY KEY (
        "id"
     )
);


CREATE TABLE "sale_properties" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "title_arabic" varchar   NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NULL,
    "property_id" bigint   NOT NULL,
    "property_facts_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_sale_properties" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "rent_properties" (
    "id" bigserial   NOT NULL,
    "property_id" bigint   NOT NULL,
    "property_facts_id" bigint   NOT NULL,
    "title" varchar   NOT NULL,
    "title_arabic" varchar   NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_rent_properties" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "sale_properties" ADD CONSTRAINT "fk_sale_properties_property_id" FOREIGN KEY("property_id")
REFERENCES "property" ("id");

ALTER TABLE "sale_properties" ADD CONSTRAINT "fk_sale_properties_property_facts_id" FOREIGN KEY("property_facts_id")
REFERENCES "property_facts" ("id");

ALTER TABLE "rent_properties" ADD CONSTRAINT "fk_rent_properties_property_id" FOREIGN KEY("property_id")
REFERENCES "property" ("id");

ALTER TABLE "rent_properties" ADD CONSTRAINT "fk_rent_properties_property_facts_id" FOREIGN KEY("property_facts_id")
REFERENCES "property_facts" ("id");


-- CREATE TABLE "swap_requirement" (
--     "id" bigserial   NOT NULL,
--     "addresses_id" bigint   NOT NULL,
--     "property_id" bigint   NOT NULL,
--     "property_type" bigint   NOT NULL,
--     "unit_types" bigint   NOT NULL,
--     "no_of_bathrooms" bigint   NULL,
--     "no_of_bedrooms" bigint   NULL,
--     "min_plot_area" float   NULL,
--     "max_plot_area" float   NULL,
--     "completion_status" bigint   NULL,
--     "views" bigint[]   NULL,
--     "amenities" bigint[]   NULL,
--     "facilities" bigint[]   NULL,
--     "min_no_of_parkings" bigint   NULL,
--     "max_no_of_parkings" bigint   NULL,
--     "min_built_up_area" bigint   NOT NULL,
--     "max_built_up_area" bigint   NOT NULL,
--     "min_price" bigint   NOT NULL,
--     "max_price" bigint   NOT NULL,
--     "ownership" bigint   NULL,
--     "furnished" bigint   NULL,
--     "mortgage" bool   NOT NULL,
--     -- vat_value bigint null
--     "category" bigint   NOT NULL,
--     "notes" varchar   NULL,
--     -- should remove
--     "notes_arabic" varchar   NULL,
--     "is_notes_public" bool   NOT NULL,
--     CONSTRAINT "pk_swap_requirement" PRIMARY KEY (
--         "id"
--      )
-- );


ALTER TABLE "swap_requirement" ADD CONSTRAINT "fk_swap_requirement_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "swap_requirement" ADD CONSTRAINT "fk_swap_requirement_property_id" FOREIGN KEY("property_id")
REFERENCES "property" ("id");

ALTER TABLE "swap_requirement" ADD CONSTRAINT "fk_swap_requirement_property_type" FOREIGN KEY("property_type")
REFERENCES "global_property_type" ("id");

ALTER TABLE "swap_requirement" ADD CONSTRAINT "fk_swap_requirement_unit_types" FOREIGN KEY("unit_types")
REFERENCES "unit_type" ("id");

-- only linked from code new table
CREATE TABLE "entity_type" (
    "id" bigserial   NOT NULL,
    "name" varchar   NOT NULL,
    CONSTRAINT "pk_entity_type" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_entity_type_name" UNIQUE (
        "name"
    )
);

CREATE TABLE "global_media" (
    "id" bigserial   NOT NULL,
    "file_urls" varchar[]   NOT NULL,
    "gallery_type" varchar   NOT NULL,
    "media_type" bigint   NOT NULL,
    -- only linked from code
    "entity_id" bigint   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "gallery_type_ar" varchar NULL,
    CONSTRAINT "pk_global_media" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "global_media" ADD CONSTRAINT "fk_global_media_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

CREATE TABLE "global_documents" (
    "id" bigserial   NOT NULL,
    "documents_category_id" bigint   NOT NULL,
    "documents_subcategory_id" bigint   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    -- only linked from code
    "entity_id" bigint   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_global_documents" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "global_documents" ADD CONSTRAINT "fk_global_documents_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

-- default data -- don't remove
INSERT INTO "entity_type"(name)
VALUES('Project'),('Phase'),('Property'),('Exhibitions'),('Unit'),('Company'),('Profile'),('Freelancer'),('User'),('Holiday'),('Service'),('Open House'),('Schedule View'),('Unit Versions'),('Property Versions');




--  new tables for units
CREATE TABLE "units" (
    "id" bigserial   NOT NULL,
    "unit_no" varchar   NOT NULL,
    -- companies_id bigint FK >- companies.id
    "unitno_is_public" bool  DEFAULT false NOT NULL,
    "notes" varchar   NOT NULL,
    "unit_title" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NOT NULL,
    "unit_title_arabic" varchar   NOT NULL,
    "notes_arabic" varchar   NOT NULL,
    "notes_public" bool  DEFAULT false NOT NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "entity_type_id" bigint  NULL,
    -- linked by code
    "entity_id" bigint  NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "addresses_id" bigint   NOT NULL,
    -- countries_id bigint
    "unit_type_id" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
    "updated_by" bigint   NOT NULL,
    -- section varchar
    -- can be nullable
    "type_name_id" bigint    NULL,
    "owner_users_id" bigint   NULL,
    "from_xml" bool  DEFAULT false NOT NULL,
    "company_id" bigint  NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    -- new field for facts
    "facts" jsonb   NOT NULL,
    "is_project_unit" bool  DEFAULT false NOT NULL,
    "exclusive" boolean NOT NULL DEFAULT false,
    "start_date" DATE NULL,
    "end_date" DATE NULL,
    CONSTRAINT "pk_units" PRIMARY KEY (
        "id"
     )
);

-- add new record every time unit is added or updated
CREATE TABLE "unit_versions" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "views_count" bigint  DEFAULT 0  NOT NULL,
    "title_arabic" varchar   NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NULL,
    "unit_id" bigint   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "type" bigint   NOT NULL,
    -- need to add this for ranking
    "unit_rank" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "created_by" bigint   NOT NULL,
    "updated_by" bigint   NOT NULL,
    -- new field for facts
    "facts" jsonb   NOT NULL,
    -- if agent is null then owner user id
    "listed_by" bigint   NOT NULL,
    "has_gallery" boolean DEFAULT false,
    "has_plans" boolean DEFAULT false,
    "is_main" BOOLEAN DEFAULT FALSE NOT NULL,
    "is_verified" BOOLEAN DEFAULT FALSE NOT NULL,
    "exclusive" BOOLEAN DEFAULT FALSE NOT NULL,
    "start_date" DATE NULL,
    "end_date" DATE NULL,
    "slug" varchar(255) NOT NULL,
    "is_hotdeal" boolean NOT NULL DEFAULT false,
    "refreshed_at"timestamptz NULL,
    CONSTRAINT "pk_unit_versions" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_unit_versions_ref_no" UNIQUE (
        "ref_no"
    )
);

-- new table
CREATE TABLE "unit_versions_agents" (
    "id" bigserial   NOT NULL,
    "agent_id" bigint   NOT NULL,
    "unit_version_id" bigint   NOT NULL,
    CONSTRAINT "pk_unit_versions_agents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "unit_type" (
    "id" bigserial   NOT NULL,
    "type" varchar   NOT NULL,
    "code" varchar   NOT NULL,
    "facts" jsonb   NOT NULL,
    "listing_facts" bigint[] NOT NULL,
    -- unit_facts_id bigint[] FK >- unit_facts.id
    "usage" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint  DEFAULT 2 NOT NULL,
    "icon" varchar   NULL,
    "type_ar" varchar NULL,
    CONSTRAINT "pk_unit_type" PRIMARY KEY (
        "id"
     )
);
 
-- CREATE TABLE "unit_type_variation" (
--     "id" bigserial   NOT NULL,
--     "description" varchar   NOT NULL,
--     "min_area" float8   NOT NULL,
--     "max_area" float8   NOT NULL,
--     "min_price" float8   NOT NULL,
--     "max_price" float8   NOT NULL,
--     "parking" bigint  DEFAULT 0 NOT NULL,
--     "balcony" bigint  DEFAULT 0 NOT NULL,
--     "bedrooms" varchar   NULL,
--     "bathroom" varchar   NULL,
--     "property_id" bigint   NOT NULL,
--     -- facts jsonb
--     "title" varchar   NOT NULL,
--     "image_url" varchar[]   NOT NULL,
--     "description_ar" varchar   NULL,
--     "status" bigint  DEFAULT 1 NOT NULL,
--     "ref_no" varchar   NOT NULL,
--     "created_at" timestamptz  DEFAULT now() NOT NULL,
--     "updated_at" timestamptz  DEFAULT now() NOT NULL
-- );


ALTER TABLE "units" ADD CONSTRAINT "fk_units_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE "units" ADD CONSTRAINT "fk_units_unit_type_id" FOREIGN KEY("unit_type_id")
REFERENCES "unit_type" ("id");

ALTER TABLE "units" ADD CONSTRAINT "fk_units_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "units" ADD CONSTRAINT "fk_units_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "unit_versions" ADD CONSTRAINT "fk_unit_versions_unit_id" FOREIGN KEY("unit_id")
REFERENCES "units" ("id");

ALTER TABLE "unit_versions" ADD CONSTRAINT "fk_unit_versions_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "unit_versions" ADD CONSTRAINT "fk_unit_versions_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "unit_versions" ADD CONSTRAINT "fk_unit_versions_agent_id" FOREIGN KEY("agent_id")
REFERENCES "users" ("id");

ALTER TABLE "unit_versions_agents" ADD CONSTRAINT "fk_unit_versions_agents_agent_id" FOREIGN KEY("agent_id")
REFERENCES "users" ("id");

ALTER TABLE "unit_versions_agents" ADD CONSTRAINT "fk_unit_versions_agents_unit_version_id" FOREIGN KEY("unit_version_id")
REFERENCES "unit_versions" ("id");

-- ALTER TABLE "unit_type_variation" ADD CONSTRAINT "fk_unit_type_variation_property_id" FOREIGN KEY("property_id")
-- REFERENCES "property" ("id");




CREATE TABLE IF NOT EXISTS "plans" (
    "id" bigserial   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "title" varchar   NOT NULL,
    "file_urls" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "uploaded_by" bigint   NOT NULL,
    "updated_by" bigint   NOT NULL,
    CONSTRAINT "pk_plans" PRIMARY KEY (
        "id"
     )
);
 
 
ALTER TABLE "plans" ADD CONSTRAINT "fk_plans_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");
 
ALTER TABLE "plans" ADD CONSTRAINT "fk_plans_uploaded_by" FOREIGN KEY("uploaded_by")
REFERENCES "users" ("id");
 
ALTER TABLE "plans" ADD CONSTRAINT "fk_plans_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

CREATE TABLE "categories" (
    "id" bigserial   NOT NULL,
    "category" varchar   NOT NULL,
    -- status bigint
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_by" bigint   NOT NULL,
    "type" bigint NOT NULL,
    CONSTRAINT "pk_categories" PRIMARY KEY (
        "id"
     )
);

-- new table
CREATE TABLE "facilities_amenities" (
    "id" bigserial   NOT NULL,
    "icon_url" varchar   NOT NULL,
    "title" varchar   NOT NULL,
    "type" bigint   NOT NULL,
    -- Types:
    -- 1- Facility
    -- 2- Amenity
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "categories" bigint   NOT NULL,
    "updated_by" bigint   NOT NULL,
    "title_ar" varchar NULL,
    CONSTRAINT "pk_facilities_amenities" PRIMARY KEY (
        "id"
     )
);

-- new table
CREATE TABLE "facilities_amenities_entity" (
    "id" bigserial   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "facility_amenity_id" bigint   NOT NULL,
    CONSTRAINT "pk_facilities_amenities_entity" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "categories" ADD CONSTRAINT "fk_categories_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "facilities_amenities" ADD CONSTRAINT "fk_facilities_amenities_categories" FOREIGN KEY("categories")
REFERENCES "categories" ("id");

ALTER TABLE "facilities_amenities" ADD CONSTRAINT "fk_facilities_amenities_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "facilities_amenities_entity" ADD CONSTRAINT "fk_facilities_amenities_entity_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE "facilities_amenities_entity" ADD CONSTRAINT "fk_facilities_amenities_entity_facility_amenity_id" FOREIGN KEY("facility_amenity_id")
REFERENCES "facilities_amenities" ("id");

COMMENT ON COLUMN facilities_amenities.type IS '1=>Facility & 2=>Amenity';



-- new schema tables --


CREATE TABLE "global_property_type" (
    "id" bigserial   NOT NULL,
    "type" varchar   NOT NULL,
    "code" varchar   NOT NULL,
    "property_type_facts" jsonB NOT NULL,
    "listing_facts" bigint[] NOT NULL,
    "usage" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint  DEFAULT 2 NOT NULL,
    "icon" varchar   NULL,
    "is_project" bool DEFAULT false NOT NULL,
    "type_ar" varchar NULL,
    CONSTRAINT "pk_global_property_type" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE IF NOT EXISTS "property_versions" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "views_count" bigint  DEFAULT 0  NOT NULL,
    "title_arabic" varchar   NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NULL,
    "property_rank" bigint  DEFAULT 1 NOT NULL,
    "property_id" bigint   NOT NULL,
    "facts" jsonb   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_by" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "agent_id" bigint   NOT NULL,
    -- nullable
    "ref_no" varchar   NOT NULL,
    "category" bigint  DEFAULT 1 NOT NULL,
    "has_gallery" boolean DEFAULT false,
    "has_plans" boolean DEFAULT false,
    "is_main" BOOLEAN DEFAULT FALSE NOT NULL,
    "is_verified" BOOLEAN DEFAULT FALSE NOT NULL,
    "exclusive" BOOLEAN DEFAULT FALSE NOT NULL,
    "start_date" DATE NULL,
    "end_date" DATE NULL,
    "slug" varchar(255) NOT NULL,
    "is_hotdeal" boolean NOT NULL DEFAULT false,
    "refreshed_at"timestamptz NULL,
    CONSTRAINT "pk_property_versions" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_property_versions_ref_no" UNIQUE (
        "ref_no"
    )
);

CREATE TABLE "property_agents" (
    "id" bigserial   NOT NULL,
    "property_id" bigint   NOT NULL,
    "agent_id" bigint   NOT NULL, 
    "note" VARCHAR   NOT NULL,
    "assignment_date" timestamptz  DEFAULT now() NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_property_agents" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "unit_type_variation" (
    "id" bigserial   NOT NULL,
    "description" varchar   NOT NULL,
    "min_area" float8   NOT NULL,
    "max_area" float8   NOT NULL,
    "min_price" float8   NOT NULL,
    "max_price" float8   NOT NULL,
    "parking" bigint  DEFAULT 0 NOT NULL,
    "balcony" bigint  DEFAULT 0 NOT NULL,
    "bedrooms" varchar   NULL,
    "bathroom" varchar   NULL,
    "property_id" bigint   NOT NULL,
    "unit_type_id" bigint NOT NULL,
    -- unit_facts jsonB
    "title" varchar   NOT NULL,
    "image_url" varchar[]   NOT NULL,
    "description_ar" varchar   NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "ref_no" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "title_ar" varchar NULL,
    CONSTRAINT "pk_unit_type_variation" PRIMARY KEY (
        "id"
     )
);


ALTER TABLE "property_versions" ADD CONSTRAINT "fk_property_versions_property_id" FOREIGN KEY("property_id")
REFERENCES "property" ("id");

ALTER TABLE "property_versions" ADD CONSTRAINT "fk_property_versions_agent_id" FOREIGN KEY("agent_id")
REFERENCES "users" ("id");

ALTER TABLE "property_agents" ADD CONSTRAINT "fk_property_agents_property_id" FOREIGN KEY("property_id")
REFERENCES "property" ("id");

ALTER TABLE "property_agents" ADD CONSTRAINT "fk_property_agents_agent_id" FOREIGN KEY("agent_id")
REFERENCES "users" ("id");

ALTER TABLE "unit_type_variation" ADD CONSTRAINT "fk_unit_type_variation_property_id" FOREIGN KEY("property_id")
REFERENCES "property" ("id");

ALTER TABLE "unit_type_variation" ADD CONSTRAINT "fk_unit_type_variation_unit_type_id" FOREIGN KEY("unit_type_id")
REFERENCES "unit_type" ("id");

COMMENT ON COLUMN unit_versions.type IS '1=>Sale, 2=>Rent, 3=>Swap & 4=>Booking';
COMMENT ON COLUMN property_versions.category IS '1=>Sale, 2=>Rent & 3=>Swap';


CREATE TABLE "license" (
    "id" bigserial   NOT NULL,
    "license_file_url" varchar   NULL,
    "license_no" varchar   NOT NULL,
    "license_issue_date" timestamptz   NULL,
    "license_registration_date" timestamptz   NULL,
    "license_expiry_date" timestamptz   NULL,
    "license_type_id" bigint   NOT NULL,
    -- license_state_fields_id bigint FK >- state_license_fields.id
    "state_id" bigint   NOT NULL,
    -- new field
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    -- to store original filename, extension etc
    "metadata" jsonb   NULL,
    CONSTRAINT "pk_license" PRIMARY KEY (
        "id"
    ),
    CONSTRAINT "uc_license_license_no_entity_type_id" UNIQUE (
        "license_no","entity_type_id"
    )
);

CREATE TABLE "service_areas" (
    "id" bigserial   NOT NULL,
    "company_users_id" bigint   NOT NULL,
    -- address -> sub community
    "service_areas_id" bigint   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    CONSTRAINT "pk_service_areas" PRIMARY KEY (
        "id"
     )
);

-- new table
CREATE TABLE "license_type" (
    "id" bigserial   NOT NULL,
    "name" varchar   NOT NULL,
    CONSTRAINT "pk_license_type" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_license_type_name" UNIQUE (
        "name"
    )
);

-- default data -- don't remove
INSERT INTO license_type(
    name
)VALUES('Commercial License'),('Rera Number'),('ORN License'),('Extra License'),('BRN License'),('NOC License');

-- new table
CREATE TABLE "state_license_fields" (
    "id" bigserial   NOT NULL,
    "field_name" varchar   NOT NULL,
    -- trakhees_permit_no only for dubai
    -- license_dcci_no   only for dubai
    -- register_no  only for dubai
    "field_value" varchar   NOT NULL,
    "license_id" bigint   NOT NULL,
    CONSTRAINT "pk_state_license_fields" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_state_license_fields_field_value" UNIQUE (
        "field_value"
    )
);

ALTER TABLE "license" ADD CONSTRAINT "fk_license_license_type_id" FOREIGN KEY("license_type_id")
REFERENCES "license_type" ("id");

ALTER TABLE "license" ADD CONSTRAINT "fk_license_state_id" FOREIGN KEY("state_id")
REFERENCES "states" ("id");

ALTER TABLE "license" ADD CONSTRAINT "fk_license_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE "state_license_fields" ADD CONSTRAINT "fk_state_license_fields_license_id" FOREIGN KEY("license_id")
REFERENCES "license" ("id");


CREATE TABLE "company_category" (
    "id" bigserial   NOT NULL,
    "category_name" varchar   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- fk - users.id
    "updated_by" bigint   NULL,
    "status" bigint DEFAULT 2 NOT NULL,
    "company_type" bigint NOT NULL,
    "category_name_ar" varchar NULL,
    CONSTRAINT "pk_company_category" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_category_category_name_company_type" UNIQUE (
        "category_name",
        "company_type"
    )
);

ALTER TABLE "company_category" ADD CONSTRAINT "fk_company_category_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "service_areas" ADD CONSTRAINT "fk_service_areas_company_users_id" FOREIGN KEY("company_users_id")
REFERENCES "company_users" ("id");

ALTER TABLE "service_areas" ADD CONSTRAINT "fk_service_areas_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE "service_areas" ADD CONSTRAINT "fk_service_areas_service_areas_id" FOREIGN KEY("service_areas_id")
REFERENCES "sub_communities" ("id");

ALTER TABLE "company_activities" ADD CONSTRAINT "fk_company_activities_company_category_id" FOREIGN KEY("company_category_id")
REFERENCES "company_category" ("id");

ALTER TABLE "company_activities" ADD CONSTRAINT "fk_company_activities_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

CREATE TABLE "social_media_profile" (
    "id" bigserial   NOT NULL,
    "social_media_name" varchar  NOT NULL,
    "social_media_url" varchar   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    CONSTRAINT "pk_social_media_profile" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "social_media_profile" ADD CONSTRAINT "fk_social_media_profile_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

CREATE TABLE "real_estate_agents" (
    "id" bigserial   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    -- linked by code
    "entity_id" bigint   NOT NULL,
    "agent_id" bigint   NOT NULL,
    "note" varchar   NOT NULL,
    "assignment_date" timestamptz  DEFAULT now() NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_real_estate_agents" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "real_estate_agents" ADD CONSTRAINT "fk_real_estate_agents_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE "real_estate_agents" ADD CONSTRAINT "fk_real_estate_agents_agent_id" FOREIGN KEY("agent_id")
REFERENCES "company_users" ("id");


CREATE TABLE "company_review" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_id" bigint   NOT NULL,
    "customer_service" int   NOT NULL,
    "staff_courstesy" int   NOT NULL,
    "implementation" int   NOT NULL,
    "quality" int   NOT NULL,
    "review_description" varchar   NOT NULL,
    "proof_images" varchar[]   NOT NULL,
    "reviewed_by" bigint   NOT NULL,
    "reviewed_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_company_review" PRIMARY KEY (
        "id"
     )
);

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

ALTER TABLE "company_review" ADD CONSTRAINT "fk_company_review_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");

ALTER TABLE "company_review" ADD CONSTRAINT "fk_company_review_reviewed_by" FOREIGN KEY("reviewed_by")
REFERENCES "users" ("id");

ALTER TABLE "user_review" ADD CONSTRAINT "fk_user_review_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "user_review" ADD CONSTRAINT "fk_user_review_reviewed_by" FOREIGN KEY("reviewed_by")
REFERENCES "users" ("id");

COMMENT ON COLUMN timeslots.entity_type_id IS 'only 12=>Open House or 13=> Schedule View';

CREATE TABLE "payment_plans" (
    "id" bigserial   NOT NULL,
    "reference_no" varchar   NOT NULL,
    "payment_plan_title" varchar   NOT NULL,
    "no_of_installments" bigint   NOT NULL,
    "is_enabled" bool DEFAULT TRUE NOT NULL,
    CONSTRAINT "pk_payment_plans" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "plan_installments" (
    "id" bigserial   NOT NULL,
    "payment_plans" bigint   NOT NULL,
    "percentage" varchar   NOT NULL,
    "date" timestamptz   NULL,
    "milestone" varchar   NOT NULL,
    CONSTRAINT "pk_plan_installments" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "payment_plans_packages" (
    "id" bigserial   NOT NULL,
    "no_of_plans" bigint   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    -- FK - payment_plans.id
    "payment_plans_id" bigint[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_payment_plans_packages" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "plan_installments" ADD CONSTRAINT "fk_plan_installments_payment_plans" FOREIGN KEY("payment_plans")
REFERENCES "payment_plans" ("id");

ALTER TABLE "payment_plans_packages" ADD CONSTRAINT "fk_payment_plans_packages_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");


CREATE TABLE "real_estate_history" (
    "id" bigserial   NOT NULL,
    "category" bigint   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "price" float   NOT NULL,
    "payment_type" bigint   NULL,
    -- for sale & rent
    "effectivity_date" timestamptz   NOT NULL,
    "contract_end" timestamptz   NULL,
    CONSTRAINT "pk_real_estate_history" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "real_estate_history" ADD CONSTRAINT "fk_real_estate_history_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");



--  adding departments and their roles .....



CREATE TABLE "department" (
    "id" bigserial   NOT NULL,
    "department" varchar(255)   NOT NULL,
    "department_ar" varchar NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    -- FK - companies.id
    "company_id" bigint   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_department" PRIMARY KEY (
        "id"
     )
);


CREATE TABLE "roles" (
    "id" bigserial   NOT NULL,
    "role" varchar(255)   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "department_id" bigint  NULL,
    "role_ar" varchar  NULL,
    CONSTRAINT "pk_roles" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "roles" ADD CONSTRAINT "fk_roles_department_id" FOREIGN KEY("department_id")
REFERENCES "department" ("id");


-------------- Subscription New Table----------------

CREATE TABLE "subscription_products" (
    "id" bigserial   NOT NULL,
    "product" varchar   NOT NULL,
    -- country_id bigint FK >- countries.id
    -- company_type_id bigserial
    "icon_url" varchar    NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_subscription_products" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "draft_contracts" (
    "id" bigserial   NOT NULL,
    "subscriber_type" int   NOT NULL,
    -- FK >-  company_types.id
    "company_type_id" bigserial   NOT NULL,
    -- FK >-  main_services.id
    "company_main_service" bigserial   NOT NULL,
    -- FK >-  user_types.id
    "user_type_id" bigserial   NOT NULL,
    "file_url" varchar[]   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_draft_contracts" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "subscription_order" (
    "id" bigserial   NOT NULL,
    "order_no" varchar   NOT NULL,
    -- could be company or user
    "subscriber_id" bigint   NOT NULL,
    -- company/user
    "subscriber_type" bigint   NOT NULL,
    "start_date" timestamptz   NULL,
    "end_date" timestamptz   NULL,
    "sign_date" timestamptz   NULL,
    "total_amount" float   NOT NULL,
    "vat" float   NOT NULL,
    "no_of_payments" bigint   NOT NULL,
    -- Monthly - Bi Anual - Yearly
    "payment_plan" bigint   NULL,
    "notes" varchar   NOT NULL,
    -- Active - Inavtive
    "status" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "draft_contract" varchar NOT NULL,
    "contract_file" varchar NULL,
    CONSTRAINT "pk_subscription_order" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "subscription_package" (
    "id" bigserial   NOT NULL,
    "subscription_order_id" bigint   NOT NULL,
    "product" bigint   NOT NULL,
    "no_of_products" bigint   NOT NULL,
    "original_price_per_unit" float NOT NULL,
    "product_discount" float   NOT NULL,
    "start_date" timestamptz   NULL,
    "end_date" timestamptz   NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_subscription_package" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "payments" (
    "id" bigserial   NOT NULL,
    "order_id" bigint   NOT NULL,
    "due_date" timestamptz  NOT NULL,
    "payment_method" bigint   NULL,
    "amount" float   NOT NULL,
    "payment_date" timestamptz   NULL,
    "bank" varchar   NULL,
    "cheque_no" varchar   NULL,
    "reference_no" varchar NULL,
    "invoice_file" varchar   NULL,
    "status" bigint DEFAULT 1  NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_payments" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "agent_products" (
    "id" bigserial   NOT NULL,
    "company_user_id" bigint   NOT NULL,
    "product" bigint   NOT NULL,
    "no_of_products" int   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_agent_products" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "subscription_cost" (
    "id" bigserial   NOT NULL,
    "countries_id" bigint   NOT NULL,
    "subscriber_type_id" bigint   NOT NULL,
    -- category id is the company main service
    "category_id" bigint   NULL,
    "product" bigint   NOT NULL,
    "price_per_unit" float   NOT NULL, 
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_subscription_cost" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "subscription_products" ADD CONSTRAINT "fk_subscription_products_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "draft_contracts" ADD CONSTRAINT "fk_draft_contracts_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "subscription_order" ADD CONSTRAINT "fk_subscription_order_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "subscription_package" ADD CONSTRAINT "fk_subscription_package_subscription_order_id" FOREIGN KEY("subscription_order_id")
REFERENCES "subscription_order" ("id");

ALTER TABLE "subscription_package" ADD CONSTRAINT "fk_subscription_package_product" FOREIGN KEY("product")
REFERENCES "subscription_products" ("id");

ALTER TABLE "subscription_package" ADD CONSTRAINT "fk_subscription_package_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "payments" ADD CONSTRAINT "fk_payments_order_id" FOREIGN KEY("order_id")
REFERENCES "subscription_order" ("id");

ALTER TABLE "payments" ADD CONSTRAINT "fk_payments_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "agent_products" ADD CONSTRAINT "fk_agent_products_company_user_id" FOREIGN KEY("company_user_id")
REFERENCES "company_users" ("id");

ALTER TABLE "agent_products" ADD CONSTRAINT "fk_agent_products_product" FOREIGN KEY("product")
REFERENCES "subscription_products" ("id");

ALTER TABLE "agent_products" ADD CONSTRAINT "fk_agent_products_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "subscription_cost" ADD CONSTRAINT "fk_subscription_cost_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "subscription_cost" ADD CONSTRAINT "fk_subscription_cost_product" FOREIGN KEY("product")
REFERENCES "subscription_products" ("id");

ALTER TABLE "subscription_cost" ADD CONSTRAINT "fk_subscription_cost_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

CREATE TABLE "subscription_consuming" (
    "id" bigserial   NOT NULL,
    "package_id" bigint   NOT NULL,
    "user_id" bigint   NOT NULL,
    "product" bigint   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "consumed_at" timestamptz   NOT NULL,
    CONSTRAINT "pk_subscription_consuming" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "subscription_consuming" ADD CONSTRAINT "fk_subscription_consuming_package_id" FOREIGN KEY("package_id")
REFERENCES "subscription_package" ("id");

ALTER TABLE "subscription_consuming" ADD CONSTRAINT "fk_subscription_consuming_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "subscription_consuming" ADD CONSTRAINT "fk_subscription_consuming_product" FOREIGN KEY("product")
REFERENCES "subscription_products" ("id");

ALTER TABLE "subscription_consuming" ADD CONSTRAINT "fk_subscription_consuming_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");
-----------------------------------------


-- Drop the existing materialized view if it exists

-- Drop the existing materialized view if it exists

DROP MATERIALIZED VIEW IF EXISTS hierarchical_location_view;

CREATE MATERIALIZED VIEW hierarchical_location_view AS

WITH RECURSIVE location_hierarchy AS (
    -- Country level
    SELECT 
        co.id AS location_id,
        co.id AS country_id,
        0::bigint AS state_id,
        0::bigint AS city_id,
        0::bigint AS community_id,
        0::bigint AS sub_community_id,
        0::bigint AS property_map_id,
        co.country AS last_attribute,
        co.country AS location_string,
        co.country AS location_without,
        1 AS level,
        setweight(to_tsvector('simple', coalesce(co.country,'')), 'A') AS search_vector
    FROM countries co

    UNION ALL

    -- State level
    SELECT 
        s.id,
        co.id,
        s.id,
        0::bigint,
        0::bigint,
        0::bigint,
        0::bigint AS property_map_id,
        s.state,
        s.state || ', ' || co.country,
        co.country,
        2,
        setweight(to_tsvector('simple', coalesce(co.country,'')), 'A') ||
        setweight(to_tsvector('simple', coalesce(s.state,'')), 'B')
    FROM states s
    JOIN countries co ON s.countries_id = co.id

    UNION ALL

    -- City level
    SELECT 
        c.id,
        co.id,
        s.id,
        c.id,
        0::bigint,
        0::bigint,
        0::bigint AS property_map_id,
        c.city,
        c.city || ', ' || s.state,
        s.state,
        3,
        setweight(to_tsvector('simple', coalesce(co.country,'')), 'A') ||
        setweight(to_tsvector('simple', coalesce(s.state,'')), 'B') ||
        setweight(to_tsvector('simple', coalesce(c.city,'')), 'C')
    FROM cities c
    JOIN states s ON c.states_id = s.id
    JOIN countries co ON s.countries_id = co.id

    UNION ALL

    -- Community level
    SELECT 
        cm.id,
        co.id,
        s.id,
        c.id,
        cm.id,
        0::bigint,
        0::bigint AS property_map_id,
        cm.community,
        cm.community || ', ' || c.city || ', ' || s.state,
        c.city || ', ' || s.state,
        4,
        setweight(to_tsvector('simple', coalesce(co.country,'')), 'A') ||
        setweight(to_tsvector('simple', coalesce(s.state,'')), 'B') ||
        setweight(to_tsvector('simple', coalesce(c.city,'')), 'C') ||
        setweight(to_tsvector('simple', coalesce(cm.community,'')), 'D')
    FROM communities cm
    JOIN cities c ON cm.cities_id = c.id
    JOIN states s ON c.states_id = s.id
    JOIN countries co ON s.countries_id = co.id

    UNION ALL

    -- Sub-community level
    SELECT 
        sc.id,
        co.id,
        s.id,
        c.id,
        cm.id,
        sc.id,
        0::bigint AS property_map_id,
        sc.sub_community,
        sc.sub_community || ', ' || cm.community || ', ' || c.city || ', ' || s.state,
        cm.community || ', ' || c.city || ', ' || s.state,
        5,
        setweight(to_tsvector('simple', coalesce(co.country,'')), 'A') ||
        setweight(to_tsvector('simple', coalesce(s.state,'')), 'B') ||
        setweight(to_tsvector('simple', coalesce(c.city,'')), 'C') ||
        setweight(to_tsvector('simple', coalesce(cm.community,'')), 'D') ||
        setweight(to_tsvector('simple', coalesce(sc.sub_community,'')), 'D')
    FROM sub_communities sc
    JOIN communities cm ON sc.communities_id = cm.id
    JOIN cities c ON cm.cities_id = c.id
    JOIN states s ON c.states_id = s.id
    JOIN countries co ON s.countries_id = co.id

    UNION ALL

    -- properties-map-location level
    SELECT 
        pm.id,
        co.id,
        s.id,
        c.id,
        cm.id,
        sc.id,
        pm.id,
        pm.property,
        pm.property || ', ' || sc.sub_community || ', ' || cm.community || ', ' || c.city || ', ' || s.state,
        sc.sub_community || ', ' || cm.community || ', ' || c.city || ', ' || s.state,
        6,
        setweight(to_tsvector('simple', coalesce(co.country,'')), 'A') ||
        setweight(to_tsvector('simple', coalesce(s.state,'')), 'B') ||
        setweight(to_tsvector('simple', coalesce(c.city,'')), 'C') ||
        setweight(to_tsvector('simple', coalesce(cm.community,'')), 'D') ||
        setweight(to_tsvector('simple', coalesce(sc.sub_community,'')), 'D') ||
        setweight(to_tsvector('simple', coalesce(pm.property,'')), 'D')
    FROM properties_map_location pm
    JOIN sub_communities sc ON pm.sub_communities_id = sc.id
    JOIN communities cm ON sc.communities_id = cm.id
    JOIN cities c ON cm.cities_id = c.id
    JOIN states s ON c.states_id = s.id
    JOIN countries co ON s.countries_id = co.id
)
SELECT 
ROW_NUMBER() OVER (ORDER BY level, country_id, state_id, city_id, community_id, sub_community_id, property_map_id) AS id,
    location_id,
    country_id,
    state_id,
    city_id,
    community_id,
    sub_community_id,
    property_map_id,
    last_attribute,
    location_string,
    location_without,
    level,
    search_vector
FROM location_hierarchy;

-- Create indexes
CREATE UNIQUE INDEX ON hierarchical_location_view (id);
CREATE INDEX hierarchical_location_view_location_id_idx ON hierarchical_location_view (location_id);
CREATE INDEX hierarchical_location_view_country_idx ON hierarchical_location_view (country_id);
CREATE INDEX hierarchical_location_view_state_idx ON hierarchical_location_view (state_id);
CREATE INDEX hierarchical_location_view_city_idx ON hierarchical_location_view (city_id);
CREATE INDEX hierarchical_location_view_community_idx ON hierarchical_location_view (community_id);
CREATE INDEX hierarchical_location_view_sub_community_idx ON hierarchical_location_view (sub_community_id);
CREATE INDEX hierarchical_location_view_property_map_idx ON hierarchical_location_view (property_map_id);
CREATE INDEX hierarchical_location_view_location_string_idx ON hierarchical_location_view USING gin (location_string gin_trgm_ops);
CREATE INDEX hierarchical_location_view_level_idx ON hierarchical_location_view (level);
CREATE INDEX hierarchical_location_view_search_idx ON hierarchical_location_view USING gin(search_vector);
-- new index for new fields
CREATE INDEX hierarchical_location_view_last_attribute_idx ON hierarchical_location_view USING gin (last_attribute gin_trgm_ops);
CREATE INDEX hierarchical_location_view_location_without_idx ON hierarchical_location_view USING gin (location_without gin_trgm_ops);

-- default data -- don't remove -- 11 is super admin id for current scenario
INSERT INTO subscription_products(
    product,created_by
)VALUES('Standard',11),('Featured',11),('Premium',11),('Top Deals',11);


COMMENT ON COLUMN payments.status IS '1=>unpaid & 2=>paid';

ALTER TABLE publish_listing ADD CONSTRAINT fk_entity_type FOREIGN KEY (entity_type_id)
REFERENCES entity_type(id);





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


--------------------------- career new schema ---------------------------
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
    "rank" bigint   NOT NULL,
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
--------------------------end of career new schema ----------------------

------------------- company verification newschema -----------------------------
 




-- 18-10-2024
CREATE TABLE "company_verification" (
    "id" bigserial   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "verification_type" bigint   NOT NULL,
    -- registration_date timestamptz
    -- 1-Approve 2-Reject
    "verification" int   NOT NULL,
    "response_date" timestamptz   NOT NULL,
    "updated_by" bigint   NOT NULL,
    "notes" varchar   NOT NULL,
    -- finance_verification int
    -- finance_response_date timestamptz
    -- finance_user bigint FK >- company_users.id
    -- finance_notes varchar

    -- "contract_file" varchar   NULL,
    -- "contract_upload_date" timestamptz   NULL,
    -- "uploaded_by" bigint   NULL,
    -- "upload_notes" varchar   NULL,
    "created_at" timestamptz DEFAULT now() NOT NULL,
    -- "draft_contract" varchar NULL,
    CONSTRAINT "pk_company_verification" PRIMARY KEY (
        "id"
     )
);



ALTER TABLE "company_verification" ADD CONSTRAINT "fk_company_verification_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE "company_verification" ADD CONSTRAINT "fk_company_verification_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "company_verification" ADD CONSTRAINT "fk_company_verification_uploaded_by" FOREIGN KEY("uploaded_by")
REFERENCES "users" ("id");
  
  
  
----------------end of company verification newschema----------------------------

--------------------------- mortgage newschema ----------------------------------

CREATE TABLE "bank_listing" (
    "id" bigserial   NOT NULL,
    "name" varchar   NOT NULL,
    -- address_id bigint FK >- addresses.id
    "bank_logo_url" varchar   NOT NULL,
    "bank_url" varchar   NOT NULL,
    -- branch_name varchar
    "fixed_interest_rate" float   NOT NULL,
    "bank_process_fee" float   NOT NULL,
    "mail" varchar   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz   NOT NULL,
    "updated_at" timestamptz   NOT NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    "country_id" bigint NOT NULL,
    CONSTRAINT "pk_bank_listing" PRIMARY KEY (
        "id"
     )
);
 
 
CREATE TABLE "bank_branches" (
    "id" bigserial   NOT NULL,
    "bank_id" bigint   NOT NULL,
    "branch_name" varchar   NOT NULL,
    "phone" varchar   NOT NULL,
    "is_main_branch" bool   NOT NULL,
    "address_id" bigint   NOT NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_bank_branches" PRIMARY KEY (
        "id"
     )
);
 
 
CREATE TABLE "mortagage" (
    "id" bigserial   NOT NULL,
    "entity_type_id" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "type" bigint   NOT NULL,
    -- fixed
    -- variable
    "employement_type" bigint   NOT NULL,
    -- salaried uae national
    -- self employed uae national
    -- salaried uae resident
    -- self employed uae resident
    -- non resident
    "age" bigint   NOT NULL,
    "monthly_income" float   NOT NULL,
    "interest_rate" float   NOT NULL,
    "loan_duration" float   NOT NULL,
    "down_payment" float   NOT NULL,
    "created_by" bigint   NULL,
    "created_at" timestamptz   NOT NULL,
    "updated_at" timestamptz   NOT NULL,
    CONSTRAINT "pk_mortagage" PRIMARY KEY (
        "id"
     )
);
 
 
ALTER TABLE "bank_listing" ADD CONSTRAINT "fk_bank_listing_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");
 
 
ALTER TABLE "bank_branches" ADD CONSTRAINT "fk_bank_branches_bank_id" FOREIGN KEY("bank_id")
REFERENCES "bank_listing" ("id");
 
ALTER TABLE "bank_branches" ADD CONSTRAINT "fk_bank_branches_address_id" FOREIGN KEY("address_id")
REFERENCES "addresses" ("id");
 
 
ALTER TABLE "mortagage" ADD CONSTRAINT "fk_mortagage_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

-----------------------end of mortgage newschema --------------------------------



-------------------------------------   New Share Tables    -----------------------------------------------------------

 
CREATE TABLE sharing (
    id BIGSERIAL PRIMARY KEY,
    sharing_type INT NOT NULL,
    entity_type_id BIGINT REFERENCES entity_type(id),
    entity_id BIGINT NOT NULL,
    shared_to BIGINT NOT NULL,
    is_enabled BOOLEAN DEFAULT TRUE, 
    country_id bigint NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    created_by BIGINT REFERENCES users(id),
    CONSTRAINT valid_sharing_type CHECK (sharing_type IN (1, 2))  -- 1: internal, 2: external
);

-- Documents table
CREATE TABLE shared_documents (
    id BIGSERIAL PRIMARY KEY,
    sharing_id BIGINT REFERENCES sharing(id),
    category_id BIGINT REFERENCES documents_category(id),
    subcategory_id BIGINT REFERENCES documents_subcategory(id),
    file_url VARCHAR NOT NULL,
    status INT DEFAULT 1,
    is_allowed BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(sharing_id, file_url)
);

-- Share requests table
CREATE TABLE share_requests (
    id BIGSERIAL PRIMARY KEY,
    document_id BIGINT REFERENCES shared_documents(id),
    request_status INT NOT NULL DEFAULT 1,
    requester_id BIGINT REFERENCES users(id),
    owner_id BIGINT REFERENCES users(id),
    created_by BIGINT REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);


CREATE INDEX idx_sharing_entity ON sharing(entity_type_id, entity_id);
CREATE INDEX idx_sharing_shared_to ON sharing(shared_to);
CREATE INDEX idx_shared_documents_sharing ON shared_documents(sharing_id);
CREATE INDEX idx_shared_documents_category ON shared_documents(category_id, subcategory_id);
CREATE INDEX idx_shared_documents_status ON shared_documents(status);
CREATE INDEX idx_share_requests_document ON share_requests(document_id);
CREATE INDEX idx_share_requests_status ON share_requests(request_status);
CREATE INDEX idx_share_requests_requester ON share_requests(requester_id);


CREATE TYPE sharing_type AS ENUM ('internal', 'external');




------------------------------------------------ Review Tables ------------------------------------------------

-- Create entity_review table if it doesn't exist
CREATE TABLE IF NOT EXISTS "entity_review" (
    "id" bigserial NOT NULL,
    "entity_type_id" bigint NOT NULL,
    "entity_id" bigint NOT NULL,
    "description" varchar NOT NULL,
    "title" varchar NOT NULL,
    "reviewer" bigint NOT NULL,
    "review_date" timestamptz DEFAULT now() NOT NULL,
    "image_url" VARCHAR[] NULL,
    "overall_avg" float NOT NULL DEFAULT 0.0, 
    CONSTRAINT "pk_entity_review" PRIMARY KEY ("id")
);

-- Create review_terms table if it doesn't exist
CREATE TABLE IF NOT EXISTS "review_terms" (
    "id" bigserial NOT NULL,
    "entity_type_id" bigint NOT NULL,
    "review_term" varchar NOT NULL,
    "review_term_ar" varchar NULL,
    "status" bigint NOT NULL DEFAULT 2,
    "created_at" timestamptz NOT NULL DEFAULT now(),
    "updated_at" timestamptz NOT NULL DEFAULT now(),
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

CREATE TABLE "swap_requirement" (
    "id" bigserial   NOT NULL,
    -- addresses_id bigint FK >- addresses.id
    -- property_id bigint FK >- property.id
    "entity_type" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "category" bigint   NOT NULL,
    -- if the category isn't unit this field required
    "property_type" bigint   NULL,
    -- if the category is unit this field required
    "unit_types" bigint   NULL,
    "no_of_bathrooms" bigint   NULL,
    "no_of_bedrooms" bigint   NULL,
    "min_plot_area" float   NULL,
    "max_plot_area" float   NULL,
    "completion_status" int   NULL,
    "min_no_of_units" bigint   NULL,
    "max_no_of_units" bigint   NULL,
    "min_no_of_floors" bigint   NULL,
    "max_no_of_floors" bigint   NULL,
    "views" bigint[]   NULL,
    "min_no_of_parkings" bigint   NULL,
    "max_no_of_parkings" bigint   NULL,
    "min_built_up_area" bigint   NULL,
    "max_built_up_area" bigint   NULL,
    "min_price" bigint   NULL,
    "max_price" bigint   NULL,
    "ownership" bigint   NOT NULL,
    "furnished" bigint   NULL,
    "mortgage" bool   NOT NULL,
    "notes" varchar   NULL,
    "notes_arabic" varchar   NULL,
    "is_notes_public" bool   NOT NULL,
    CONSTRAINT "pk_swap_requirement" PRIMARY KEY (
        "id"
     )
);
 
CREATE TABLE "swap_requirment_address" (
    "id" bigserial   NOT NULL,
    "swap_requirment_id" bigint   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    CONSTRAINT "pk_swap_requirment_address" PRIMARY KEY (
        "id"
     )
);
 
 
ALTER TABLE "swap_requirement" ADD CONSTRAINT "fk_swap_requirement_entity_type" FOREIGN KEY("entity_type")
REFERENCES "entity_type" ("id");
 
ALTER TABLE "swap_requirment_address" ADD CONSTRAINT "fk_swap_requirment_address_swap_requirment_id" FOREIGN KEY("swap_requirment_id")
REFERENCES "swap_requirement" ("id");

CREATE TABLE "platform_contacts" (
    "id" bigserial   NOT NULL,
    "name" varchar(255) NOT NULL,
    "email" varchar(255) NOT NULL,
    "message" varchar(255) NOT NULL,
    "platform" bigserial  NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "preferred_email" bool NOT NULL DEFAULT false,
    "preferred_phone" bool NOT NULL DEFAULT false,
    "purpose" varchar NOT NULL,
    "phone_number" varchar NULL,
    "country_code" varchar NULL,
     CONSTRAINT "pk_platform_contacts" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "listing_request" (
    "id" bigserial   NOT NULL,
    "entity_type" bigint   NOT NULL,
    "category" bigint   NOT NULL,
    -- 1- Sale
    -- 2- Rent
    -- 3- Swap
    "property_type" bigint   NULL,
    "unit_type" bigint   NULL,
    "name" varchar  NULL,
    "addresses_id" bigint   NOT NULL,
    "phone_number" varchar   NOT NULL,
    "title" varchar   NOT NULL,
    "description" varchar  NULL,
    "images" varchar[]   NOT NULL,
    "facts" jsonb NOT NULL,
    "platform" bigint   NOT NULL,
    "usage"  bigint   NOT NULL,
    CONSTRAINT "pk_listing_request" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "listing_request" ADD CONSTRAINT "fk_listing_request_entity_type" FOREIGN KEY("entity_type")
REFERENCES "entity_type" ("id");

ALTER TABLE "listing_request" ADD CONSTRAINT "fk_listing_request_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");


CREATE TABLE "properties_map_location" (
    "id" bigserial   NOT NULL,
    "property" varchar   NOT NULL,
    "sub_communities_id" bigint   NOT NULL,
    "lat" float   NOT NULL,
    "lng" float   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NULL,
    "status" bigint NOT NULL,
    "deleted_at" timestamptz NULL,
    "updated_by" bigint NOT NULL,
    "property_ar" varchar NULL,
    CONSTRAINT "pk_properties_map_location" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "properties_map_location" ADD CONSTRAINT "fk_properties_map_location_sub_communities_id" FOREIGN KEY("sub_communities_id")
REFERENCES "sub_communities" ("id");


CREATE TABLE "toggles_check" (
    "id" bigserial   NOT NULL,
    "entity_type" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "status_type" int   NOT NULL,
    -- 1- Verify
    -- 2- Exclusive
    -- 3- Leased
    "start_date" timestamptz   NOT NULL,
    "end_date" timestamptz   NULL,
    "company_id" bigint   NULL,
    "doc" VARCHAR[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_toggles_check" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "toggles_check" ADD CONSTRAINT "fk_toggles_check_entity_type" FOREIGN KEY("entity_type")
REFERENCES "entity_type" ("id");

COMMENT ON COLUMN license.metadata IS 'to store the filename,extension etc.';

-- it has to be unique so they will not conflict with each other
ALTER SEQUENCE section_permission_id_seq RESTART WITH 1;
ALTER SEQUENCE permissions_id_seq RESTART WITH 300;
ALTER SEQUENCE sub_section_id_seq RESTART WITH 1300;

-- materialized view for property quality score
DROP MATERIALIZED VIEW IF EXISTS property_quality_score;
CREATE MATERIALIZED VIEW property_quality_score AS
SELECT p.id AS property_id, pv.id AS property_version_id,
    LEAST(length(pv.title::text)::numeric / 60.0 * 100::numeric, 100::numeric) AS title_quality,
    LEAST(length(pv.description::text)::numeric / 2000.0 * 100::numeric, 100::numeric) AS description_quality,
    LEAST(COALESCE(count(gm.id), 0::bigint)::numeric / 30.0 * 100::numeric, 100::numeric) AS media_quality,
    LEAST((
        CASE
            WHEN a.countries_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.cities_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.communities_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.sub_communities_id IS NOT NULL THEN 1
            ELSE 0
        END)::numeric / 4.0 * 100::numeric, 100::numeric) AS address_quality,
    (LEAST(length(pv.title::text)::numeric / 60.0 * 100::numeric, 100::numeric) + LEAST(length(pv.description::text)::numeric / 2000.0 * 100::numeric, 100::numeric) + LEAST(COALESCE(count(gm.id), 0::bigint)::numeric / 30.0 * 100::numeric, 100::numeric) + LEAST((
        CASE
            WHEN a.countries_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.cities_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.communities_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.sub_communities_id IS NOT NULL THEN 1
            ELSE 0
        END)::numeric / 4.0 * 100::numeric, 100::numeric)) / 4::numeric AS quality_score
   FROM property p
   LEFT JOIN property_versions pv ON pv.property_id = p.id
     LEFT JOIN addresses a ON p.addresses_id = a.id
     LEFT JOIN global_media gm ON (
     CASE WHEN pv.has_gallery = true THEN gm.entity_type_id = 15 AND gm.entity_id = pv.id 
     ELSE gm.entity_type_id = 3 AND gm.entity_id = p.id END
     )
  GROUP BY p.id,pv.id, pv.title, pv.description, a.countries_id, a.cities_id, a.communities_id, a.sub_communities_id;

-- Function to refresh the materialized view
CREATE OR REPLACE FUNCTION refresh_property_quality_score()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW property_quality_score;
END;
$$ LANGUAGE plpgsql;


-- materialized view for unit quality score
DROP MATERIALIZED VIEW IF EXISTS unit_quality_score;
CREATE MATERIALIZED VIEW unit_quality_score AS
SELECT u.id AS unit_id, uv.id AS unit_version_id,
    LEAST(length(uv.title::text)::numeric / 60.0 * 100::numeric, 100::numeric) AS title_quality,
    LEAST(length(uv.description::text)::numeric / 2000.0 * 100::numeric, 100::numeric) AS description_quality,
    LEAST(COALESCE(count(gm.id), 0::bigint)::numeric / 30.0 * 100::numeric, 100::numeric) AS media_quality,
    LEAST((
        CASE
            WHEN a.countries_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.cities_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.communities_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.sub_communities_id IS NOT NULL THEN 1
            ELSE 0
        END)::numeric / 4.0 * 100::numeric, 100::numeric) AS address_quality,
    (LEAST(length(uv.title::text)::numeric / 60.0 * 100::numeric, 100::numeric) + 
     LEAST(length(uv.description::text)::numeric / 2000.0 * 100::numeric, 100::numeric) + 
     LEAST(COALESCE(count(gm.id), 0::bigint)::numeric / 30.0 * 100::numeric, 100::numeric) + 
     LEAST((
        CASE
            WHEN a.countries_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.cities_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.communities_id IS NOT NULL THEN 1
            ELSE 0
        END +
        CASE
            WHEN a.sub_communities_id IS NOT NULL THEN 1
            ELSE 0
        END)::numeric / 4.0 * 100::numeric, 100::numeric)) / 4::numeric AS quality_score
   FROM units u
   LEFT JOIN unit_versions uv ON uv.unit_id = u.id
   LEFT JOIN addresses a ON u.addresses_id = a.id
   LEFT JOIN global_media gm ON (
   CASE WHEN uv.has_gallery = true THEN gm.entity_type_id = 14 AND gm.entity_id = uv.id 
   ELSE gm.entity_type_id = 5 AND gm.entity_id = u.id END
   )
  GROUP BY u.id, uv.id, uv.title, uv.description, a.countries_id, a.cities_id, a.communities_id, a.sub_communities_id;

-- Function to refresh the materialized view
CREATE OR REPLACE FUNCTION refresh_unit_quality_score()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW unit_quality_score;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_full_address() 
RETURNS TRIGGER AS $$
BEGIN
    -- Start building the address from the country, state, and city
    NEW.full_address := 
        COALESCE((SELECT country FROM countries WHERE id = NEW.countries_id), '') ||
        CASE WHEN COALESCE((SELECT country FROM countries WHERE id = NEW.countries_id), '') <> '' THEN ', ' ELSE '' END ||
        COALESCE((SELECT state FROM states WHERE id = NEW.states_id), '') ||
        CASE WHEN COALESCE((SELECT state FROM states WHERE id = NEW.states_id), '') <> '' THEN ', ' ELSE '' END ||
        COALESCE((SELECT city FROM cities WHERE id = NEW.cities_id), '') ||
        CASE WHEN COALESCE((SELECT city FROM cities WHERE id = NEW.cities_id), '') <> '' THEN ', ' ELSE '' END ||
        COALESCE((SELECT community FROM communities WHERE id = NEW.communities_id), '') ||
        CASE WHEN COALESCE((SELECT community FROM communities WHERE id = NEW.communities_id), '') <> '' THEN ', ' ELSE '' END ||
        COALESCE((SELECT sub_community FROM sub_communities WHERE id = NEW.sub_communities_id), '') ||
        CASE WHEN COALESCE((SELECT sub_community FROM sub_communities WHERE id = NEW.sub_communities_id), '') <> '' THEN ', ' ELSE '' END ||
        COALESCE((SELECT property FROM properties_map_location WHERE id = NEW.property_map_location_id), '');

    -- Remove any trailing comma and space
    NEW.full_address := rtrim(NEW.full_address, ', ');

    -- Return the modified row
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_full_address ON addresses CASCADE;

CREATE TRIGGER trigger_update_full_address
BEFORE INSERT OR UPDATE ON addresses
FOR EACH ROW
EXECUTE FUNCTION update_full_address();


CREATE TABLE "service_promotions" (
    "id" bigserial   NOT NULL,
    "service" bigint   NOT NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    "promotion_name" varchar   NOT NULL,
    "promotion_details" varchar   NOT NULL,
    "price" float   NOT NULL,
    "tags_id" bigint   NOT NULL,
    "start_date" timestamptz   NOT NULL,
    "end_date" timestamptz   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "promotion_name_ar" varchar NULL,
    "promotion_details_ar" varchar NULL,
    CONSTRAINT "pk_service_promotions" PRIMARY KEY (
        "id"
     )
);


ALTER TABLE "service_promotions" ADD CONSTRAINT "fk_service_promotions_service" FOREIGN KEY("service")
REFERENCES "services" ("id");

ALTER TABLE "service_promotions" ADD CONSTRAINT "fk_service_promotions_tags_id" FOREIGN KEY("tags_id")
REFERENCES "tags" ("id");

ALTER TABLE "service_promotions" ADD CONSTRAINT "fk_service_promotions_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");


CREATE TABLE "property_type_unit_type" (
    "id" bigserial   NOT NULL,
    "unit_type_id" bigint   NOT NULL,
    "property_type_id" bigint   NOT NULL,
    CONSTRAINT "pk_property_type_unit_type" PRIMARY KEY (
        "id"
     ),
     CONSTRAINT "uc_property_type_unit_type_unit_type_id_property_type_id" UNIQUE(
        "unit_type_id","property_type_id"
     )
);

ALTER TABLE "property_type_unit_type" ADD CONSTRAINT "fk_property_type_unit_type_unit_type_id" FOREIGN KEY("unit_type_id")
REFERENCES "unit_type" ("id");

ALTER TABLE "property_type_unit_type" ADD CONSTRAINT "fk_property_type_unit_type_property_type_id" FOREIGN KEY("property_type_id")
REFERENCES "global_property_type" ("id");



CREATE TABLE "aqary_guide" (
    "id" bigserial   NOT NULL,
    "guide_type" varchar   NOT NULL,
    "guide_content" varchar   NOT NULL,
    "guide_content_ar" varchar   NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz   NOT NULL,
    "updated_at" timestamptz   NOT NULL,
    "status" bigint NOT NULL,
    "slug" varchar NOT NULL,
    CONSTRAINT "pk_aqary_guide" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "aqary_guide" ADD CONSTRAINT "fk_aqary_guide_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");


CREATE TABLE "sharing_entities" (
    "id" bigserial   NOT NULL,
    "sharing_id" bigint   NOT NULL,
    "entity_type" bigint   NOT NULL,
    -- version id of unit & property
    "entity_id" bigint   NOT NULL,
    -- if unit is a property unit
    "property_id" bigint   NULL,
    "phase_id" bigint NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NULL,
    -- fk - users.id
    "updated_by" bigint   NULL,
    "exclusive_start_date" DATE NULL,
    "exclusive_expire_date" DATE NULL,
    "is_exclusive" BOOLEAN DEFAULT false NOT NULL,
    CONSTRAINT "pk_sharing_entities" PRIMARY KEY (
        "id"
     )
);


ALTER TABLE "sharing_entities" ADD CONSTRAINT "fk_sharing_entities_sharing_id" FOREIGN KEY("sharing_id")
REFERENCES "sharing" ("id");

ALTER TABLE "sharing_entities" ADD CONSTRAINT "fk_sharing_entities_entity_type" FOREIGN KEY("entity_type")
REFERENCES "entity_type" ("id");



CREATE TABLE "luxury_brands" (
    "id" bigserial   NOT NULL,
    "brand_name" varchar   NOT NULL,
    "description" varchar  NULL,
    "logo_url" varchar   NOT NULL,
    "status" bigint NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_luxury_brands" PRIMARY KEY (
        "id"
    ),
    CONSTRAINT "uq_brand_name" UNIQUE ("brand_name") 
);

---------------------------------------- REQUEST VERIFICATION EXPERIMENTAL ----------------------------------------


CREATE TABLE "requests_type" (
    "id" bigserial   NOT NULL,
    "type" varchar   NOT NULL,
    "status" boolean   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NULL,
    CONSTRAINT "pk_requests_type" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "requests_verification" (
    "id" bigserial   NOT NULL,
    "request_type" bigint   NOT NULL,
    "entity_type" bigint   NOT NULL,
    "entity_id" bigint   NOT NULL,
    "requested_by" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NULL,
    "ref_no" VARCHAR NOT NULL,
    CONSTRAINT "pk_requests_verification" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "request_data" (
    "id" bigserial   NOT NULL,
    "request_id" bigint   NOT NULL,
    "field_name" varchar   NOT NULL,
    "field_value" varchar   NOT NULL,
    "field_type" VARCHAR DEFAULT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_request_data" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "workflows" (
    "id" bigserial   NOT NULL,
    "request_type" bigint   NOT NULL,
    "step" bigint   NOT NULL,
    "department" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "user_ids" bigint[] NOT NULL,
    CONSTRAINT "pk_workflows" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "approvals" (
    "id" bigserial   NOT NULL,
    "request_id" bigint   NOT NULL,
    "workflow_step" bigint   NOT NULL,
    "department" bigint   NOT NULL,
    "approved_by" bigint  NULL,
    "status" bigint   NOT NULL,
    "remarks" varchar   NOT NULL,
    "files" jsonb NULL,
    "required_fields" bigint[] DEFAULT NULL,
    "updated_at" timestamptz   NULL,
    "user_ids" bigint[] NOT NULL,
    CONSTRAINT "pk_approvals" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "requests_verification" ADD CONSTRAINT "fk_requests_verification_request_type" FOREIGN KEY("request_type")
REFERENCES "requests_type" ("id");

ALTER TABLE "requests_verification" ADD CONSTRAINT "fk_requests_verification_entity_type" FOREIGN KEY("entity_type")
REFERENCES "entity_type" ("id");

ALTER TABLE "requests_verification" ADD CONSTRAINT "fk_requests_verification_requested_by" FOREIGN KEY("requested_by")
REFERENCES "users" ("id");

ALTER TABLE "request_data" ADD CONSTRAINT "fk_request_data_request_id" FOREIGN KEY("request_id")
REFERENCES "requests_verification" ("id");

ALTER TABLE "workflows" ADD CONSTRAINT "fk_workflows_request_type" FOREIGN KEY("request_type")
REFERENCES "requests_type" ("id");

ALTER TABLE "workflows" ADD CONSTRAINT "fk_workflows_department" FOREIGN KEY("department")
REFERENCES "department" ("id");

ALTER TABLE "approvals" ADD CONSTRAINT "fk_approvals_request_id" FOREIGN KEY("request_id")
REFERENCES "requests_verification" ("id");

ALTER TABLE "approvals" ADD CONSTRAINT "fk_approvals_workflow_step" FOREIGN KEY("workflow_step")
REFERENCES "workflows" ("id");

ALTER TABLE "approvals" ADD CONSTRAINT "fk_approvals_department" FOREIGN KEY("department")
REFERENCES "department" ("id");

ALTER TABLE "approvals" ADD CONSTRAINT "fk_approvals_approved_by" FOREIGN KEY("approved_by")
REFERENCES "users" ("id");

ALTER TABLE "bank_listing"
ADD CONSTRAINT "fk_bank_listing_country_id" FOREIGN KEY("country_id")
REFERENCES "countries" ("id");

--------------- Func Generate Unique Refno START---------------------------
CREATE OR REPLACE FUNCTION generate_unique_ref_no()
RETURNS TRIGGER AS $$
DECLARE
    new_ref_no VARCHAR(12);  -- To store the generated reference number with the prefix
BEGIN
    -- Prefix for the reference number
    -- You can change 'REF-' to any other string if needed
    LOOP
        -- Generate a random 6-digit number
        new_ref_no := 'REQ-' || LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');

        -- Check if the generated ref_no already exists
        IF NOT EXISTS (SELECT 1 FROM requests_verification WHERE ref_no = new_ref_no) THEN
            -- If unique, assign it to the new row
            NEW.ref_no := new_ref_no;
            RETURN NEW;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER before_request_insert_trigger
BEFORE INSERT ON requests_verification
FOR EACH ROW
EXECUTE FUNCTION generate_unique_ref_no();
--------------- Func Generate Unique Refno END ---------------------------

--------------- Indexing for Project listing -----------------------
CREATE INDEX idx_phases_projects_id ON phases (projects_id);
CREATE INDEX idx_property_entity ON property (entity_id, entity_type_id);
CREATE INDEX idx_property_property_type_id ON property (property_type_id);
CREATE INDEX idx_property_versions_property_id ON property_versions (property_id);
--------------- Indexing for Project listing -----------------------


CREATE OR REPLACE FUNCTION refresh_autocomplete_view()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW autocomplete_view;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION refresh_hierarchical_location_view()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW hierarchical_location_view;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION refresh_permissions_mv()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW permissions_mv;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION refresh_section_permission_mv()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW section_permission_mv;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION refresh_sub_section_mv()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW sub_section_mv;
END;
$$ LANGUAGE plpgsql;

ALTER TABLE facilities_amenities_entity
ADD CONSTRAINT unique_facility_amenity_per_entity UNIQUE (entity_type_id, entity_id, facility_amenity_id);


CREATE OR REPLACE FUNCTION generate_property_slug()
RETURNS TRIGGER AS
$$
BEGIN
    -- Generating the slug based on the logic provided
    NEW.slug := LOWER(
        REPLACE(
            CONCAT(
                REPLACE(COALESCE((SELECT pt."type" FROM property p
                                 JOIN global_property_type pt ON pt.id = p.property_type_id
                                 WHERE p.id = NEW.property_id), ''), ' ', '-'), 
                CASE WHEN (SELECT pt."type" FROM property p
                           JOIN global_property_type pt ON pt.id = p.property_type_id
                           WHERE p.id = NEW.property_id) IS NOT NULL 
                     AND NEW.category IS NOT NULL THEN '-for-' ELSE '' END,
                CASE 
                    WHEN NEW.category = 1 THEN 'sale' 
                    ELSE 'rent' 
                END,
                CASE WHEN (SELECT st."state" FROM addresses ad
                           JOIN states st ON st.id = ad.states_id
                           WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)) IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN (SELECT st."state" FROM addresses ad
                           JOIN states st ON st.id = ad.states_id
                           WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)) IS NOT NULL
                     THEN REPLACE(COALESCE((SELECT st."state" FROM addresses ad
                                            JOIN states st ON st.id = ad.states_id
                                            WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)), ''), ' ', '-') ELSE '' END,
                CASE WHEN (SELECT co.community FROM addresses ad
                           JOIN communities co ON co.id = ad.communities_id
                           WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)) IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN (SELECT co.community FROM addresses ad
                           JOIN communities co ON co.id = ad.communities_id
                           WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)) IS NOT NULL
                     THEN REPLACE(COALESCE((SELECT co.community FROM addresses ad
                                            JOIN communities co ON co.id = ad.communities_id
                                            WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)), ''), ' ', '-') ELSE '' END,
                CASE WHEN (SELECT sb.sub_community FROM addresses ad
                           JOIN sub_communities sb ON sb.id = ad.sub_communities_id
                           WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)) IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN (SELECT sb.sub_community FROM addresses ad
                           JOIN sub_communities sb ON sb.id = ad.sub_communities_id
                           WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)) IS NOT NULL
                     THEN REPLACE(COALESCE((SELECT sb.sub_community FROM addresses ad
                                            JOIN sub_communities sb ON sb.id = ad.sub_communities_id
                                            WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)), ''), ' ', '-') ELSE '' END,
                CASE WHEN (SELECT pml.property FROM addresses ad
                           JOIN properties_map_location pml ON pml.id = ad.property_map_location_id
                           WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)) IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN (SELECT pml.property FROM addresses ad
                           JOIN properties_map_location pml ON pml.id = ad.property_map_location_id
                           WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)) IS NOT NULL
                     THEN REPLACE(COALESCE((SELECT pml.property FROM addresses ad
                                            JOIN properties_map_location pml ON pml.id = ad.property_map_location_id
                                            WHERE ad.id = (SELECT addresses_id FROM property WHERE id = NEW.property_id)), ''), ' ', '-') ELSE '' END,
                CASE WHEN NEW.id IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN NEW.id IS NOT NULL THEN NEW.id END 
            ), 
            ' ', '-'
        )
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER property_slug_trigger
BEFORE INSERT OR UPDATE ON property_versions
FOR EACH ROW
EXECUTE FUNCTION generate_property_slug();


CREATE OR REPLACE FUNCTION generate_company_profile_project_slug()
RETURNS TRIGGER AS
$$
BEGIN
    -- Generating the slug based on the same logic provided in the query
    NEW.slug := LOWER(
        REPLACE(
            CONCAT(
                REPLACE(COALESCE((SELECT trim(p.project_name) FROM company_profiles_projects p
                                 WHERE p.id = NEW.id), ''), ' ', '-'),
                CASE WHEN NEW.id IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN NEW.id IS NOT NULL THEN NEW.id END 
            ), 
            ' ', '-'
        )
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER company_profile_project_slug_trigger
BEFORE INSERT OR UPDATE ON company_profiles_projects
FOR EACH ROW
EXECUTE FUNCTION generate_company_profile_project_slug();

 

CREATE OR REPLACE FUNCTION generate_project_slug()
RETURNS TRIGGER AS
$$
BEGIN
    -- Generating the slug based on the same logic provided in the query
    NEW.slug := LOWER(
        REPLACE(
            CONCAT(
                REPLACE(COALESCE((SELECT p.project_name FROM projects p
                                 WHERE p.id = NEW.id), ''), ' ', '-'),
                CASE WHEN NEW.id IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN NEW.id IS NOT NULL THEN NEW.id END 
            ), 
            ' ', '-'
        )
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER project_slug_trigger
BEFORE INSERT OR UPDATE ON projects
FOR EACH ROW
EXECUTE FUNCTION generate_project_slug();

CREATE OR REPLACE FUNCTION generate_unit_version_slug()
RETURNS TRIGGER AS
$$
BEGIN
    -- Generating the slug based on the same logic provided in the query
    NEW.slug := LOWER(
        REPLACE(
            CONCAT(
                REPLACE(COALESCE((SELECT pt."type" FROM units p
                                 JOIN unit_type pt ON pt.id = p.unit_type_id
                                 WHERE p.id = NEW.unit_id), ''), ' ', '-'), 
                CASE WHEN (SELECT pt."type" FROM units p
                           JOIN unit_type pt ON pt.id = p.unit_type_id
                           WHERE p.id = NEW.unit_id) IS NOT NULL 
                     AND NEW."type" IS NOT NULL THEN '-for-' ELSE '' END,
                CASE 
                    WHEN NEW."type" = 1 THEN 'sale' 
                    WHEN NEW."type" = 2 THEN 'rent' 
                    WHEN NEW."type" = 3 THEN 'swap'
                END,
                CASE WHEN (SELECT st."state" FROM addresses ad
                           JOIN states st ON st.id = ad.states_id
                           WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)) IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN (SELECT st."state" FROM addresses ad
                           JOIN states st ON st.id = ad.states_id
                           WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)) IS NOT NULL
                     THEN REPLACE(COALESCE((SELECT st."state" FROM addresses ad
                                            JOIN states st ON st.id = ad.states_id
                                            WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)), ''), ' ', '-') ELSE '' END,
                CASE WHEN (SELECT co.community FROM addresses ad
                           JOIN communities co ON co.id = ad.communities_id
                           WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)) IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN (SELECT co.community FROM addresses ad
                           JOIN communities co ON co.id = ad.communities_id
                           WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)) IS NOT NULL
                     THEN REPLACE(COALESCE((SELECT co.community FROM addresses ad
                                            JOIN communities co ON co.id = ad.communities_id
                                            WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)), ''), ' ', '-') ELSE '' END,
                CASE WHEN (SELECT sb.sub_community FROM addresses ad
                           JOIN sub_communities sb ON sb.id = ad.sub_communities_id
                           WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)) IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN (SELECT sb.sub_community FROM addresses ad
                           JOIN sub_communities sb ON sb.id = ad.sub_communities_id
                           WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)) IS NOT NULL
                     THEN REPLACE(COALESCE((SELECT sb.sub_community FROM addresses ad
                                            JOIN sub_communities sb ON sb.id = ad.sub_communities_id
                                            WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)), ''), ' ', '-') ELSE '' END,
                CASE WHEN (SELECT pml.property FROM addresses ad
                           JOIN properties_map_location pml ON pml.id = ad.property_map_location_id
                           WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)) IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN (SELECT pml.property FROM addresses ad
                           JOIN properties_map_location pml ON pml.id = ad.property_map_location_id
                           WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)) IS NOT NULL
                     THEN REPLACE(COALESCE((SELECT pml.property FROM addresses ad
                                            JOIN properties_map_location pml ON pml.id = ad.property_map_location_id
                                            WHERE ad.id = (SELECT addresses_id FROM units WHERE id = NEW.unit_id)), ''), ' ', '-') ELSE '' END,
                CASE WHEN NEW.id IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN NEW.id IS NOT NULL THEN NEW.id END 
            ), 
            ' ', '-'
        )
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER unit_versions_slug_trigger
BEFORE INSERT OR UPDATE ON unit_versions
FOR EACH ROW
EXECUTE FUNCTION generate_unit_version_slug();


CREATE OR REPLACE FUNCTION generate_service_slug()
RETURNS TRIGGER AS
$$
BEGIN
    -- Generating the slug based on the same logic provided in the query
    NEW.slug := LOWER(
        REPLACE(
            CONCAT(
                REPLACE(COALESCE((SELECT p.service_name FROM services p
                                 WHERE p.id = NEW.id), ''), ' ', '-'),
                CASE WHEN NEW.id IS NOT NULL THEN '-' ELSE '' END,
                CASE WHEN NEW.id IS NOT NULL THEN NEW.id END 
            ), 
            ' ', '-'
        )
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER services_slug_trigger
BEFORE INSERT OR UPDATE ON services
FOR EACH ROW
EXECUTE FUNCTION generate_service_slug();

ALTER TABLE "xml_url" ADD CONSTRAINT "fk_xml_url_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");

CREATE TABLE "platform_users" (  
    "id" bigserial   NOT NULL,
    "company_id" bigint NULL,
    "username" varchar NOT NULL,
    "password" varchar NOT NULL,
    "country_code" varchar NULL,
    "phone_number" bigint NULL,
    "date_of_birth" date NULL,
    "first_name" varchar NULL,
    "last_name" varchar  NULL,		
    "email" varchar NOT NULL,
    "gender"  bigint  NULL,
    "profile_image_url" varchar NULL,
    "cover_image_url" varchar NULL,
    "about" varchar NULL,
    "addresses_id" bigint NOT NULL,

    "is_phone_verified" bool NOT NULL DEFAULT false,
   "is_email_verified" bool NOT NULL DEFAULT false,
    "status" bigint NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "nationality" bigint NULL,
    "social_login" VARCHAR NULL,
    CONSTRAINT "pk_platform_users" PRIMARY KEY (
        "id"
     )
);
 

ALTER TABLE "platform_users" ADD CONSTRAINT "fk_platform_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");

ALTER TABLE "countries" ADD CONSTRAINT "fk_countries_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "states" ADD CONSTRAINT "fk_states_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "cities" ADD CONSTRAINT "fk_cities_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "communities" ADD CONSTRAINT "fk_communities_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "sub_communities" ADD CONSTRAINT "fk_sub_communities_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "properties_map_location" ADD CONSTRAINT "fk_properties_map_location_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

ALTER TABLE "currency" ADD CONSTRAINT "fk_currency_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");

COMMENT ON COLUMN countries.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN states.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN cities.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN communities.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN sub_communities.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN properties_map_location.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN currency.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN subscription_order.status IS '1 => in-active, 2 => active';

CREATE TABLE "newsletter_subscribers"(
    "id" bigserial NOT NULL,
    "email" varchar NOT NULL,
    "is_subscribed" boolean NOT NULL,
    "company_id" bigint NOT NULL,
    CONSTRAINT "pk_newsletter_subscribers" PRIMARY KEY (
        "id"
    ),
    CONSTRAINT "uc_email_company_id" UNIQUE (
        "email","company_id"
    )
);

ALTER TABLE "newsletter_subscribers" ADD CONSTRAINT "fk_newsletter_subscribers_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");


CREATE TABLE "waiting_list" (
    "id" bigserial   NOT NULL,
    "name" varchar  NOT NULL,
    "email" varchar  NOT NULL,
    "phone_number" varchar NOT NULL,
    "country_code" varchar NOT NULL, 
    "company_id" bigint NOT NULL, 
    "section" varchar NOT NULL, 
    CONSTRAINT "pk_waiting_list" PRIMARY KEY (
        "id"
     ), 
      CONSTRAINT "uc_email_company_id_section" UNIQUE (
        "email","company_id","section"
    ), 
    CONSTRAINT "uc_phone_company_id_section" UNIQUE (
        "phone_number","country_code","company_id","section"
    )
);

ALTER TABLE "waiting_list" ADD CONSTRAINT "fk_waiting_list_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");

CREATE TABLE "faqs" (
    "id" bigserial   NOT NULL,
    "company_id" bigint NULL,
    "section_id" bigint NULL,
    "platform_id" bigint DEFAULT 1 NOT NULL,
    "tags" varchar[] NULL, 
    "questions" varchar NOT NULL,
    "answers" varchar NOT NULL,
    "questions_ar" varchar NULL,
    "answers_ar" varchar NULL,
    "media_urls" varchar[]   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint NOT NULL,
    "created_by" bigint NOT NULL,
    CONSTRAINT "pk_faqs" PRIMARY KEY (
        "id"
     ),
    "likes" bigint NULL,
    "dislikes" bigint NULL
);

ALTER TABLE "faqs" ADD CONSTRAINT "fk_faqs_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");

ALTER TABLE "faqs" ADD CONSTRAINT "fk_faqs_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

CREATE TABLE "wishlist"(
    "id" bigserial NOT NULL,
    "entity_type_id" bigint NOT NULL,
    "entity_id" bigint NOT NULL,
    "platform_user_id" bigint NOT NULL,
    "company_id" bigint ,
    "created_at" TIMESTAMPTZ NOT NULL,
    CONSTRAINT "pk_wishlist" PRIMARY KEY ("id"),
    CONSTRAINT "uc_wishlist_entity_type_id_entity_id_platform_user_id" UNIQUE("entity_type_id", "entity_id","platform_user_id")
);
 
 
ALTER TABLE "wishlist" ADD CONSTRAINT "fk_platform_user_id" FOREIGN KEY("platform_user_id")
REFERENCES "platform_users" ("id");
 
ALTER TABLE "wishlist" ADD CONSTRAINT "fk_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");
 
ALTER TABLE "wishlist" ADD CONSTRAINT "fk_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");

------------- ???? COMPANY PROFILES ???? ---------------
CREATE TABLE "company_profiles" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_type" bigint  NOT NULL,
	"company_name" varchar  NOT NULL,
    "company_name_ar" TEXT,
    "company_category_id" bigint NOT NULL,
    "company_activities_id" bigint[]   NOT NULL,
    "website_url" varchar   NULL,
    "company_email" varchar   NOT NULL,
    "phone_number" varchar   NOT NULL,
    "logo_url" varchar   NOT NULL,
	"cover_image_url" varchar   NOT NULL,
    "internal_cover_image" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_ar" varchar   NULL,
    "status" bigint   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
    "sort_order" bigint NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,   
    "updated_by" bigint   NULL, 
    CONSTRAINT "pk_company_profiles" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_profiles_ref_no" UNIQUE (
        "ref_no"
    )
);

ALTER TABLE "company_profiles" ADD CONSTRAINT "fk_company_profiles_company_type" FOREIGN KEY("company_type")
REFERENCES "company_types"("id");

ALTER TABLE "company_profiles" ADD CONSTRAINT "fk_company_profiles_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses"("id");

ALTER TABLE "company_profiles" ADD CONSTRAINT "fk_company_profiles_created_by" FOREIGN KEY("created_by")
REFERENCES "users"("id");

ALTER TABLE "company_profiles" ADD CONSTRAINT "fk_company_profiles_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users"("id");

ALTER TABLE "company_profiles" ADD CONSTRAINT "fk_company_profiles_company_category_id" FOREIGN KEY("company_category_id")
REFERENCES "company_category"("id");


CREATE TABLE "company_profiles_projects" (
    "id" bigserial   NOT NULL,
	"ref_number" varchar  NOT NULL,
	"project_no" varchar   NOT NULL,
    "project_name" varchar   NOT NULL,
    "company_profiles_id" bigint   NOT NULL,
    "is_verified" boolean NOT NULL,
	"is_multiphase" boolean   NOT NULL,
    "license_no" varchar NOT NULL,
    "addresses_id" bigint   NOT NULL,
	"bank_name" VARCHAR NULL,    
    "escrow_number" VARCHAR NULL,
	"registration_date" DATE NULL,
	"status" bigint  DEFAULT 1 NOT NULL,
	"description" varchar   NOT NULL,
    "description_arabic" varchar   NULL,
    "properties_ref_nos" varchar[]  NULL,
    "facts" jsonb NOT NULL,
    "promotions" jsonb NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "slug" varchar(255) DEFAULT 'slug' NOT NULL, 
    CONSTRAINT "pk_company_profiles_projects" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_profiles_projects_ref_number" UNIQUE (
        "ref_number"
    )
);

ALTER TABLE "company_profiles_projects" ADD CONSTRAINT "fk_company_profiles_projects_company_profiles_id" FOREIGN KEY("company_profiles_id")
REFERENCES "company_profiles"("id");

ALTER TABLE "company_profiles_projects" ADD CONSTRAINT "fk_company_profiles_projects_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses"("id");

CREATE TABLE "company_profiles_phases" (
    "id" bigserial   NOT NULL,
	"ref_number" varchar  NOT NULL,
	"company_profiles_projects_id" bigint NOT NULL,
	"phase_name" varchar NOT NULL,
    "registration_date" DATE NULL,
    "bank_name" varchar NULL,
    "escrow_number" varchar NULL,
    "facts" jsonb NOT NULL,
	"properties_ref_nos" varchar[]  NULL,
    "promotions" jsonb NULL,
	"status" bigint  DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_company_profiles_phases" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_profiles_phases_ref_number" UNIQUE (
        "ref_number"
    )
);

ALTER TABLE "company_profiles_phases" ADD CONSTRAINT "fk_company_profiles_phases_company_profiles_projects_id" FOREIGN KEY("company_profiles_projects_id")
REFERENCES "company_profiles_projects"("id");

CREATE TABLE "community_guidelines" (
    "id" bigserial   NOT NULL,
    -- "title" varchar   NOT NULL,
    "country_id" bigint  NOT NULL,
    "state_id" bigint   NOT NULL,
    "city_id" bigint   NOT NULL,
    "community_id" bigint   NOT NULL,
    "description" varchar   NOT NULL,
    "cover_image" varchar   NOT NULL,
    "insights" bigint[]  NULL,
    "sub_insights" bigint[] NULL,
    "status" bigint   NOT NULL,
    "about" varchar  NULL,
    "created_at" timestamptz   NOT NULL,
    "update_at" timestamptz   NOT NULL,
    "deleted_at" timestamptz  NULL,

    CONSTRAINT "pk_community_guidelines" PRIMARY KEY (
        "id"
     ),
     CONSTRAINT "uc_community_guidelines" UNIQUE (
        "community_id"
     )
     
);

CREATE TABLE "community_guidelines_insight" (
    "id" bigserial   NOT NULL,
    "insight_name" varchar   NOT NULL,
    "insight_name_ar" varchar   NOT NULL,
    "icon" varchar   NOT NULL,
    "description_text" varchar NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz   NOT NULL,
    "update_at" timestamptz   NOT NULL,
    "deleted_at" timestamptz  NULL,

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
    "status" bigint   NOT NULL,
    "created_at" timestamptz   NOT NULL,
    "update_at" timestamptz   NOT NULL,
    "deleted_at" timestamptz  NULL,
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



CREATE TABLE "banner_plan_package"(
    "id" bigserial NOT NULL,
    "package_name" BIGINT NOT NULL,
    "plan_type" BIGINT NOT NULL,
    "plan_package_name" VARCHAR NOT NULL,
    "quantity" BIGINT NOT NULL,-- number of banners
    "counts_per_banner" BIGINT NOT NULL,
    "icon" VARCHAR NOT NULL,
    "description" VARCHAR NULL,
    "status" BIGINT NOT NULL,
    "created_at" timestamptz NOT NULL,
    "updated_at" timestamptz NOT NULL,
    CONSTRAINT "pk_banner_plan_package" PRIMARY KEY ("id"),
    CONSTRAINT "banner_plan_package_unique_constraint" UNIQUE("plan_package_name")
);



CREATE TABLE "banner_plan_cost"(
 "id" bigserial NOT NULL,
 "country_id" BIGINT NOT NULL, 
 "company_type" BIGINT NOT NULL,
 "plan_package_id" BIGINT NOT NULL, 
 "platform" BIGINT NOT NULL, 
 "price" FLOAT NOT NULL, 
 "status" BIGINT NOT NULL,
 "created_at" timestamptz NOT NULL,
    "updated_at" timestamptz NOT NULL,
 CONSTRAINT "pk_banner_plan_cost" PRIMARY KEY ("id"), 
 CONSTRAINT "banner_plan_cost_unique_constraint" UNIQUE("country_id","company_type","plan_package_id","platform")
);



ALTER TABLE "banner_plan_cost" ADD CONSTRAINT "fk_country_id" FOREIGN KEY("country_id")
REFERENCES "countries" ("id");

ALTER TABLE "banner_plan_cost" ADD CONSTRAINT "fk_plan_package_id" FOREIGN KEY("plan_package_id") 
REFERENCES "banner_plan_package" ("id");



CREATE TABLE "banner_order"(
	"id" bigserial NOT NULL,
	"ref_no" VARCHAR NOT NULL, 
	"company_id" BIGINT NOT NULL,
	"plan_packages" jsonb NOT NULL, 
	"total_price" FLOAT NOT NULL, 
	"start_date" timestamptz NOT NULL, 
	"end_date" timestamptz NOT NULL,
	"created_by" BIGINT NOT NULL,
	"updated_by" BIGINT NULL,
	"created_at" timestamptz NOT NULL, 
	"updated_at" timestamptz NOT NULL, 
    "status" BIGINT NOT NULL,
    "company_type" BIGINT NOT NULL, 
    "country_id" BIGINT NOT NULL,
    "note" VARCHAR ,
	CONSTRAINT "pk_banner_order" PRIMARY KEY ("id")
);
 
	
ALTER TABLE "banner_order" ADD CONSTRAINT "fk_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");
 
ALTER TABLE "banner_order" ADD CONSTRAINT "fk_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");
 
ALTER TABLE "banner_order" ADD CONSTRAINT "fk_updated_by" FOREIGN KEY("updated_by")
REFERENCES "users" ("id");


CREATE TABLE "company_activities_detail" (
    "id" BIGSERIAL NOT NULL,
    "company_id" BIGINT NOT NULL,
    "activity_id" BIGINT NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "description" TEXT, 
    "status" bigint NOT NULL DEFAULT 1,
    "created_by" BIGINT NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "fk_company_id" FOREIGN KEY ("company_id") REFERENCES companies("id"),
    CONSTRAINT "fk_activity_id" FOREIGN KEY ("activity_id") REFERENCES company_activities("id"),
    CONSTRAINT "fk_created_by" FOREIGN KEY ("created_by") REFERENCES users("id")
);

-- Create an index for faster queries on company_id and activity_id
CREATE INDEX "idx_company_activities_detail_company_id" ON "company_activities_detail" ("company_id");
CREATE INDEX "idx_company_activities_detail_activity_id" ON "company_activities_detail" ("activity_id");
CREATE INDEX "idx_company_activities_detail_status" ON "company_activities_detail" ("status");


CREATE TABLE "banners" (
    "id" bigserial NOT NULL,
    "company_id" bigint NOT NULL,
    "banner_order_id" bigint NOT NULL,
    "banner_name" varchar NOT NULL,
    "status" bigint NOT NULL,
    "target_url" varchar NOT NULL,
    "plan_package_id" bigint NOT NULL,
    "duration" bigint NOT NULL,
    "banner_direction" bigint NOT NULL,
    "banner_position" bigint NOT NULL,
    "media_type" bigint NOT NULL,
    "file_url" varchar NOT NULL,
    "description" varchar NULL,
    "created_by" bigint NOT NULL,
    "updated_by" bigint NULL,
    "created_at" timestamptz NOT NULL, 
    "updated_at" timestamptz NOT NULL, 
    "banner_cost_id" bigint NOT NULL,
    "no_of_impressions" bigint,
    CONSTRAINT "pk_banners" PRIMARY KEY ("id")
);

-- Add foreign key constraints
ALTER TABLE "banners" ADD CONSTRAINT "fk_company_id" FOREIGN KEY("company_id") REFERENCES "companies" ("id");
ALTER TABLE "banners" ADD CONSTRAINT "fk_plan_package_id" FOREIGN KEY("plan_package_id") REFERENCES "banner_plan_package" ("id");
ALTER TABLE "banners" ADD CONSTRAINT "fk_created_by" FOREIGN KEY("created_by") REFERENCES "users" ("id");
ALTER TABLE "banners" ADD CONSTRAINT "fk_banner_order_id" FOREIGN KEY ("banner_order_id") REFERENCES "banner_order" ("id");

 
CREATE TABLE "banner_criteria" (

    "id" bigserial   NOT NULL,
"banner_type_id" bigint NOT NULL,
    "banner_name_id" bigint NOT NULL,
    "banners_id" bigint not null,
    CONSTRAINT "pk_banner_criteria" PRIMARY KEY (
        "id"
     )
     
    );
    
ALTER TABLE "banner_criteria" ADD CONSTRAINT "fk_banners_id" FOREIGN KEY("banners_id") REFERENCES "banners" ("id");


CREATE TABLE refresh_schedules (
    "id" BIGSERIAL PRIMARY KEY,
    "entity_id" BIGINT NOT NULL,
    "entity_type_id" INT NOT NULL,

    "schedule_type" TEXT NOT NULL CHECK (schedule_type IN ('daily', 'weekly')),

    "next_run_at" TIMESTAMPTZ NOT NULL,
    "last_run_at" TIMESTAMPTZ,

    "preferred_hour" INT NOT NULL DEFAULT 3 CHECK ("preferred_hour" >= 0 AND "preferred_hour" < 24),
    "preferred_minute" INT NOT NULL DEFAULT 0 CHECK ("preferred_minute" >= 0 AND "preferred_minute" < 60),

    "week_days" SMALLINT[] CHECK (
        "week_days" IS NULL 
        OR array_length("week_days", 1) <= 6
    ),

    "status" BIGINT NOT NULL,
    "created_by" BIGINT NOT NULL,
    "created_at" TIMESTAMPTZ DEFAULT NOW(),
    "updated_at" TIMESTAMPTZ DEFAULT NOW()
);
 

 CREATE TABLE reservation_requests (
    "id" SERIAL PRIMARY KEY,
    "ref_no" VARCHAR NOT NULL,
    "name" VARCHAR NOT NULL,
    "email" VARCHAR NOT NULL UNIQUE,
    "phone" VARCHAR NOT NULL,
    "nic_document" VARCHAR NOT NULL,     
    "payment_proof" VARCHAR NOT NULL,   
    "entity_type" BIGINT NOT NULL,        
    "entity_id" BIGINT NOT NULL,          
    "status" BIGINT NOT NULL DEFAULT 1,  
    "created_by" BIGINT NOT NULL,                      
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT now(),
    "updated_at" TIMESTAMP WITH TIME ZONE DEFAULT now()
);

 CREATE TABLE "country_guide" (
    "id" BIGSERIAL PRIMARY KEY,
    "country_id" BIGINT NOT NULL ,
    "cover_image" VARCHAR NOT NULL,
    "description" VARCHAR,
    "status" BIGINT NOT NULL,
    "created_at" TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    "updated_at" TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    "deleted_at" TIMESTAMPTZ
);
 
-- State Guide Table
CREATE TABLE "state_guide" (
    "id" BIGSERIAL PRIMARY KEY,
    "state_id" BIGINT NOT NULL ,
    "cover_image" VARCHAR NOT NULL,
    "description" VARCHAR,
    "status" BIGINT NOT NULL,
    "created_at" TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    "updated_at" TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    "deleted_at" TIMESTAMPTZ
);
 
-- City Guide Table
CREATE TABLE "city_guide" (
    "id" BIGSERIAL PRIMARY KEY,
    "city_id" BIGINT NOT NULL ,
    "cover_image" VARCHAR NOT NULL,
    "description" VARCHAR,
    "status" BIGINT NOT NULL,
    "created_at" TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    "updated_at" TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    "deleted_at" TIMESTAMPTZ
);

ALTER TABLE "country_guide" ADD CONSTRAINT "fk_country_id" FOREIGN KEY("country_id") REFERENCES "countries" ("id");
ALTER TABLE "city_guide" ADD CONSTRAINT "fk_city_id" FOREIGN KEY("city_id") REFERENCES "cities" ("id");
ALTER TABLE "state_guide" ADD CONSTRAINT "fk_state_id" FOREIGN KEY("state_id") REFERENCES "states" ("id");


CREATE TABLE entity_service_locations (
  "id" BIGSERIAL PRIMARY KEY,         
  "entity_id" BIGINT NOT NULL,    
  "entity_type_id" BIGINT NOT NULL,
  "country_id" BIGINT NOT NULL,
  "state_id" BIGINT NOT NULL,        
  "city_id" BIGINT NOT NULL,
  "community_id" BIGINT,
  "sub_community_id" BIGINT,
  "created_at" timestamptz  DEFAULT now() NOT NULL,
  "updated_at" timestamptz  DEFAULT now() NOT NULL
);


-- Table: expertise
CREATE TABLE "expertise" (
    "id" BIGSERIAL PRIMARY KEY,
    "title" VARCHAR(255) NOT NULL,
    "title_ar" VARCHAR(255),
    "description" VARCHAR(5000),
    "status" BIGINT NOT NULL,
    "created_at" TIMESTAMPTZ DEFAULT NOW(),
    "updated_at" TIMESTAMPTZ DEFAULT NOW(),
    "deleted_at" TIMESTAMPTZ,
 
    CONSTRAINT "unique_expertise_title" UNIQUE (title)
);
 
-- Table: company_user_expertise
CREATE TABLE "company_user_expertise" (
    "id" BIGSERIAL PRIMARY KEY,
    "expertise_id" BIGINT NOT NULL ,
    "company_user_id" BIGINT NOT NULL ,
    "created_at" TIMESTAMPTZ DEFAULT NOW(),
 
    CONSTRAINT "unique_company_user_expertise" UNIQUE ("expertise_id", "company_user_id"),
    CONSTRAINT "fk_expertise" FOREIGN KEY ("expertise_id") REFERENCES "expertise"("id") ON DELETE CASCADE
);

CREATE TABLE "faq_user_reactions" (
    "id" SERIAL PRIMARY KEY,
    "user_id" INT NOT NULL,
    "faq_id" INT NOT NULL,
    "reaction" VARCHAR(10) NOT NULL CHECK (reaction IN ('like', 'dislike', 'none')),
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("user_id") REFERENCES "platform_users"("id") ON DELETE CASCADE,
    FOREIGN KEY ("faq_id") REFERENCES "faqs"("id") ON DELETE CASCADE,
    CONSTRAINT "unique_user_faq" UNIQUE ("user_id", "faq_id")
);
ALTER TABLE "company_user_expertise" ADD CONSTRAINT "fk_company_user" FOREIGN KEY("company_user_id")
REFERENCES "company_users" ("id");


-- Create or replace a generic trigger function for score calculation
CREATE OR REPLACE FUNCTION calculate_entity_score()
RETURNS TRIGGER AS $$
BEGIN
    -- Calculate the score based on the formula (same for both properties and units)
    NEW.score := LEAST(100,
        CASE WHEN NEW.exclusive THEN 35 ELSE 0 END +
        CASE WHEN NEW.is_hotdeal THEN 20 ELSE 0 END +
        CASE WHEN (NEW.facts->>'life_style')::int = 3 THEN 20 ELSE 0 END +
        CASE WHEN NEW.is_verified THEN 25 ELSE 0 END
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
 
-- Drop the triggers if they already exist
DROP TRIGGER IF EXISTS update_property_score ON property_versions;
DROP TRIGGER IF EXISTS update_unit_score ON unit_versions;
 
-- Create the triggers for both tables
CREATE TRIGGER update_property_score
BEFORE INSERT OR UPDATE OF exclusive, is_hotdeal, facts, is_verified ON property_versions
FOR EACH ROW
EXECUTE FUNCTION calculate_entity_score();
 
CREATE TRIGGER update_unit_score
BEFORE INSERT OR UPDATE OF exclusive, is_hotdeal, facts, is_verified ON unit_versions
FOR EACH ROW
EXECUTE FUNCTION calculate_entity_score();

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

CREATE TABLE listing_sections (
    "id" SERIAL PRIMARY KEY,
    "section_key" BIGINT NOT NULL UNIQUE,
    "title" VARCHAR(255) NOT NULL,
    "subtitle" VARCHAR(255) NOT NULL,
    "title_ar" VARCHAR(255) NULL,
    "sub_title_ar" VARCHAR(255) NULL,
    "sort" BIGINT NOT NULL DEFAULT 1,
    "properties" BIGINT NOT NULL DEFAULT 0,
    "is_external" BOOLEAN NOT NULL DEFAULT FALSE,
    "is_coming_soon" BOOLEAN NOT NULL DEFAULT FALSE,
    "show_on" VARCHAR[] NOT NULL, 
    "platforms" BIGINT[], 
    "color" VARCHAR(20) NOT NULL,
    "icon_path" VARCHAR(255) NOT NULL,
    "image_url" VARCHAR(255) NOT NULL,
    "view_all_image" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

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