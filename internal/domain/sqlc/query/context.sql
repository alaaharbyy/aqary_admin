 
-- SQLC queries for setting and getting context
-- name: SetUserContext :one
SELECT set_current_user_id($1) AS result;

-- name: GetCurrentUserID :one
SELECT get_current_user_id();

-- name: GetCurrentUserIDRaw :one
SELECT current_setting('app.current_user_id', true) AS user_id_str;
-- name: SetModuleContext :exec
SELECT set_current_module_name($1);



-- name: ToggleTrigger :exec
SELECT toggle_trigger_status(@table_name, @status);


-- name: SetLogContext :exec
SELECT set_logging_context($1::text,$2::bigint, $3::text);

 