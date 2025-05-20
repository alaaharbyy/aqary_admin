ALTER TABLE projects
ADD COLUMN facts jsonb NULL;
 
ALTER TABLE phases
ADD COLUMN facts jsonb NULL;
 
 
update projects set facts = '{"price": 750000.75}';
 
update phases set facts = '{"price": 750000.75}';
 
 
 
 
ALTER TABLE projects
ALTER COLUMN facts SET NOT NULL;
 
ALTER TABLE phases
ALTER COLUMN facts SET NOT NULL;