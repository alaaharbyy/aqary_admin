-- name: CreateFinancialProviders :one
INSERT INTO financial_providers (
    ref_no,
    provider_type,
    provider_name,
    logo_url,
    created_at,
    updated_at
)VALUES(
    $1, $2, $3, $4, $5, $6
) RETURNING *;

-- name: CreateProjectFinancialProviders :one
INSERT INTO project_financial_provider (
    projects_id,
    phases_id,
    financial_providers_id
)VALUES(
    $1, $2, $3
) RETURNING *;

-- name: GetFinancialProviders :one
SELECT * FROM financial_providers
WHERE id = $1;

-- name: GetProjectAndPhaseFinancialProviders :one
SELECT * FROM project_financial_provider
WHERE CASE WHEN @phases_id::bigint = 0 THEN projects_id = @projects_id AND phases_id IS NULL ELSE phases_id = @phases_id::bigint END;

-- name: UpdateProjectAndPhaseFinancialProviders :one
UPDATE project_financial_provider
SET financial_providers_id = $2
WHERE id = $1
RETURNING *;

-- name: GetAllProjectFinancialProviders :many
SELECT * FROM project_financial_provider
WHERE projects_id = $1;

-- name: GetAllPhaseFinancialProviders :one
SELECT * FROM project_financial_provider
WHERE phases_id = $1;

-- name: GetAllFinancialProvidersByIds :many
	SELECT 
		id,
		provider_type,
		provider_name,
    logo_url
	FROM financial_providers
	WHERE id = ANY(@ids::bigint[]) 
 LIMIT $1 OFFSET $2;

-- name: GetCountAllFinancialProvidersByIds :one
	SELECT 
		COUNT(id) 
	FROM financial_providers
	WHERE id = ANY(@ids::bigint[]);

-- name: DeleteProjectAndPhaseFinancialProvider :execrows
WITH to_process AS (
  SELECT 
    id, 
    CASE
    	WHEN (array_remove(financial_providers_id, @id::bigint) = '{}') THEN 'DELETE'
      	WHEN financial_providers_id @> ARRAY[@id::bigint] THEN 'UPDATE'
      	ELSE 'IGNORE'
    END AS operation
  FROM project_financial_provider
  WHERE CASE WHEN @phases_id::bigint = 0 THEN (projects_id = @project_id::bigint AND phases_id IS NULL) ELSE  phases_id = @phases_id::bigint END
),
deleted AS (
  DELETE FROM project_financial_provider
  USING to_process
  WHERE project_financial_provider.id = to_process.id
    AND to_process.operation = 'DELETE'
  RETURNING 
    project_financial_provider.id,
    'DELETED'::text AS operation
),
updated AS (
  UPDATE project_financial_provider 
  SET
    financial_providers_id = CASE
    	WHEN array_remove(financial_providers_id, @id::bigint) = '{}' THEN NULL
    		ELSE array_remove(financial_providers_id, @id::bigint)
        END
  FROM to_process
  WHERE project_financial_provider.id = to_process.id
    AND to_process.operation = 'UPDATE'
  RETURNING 
    project_financial_provider.id,
    'UPDATED'::text AS operation
)
SELECT id FROM deleted
UNION ALL
SELECT id FROM updated;

-- name: GetFinancialProvidersByType :many
SELECT * FROM financial_providers
WHERE provider_type = $1;


-- name: GetAllFinancialProviders :many
SELECT * FROM financial_providers
OFFSET $1 LIMIT $2;

-- name: GetCountAllFinancialProviders :one
SELECT COUNT(id) FROM financial_providers;

-- name: DeleteFinancialProvider :one
WITH checkIfFound AS (
    -- Check if the row exists in the financial_providers table
    SELECT id 
    FROM financial_providers 
    WHERE id = @id::bigint
), checkIfInUse AS (
    -- Check if the row exists in the sub_test project_financial_provider (indicating it’s in use)
    SELECT 1
    FROM project_financial_provider 
    WHERE @id::bigint = ANY(financial_providers_id)
), performDelete AS (
    -- Perform the delete operation only if the row exists in financial_providers and is not in project_financial_provider
    DELETE FROM financial_providers
    WHERE id = @id::bigint
    AND EXISTS (SELECT 1 FROM checkIfFound)
    AND NOT EXISTS (SELECT 1 FROM checkIfInUse)
    RETURNING id
)SELECT
    CASE
        WHEN EXISTS (SELECT 1 FROM checkIfInUse) THEN 'IN-USE'::varchar
        WHEN EXISTS (SELECT 1 FROM performDelete) THEN 'DELETED'::varchar
        ELSE 'NOT-FOUND'::varchar
    END AS result;
