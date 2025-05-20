ALTER TABLE faqs RENAME section_id TO section_name;
ALTER TABLE faqs ALTER COLUMN section_name SET DATA TYPE varchar;