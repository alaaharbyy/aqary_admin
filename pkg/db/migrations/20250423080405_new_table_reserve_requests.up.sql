CREATE TABLE reservation_requests (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    email VARCHAR NOT NULL UNIQUE,
    phone VARCHAR NOT NULL,
    nic_document VARCHAR NOT NULL,     
    payment_proof VARCHAR NOT NULL,   

    entity_type BIGINT NOT NULL,        
    entity_id BIGINT NOT NULL,          

    status BIGINT NOT NULL DEFAULT 1,  
    created_by BIGINT NOT NULL,                      

    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
