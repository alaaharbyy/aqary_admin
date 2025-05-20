CREATE TABLE company_activities_detail (
    id BIGSERIAL PRIMARY KEY,
    company_id BIGINT NOT NULL,
    activity_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT, 
    status INTEGER NOT NULL DEFAULT 1,
    created_by BIGINT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_company_id FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    CONSTRAINT fk_activity_id FOREIGN KEY (activity_id) REFERENCES company_activities(id) ON DELETE CASCADE,
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT
);

-- Create an index for faster queries on company_id and activity_id
CREATE INDEX idx_company_activities_detail_company_id ON company_activities_detail (company_id);
CREATE INDEX idx_company_activities_detail_activity_id ON company_activities_detail (activity_id);
CREATE INDEX idx_company_activities_detail_status ON company_activities_detail (status);

