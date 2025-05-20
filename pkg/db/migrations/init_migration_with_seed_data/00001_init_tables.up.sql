
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
    CONSTRAINT "pk_countries" PRIMARY KEY (
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

CREATE TABLE "properties_map_location" (
    "id" bigserial   NOT NULL,
    "property" varchar   NOT NULL,
    "sub_communities_id" bigint   NOT NULL,
    "lat" float   NOT NULL,
    "lng" float   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz   NULL,
    CONSTRAINT "pk_properties_map_location" PRIMARY KEY (
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
    CONSTRAINT "pk_addresses" PRIMARY KEY (
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

CREATE TABLE "company_types" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    -- Title -->
    "image_url" varchar   NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_company_types" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_types_title" UNIQUE (
        "title"
    )
);

CREATE TABLE "company_category" (
    "id" bigserial   NOT NULL,
    "category_name" varchar   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- fk - users.id
    "updated_by" bigint   NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    "company_type" bigint NOT NULL,
    CONSTRAINT "pk_company_category" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_category_category_name_company_type" UNIQUE (
        "category_name",
        "company_type"
    )
);


CREATE TABLE "company_activities" (
    "id" bigserial   NOT NULL,
    "company_category_id" bigint   NOT NULL,
    "activity_name" varchar   NOT NULL,
    "icon_url" varchar   NULL,
    -- FK >-  tags.id
    "tag_id" int[]   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    -- fk - users.id
    "updated_by" bigint   NULL,
    "description" varchar   NULL,
    "description_ar" varchar   NULL,
    "status" bigint DEFAULT 1 NOT NULL,
    CONSTRAINT "pk_company_activities" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_company_activities_company_category_id_activity_name" UNIQUE (
        "company_category_id","activity_name"
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
    CONSTRAINT "pk_roles" PRIMARY KEY (
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

CREATE TABLE "unit_type" (
    "id" bigserial   NOT NULL,
    "type" varchar   NOT NULL,
    "code" varchar   NOT NULL,
    "facts" jsonb   NOT NULL,
    -- unit_facts_id bigint[] FK >- unit_facts.id
    "usage" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "icon" varchar   NULL,
    CONSTRAINT "pk_unit_type" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "global_property_type" (
    "id" bigserial   NOT NULL,
    "type" varchar   NOT NULL,
    "code" varchar   NOT NULL,
    "property_type_facts" jsonB NOT NULL,
    "usage" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "icon" varchar   NULL,
    "is_project" bool DEFAULT false NOT NULL,
    CONSTRAINT "pk_global_property_type" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "facts" (
    	"id" bigserial   NOT NULL,
	"title" varchar     NOT NULL,
	"icon_url" varchar     NOT NULL,
       CONSTRAINT "pk_facts" PRIMARY KEY (
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
       

CREATE TABLE "currency" (
    "id" bigserial   NOT NULL,
    "currency" varchar(255)   NOT NULL,
    "code" varchar(255)   NOT NULL,
    "flag" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "currency_rate" float8 NOT NULL,
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

CREATE TABLE "views" (
    "id" bigserial   NOT NULL,
    "title" varchar(255)   NOT NULL,
    "status" bigint NOT NULL,
    "icon"  varchar NULL, 
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_views" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "projects" (
    "id" bigserial   NOT NULL,
    "project_name" varchar   NOT NULL,
    "ref_number" varchar  NOT NULL,
    "no_of_views" bigint  DEFAULT 0 NOT NULL,
    "is_verified" bool   NOT NULL,
    "project_rank" bigint  DEFAULT 1 NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "status" bigint  DEFAULT 1 NOT NULL,
    "developer_companies_id" bigint   NOT NULL,  -- > new company table 
    "developer_company_branches_id" bigint   NULL,
    "countries_id" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "is_multiphase" bool   NOT NULL,
    "live_status" bool  DEFAULT true NOT NULL,
    "project_no" varchar   NOT NULL,
    "license_no" varchar   NOT NULL,
    "users_id" bigint   NOT NULL, 
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NULL,
    "rating" float  DEFAULT 0.0 NOT NULL,
    "polygon_coords" jsonb   NOT NULL,
    "facts" jsonb NOT NULL,
    "exclusive" boolean NOT NULL DEFAULT false,
    "start_date" DATE NULL,
    "end_date" DATE NULL,
    "slug" varchar(255) NOT NULL,
    "bank_name" VARCHAR NULL,
    "registration_date" DATE NULL,
    "escrow_number" VARCHAR NULL,
    CONSTRAINT "pk_projects" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_projects_ref_number" UNIQUE (
        "ref_number"
    )
);

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
    CONSTRAINT "pk_blog_categories" PRIMARY KEY (
        "id"
     )
);

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


CREATE TABLE "exchange_offer_category" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "ref_id" varchar   NOT NULL,
    CONSTRAINT "pk_exchange_offer_category" PRIMARY KEY (
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
    CONSTRAINT "pk_schedule_view" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_schedule_view_ref_no" UNIQUE (
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

ALTER TABLE "broker_company_agents" ADD CONSTRAINT "fk_broker_company_agents_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "broker_company_agents" ADD CONSTRAINT "fk_broker_company_agents_profiles_id" FOREIGN KEY("profiles_id")
REFERENCES "profiles" ("id");

ALTER TABLE "bank_account_details" ADD CONSTRAINT "fk_bank_account_details_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "bank_account_details" ADD CONSTRAINT "fk_bank_account_details_currency_id" FOREIGN KEY("currency_id")
REFERENCES "currency" ("id");

ALTER TABLE "bank_account_details" ADD CONSTRAINT "fk_bank_account_details_entity_type_id" FOREIGN KEY("entity_type_id")
REFERENCES "entity_type" ("id");

ALTER TABLE "projects" ADD CONSTRAINT "fk_projects_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "projects" ADD CONSTRAINT "fk_projects_developer_companies_id" FOREIGN KEY("developer_companies_id")
REFERENCES "companies" ("id");

ALTER TABLE "projects" ADD CONSTRAINT "fk_projects_countries_id" FOREIGN KEY("countries_id")
REFERENCES "countries" ("id");

ALTER TABLE "projects" ADD CONSTRAINT "fk_projects_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

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

ALTER TABLE "documents_subcategory" ADD CONSTRAINT "fk_documents_subcategory_documents_category_id" FOREIGN KEY("documents_category_id")
REFERENCES "documents_category" ("id");

ALTER TABLE "phases" ADD CONSTRAINT "fk_phases_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "phases" ADD CONSTRAINT "fk_phases_projects_id" FOREIGN KEY("projects_id")
REFERENCES "projects" ("id");

ALTER TABLE "phases" ADD CONSTRAINT "composite_unique_phase_name_projects_id" UNIQUE (phase_name, projects_id);

ALTER TABLE "profiles" ADD CONSTRAINT "fk_profiles_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "profiles" ADD CONSTRAINT "fk_profiles_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "users" ADD CONSTRAINT "fk_users_user_types_id" FOREIGN KEY("user_types_id")
REFERENCES "user_types" ("id");

ALTER TABLE "services" ADD CONSTRAINT "fk_services_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");

ALTER TABLE "services" ADD CONSTRAINT "fk_services_company_activities_id" FOREIGN KEY("company_activities_id")
REFERENCES "company_activities" ("id");

ALTER TABLE "services" ADD CONSTRAINT "fk_services_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "roles_permissions" ADD CONSTRAINT "fk_roles_permissions_roles_id" FOREIGN KEY("roles_id")
REFERENCES "roles" ("id");

ALTER TABLE "leaders" ADD CONSTRAINT "fk_leaders_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "permissions" ADD CONSTRAINT "fk_permissions_section_permission_id" FOREIGN KEY("section_permission_id")
REFERENCES "section_permission" ("id");

ALTER TABLE "sub_section" ADD CONSTRAINT "fk_sub_section_permissions_id" FOREIGN KEY("permissions_id")
REFERENCES "permissions" ("id");

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

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_company_type" FOREIGN KEY("company_type")
REFERENCES "company_types" ("id");

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_addresses_id" FOREIGN KEY("addresses_id")
REFERENCES "addresses" ("id");

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_users_id" FOREIGN KEY("users_id")
REFERENCES "users" ("id");

ALTER TABLE "companies" ADD CONSTRAINT "fk_companies_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "companies_leadership" ADD CONSTRAINT "fk_companies_leadership_companies_id" FOREIGN KEY("companies_id")
REFERENCES "companies" ("id");

ALTER TABLE "companies_leadership" ADD CONSTRAINT "fk_companies_leadership_created_by" FOREIGN KEY("created_by")
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

 

ALTER TABLE projects ADD CONSTRAINT uc_projects_project_name_countries_id UNIQUE (project_name, countries_id);
ALTER TABLE projects ADD CONSTRAINT uc_projects_project_no_countries_id UNIQUE (project_no, countries_id);
ALTER TABLE projects ADD CONSTRAINT uc_projects_license_no_countries_id UNIQUE (license_no, countries_id);



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

CREATE TABLE "property" (
    "id" bigserial   NOT NULL,
    "company_id" bigint  NULL,
    "property_type_id" bigint   NOT NULL,
    "unit_type_id" bigint[]   NULL,
    "property_title" varchar  NOT NULL,
    "property_title_arabic" varchar  NULL,
    "is_verified" bool  DEFAULT false NOT NULL,
    "property_rank" bigint  DEFAULT 1 NOT NULL,
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
  
ALTER TABLE "openhouse" ADD CONSTRAINT "fk_openhouse_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");

ALTER TABLE "openhouse" ADD CONSTRAINT "fk_openhouse_property_id" FOREIGN KEY("property_id")
REFERENCES "property" ("id");

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
    "views_count" bigint NOT NULL DEFAULT 0,
    "is_hotdeal" boolean NOT NULL DEFAULT false,
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

ALTER TABLE "unit_versions_agents" ADD CONSTRAINT "fk_unit_versions_agents_agent_id" FOREIGN KEY("agent_id")
REFERENCES "users" ("id");

ALTER TABLE "unit_versions_agents" ADD CONSTRAINT "fk_unit_versions_agents_unit_version_id" FOREIGN KEY("unit_version_id")
REFERENCES "unit_versions" ("id");

CREATE TABLE "plans" (
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



-- new schema tables --



CREATE TABLE "property_versions" (
    "id" bigserial   NOT NULL,
    "title" varchar   NOT NULL,
    "title_arabic" varchar   NULL,
    "description" varchar   NOT NULL,
    "description_arabic" varchar   NULL,
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
    "views_count" bigint NOT NULL DEFAULT 0,
    "is_hotdeal" boolean NOT NULL DEFAULT false,
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

 
--  adding departments and their roles .....





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
    "sign_date" timestamptz   NOT NULL,
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
    "remained_units" bigint   NOT NULL,
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
 

------------------- company verification newschema -----------------------------

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
    "contract_file" varchar   NULL,
    "contract_upload_date" timestamptz   NULL,
    "uploaded_by" bigint   NULL,
    "upload_notes" varchar   NULL,
    "created_at" timestamptz DEFAULT now() NOT NULL,
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

CREATE TYPE sharing_type AS ENUM ('internal', 'external');

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

------------------------------------------------ Review Tables ------------------------------------------------

-- Create entity_review table if it doesn't exist
CREATE TABLE "entity_review" (
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
CREATE TABLE "review_terms" (
    "id" bigserial NOT NULL,
    "entity_type_id" bigint NOT NULL,
    "review_term" varchar NOT NULL,
    "status" bigint NOT NULL DEFAULT 2,
    "created_at" timestamptz NOT NULL DEFAULT now(),
    "updated_at" timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "pk_review_terms" PRIMARY KEY ("id")
);

-- Create reviews_table if it doesn't exist
CREATE TABLE "reviews_table" (
    "id" bigserial NOT NULL,
    "entity_review_id" bigint NOT NULL,
    "review_term_id" bigint NOT NULL,
    "review_value" int NOT NULL,
    CONSTRAINT "pk_reviews_table" PRIMARY KEY ("id")
);
 


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

ALTER TABLE "swap_requirement" ADD CONSTRAINT "fk_swap_requirement_property_type" FOREIGN KEY("property_type")
REFERENCES "global_property_type" ("id");

ALTER TABLE "swap_requirement" ADD CONSTRAINT "fk_swap_requirement_unit_types" FOREIGN KEY("unit_types")
REFERENCES "unit_type" ("id");
 
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
    CONSTRAINT "uc_platform_contacts_email" UNIQUE (
        "email"
    ),
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



-- it has to be unique so they will not conflict with each other
ALTER SEQUENCE section_permission_id_seq RESTART WITH 1;
ALTER SEQUENCE permissions_id_seq RESTART WITH 300;
ALTER SEQUENCE sub_section_id_seq RESTART WITH 1300;

CREATE TABLE "tags" (
    "id" bigserial   NOT NULL,
    "tag_name" varchar   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    CONSTRAINT "pk_tags" PRIMARY KEY (
        "id"
     )
);

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

ALTER TABLE facilities_amenities_entity
ADD CONSTRAINT unique_facility_amenity_per_entity UNIQUE (entity_type_id, entity_id, facility_amenity_id);

CREATE TABLE "xml_url" (
    "id" bigserial   NOT NULL,
    "url" varchar   NOT NULL,
    "company_id" bigint   NOT NULL,
    "status" bigint   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "last_update" timestamptz NULL,
    "contact_email" VARCHAR NOT NULL,
    CONSTRAINT "pk_xml_url" PRIMARY KEY (
        "id"
     )
);

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
     ),
  CONSTRAINT "uc_platform_company_email" UNIQUE (
        "company_id",
        "email"
    )
);
 

ALTER TABLE "platform_users" ADD CONSTRAINT "fk_platform_company_id" FOREIGN KEY("company_id")
REFERENCES "companies" ("id");

CREATE TABLE "agent_products" (
    "id" bigserial   NOT NULL,
    "package_id" bigint   NOT NULL,
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

ALTER TABLE "agent_products" ADD CONSTRAINT "fk_agent_products_package_id" FOREIGN KEY("package_id")
REFERENCES "subscription_package" ("id");

ALTER TABLE "agent_products" ADD CONSTRAINT "fk_agent_products_company_user_id" FOREIGN KEY("company_user_id")
REFERENCES "company_users" ("id");

ALTER TABLE "agent_products" ADD CONSTRAINT "fk_agent_products_product" FOREIGN KEY("product")
REFERENCES "subscription_products" ("id");

ALTER TABLE "agent_products" ADD CONSTRAINT "fk_agent_products_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");
CREATE TABLE "contacts" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "salutation" varchar   NOT NULL,
    "firstname" varchar   NOT NULL,
    "lastname" varchar   NOT NULL,
    "status" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
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

ALTER TABLE "user_review" ADD CONSTRAINT "fk_user_review_user_id" FOREIGN KEY("user_id")
REFERENCES "users" ("id");

ALTER TABLE "user_review" ADD CONSTRAINT "fk_user_review_reviewed_by" FOREIGN KEY("reviewed_by")
REFERENCES "users" ("id");


CREATE TABLE "webportals" (
    "id" bigserial   NOT NULL,
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

ALTER TABLE "social_connections" ADD CONSTRAINT "fk_social_connections_companies_id" FOREIGN KEY("companies_id")
REFERENCES "companies" ("id");

ALTER TABLE "social_connections" ADD CONSTRAINT "fk_social_connections_requested_by" FOREIGN KEY("requested_by")
REFERENCES "companies" ("id");


CREATE TABLE "faqs" (
    "id" bigserial   NOT NULL,
    "company_id" bigint NULL,
    "section_id" bigint NULL,
    "tags" varchar[] NULL, 
    "questions" varchar NOT NULL,
    "answers" varchar NOT NULL,
    "media_urls" varchar[]   NOT NULL,
    "created_at" timestamptz  DEFAULT now() NOT NULL,
    "updated_at" timestamptz  DEFAULT now() NOT NULL,
    "status" bigint NOT NULL,
    CONSTRAINT "pk_faqs" PRIMARY KEY (
        "id"
     )
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