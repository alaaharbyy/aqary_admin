-- name: CreateNewFaq :one
INSERT INTO faqs (
    company_id,
    section_id, 
    platform_id,
    tags, 
    questions, 
    answers, 
    questions_ar, 
    answers_ar,
    media_urls,
    created_at, 
    updated_at,
	created_by,
    status
) VALUES (
    $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13
)RETURNING *;

-- name: UpdateFaqStatus :one
UPDATE faqs
SET status = $1, updated_at = NOW()
WHERE id = $2
RETURNING *;

-- name: GetFaqsByID :one
select f.*, fu.reaction from faqs f
left join faq_user_reactions fu on fu.faq_id = f.id and fu.user_id = @user_id
where f.id = $1;

-- name: GetfaqsByStatusByCompID :many
select f.*, fu.reaction from faqs f
left join faq_user_reactions fu on fu.faq_id = f.id and fu.user_id = @user_id
where f.status = $1 and f.company_id = $2 and platform_id = $3
ORDER BY f.updated_at DESC
LIMIT $4
OFFSET $5;

-- name: GetCountAllFaqsByComp :one
select COUNT(*) from faqs where status = $1 and company_id = $2 and platform_id = $3;

-- name: GetfaqsByStatus :many
select f.*, fu.reaction from faqs f 
left join faq_user_reactions fu on fu.faq_id = f.id and fu.user_id = @user_id
where f.status = $1 
ORDER BY f.updated_at DESC
LIMIT $2
OFFSET $3;


-- name: GetCountAllFaqsByStatus :one
select COUNT(*) from faqs where status = $1 and platform_id = $2;


-- -- name: DeleteAllFaqMedia :one
-- update faqs set media_urls = "" where id = $1 returning *;


-- name: GetFaqByID :one
select * from faqs where id = $1;

-- name: UpdateFaqMedia :one
update faqs set media_urls = $1 where id = $2 returning *;


-- name: UpdateFaqByID :one
UPDATE faqs 
SET 
    company_id = $1,
    section_id = $2,
    platform_id = $14,
    tags = $3,
    questions = $4,
    answers = $5,
    media_urls = $6,
    created_at = $7,
    updated_at = $8,
    created_by = $9,
    status = $10,
    questions_ar = $11,
    answers_ar = $12
WHERE id = $13
RETURNING *;


-- name: GetExistingReaction :one
SELECT reaction FROM faq_user_reactions WHERE user_id = $1 AND faq_id = $2;

-- name: InsertFaqReaction :one
INSERT INTO faq_user_reactions (user_id, faq_id, reaction)
VALUES ($1, $2, $3)
RETURNING *;

-- name: UpdateExistingReaction :one
UPDATE faq_user_reactions
SET reaction = 'none', updated_at = CURRENT_TIMESTAMP
WHERE user_id = $1 AND faq_id = $2
RETURNING *;

-- name: ConvertExistingReaction :one
UPDATE faq_user_reactions
SET reaction = $1, updated_at = CURRENT_TIMESTAMP
WHERE user_id = $2 AND faq_id = $3
RETURNING *;

-- name: UpdateFaqReactionCounts :one
UPDATE faqs
SET 
  likes = likes + @like_delta,
  dislikes = dislikes + @dislike_delta
WHERE id = @id
RETURNING *;

-- name: GetListingSectionWeb :one
SELECT * FROM listing_sections WHERE section_key = $1;

-- name: GetSectionsByID :one
SELECT * FROM section_permission WHERE id = $1;