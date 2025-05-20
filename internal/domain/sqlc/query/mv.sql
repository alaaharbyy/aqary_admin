-- name: RefreshQualityScoreMV :exec
SELECT refresh_property_quality_score();

-- name: RefreshAutoCompleteMV :exec
SELECT refresh_autocomplete_view();

-- name: RefreshHierarchicalLocationMV :exec
SELECT refresh_hierarchical_location_view();

-- name: RefreshPermissionsMV :exec
SELECT refresh_permissions_mv();

-- name: RefreshSectionPermissionMV :exec
SELECT refresh_section_permission_mv();

-- name: RefreshSubSectionMV :exec
SELECT refresh_sub_section_mv();
