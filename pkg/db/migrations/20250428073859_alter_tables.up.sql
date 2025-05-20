ALTER TABLE "faqs" DROP COLUMN "section_name";
ALTER TABLE "faqs" ADD COLUMN "section_id" bigint NULL;
ALTER TABLE community_guidelines DROP COLUMN IF EXISTS title;
