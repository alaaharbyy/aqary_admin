ALTER TABLE profiles ADD COLUMN users_id bigint NOT NULL DEFAULT 1;
ALTER TABLE profiles ADD CONSTRAINT fk_profiles_users_id FOREIGN KEY(users_id) REFERENCES users (id);

UPDATE profiles
SET users_id = users.id
FROM users
WHERE users.profiles_id = profiles.id;

UPDATE users
SET phone_number = profiles.phone_number
FROM profiles
WHERE profiles.users_id = users.id;


ALTER TABLE profiles DROP COLUMN phone_number;
ALTER TABLE users DROP COLUMN profiles_id;
ALTER TABLE profiles ALTER COLUMN users_id DROP DEFAULT;
