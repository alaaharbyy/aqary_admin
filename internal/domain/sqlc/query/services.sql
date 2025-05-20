-- name: CreateService :one
INSERT INTO services (
    ref_no,
    company_id,
    company_activities_id,
    service_name,
    service_name_ar,
    description,
    description_ar,
    price,
    tag_id,
    service_rank,
    created_by,
    created_at,
    updated_at,
    status
)VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,$13,$14
) RETURNING *;

-- name: UpdateService :one
UPDATE services SET 
    service_name=$1,
    service_name_ar=$2,
    description=$3,
    description_ar=$4,
    price=$5,
    tag_id=$6,
    service_rank=$7,
    updated_at=$8
WHERE id=$9
RETURNING *;

-- name: UpdateServiceRank :one
UPDATE services SET 
    service_rank=$3,
    updated_at=$2
WHERE id=$1
RETURNING *;

-- name: GetServices :many
WITH rating AS(
	SELECT  entity_review.entity_id AS id, avg(reviews_table.review_value) AS rating_value FROM entity_review 
	JOIN reviews_table ON reviews_table.entity_review_id=entity_review.id
	WHERE entity_review.entity_type_id= @services_entity_type
	GROUP BY entity_review.entity_id
),
service_tags AS (
    SELECT 
        services.id AS service_id,
        ARRAY_AGG(global_tagging.tag_name::varchar)::varchar[] AS tag_names
    FROM services
    JOIN LATERAL UNNEST(services.tag_id) AS tags_id ON true
    JOIN global_tagging ON global_tagging.id = tags_id
    GROUP BY services.id
)
SELECT 
    sqlc.embed(services),
    companies.company_name, 
    CASE WHEN @lang::varchar = 'ar' THEN COALESCE(company_activities.activity_name_ar,company_activities.activity_name)
    ELSE COALESCE(company_activities.activity_name, '') END::varchar as company_activity,
    COALESCE(rating.rating_value, 0.0),
    service_tags.tag_names::varchar[]
FROM services
JOIN companies ON companies.id = services.company_id
JOIN company_activities ON company_activities.id = services.company_activities_id
LEFT JOIN rating ON rating.id = services.id
LEFT JOIN service_tags ON service_tags.service_id = services.id
WHERE services.status = $3
LIMIT $1 OFFSET $2;

-- name: GetServicesCount :one
SELECT 
    count(services.id)
FROM services
JOIN companies ON companies.id = services.company_id
JOIN company_activities ON company_activities.id = services.company_activities_id
WHERE services.status = $1;


-- name: GetService :one
with service_tags AS (
    SELECT 
        services.id AS service_id,
        ARRAY_AGG(global_tagging.tag_name::varchar)::varchar[] AS tag_names
    FROM services
    JOIN LATERAL UNNEST(services.tag_id) AS tags_id ON true
    JOIN global_tagging ON global_tagging.id = tags_id
    GROUP BY services.id
)
SELECT
    sqlc.embed(services),companies.company_name, company_activities.activity_name,company_activities.activity_name_ar,service_tags.tag_names::varchar[]
FROM services
JOIN companies ON companies.id=services.company_id
JOIN company_activities ON company_activities.id=services.company_activities_id
LEFT JOIN service_tags ON service_tags.service_id = services.id
WHERE services.id=$1;

-- name: UpdateServiceStatus :one
UPDATE services SET 
    status=$1,
    updated_at=$2
WHERE id=$3
RETURNING *;

-- name: GetServiceReviews :many
with score as (
  select reviews_table.entity_review_id as id,  json_agg( json_build_object( 'term', review_terms.review_term, 'term_ar', review_terms.review_term_ar, 'value',reviews_table.review_value ) ) as scores from reviews_table
	join review_terms on review_terms.id=reviews_table.review_term_id 
	group by reviews_table.entity_review_id
)
SELECT 
	services.service_name,
	services.service_name_ar,
	companies.company_name,
	company_activities.activity_name,
	company_activities.activity_name_ar,
	score.scores,
	sqlc.embed(entity_review), 
	profiles.first_name,
	profiles.last_name,
	profiles.profile_image_url
FROM entity_review 
JOIN score ON score.id=entity_review.id
JOIN services ON services.id=entity_review.entity_id 
JOIN companies ON companies.id=services.company_id
JOIN company_activities ON company_activities.id=services.company_activities_id
JOIN profiles on profiles.users_id=entity_review.reviewer
WHERE entity_review.entity_type_id= @services_entity_type AND services.id= $1 AND services.status!=6 AND companies.status!=6 AND company_activities.status!=6 ;