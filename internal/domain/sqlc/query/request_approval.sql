-- name: CreateRequestApproval :one
INSERT INTO
    requests_verification(
        request_type,
        entity_type,
        entity_id,
        requested_by,
        status,
        created_at,
        updated_at
    )
VALUES
    ($1, $2, $3, $4, $5, $6, $7)RETURNING id;
    
-- name: CreateRequestApprovalData :exec
INSERT INTO
    request_data(
        request_id,
        field_name,
        field_value,
        created_at, 
        field_type
    )
VALUES
    ($1, $2, $3, $4, $5);


-- name: GetAllRequestsForDepartment :many
SELECT
    requests_verification.*,requests_type.type,w.id AS "workflow_id"
FROM
    requests_verification
    INNER JOIN requests_type ON requests_type.id=requests_verification.request_type
    INNER JOIN workflows w ON requests_verification.request_type = w.request_type
    AND w.department = @department_id:: BIGINT
    AND(
        w.step = 1  
        OR EXISTS (
            SELECT
                1
            FROM
                approvals
            INNER JOIN workflows w2 ON w2.id=approvals.workflow_step
            WHERE
                approvals.request_id = requests_verification.id
                AND w.step = w2.step +1
                AND approvals.status = @approval_status::VARCHAR
                AND requests_verification.status = @processing_status::VARCHAR
        )
    ) AND requests_verification.status!= @approval_status::VARCHAR;



-- name: CreateApprovalForRequest :one 
INSERT INTO
    approvals(
        request_id,
        workflow_step,
        department,
        approved_by,
        status,
        remarks,
        files,
        updated_at
    ) 
SELECT
    $1,workflows.id,$2,$3,$4,$5,$6,$7
FROM
    requests_verification
    INNER JOIN workflows ON workflows.request_type = requests_verification.request_type
    AND workflows.department = $2::BIGINT
WHERE
    requests_verification.id = $1
RETURNING workflow_step;


-- name: UpdateStatusRequestsVerification :exec 
UPDATE 
    requests_verification
SET 
    status=$2, 
    updated_at=$3
WHERE id=$1 AND requested_by=$4;


-- name: GetTheStepForWorkFlow :one 
SELECT step
FROM 
    workflows
WHERE id=$1;


-- name: LastStepForRequestType :one 
SELECT MAX(workflows.step)::BIGINT
FROM 
    workflows
WHERE workflows.request_type= (SELECT requests_verification.request_type FROM requests_verification WHERE requests_verification.id= @request_id::BIGINT);


-- name: GetRequestCountWithEntity :one
SELECT COUNT(rv.id) AS total 
FROM 
    requests_verification rv
WHERE rv.request_type = $1 AND rv.entity_type = $2 AND rv.entity_id = $3 AND rv.status NOT IN ('3','4'); 





-- name: CreatePendingApproval :exec 
INSERT INTO
    approvals(
        request_id,
        workflow_step,
        department,
        status,
        remarks, 
        user_ids
    ) 
SELECT rv.id,workflows.id,workflows.department,@pending_status::BIGINT,$1,workflows.user_ids
	FROM
		requests_verification rv
		INNER JOIN workflows ON workflows.request_type= rv.request_type AND workflows.step= @workflow_step::BIGINT  
WHERE 
	rv.id= @request_id::BIGINT; 



-- name: UpdateApprovalStatus :one 
UPDATE 
	approvals
SET 
	status=$1, 
	remarks=$2,
	files=$3, 
	updated_at=$4, 
	required_fields=$5, 
    approved_by=$6
FROM workflows 
WHERE 
	approvals.id= @approval_id::BIGINT AND workflows.id=approvals.workflow_step
RETURNING workflows.step;


-- name: GetRequestEntity :one 
SELECT * FROM requests_verification WHERE id= @request_id::BIGINT;


-- name: GetRequestData :many 
SELECT * FROM request_data WHERE request_id= @request_id::BIGINT; 



-- name: GetRequestsByStatus :many
WITH requestData as (
    SELECT 
        request_data.request_id AS request_id,
        jsonb_agg(
        jsonb_build_object(
			'id', request_data.id,
            'name', request_data.field_name,
            'value', request_data.field_value, 
            'field_type',request_data.field_type
        )) AS requests

    FROM request_data
    GROUP BY  request_data.request_id 

)
SELECT
    sqlc.embed(a),
    sqlc.embed(rv), 
    requestData.requests,
    requests_type.type
FROM
    approvals a
INNER JOIN requests_verification rv ON rv.id = a.request_id
INNER JOIN requests_type ON requests_type.id=rv.request_type
--INNER JOIN workflows ON a.workflow_step=workflows.id AND @user_id::BIGINT =ANY(workflows.user_ids)
JOIN requestData ON requestData.request_id=a.request_id
WHERE
     a.status = ANY( @statuses::BIGINT[])  AND @user_id::BIGINT =ANY(a.user_ids)
ORDER BY a.id DESC
LIMIT
    sqlc.narg('limit') OFFSET sqlc.narg('offset');



-- name: UpdateRequestData :exec
WITH request AS (
    SELECT jsonb_array_elements( @data ::JSONB) AS data
)
UPDATE request_data
SET field_value = request.data->>'value'::VARCHAR
FROM request
WHERE request_data.id = (request.data->>'id')::BIGINT;


-- name: GetRequiredFieldsForRejectedRequest :many 
SELECT 
    rd.*
FROM 
    approvals a
JOIN 
    LATERAL UNNEST(a.required_fields) AS rf(request_id)
    ON true
JOIN 
    request_data rd
    ON rd.id = rf.request_id
WHERE 
    a.id = @approval_id::BIGINT;


-- name: CreatePendingApprovalAfterRejection :exec
INSERT INTO
    approvals(
        request_id,
        workflow_step,
        department,
        approved_by,
        status,
        remarks, 
        user_ids
    )
SELECT approvals.request_id,approvals.workflow_step,approvals.department,approvals.approved_by, @pending_status::BIGINT ,$1,workflows.user_ids
FROM
    approvals
INNER JOIN workflows ON approvals.workflow_step=workflows.id 
WHERE 
	approvals.request_id = @request_id::BIGINT 
ORDER BY approvals.id DESC 
LIMIT 1;



-- name: GetRequestsForUser :many
SELECT rv.*, rt."type"
FROM 
	requests_verification rv 
INNER JOIN 
	requests_type rt ON rv.request_type=rt.id 
WHERE rv.status= ANY( @status::BIGINT[]) AND rv.requested_by = @user_id::BIGINT 
ORDER BY rv.updated_at DESC 
LIMIT sqlc.narg('limit')
OFFSET sqlc.narg('offset');

-- name: GetRequestsUserCount :one 
SELECT COUNT(*)
FROM 
	requests_verification rv 
INNER JOIN 
	requests_type rt ON rv.request_type=rt.id 
WHERE rv.status= ANY( @status::BIGINT[]) AND rv.requested_by = @user_id::BIGINT ;




-- name: GetRequestByID :one
WITH requestData as (
    SELECT
        request_data.request_id AS request_id,
        jsonb_agg(
            jsonb_build_object(
                'id',
                request_data.id,
                'name',
                request_data.field_name,
                'value',
                request_data.field_value, 
                'field_type',request_data.field_type
            )
        ) AS requests_data_json
    FROM
        request_data
    WHERE
        request_data.request_id = @request_id :: BIGINT
    GROUP BY
        request_data.request_id
),
approvalsHistory as(
    SELECT
        approvals.request_id AS request_id,
        jsonb_agg(
            jsonb_build_object(
                'id', 
                approvals.id,
                'department_id',
                department.id,
                'department_name',
                department.department,
                'files',
                approvals.files, 
                'status', 
                approvals.status, 
                'remarks', 
                approvals.remarks
            )
        ) AS approvals_history_json
    FROM
        approvals
        INNER JOIN department ON approvals.department = department.id
    WHERE
        approvals.request_id = @request_id :: BIGINT
   -- ORDER BY approvals.updated_at DESC
    GROUP BY
        approvals.request_id
), 
department_remark as(
     SELECT approvals.remarks,department.department,@request_id::BIGINT as request_id
        FROM
            approvals
        INNER JOIN department ON department.id=approvals.department
        WHERE
            approvals.request_id = @request_id
        ORDER BY approvals.id DESC
        LIMIT 1 
)
SELECT
    rv.*,
    rt.type,
    requestData.* ,
    approvalsHistory.*, 
    dr.remarks, 
    dr.department
FROM
    requests_verification rv
    INNER JOIN requests_type rt ON rv.request_type = rt.id
    INNER JOIN requestData ON requestData.request_id = rv.id
    INNER JOIN approvalsHistory ON approvalsHistory.request_id = rv.id
    INNER JOIN department_remark as dr ON dr.request_id=rv.id
WHERE
    rv.id = @request_id :: BIGINT AND rv.requested_by= @user_id::BIGINT;


-- name: GetRejectedData :many
SELECT
    rd.id,
    rd.field_name,
    rd.field_value,
    rd.field_type
FROM
    approvals a
    JOIN LATERAL UNNEST(a.required_fields) AS rf(request_id) ON true
    JOIN request_data rd ON rd.id = rf.request_id
    JOIN requests_verification rv ON rv.id= @request_id :: BIGINT AND rv.requested_by= @user_id::BIGINT
WHERE
    a.request_id = @request_id :: BIGINT
    AND a.status = @rejected_status :: BIGINT
    AND a.id =(
        SELECT
            MAX(id)
        FROM
            approvals
        WHERE
            request_id = @request_id :: BIGINT
            AND status = @rejected_status :: BIGINT
    );




-- name: GetNumberRequestsByStatus :one
SELECT
    COUNT(*)
FROM
    approvals a
INNER JOIN requests_verification rv ON rv.id = a.request_id
INNER JOIN requests_type ON requests_type.id=rv.request_type
--INNER JOIN workflows ON a.workflow_step=workflows.id AND @user_id::BIGINT =ANY(workflows.user_ids)

WHERE
 a.status = ANY( @statuses::BIGINT[]) AND @user_id::BIGINT =ANY(a.user_ids);




-- name: IsEligibleForRequestResponse :one 
SELECT true::BOOLEAN
FROM 
	approvals
--INNER JOIN workflows ON workflows.id=approvals.workflow_step AND @user_id::BIGINT =ANY(workflows.user_ids)
WHERE id= @approval_id::BIGINT AND @user_id::BIGINT=ANY(user_ids); 




-- name: GetApprovalIdForRejectedRequest :one
SELECT
    COALESCE(MAX(a.id),0) :: BIGINT
FROM
    approvals a
    INNER JOIN requests_verification rv ON rv.id = @request_id :: BIGINT
    AND rv.requested_by = @user_id :: BIGINT
WHERE
    a.request_id = @request_id :: BIGINT
    AND a.status = @rejected_status :: BIGINT; 



-- name: IsRequestActiveOrValid :one
SELECT
    TRUE :: BOOLEAN
FROM
    requests_verification rv
INNER JOIN request_data rd_start ON
    rd_start.request_id = rv.id
    AND rd_start.field_name = @start_date_name :: VARCHAR
    AND rd_start.field_type = @data_filed_type :: VARCHAR
INNER JOIN request_data rd_end ON
    rd_end.request_id = rv.id
    AND rd_end.field_name = @end_date_name :: VARCHAR
    AND rd_end.field_type = @data_filed_type :: VARCHAR
WHERE
    rv.entity_type = @entity_type_id :: BIGINT
    AND rv.entity_id = @entity_id :: BIGINT
    AND rv.request_type = @request_type :: BIGINT
    AND (
        rv.status IN (@pending_status :: BIGINT, @processing_status :: BIGINT)
        OR (
            NOW() BETWEEN CAST(rd_start.field_value AS TIMESTAMP) AND CAST(rd_end.field_value AS TIMESTAMP)
            AND rv.status = @approved_status :: BIGINT
        )
    );


-- name: RetrieveApprovedExclusiveWithData :one
SELECT rv.id,rd_start.field_name,rd_start.field_value,rd_end.field_name,rd_end.field_value
FROM
    requests_verification rv
    INNER JOIN request_data rd_start ON rd_start.request_id = rv.id
    AND rd_start.field_name = @start_date_name :: VARCHAR
    AND rd_start.field_type = @data_filed_type :: VARCHAR
    INNER JOIN request_data rd_end ON rd_end.request_id = rv.id
    AND rd_end.field_name = @end_date_name :: VARCHAR
    AND rd_end.field_type = @data_filed_type :: VARCHAR
WHERE
    rv.status = @approved_status :: BIGINT
    AND rv.entity_type = @entity_type_id :: BIGINT
    AND rv.entity_id = @entity_id :: BIGINT
    AND rv.request_type = @request_type :: BIGINT
    AND NOW() BETWEEN CAST(rd_start.field_value AS TIMESTAMP)
    AND CAST(rd_end.field_value AS TIMESTAMP);