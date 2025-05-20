CREATE TABLE faq_user_reactions (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    faq_id INT NOT NULL,
    reaction VARCHAR(10) CHECK (reaction IN ('like', 'dislike', 'none')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (faq_id) REFERENCES faqs(id) ON DELETE CASCADE,
    CONSTRAINT unique_user_faq UNIQUE (user_id, faq_id)
);