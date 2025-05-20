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