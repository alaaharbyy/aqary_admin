DROP TABLE IF EXISTS share_requests CASCADE;
DROP TABLE IF EXISTS shared_documents CASCADE;
DROP TABLE IF EXISTS sharing CASCADE;
DROP TYPE IF EXISTS sharing_type CASCADE;
 
CREATE TYPE sharing_type AS ENUM ('internal', 'external');

-- Create tables if they don't exist
CREATE TABLE IF NOT EXISTS sharing (
    id BIGSERIAL PRIMARY KEY,
    sharing_type bigint NOT NULL,
    entity_type_id BIGINT REFERENCES entity_type(id),
    entity_id BIGINT NOT NULL,
    shared_to BIGINT NOT NULL,
    is_enabled BOOLEAN DEFAULT TRUE, 
    country_id bigint NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    created_by BIGINT REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS shared_documents (
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

CREATE TABLE IF NOT EXISTS share_requests (
    id BIGSERIAL PRIMARY KEY,
    document_id BIGINT REFERENCES shared_documents(id),
    request_status INT NOT NULL DEFAULT 1,
    sharing_type sharing_type NOT NULL DEFAULT 'internal',
    requester_id BIGINT REFERENCES users(id),
    owner_id BIGINT REFERENCES users(id),
    created_by BIGINT REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

 
CREATE INDEX IF NOT EXISTS idx_sharing_entity ON sharing(entity_type_id, entity_id);
CREATE INDEX IF NOT EXISTS idx_sharing_shared_to ON sharing(shared_to);
CREATE INDEX IF NOT EXISTS idx_sharing_sharing_type ON sharing(sharing_type);

CREATE INDEX IF NOT EXISTS idx_shared_documents_sharing ON shared_documents(sharing_id);
CREATE INDEX IF NOT EXISTS idx_shared_documents_category ON shared_documents(category_id, subcategory_id);
CREATE INDEX IF NOT EXISTS idx_shared_documents_status ON shared_documents(status);

CREATE INDEX IF NOT EXISTS idx_share_requests_document ON share_requests(document_id);
CREATE INDEX IF NOT EXISTS idx_share_requests_status ON share_requests(request_status);
CREATE INDEX IF NOT EXISTS idx_share_requests_requester ON share_requests(requester_id);
CREATE INDEX IF NOT EXISTS idx_share_requests_sharing_type ON share_requests(sharing_type);