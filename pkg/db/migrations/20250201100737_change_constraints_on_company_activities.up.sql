ALTER TABLE company_activities 
DROP CONSTRAINT IF EXISTS uc_company_activities_activity_name,
ADD CONSTRAINT "uc_company_activities_company_category_id_activity_name" UNIQUE (
        "company_category_id","activity_name"
    );