ALTER TABLE projects 
ADD COLUMN start_date DATE NULL,
ADD COLUMN end_date DATE NULL;

ALTER TABLE phases 
ADD COLUMN start_date DATE NULL,
ADD COLUMN end_date DATE NULL;
 
ALTER TABLE property 
ADD COLUMN start_date DATE NULL,
ADD COLUMN end_date DATE NULL;
 
ALTER TABLE units 
ADD COLUMN start_date DATE NULL,
ADD COLUMN end_date DATE NULL;