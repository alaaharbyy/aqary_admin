




-- name: GetCareerNationalities :many
SELECT nats.*
FROM
    careers cr
JOIN LATERAL unnest(cr.nationality_id) AS nat ON true
JOIN countries nats ON nat = nats.id
WHERE cr.id=$1;



-- name: GetCareerSpecializations :many
SELECT specs.*
FROM
    careers cr
JOIN LATERAL unnest(cr.specialization) AS spec ON true
JOIN specialization as specs ON spec = specs.id
WHERE cr.id=$1;



-- name: GetCareerBenefits :many
SELECT bens.*
FROM
    careers cr
JOIN LATERAL unnest(cr.benefits) AS ben ON true
JOIN benefits bens ON ben = bens.id
WHERE cr.id=$1;



-- name: GetCareerTags :many
SELECT tags.*
FROM
    careers cr
JOIN LATERAL unnest(cr.global_tagging_id) AS tag ON true
JOIN global_tagging as tags ON tag = tags.id
WHERE cr.id=$1;



-- name: GetCareerFieldsOfStudy :many
SELECT foss.*
FROM
    careers cr
JOIN LATERAL unnest(cr.field_of_studies) AS fos ON true
JOIN field_of_studies as foss ON fos = foss.id
WHERE cr.id=$1;



-- name: GetCareerLanguages :many
SELECT langs.*
FROM
    careers cr
JOIN LATERAL unnest(cr.languages) AS lang ON true
JOIN all_languages langs ON lang = langs.id
WHERE cr.id=$1;



-- -- name: SearchEmployerCareersByTitle :many
-- SELECT sqlc.embed(c)
-- FROM careers c
-- JOIN employers e ON e.id= c.employers_id
-- WHERE 
-- job_title ILIKE '%' || $2 || '%' AND 
-- career_status != 6 AND e.users_id=$1;



-- -- name: GetCareersCountForEmployer :one
-- SELECT COUNT(*) 
-- FROM careers c
-- JOIN employers e ON e.id= c.employers_id
-- WHERE e.users_id=$1 AND c.career_status!=6;



-- name: GetSkillsForCareer :one
SELECT
    array_agg(DISTINCT COALESCE( skill.id,0))::bigint[] AS skills_ids, 
    array_agg(DISTINCT COALESCE (skill.title,''))::text[] AS skills 
    from careers c
LEFT JOIN LATERAL unnest(c.skills) AS skill_id ON true
LEFT JOIN skills as skill ON skill_id = skill.id
where c.id=$1;



-- -- name: GetCareerActivitiesCount :one
-- SELECT COUNT(*) FROM careers c
-- JOIN careers_activities ca ON c.id=ca.ref_activity_id
-- WHERE c.employers_id=$1 ;

-- name: CareersAdvancedSearch :many
-- WITH 

-- candidate_count AS (
--     SELECT
--         c.careers_id,
--         COUNT(c.id) AS count
--     FROM
--         candidates c
--     JOIN
--         applicants a ON c.applicants_id = a.id
--     JOIN
--         careers car ON c.careers_id = car.id
--     WHERE
--         c.application_status != 6 AND (car.career_status != 6 AND car.career_status != 5)
--     GROUP BY
--         c.careers_id
-- )
SELECT
    -- COALESCE(cc.count, 0) AS candidate_count,
    sqlc.embed(cr),
    -- sqlc.embed(e),
    sqlc.embed(co),
    sqlc.embed(ci),
    sqlc.embed(com)
FROM
    careers cr
-- LEFT JOIN
--     candidate_count cc ON cr.id = cc.careers_id
-- JOIN
--     employers e ON cr.employers_id = e.id
JOIN
    countries co ON cr.countries_id = co.id
JOIN
    cities ci ON cr.city_id = ci.id
JOIN
    communities com ON cr.community_id = com.id
WHERE
    (cr.min_salary >=  @min_salary OR @disable_min_salary::BOOLEAN)
AND
    (cr.max_salary <= @max_salary OR @disable_max_salary::BOOLEAN)
AND
    (cr.is_urgent = @is_urgent OR @disable_is_urgent::BOOLEAN)
AND
    (CASE WHEN ARRAY_LENGTH(@job_title::VARCHAR[], 1) IS NULL THEN TRUE
    ELSE cr.job_title = ANY(@job_title::VARCHAR[]) END)
AND
    (CASE WHEN ARRAY_LENGTH(@gender::BIGINT[], 1) IS NULL THEN TRUE
    ELSE cr.gender = ANY(@gender::BIGINT[]) END)
AND
    (CASE WHEN ARRAY_LENGTH(@career_status::BIGINT[], 1) IS NULL THEN TRUE
    ELSE cr.career_status = ANY(@career_status::bigint[]) END)
AND
    (CASE WHEN ARRAY_LENGTH(@career_level::BIGINT[], 1) IS NULL THEN TRUE
    ELSE cr.career_level = ANY(@career_level::bigint[]) END)
AND
    (CASE WHEN ARRAY_LENGTH(@years_of_experience::BIGINT[], 1) IS NULL THEN TRUE
    ELSE cr.years_of_experience = ANY(@years_of_experience::bigint[]) END)
AND 
	 (CASE WHEN ARRAY_LENGTH(@job_category::BIGINT[], 1) IS NULL THEN TRUE
    ELSE cr.job_categories = ANY(@job_category::bigint[]) END)
AND
    (CASE WHEN ARRAY_LENGTH(@keywords::VARCHAR[], 1) IS NULL THEN TRUE ELSE cr.job_title ILIKE ANY(@keywords::VARCHAR[])
    OR cr.ref_no ILIKE ANY(@keywords::VARCHAR[])
    OR cr.job_description ILIKE ANY(@keywords::VARCHAR[]) END)
AND
    (CASE WHEN ARRAY_LENGTH(@benefits::bigint[], 1) IS NULL THEN TRUE ELSE cr.benefits && @benefits::bigint[] END) AND
    (CASE WHEN ARRAY_LENGTH(@languages::bigint[], 1) IS NULL THEN TRUE ELSE cr.languages && @languages::bigint[] END) AND
    (CASE WHEN ARRAY_LENGTH(@employment_types::bigint[], 1) IS NULL THEN TRUE ELSE cr.employment_types && @employment_types::bigint[] END) AND
    (CASE WHEN ARRAY_LENGTH(@education_level::bigint[], 1) IS NULL THEN TRUE ELSE cr.education_level && @education_level::bigint[] END)
AND
    (CASE WHEN COALESCE(@dates::BIGINT,1) =1 THEN true WHEN @dates::BIGINT= 2 THEN cr.created_at >= DATE_TRUNC
        ('day', CURRENT_DATE) WHEN @dates::BIGINT = 3 THEN cr.created_at >= DATE_TRUNC('week', CURRENT_DATE - INTERVAL '1 week')AND cr.created_at < DATE_TRUNC('week', CURRENT_DATE)
        WHEN @dates::BIGINT = 4 THEN cr.created_at >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
        AND cr.created_at < DATE_TRUNC('month', CURRENT_DATE)
     END)
AND
    (CASE WHEN ARRAY_LENGTH(@cities_id::bigint[], 1) IS NULL THEN TRUE ELSE ci.id = ANY(@cities_id::bigint[]) END)  AND
    (CASE WHEN ARRAY_LENGTH(@communities_id::bigint[], 1) IS NULL THEN TRUE ELSE com.id = ANY(@communities_id::bigint[])END) AND
    (CASE WHEN ARRAY_LENGTH(@country_id::bigint[], 1) IS NULL THEN TRUE ELSE co.id = ANY(@country_id::bigint[]) END)
ORDER BY
    CASE
        WHEN @sort::bigint = 1 THEN cc.count END DESC,
    CASE
        WHEN @sort::bigint = 2 THEN cr.created_at END DESC,
    CASE
        WHEN @sort::bigint = 3 THEN cr.min_salary END DESC,
    CASE
        WHEN @sort::bigint = 4 THEN cr.min_salary END ASC
LIMIT $1 OFFSET $2;








-- name: CareersAdvancedSearchCount :one
SELECT
    count(cr.*)
FROM
    careers cr

-- JOIN
    -- employers e ON cr.employers_id = e.id
JOIN
    countries co ON cr.countries_id = co.id
JOIN
    cities ci ON cr.city_id = ci.id
JOIN
    communities com ON cr.community_id = com.id
WHERE
    (cr.min_salary >=  @min_salary OR @disable_min_salary::BOOLEAN)
AND
    (cr.max_salary <= @max_salary OR @disable_max_salary::BOOLEAN)
AND
    (cr.is_urgent = @is_urgent OR @disable_is_urgent::BOOLEAN)
AND
    (CASE WHEN ARRAY_LENGTH(@job_title::VARCHAR[], 1) IS NULL THEN TRUE
    ELSE cr.job_title = ANY(@job_title::VARCHAR[]) END)
AND
    (CASE WHEN ARRAY_LENGTH(@gender::BIGINT[], 1) IS NULL THEN TRUE
    ELSE cr.gender = ANY(@gender::BIGINT[]) END)
AND
    (CASE WHEN ARRAY_LENGTH(@career_status::BIGINT[], 1) IS NULL THEN TRUE
    ELSE cr.career_status = ANY(@career_status::bigint[]) END)
AND
    (CASE WHEN ARRAY_LENGTH(@career_level::BIGINT[], 1) IS NULL THEN TRUE
    ELSE cr.career_level = ANY(@career_level::bigint[]) END)
AND
    (CASE WHEN ARRAY_LENGTH(@years_of_experience::BIGINT[], 1) IS NULL THEN TRUE
    ELSE cr.years_of_experience = ANY(@years_of_experience::bigint[]) END)
AND 
	 (CASE WHEN ARRAY_LENGTH(@job_category::BIGINT[], 1) IS NULL THEN TRUE
    ELSE cr.job_categories = ANY(@job_category::bigint[]) END)
AND
    (CASE WHEN ARRAY_LENGTH(@keywords::VARCHAR[], 1) IS NULL THEN TRUE ELSE cr.job_title ILIKE ANY(@keywords::VARCHAR[])
    OR cr.ref_no ILIKE ANY(@keywords::VARCHAR[])
    OR cr.job_description ILIKE ANY(@keywords::VARCHAR[]) END)
AND
    (CASE WHEN ARRAY_LENGTH(@benefits::bigint[], 1) IS NULL THEN TRUE ELSE cr.benefits && @benefits::bigint[] END) AND
    (CASE WHEN ARRAY_LENGTH(@languages::bigint[], 1) IS NULL THEN TRUE ELSE cr.languages && @languages::bigint[] END) AND
    (CASE WHEN ARRAY_LENGTH(@employment_types::bigint[], 1) IS NULL THEN TRUE ELSE cr.employment_types && @employment_types::bigint[] END) AND
    (CASE WHEN ARRAY_LENGTH(@education_level::bigint[], 1) IS NULL THEN TRUE ELSE cr.education_level && @education_level::bigint[] END)
AND
    (CASE WHEN COALESCE(@dates::BIGINT,1) =1 THEN true WHEN @dates::BIGINT= 2 THEN cr.created_at >= DATE_TRUNC
        ('day', CURRENT_DATE) WHEN @dates::BIGINT = 3 THEN cr.created_at >= DATE_TRUNC('week', CURRENT_DATE - INTERVAL '1 week')AND cr.created_at < DATE_TRUNC('week', CURRENT_DATE)
        WHEN @dates::BIGINT = 4 THEN cr.created_at >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
        AND cr.created_at < DATE_TRUNC('month', CURRENT_DATE)
     END)
AND
    (CASE WHEN ARRAY_LENGTH(@cities_id::bigint[], 1) IS NULL THEN TRUE ELSE ci.id = ANY(@cities_id::bigint[]) END)  AND
    (CASE WHEN ARRAY_LENGTH(@communities_id::bigint[], 1) IS NULL THEN TRUE ELSE com.id = ANY(@communities_id::bigint[])END) AND
    (CASE WHEN ARRAY_LENGTH(@country_id::bigint[], 1) IS NULL THEN TRUE ELSE co.id = ANY(@country_id::bigint[]) END);