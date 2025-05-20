ALTER TABLE property_versions 
ADD COLUMN has_gallery BOOLEAN DEFAULT false,
ADD COLUMN has_plans BOOLEAN DEFAULT false;

ALTER TABLE unit_versions 
ADD COLUMN has_gallery BOOLEAN DEFAULT false,
ADD COLUMN has_plans BOOLEAN DEFAULT false;