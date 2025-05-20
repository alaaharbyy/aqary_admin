-- name: GetLiveCommentsForAgentReview :many
SELECT 
    rc.id AS comment_id, 
    u.username as reviewer_username,
    rc.parent_review_comments as parent_comment_id, -- parent comment is in the review comments table
    p.first_name as agent_first_name,
    p.last_name as agent_last_name, 
    rcc.comment as parent_comment,
    cu.username as commented_by, 
    rcc.comment as parent_comment,
    rc.comment, 
    ar.agent_knowledge,
    ar.agent_expertise,
    ar.agent_responsiveness,
    ar.agent_negotiation,
    ar.review,
    COALESCE(bc.company_name, bcb.company_name) AS company_name,
    rc.comment_date
FROM review_comments rc
JOIN agent_reviews ar ON rc.reviews_id = ar.id
JOIN users as u ON ar.reviewer=u.id
JOIN profiles as p ON p.id=ar.agent_id
JOIN users as cu ON cu.id=rc.commented_by
LEFT JOIN review_comments rcc on rcc.id=rc.parent_review_comments
LEFT JOIN broker_companies bc ON ar.companies_id = bc.id AND ar.is_branch = false
LEFT JOIN broker_companies_branches bcb ON ar.companies_id = bcb.id AND ar.is_branch = true
WHERE rc.review_comment_category = 1 and ar.id=$1;