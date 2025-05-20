-- name: AddPropertyAd :one
INSERT INTO aqary_property_ads (
    company_types_id, companies_id, is_branch, title, property_unit_id,
     ads_category, created_by,is_property_unit_branch,
      ads_schema,ads_status,property_hub_category, is_public, is_verified,tags) VALUES
($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11,$12,$13, $14) RETURNING *;
 
-- name: UpdatePropertyAd :one
UPDATE aqary_property_ads SET company_types_id = $2 ,companies_id=$3,is_branch=$4,title=$5,property_unit_id=$6,ads_category=$7,created_by=$8,is_property_unit_branch=$9,ads_schema=$10,ads_status=$11,property_hub_category=$12, tags=$13 WHERE id = $1 RETURNING *;
 
-- name: GetAllPropertyAds :many
SELECT * FROM aqary_property_ads app JOIN users u ON app.created_by = u.id LIMIT $1 OFFSET $2;
 
-- name: GetAllPropertyAdsByPostedBy :many
SELECT * FROM aqary_property_ads app JOIN users u ON app.created_by = u.id WHERE app.created_by = $3 LIMIT $1 OFFSET $2;
 
-- name: GetPropertyAdByID :one
SELECT * FROM aqary_property_ads app JOIN users u ON app.created_by = u.id WHERE app.id = $1 LIMIT 1;
 
-- name: DeletePropertyAd :exec
DELETE FROM aqary_property_ads WHERE id = $1;

-- name: UpdatePropertyAdIsVerified :one
UPDATE aqary_property_ads SET is_verified = $2 WHERE id = $1 RETURNING *;