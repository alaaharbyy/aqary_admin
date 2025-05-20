ALTER TABLE property ADD COLUMN exclusive boolean NOT NULL DEFAULT false;
ALTER TABLE units ADD COLUMN exclusive boolean NOT NULL DEFAULT false;
ALTER TABLE projects ADD COLUMN exclusive boolean NOT NULL DEFAULT false;
ALTER TABLE phases ADD COLUMN exclusive boolean NOT NULL DEFAULT false;
