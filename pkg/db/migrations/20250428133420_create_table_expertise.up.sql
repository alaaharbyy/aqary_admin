-- Table: expertise
CREATE TABLE expertise (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    title_ar VARCHAR(255),
    description VARCHAR(5000),
    status BIGINT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
 
    CONSTRAINT unique_expertise_title UNIQUE (title)
);
 
-- Table: company_user_expertise
CREATE TABLE company_user_expertise (
    id BIGSERIAL PRIMARY KEY,
    expertise_id BIGINT NOT NULL ,
    company_user_id BIGINT NOT NULL ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
 
    CONSTRAINT unique_company_user_expertise UNIQUE (expertise_id, company_user_id),
    CONSTRAINT fk_expertise FOREIGN KEY (expertise_id) REFERENCES expertise(id) ON DELETE CASCADE
);