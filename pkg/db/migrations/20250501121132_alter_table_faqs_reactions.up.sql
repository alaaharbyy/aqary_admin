ALTER TABLE "faq_user_reactions"
DROP CONSTRAINT IF EXISTS "faq_user_reactions_user_id_fkey";

ALTER TABLE "faq_user_reactions"
ADD CONSTRAINT "faq_user_reactions_user_id_fkey"
FOREIGN KEY ("user_id") REFERENCES "platform_users"("id") ON DELETE CASCADE;