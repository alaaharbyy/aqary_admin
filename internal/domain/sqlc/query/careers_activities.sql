-- -- name: CreateCareerActivity :one
-- INSERT INTO careers_activities (
--     activity_type, 
--     activity,
--     activity_date,
--     user_id,
--     ref_activity_id
-- ) VALUES (
--     $1, $2, $3, $4, $5
-- ) RETURNING *;
 
 
 
-- -- name: GetAllCareerActivities :many
-- SELECT 
-- 	sqlc.embed(ca),
-- 	c.ref_no,
-- 	c.job_title
-- FROM careers c
-- JOIN careers_activities ca ON c.id=ca.ref_activity_id
-- WHERE c.employers_id=$1 
-- ORDER BY ca.id DESC
-- LIMIT $2 OFFSET $3;


-- -- name: GetCareerActivity :many
-- SELECT * FROM careers_activities
-- WHERE ref_activity_id=$1;

-- -- name: GetCareerActivityByRefId :one
-- SELECT *  FROM careers_activities
-- WHERE ref_activity_id = $1 LIMIT 1;

-- -- name: GetCareerActivityByID :one
-- SELECT * FROM careers_activities
-- WHERE id = $1;

