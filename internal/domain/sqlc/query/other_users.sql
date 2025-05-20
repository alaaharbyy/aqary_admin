


-- name: GetAllFreelanceUsers :many
SELECT
  	users.id,
  	profiles.profile_image_url,
	profiles.first_name,
	profiles.last_name,
	l1.license_no as brn,
	l2.license_no as noc,
	users.phone_number,
	users.email, 
	department.department,
	roles."role",
	users.is_verified, 
	users.status
FROM
	users 
	LEFT JOIN profiles ON profiles.users_id = users.id
    LEFT JOIN roles ON users.roles_id = roles.id
	LEFT JOIN department ON roles.department_id = department.id
	LEFT JOIN license l1 ON  users.id = l1.entity_id  AND l1.license_type_id = 5 -- brn
	LEFT JOIN license l2 ON  users.id = l2.entity_id  AND l2.license_type_id = 6 -- noc 
	------------------------------------------------------------@search---------------------
WHERE
    (@search = @search
     OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search 
      OR users.phone_number ILIKE @search
      OR users.email ILIKE @search
    )
	AND users.status NOT IN (5,6)
ORDER BY
	users.updated_at DESC
LIMIT $1 OFFSET $2;



-- name: CountAllFreelanceUsers :one
SELECT
  	COUNT(*)
FROM
	users 
	LEFT JOIN profiles ON profiles.users_id = users.id
    LEFT JOIN roles ON users.roles_id = roles.id
	LEFT JOIN department ON roles.department_id = department.id
	LEFT JOIN license l1 ON  users.id = l1.entity_id  AND l1.license_type_id = 5 -- brn
	LEFT JOIN license l2 ON  users.id = l2.entity_id  AND l2.license_type_id = 6 -- noc 
	------------------------------------------------------------@search---------------------
WHERE
    (@search = @search
     OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search 
      OR users.phone_number ILIKE @search
      OR users.email ILIKE @search
    )
	AND users.status NOT IN (5,6);





-- name: GetAllOwnerUsers :many
SELECT
  	users.id,
  	profiles.profile_image_url,
	profiles.first_name,
	profiles.last_name, 
	users.phone_number,
	users.is_verified, 
	users.email,
	users.status
FROM
	users 
	LEFT JOIN profiles ON profiles.users_id = users.id
    LEFT JOIN roles ON users.roles_id = roles.id
	LEFT JOIN department ON roles.department_id = department.id
 	------------------------------------------------------------@search---------------------
WHERE
    (@search = @search
     OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search 
      OR users.phone_number ILIKE @search
      OR users.email ILIKE @search
    )
	AND users.status NOT IN (5,6)
ORDER BY
	users.updated_at DESC
LIMIT $1 OFFSET $2;



-- name: CountAllOwnerUsers :one
SELECT
  COUNT(*)
FROM
	users 
	LEFT JOIN profiles ON profiles.users_id = users.id
    LEFT JOIN roles ON users.roles_id = roles.id
	LEFT JOIN department ON roles.department_id = department.id
 	------------------------------------------------------------@search---------------------
WHERE
    (@search = @search
     OR CONCAT(profiles.first_name, ' ', profiles.last_name) ILIKE @search 
      OR users.phone_number ILIKE @search
      OR users.email ILIKE @search
    )
	AND users.status NOT IN (5,6);