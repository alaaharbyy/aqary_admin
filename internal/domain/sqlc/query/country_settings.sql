-- name: CreateCountrySettings :exec
INSERT INTO countries (
    country,
    country_ar,
    flag,
    created_at, 
    updated_at,
    alpha2_code,
    alpha3_code,
    country_code, 
    name, 
    status, 
    updated_by
)VALUES (
    $1, $2, $3, $4, $5, $6,$7,$8,$9,$10,$11 
);



-- name: UpdateCountrySettings :exec
Update countries
SET 
    country=$2, 
    flag=$3, 
    updated_at=$4, 
    alpha2_code=$5, 
    alpha3_code=$6, 
    country_code=$7, 
    name=$8, 
    updated_by=$9, 
    status=$10,
    country_ar=$11
WHERE id=$1 AND status!= 6; 


-- name: GetCountrySettingsByID :one 
SELECT country, flag,alpha2_code,alpha3_code,country_code,status,name,country_ar
FROM countries
WHERE id=$1 AND status!=6; 

-- name: GetAllCountriesSettings :many 
SELECT
    id,
    country,
    flag,
    alpha2_code,
    alpha3_code,
    country_code,
    status,
    updated_at,
    country_ar
FROM
    countries
WHERE 
    (@status::BIGINT = 6 AND status = 6) 
    OR (@status::BIGINT != 6 AND status IN (1, 2))
ORDER BY
    updated_at DESC
LIMIT sqlc.narg('limit') OFFSET sqlc.narg('offset');


-- name: GetNumberOfCountriesSettings :one 
SELECT
   COUNT(*)
FROM
    countries
WHERE 
    (@status::BIGINT = 6 AND status = 6) 
    OR (@status::BIGINT != 6 AND status IN (1, 2));
    

-- name: DeleteRestoreCountrySettings :exec 
UPDATE countries 
SET 
    status = @status::BIGINT,
    updated_at = $2, 
    updated_by=$3
WHERE 
    id = $1;



    
    



