
-- name: CreateProfileLanguage :one
INSERT INTO profile_languages(
    profiles_id,
    all_languages_id
)VALUES (
    $1, $2
)RETURNING *;


-- name: UpdateProfileLanguage :one
Update profile_languages
SET all_languages_id = $2
WHERE profiles_id = $1 and id = $3
RETURNING *; 

-- name: DeleteProfileLanguage :many
DELETE FROM profile_languages
WHERE profiles_id = $1 
RETURNING *;

-- name: CreateProfileNationalities :one
INSERT INTO profile_nationalities(
    profiles_id,
    country_id
)VALUES (
    $1, $2
)RETURNING *;


-- name: DeleteProfileNationalities :many
DELETE FROM profile_nationalities
WHERE profiles_id = $1 
RETURNING *;


-- name: UpdateProfileNationalies :one 
Update profile_nationalities
SET country_id = $2
WHERE profiles_id = $1
RETURNING *;


-- name: GetAllLanguagesByID :one
SELECT * FROM profile_languages
INNER JOIN all_languages ON profile_languages.all_languages_id = all_languages.id
WHERE profile_languages.id = @id;


-- name: GetAllNationalitiesByProfileID :many
SELECT * FROM profile_nationalities
INNER JOIN countries ON profile_nationalities.country_id =  countries.id
WHERE profile_nationalities.profiles_id = @profile_id;
 

-- name: GetAllLanguagesByUserID :many
SELECT * FROM profile_languages
INNER JOIN all_languages ON profile_languages.all_languages_id = all_languages.id
WHERE profile_languages.profiles_id = @profile_id;

-- name: CheckProfileLanguageExists :one
SELECT * FROM profile_languages 
INNER JOIN all_languages ON profile_languages.all_languages_id = all_languages.id
WHERE profile_languages.profiles_id = @profile_id AND profile_languages.all_languages_id = @language_id;

-- name: CheckProfileNationalityExists :one
SELECT * FROM profile_nationalities
INNER JOIN countries ON profile_nationalities.country_id = countries.id
WHERE profile_nationalities.profiles_id = @profile_id AND profile_nationalities.country_id = @country_id ;
 
-- name: GetNationalitiesIDsByProfile :one
SELECT ARRAY_AGG(country_id::BIGINT)::BIGINT[] AS nationality_ids 
FROM profile_nationalities WHERE profiles_id= @profile_id 
GROUP BY profiles_id;

-- name: GetLanguagesIDsByProfile :one
SELECT ARRAY_AGG(all_languages_id::BIGINT)::BIGINT[] AS languages_ids 
FROM profile_languages WHERE profiles_id= @profile_id 
GROUP BY profiles_id;


-- name: DeleteProfileNationalityList :exec
DELETE FROM profile_nationalities
WHERE profiles_id = $1 AND country_id=any(@countries::BIGINT[]);

-- name: DeleteProfileLanguageList :exec
DELETE FROM profile_languages
WHERE profiles_id = $1 AND all_languages_id=any(@languages_ids::BIGINT[]);