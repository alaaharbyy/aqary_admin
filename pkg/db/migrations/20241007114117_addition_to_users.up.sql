


ALTER TABLE profiles DROP COLUMN nic_image_url;
ALTER TABLE profiles DROP COLUMN nic_no;
ALTER TABLE profiles DROP COLUMN all_languages_id;
ALTER TABLE profiles DROP COLUMN tawasal;
ALTER TABLE profiles DROP COLUMN botim;
ALTER TABLE profiles DROP COLUMN company_number;

ALTER TABLE profiles ADD COLUMN secondary_number varchar NULL;
ALTER TABLE profiles ADD COLUMN show_whatsapp_number bool NULL;
ALTER TABLE profiles ADD COLUMN botim_number varchar NULL;
ALTER TABLE profiles ADD COLUMN show_botim_number bool NULL;
ALTER TABLE profiles ADD COLUMN tawasal_number varchar NULL;
ALTER TABLE profiles ADD COLUMN show_tawasal_number bool NULL;
ALTER TABLE profiles ADD COLUMN about varchar NULL;
ALTER TABLE profiles ADD COLUMN about_arabic varchar NULL;


 
-- ALTER TABLE profiles ADD COLUMN cover_image_url varchar NULL;
-- ALTER TABLE profiles ADD COLUMN passport_no varchar NULL;
-- ALTER TABLE profiles ADD COLUMN passport_image_url varchar NULL;
-- ALTER TABLE profiles ADD COLUMN about varchar NULL;

-- ALTER TABLE users DROP department CASCADE; 

-- ALTER TABLE users ADD COLUMN show_hide_details varchar NULL;
-- ALTER TABLE users ADD COLUMN experiance_since timestamptz NULL;
-- ALTER TABLE users ADD COLUMN is_verified bool NULL;

  