CREATE TABLE refresh_schedules (
    id BIGSERIAL PRIMARY KEY,
    entity_id BIGINT NOT NULL,
    entity_type_id INT NOT NULL,

    schedule_type TEXT NOT NULL CHECK (schedule_type IN ('daily', 'weekly')),

    next_run_at TIMESTAMPTZ NOT NULL,
    last_run_at TIMESTAMPTZ,

    preferred_hour INT NOT NULL DEFAULT 3 CHECK (preferred_hour >= 0 AND preferred_hour < 24),
    preferred_minute INT NOT NULL DEFAULT 0 CHECK (preferred_minute >= 0 AND preferred_minute < 60),

    week_days SMALLINT[] CHECK (
        week_days IS NULL 
        OR array_length(week_days, 1) <= 6
    ),

    status BIGINT NOT NULL,
    created_by BIGINT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
