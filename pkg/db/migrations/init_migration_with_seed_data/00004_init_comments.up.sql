COMMENT ON TABLE companies IS 'table for company information';
COMMENT ON COLUMN companies.company_rank IS 'rank of the company i.e. standard,featured, premium,top deal etc.';
COMMENT ON COLUMN companies.users_id IS 'admin user of the company';

COMMENT ON COLUMN financial_providers.provider_type IS '1 => Bank & 2 => Financial Institution';
COMMENT ON COLUMN project_financial_provider.financial_providers_id IS 'foriegn key ids of table financial_providers';

COMMENT ON COLUMN unit_versions.type IS '1=>Sale, 2=>Rent, 3=>Swap & 4=>Booking';
COMMENT ON COLUMN property_versions.category IS '1=>Sale, 2=>Rent & 3=>Swap';

COMMENT ON COLUMN timeslots.entity_type_id IS 'only 12=>Open House or 13=> Schedule View';

COMMENT ON COLUMN payments.status IS '1=>unpaid & 2=>paid';

COMMENT ON TABLE entity_review IS 'Stores entity reviews with their basic information';
COMMENT ON TABLE review_terms IS 'Stores available review terms for different entity types';
COMMENT ON TABLE reviews_table IS 'Stores the actual review values for each review term';

COMMENT ON COLUMN license.metadata IS 'to store the filename,extension etc.';
COMMENT ON COLUMN facilities_amenities.type IS '1=>Facility & 2=>Amenity';

COMMENT ON COLUMN subscription_order.status IS '1 => in-active, 2 => active';

