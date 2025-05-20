ALTER TABLE countries
ADD COLUMN status bigint NOT NULL DEFAULT 1,
ADD COLUMN deleted_at timestamptz NULL,
ADD COLUMN updated_by bigint NOT NULL DEFAULT 1;
ALTER TABLE countries ADD CONSTRAINT fk_countries_updated_by FOREIGN KEY(updated_by)
REFERENCES users (id);
ALTER TABLE countries
ALTER COLUMN status DROP DEFAULT,
ALTER COLUMN updated_by DROP DEFAULT;


ALTER TABLE states
ADD COLUMN status bigint NOT NULL DEFAULT 1,
ADD COLUMN deleted_at timestamptz NULL,
ADD COLUMN updated_by bigint NOT NULL DEFAULT 1;
ALTER TABLE states ADD CONSTRAINT fk_states_updated_by FOREIGN KEY(updated_by)
REFERENCES users (id);
ALTER TABLE states
ALTER COLUMN status DROP DEFAULT,
ALTER COLUMN updated_by DROP DEFAULT;

ALTER TABLE cities
ADD COLUMN status bigint NOT NULL DEFAULT 1,
ADD COLUMN deleted_at timestamptz NULL,
ADD COLUMN updated_by bigint NOT NULL DEFAULT 1;
ALTER TABLE cities ADD CONSTRAINT fk_cities_updated_by FOREIGN KEY(updated_by)
REFERENCES users (id);
ALTER TABLE cities
ALTER COLUMN status DROP DEFAULT,
ALTER COLUMN updated_by DROP DEFAULT;


ALTER TABLE communities
ADD COLUMN status bigint NOT NULL DEFAULT 1,
ADD COLUMN deleted_at timestamptz NULL,
ADD COLUMN updated_by bigint NOT NULL DEFAULT 1;
ALTER TABLE communities ADD CONSTRAINT fk_communities_updated_by FOREIGN KEY(updated_by)
REFERENCES users (id);
ALTER TABLE communities
ALTER COLUMN status DROP DEFAULT,
ALTER COLUMN updated_by DROP DEFAULT;

ALTER TABLE sub_communities
ADD COLUMN status bigint NOT NULL DEFAULT 1,
ADD COLUMN deleted_at timestamptz NULL,
ADD COLUMN updated_by bigint NOT NULL DEFAULT 1;
ALTER TABLE sub_communities ADD CONSTRAINT fk_sub_communities_updated_by FOREIGN KEY(updated_by)
REFERENCES users (id);
ALTER TABLE sub_communities
ALTER COLUMN status DROP DEFAULT,
ALTER COLUMN updated_by DROP DEFAULT;

ALTER TABLE properties_map_location
ADD COLUMN status bigint NOT NULL DEFAULT 1,
ADD COLUMN deleted_at timestamptz NULL,
ADD COLUMN updated_by bigint NOT NULL DEFAULT 1;
ALTER TABLE properties_map_location ADD CONSTRAINT fk_properties_map_location_updated_by FOREIGN KEY(updated_by)
REFERENCES users (id);
ALTER TABLE properties_map_location
ALTER COLUMN status DROP DEFAULT,
ALTER COLUMN updated_by DROP DEFAULT;

ALTER TABLE currency
ADD COLUMN status bigint NOT NULL DEFAULT 1,
ADD COLUMN deleted_at timestamptz NULL,
ADD COLUMN updated_by bigint NOT NULL DEFAULT 1;
ALTER TABLE currency ADD CONSTRAINT fk_currency_updated_by FOREIGN KEY(updated_by)
REFERENCES users (id);
ALTER TABLE currency
ALTER COLUMN status DROP DEFAULT,
ALTER COLUMN updated_by DROP DEFAULT;

COMMENT ON COLUMN countries.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN states.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN cities.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN communities.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN sub_communities.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN properties_map_location.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';
COMMENT ON COLUMN currency.status IS '1=>draft (disable), 2=>available (enable), 6=>deleted';

UPDATE countries SET status = 2 WHERE id = 1;
UPDATE states SET status = 2 WHERE id = 1;
UPDATE cities SET status = 2 WHERE id = 1;
UPDATE communities SET status = 2 WHERE id = 1;
UPDATE sub_communities SET status = 2 WHERE id = 1;
UPDATE currency SET status = 2 WHERE id = 1;

ALTER TABLE property_type_unit_type
ADD CONSTRAINT uc_property_type_unit_type_unit_type_id_property_type_id UNIQUE(
    unit_type_id,property_type_id
);
COMMENT ON COLUMN global_property_type.status IS '1=>in-active, 2=>active, 6=>deleted';
ALTER TABLE global_property_type ALTER COLUMN status SET DEFAULT 2;
UPDATE global_property_type SET status = 2 WHERE status = 1;
COMMENT ON COLUMN unit_type.status IS '1=>in-active, 2=>active, 6=>deleted';
ALTER TABLE unit_type ALTER COLUMN status SET DEFAULT 2;
UPDATE unit_type SET status = 2 WHERE status = 1;


------------- * INFO :--Start HERE--:: there is not any down for this, write if needed--------
WITH duplicates AS (
    SELECT id, currency,
           ROW_NUMBER() OVER (PARTITION BY currency ORDER BY id) AS row_num
    FROM currency
)
DELETE FROM currency
WHERE id IN (
    SELECT id
    FROM duplicates
    WHERE row_num > 1
);

CREATE TABLE "currency_new" (
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
    CONSTRAINT "pk_currency_new" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_currency_new_currency" UNIQUE (
        "currency"
    ),
    CONSTRAINT "uc_currency_new_code" UNIQUE (
        "code"
    )
 
);

insert into currency_new(
  currency,
    code,
    flag,
    currency_rate,
    updated_at,
    updated_by,
    created_at,
    status
)SELECT  currency,
    code,
    flag,
    currency_rate,
    updated_at,
    updated_by,
    created_at,
    status from currency;



update currency_new 
    set currency='UAE Dirham1',
    code='AED1',
    flag='https://aqarydashboard.blob.core.windows.net/upload/flags/1731308024339707437019319ff-f213-7e58-93ce-aeb6be6a0c9eflag-of-the-united-arab-emirates.webp'
    where code='AED';

UPDATE currency_new
SET 
    currency=currency||'1',
    code = code||'1',
    flag = flag,
    currency_rate = currency_rate,
    updated_at = updated_at,
    updated_by = updated_by,
    created_at = created_at,
    status = status
WHERE id = 1;

insert into currency_new(
  currency,
    code,
    flag,
    currency_rate,
    updated_at,
    updated_by,
    created_at,
    status
)SELECT  REPLACE(currency, '1', ''),
    REPLACE(code, '1', ''),
    flag,
    currency_rate,
    updated_at,
    updated_by,
    created_at,
    status from currency_new where id  = 1;

update currency_new 
    set currency='UAE Dirham',
    code='AED',
    flag='https://aqarydashboard.blob.core.windows.net/upload/flags/1731308024339707437019319ff-f213-7e58-93ce-aeb6be6a0c9eflag-of-the-united-arab-emirates.webp'
    where id = 1;

DELETE FROM currency_new WHERE code = 'AED1';

ALTER TABLE currency RENAME TO currency_temp;
ALTER TABLE currency_new RENAME TO currency;

 
ALTER TABLE bank_account_details DROP CONSTRAINT fk_bank_account_details_currency_id;

ALTER TABLE bank_account_details
ADD CONSTRAINT fk_bank_account_details_currency_id FOREIGN KEY (currency_id) REFERENCES currency (id);

DROP TABLE IF EXISTS currency_temp;

ALTER TABLE currency DROP CONSTRAINT uc_currency_new_currency;
ALTER TABLE currency DROP CONSTRAINT uc_currency_new_code;

 ALTER TABLE currency  
 ADD CONSTRAINT "uc_currency_currency" UNIQUE (
        "currency"
    ),
    ADD CONSTRAINT "uc_currency_code" UNIQUE (
        "code"
    );

ALTER TABLE currency RENAME CONSTRAINT pk_currency_new TO pk_currency;

ALTER TABLE company_activities RENAME COLUMN tag_id TO tags;
ALTER TABLE company_activities ALTER COLUMN tags SET DATA TYPE varchar[];
ALTER TABLE company_activities ALTER COLUMN status SET DEFAULT 2;
ALTER TABLE company_category ALTER COLUMN status SET DEFAULT 2;

DELETE FROM facilities_amenities WHERE id = 92;
DELETE FROM facilities_amenities WHERE id = 94;
DELETE FROM facilities_amenities WHERE id = 211;
DELETE FROM facilities_amenities WHERE id = 219;
DELETE FROM facilities_amenities WHERE id = 223;

ALTER TABLE facilities_amenities ADD CONSTRAINT uc_facilities_amenities_title_type_categories UNIQUE(
    title,type,categories
);


ALTER TABLE categories ADD COLUMN "type" bigint NOT NULL DEFAULT 1;
ALTER TABLE categories ALTER COLUMN "type" DROP DEFAULT;

INSERT INTO categories(category,created_at,updated_at,updated_by,"type")
SELECT category,now(),now(),updated_by,2 FROM categories;

COMMENT ON COLUMN categories.type IS '1=>facility, 2=>amenity';

ALTER TABLE facts ADD COLUMN title_ar VARCHAR NOT NULL DEFAULT '';
ALTER TABLE facts ALTER COLUMN title_ar DROP DEFAULT;

ALTER TABLE company_verification ADD COLUMN draft_contract VARCHAR NULL;

ALTER TABLE agent_products DROP COLUMN package_id;
DROP TABLE IF EXISTS newsletter_subscribers;
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

ALTER TABLE subscription_package DROP COLUMN remained_units;




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


ALTER TABLE projects ADD COLUMN deleted_at timestamptz NULL;
ALTER TABLE subscription_order ALTER COLUMN sign_date DROP NOT NULL;

ALTER TABLE views ADD COLUMN title_ar varchar NULL;
ALTER TABLE user_types ADD COLUMN user_type_ar varchar NULL;

ALTER TABLE unit_type_variation ADD COLUMN title_ar varchar NULL;
ALTER TABLE unit_type ADD COLUMN type_ar varchar NULL;
ALTER TABLE tags ADD COLUMN type_name_ar varchar NULL;
ALTER TABLE services ADD COLUMN service_name_ar varchar NULL;

ALTER TABLE service_promotions 
ADD COLUMN promotion_name_ar varchar NULL,
ADD COLUMN promotion_details_ar varchar NULL;

ALTER TABLE roles ADD COLUMN role_ar varchar NULL;
ALTER TABLE review_terms ADD COLUMN review_term_ar varchar NULL; -- not exist in schema
ALTER TABLE global_property_type ADD COLUMN type_ar varchar NULL;
ALTER TABLE global_media ADD COLUMN gallery_type_ar varchar NULL;
-- ALTER TABLE facts ADD COLUMN title_ar varchar NULL;
ALTER TABLE facilities_amenities ADD COLUMN title_ar varchar NULL;
ALTER TABLE documents_subcategory ADD COLUMN sub_category_ar varchar NULL;
ALTER TABLE documents_category ADD COLUMN category_ar varchar NULL;
ALTER TABLE company_types ADD COLUMN title_ar varchar NULL;
ALTER TABLE company_category ADD COLUMN category_name_ar varchar NULL;
ALTER TABLE blog_categories 
ADD COLUMN category_title_ar varchar NULL,
ADD COLUMN description_ar varchar NULL;

ALTER TABLE addresses 
ADD COLUMN full_address_ar varchar NULL;

ALTER TABLE countries ADD COLUMN country_ar varchar NULL;
ALTER TABLE states ADD COLUMN state_ar varchar NULL;
ALTER TABLE cities ADD COLUMN city_ar varchar NULL;
ALTER TABLE communities ADD COLUMN community_ar varchar NULL;
ALTER TABLE sub_communities ADD COLUMN sub_community_ar varchar NULL;
ALTER TABLE properties_map_location ADD COLUMN property_ar varchar NULL;
ALTER TABLE company_activities ADD COLUMN activity_name_ar VARCHAR NULL;

ALTER TABLE subscription_order 
ADD COLUMN draft_contract varchar NOT NULL DEFAULT '',
ADD COLUMN contract_file varchar NULL;

ALTER TABLE subscription_order ALTER COLUMN draft_contract DROP DEFAULT;

ALTER TABLE platform_contacts
ADD COLUMN purpose varchar NOT NULL DEFAULT '',
ADD COLUMN phone_number varchar NULL,
ADD COLUMN country_code varchar NULL;

ALTER TABLE platform_contacts
ALTER COLUMN purpose DROP DEFAULT;

ALTER TABLE faqs RENAME section_id TO section_name;
ALTER TABLE faqs ALTER COLUMN section_name SET DATA TYPE varchar;
ALTER TABLE faqs ALTER COLUMN media_urls DROP NOT NULL;

ALTER TABLE platform_contacts DROP CONSTRAINT uc_platform_contacts_email;
ALTER TABLE platform_contacts DROP CONSTRAINT uc_platform_contacts_email_platform;



------------- ???? COMPANY PROFILES ???? ---------------
CREATE TABLE "company_profiles" (
    "id" bigserial   NOT NULL,
    "ref_no" varchar   NOT NULL,
    "company_type" bigint  NOT NULL,
	"company_name" varchar  NOT NULL,
    "company_category_id" bigint NOT NULL,
    "company_activities_id" bigint[]   NOT NULL,
    "website_url" varchar   NULL,
    "company_email" varchar   NOT NULL,
    "phone_number" varchar   NOT NULL,
    "logo_url" varchar   NOT NULL,
	"cover_image_url" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "description_ar" varchar   NULL,
    "status" bigint   NOT NULL,
    "addresses_id" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
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
ALTER TABLE users
ADD COLUMN profile_views BIGINT DEFAULT 0 NOT NULL;

ALTER TABLE global_property_type ADD COLUMN listing_facts bigint[] NOT NULL DEFAULT '{}';
ALTER TABLE unit_type ADD COLUMN listing_facts bigint[] NOT NULL DEFAULT '{}';
ALTER TABLE global_property_type ALTER COLUMN listing_facts DROP DEFAULT;
ALTER TABLE unit_type ALTER COLUMN listing_facts DROP DEFAULT;
ALTER TABLE xml_url ADD COLUMN last_report VARCHAR NULL;
------------- * INFO :--END HERE--:: there is not any down for this, write if needed--------