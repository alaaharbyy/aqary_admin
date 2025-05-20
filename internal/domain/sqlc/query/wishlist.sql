-- name: CreateWishlist :one
INSERT INTO
    wishlist (
        entity_type_id,
        entity_id,
        platform_user_id,
        company_id,
        created_at
    )
SELECT
    @entity_type_id::BIGINT,
    @entity_id::BIGINT,
    @platform_user_id::BIGINT,
    $1,
    @created_at::TIMESTAMPTZ
WHERE
    (
        CASE
            @entity_type_id::BIGINT
            WHEN @project_entity_type_id::BIGINT THEN EXISTS(
                SELECT
                    1
                FROM
                    projects
                WHERE
                    id = @entity_id::BIGINT
                    AND status = @available_status::BIGINT
            )
            WHEN @property_version_type_id::BIGINT THEN EXISTS(
                SELECT
                    1
                FROM
                    property_versions
                WHERE 
                	id= @entity_id::BIGINT
                    AND status = @available_status::BIGINT
            )
            WHEN @unit_version_type_id::BIGINT THEN EXISTS(
                SELECT
                    1
                FROM
                    unit_versions
                WHERE 
                	id= @entity_id::BIGINT
                    AND status = @available_status::BIGINT
            )
        END
    )RETURNING 1;



-- name: DeleteWishlist :one
DELETE FROM wishlist WHERE id=$1 RETURNING 1; 