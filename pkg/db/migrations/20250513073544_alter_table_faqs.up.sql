
 
ALTER TABLE "faqs" ALTER COLUMN "questions_ar" SET NOT NULL;
 
ALTER TABLE "faqs" ALTER COLUMN "answers_ar" SET NOT NULL;
 
ALTER TABLE "faqs" DROP COLUMN "platform_id";