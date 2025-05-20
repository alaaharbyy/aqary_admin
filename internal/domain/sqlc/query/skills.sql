


-- name: CreateSkill :one
INSERT INTO skills (
    skill_type,
    title,
    title_ar
 ) VALUES (
    $1, $2, $3
) RETURNING *;


-- name: GetAllSkills :many
SELECT * FROM skills;



-- name: GetSkillByID :one
SELECT * FROM skills where id=$1;



-- name: GetSkillByTitle :one
SELECT * FROM skills WHERE title=$1;

