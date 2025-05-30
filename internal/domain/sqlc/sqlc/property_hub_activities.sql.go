// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: property_hub_activities.sql

package sqlc

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
)

const createPropertyHubActivity = `-- name: CreatePropertyHubActivity :one
INSERT INTO property_hub_activities (
    company_types_id,
    companies_id,
    is_branch,
    is_property,
    is_property_branch,
    unit_category,
    property_unit_id,
    module_name,
    activity_type,
    file_category,
    file_url,
    portal_url,
    activity,
    user_id,
    activity_date  
)VALUES (
    $1 , $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15
) RETURNING id, company_types_id, companies_id, is_branch, is_property, is_property_branch, unit_category, property_unit_id, module_name, activity_type, file_category, file_url, portal_url, activity, user_id, activity_date
`

type CreatePropertyHubActivityParams struct {
	CompanyTypesID   pgtype.Int8 `json:"company_types_id"`
	CompaniesID      pgtype.Int8 `json:"companies_id"`
	IsBranch         pgtype.Bool `json:"is_branch"`
	IsProperty       pgtype.Bool `json:"is_property"`
	IsPropertyBranch pgtype.Bool `json:"is_property_branch"`
	UnitCategory     pgtype.Text `json:"unit_category"`
	PropertyUnitID   pgtype.Int8 `json:"property_unit_id"`
	ModuleName       string      `json:"module_name"`
	ActivityType     int64       `json:"activity_type"`
	FileCategory     pgtype.Int8 `json:"file_category"`
	FileUrl          pgtype.Text `json:"file_url"`
	PortalUrl        pgtype.Text `json:"portal_url"`
	Activity         string      `json:"activity"`
	UserID           int64       `json:"user_id"`
	ActivityDate     time.Time   `json:"activity_date"`
}

func (q *Queries) CreatePropertyHubActivity(ctx context.Context, arg CreatePropertyHubActivityParams) (PropertyHubActivity, error) {
	row := q.db.QueryRow(ctx, createPropertyHubActivity,
		arg.CompanyTypesID,
		arg.CompaniesID,
		arg.IsBranch,
		arg.IsProperty,
		arg.IsPropertyBranch,
		arg.UnitCategory,
		arg.PropertyUnitID,
		arg.ModuleName,
		arg.ActivityType,
		arg.FileCategory,
		arg.FileUrl,
		arg.PortalUrl,
		arg.Activity,
		arg.UserID,
		arg.ActivityDate,
	)
	var i PropertyHubActivity
	err := row.Scan(
		&i.ID,
		&i.CompanyTypesID,
		&i.CompaniesID,
		&i.IsBranch,
		&i.IsProperty,
		&i.IsPropertyBranch,
		&i.UnitCategory,
		&i.PropertyUnitID,
		&i.ModuleName,
		&i.ActivityType,
		&i.FileCategory,
		&i.FileUrl,
		&i.PortalUrl,
		&i.Activity,
		&i.UserID,
		&i.ActivityDate,
	)
	return i, err
}

const deletePropertyHubActivities = `-- name: DeletePropertyHubActivities :exec
DELETE FROM property_hub_activities
Where id = $1
`

func (q *Queries) DeletePropertyHubActivities(ctx context.Context, id int64) error {
	_, err := q.db.Exec(ctx, deletePropertyHubActivities, id)
	return err
}

const deletePropertyHubActivity = `-- name: DeletePropertyHubActivity :exec
DELETE FROM property_hub_activities
WHERE id=$1
`

func (q *Queries) DeletePropertyHubActivity(ctx context.Context, id int64) error {
	_, err := q.db.Exec(ctx, deletePropertyHubActivity, id)
	return err
}

const getActivityViewForPropertyHubActivitiesFileView = `-- name: GetActivityViewForPropertyHubActivitiesFileView :many
WITH X AS (
SELECT act_ch.id,act_ch.activity_date,fp.property_name,act_ch.field_name  AS File_viewed,dc.category, users.username,act_ch.before AS activity FROM activity_changes AS act_ch
INNER JOIN property_hub_activities AS prop_hub_act ON act_ch.activities_id=prop_hub_act.id AND prop_hub_act.file_category=$1 AND prop_hub_act.activity_type=2 AND prop_hub_act.id=$2
INNER JOIN freelancers_properties AS fp ON fp.id=prop_hub_act.property_unit_id
INNER JOIN users ON prop_hub_act.user_id=users.id
INNER JOIN freelancers_properties_documents AS fpd ON fpd.freelancers_properties_id = fp.id
INNER JOIN documents_category AS dc ON dc.id = fpd.documents_category_id
WHERE act_ch.section_id=2
UNION ALL
SELECT act_ch.id,act_ch.activity_date,op.property_name,act_ch.field_name AS File_viewed, dc.category, users.username,act_ch.before AS activity FROM activity_changes AS act_ch
INNER JOIN property_hub_activities AS prop_hub_act ON act_ch.activities_id=prop_hub_act.id
AND prop_hub_act.file_category=$1 AND prop_hub_act.activity_type=2 AND prop_hub_act.id=$2
INNER JOIN owner_properties AS op ON op.id=prop_hub_act.property_unit_id
INNER JOIN users ON prop_hub_act.user_id=users.id
INNER JOIN owner_properties_documents AS opd ON opd.owner_properties_id = op.id
INNER JOIN documents_category AS dc ON dc.id = opd.documents_category_id
WHERE act_ch.section_id=2
UNION ALL
SELECT act_ch.id,act_ch.activity_date,bca.property_name,act_ch.field_name AS File_viewed, dc.category, users.username,act_ch.before AS activity FROM activity_changes AS act_ch
INNER JOIN property_hub_activities AS prop_hub_act ON act_ch.activities_id=prop_hub_act.id AND prop_hub_act.file_category=$1 AND prop_hub_act.activity_type=2 AND prop_hub_act.id=$2
INNER JOIN broker_company_agent_properties AS bca ON bca.id=prop_hub_act.property_unit_id
INNER JOIN users ON prop_hub_act.user_id=users.id
INNER JOIN broker_company_agent_properties_documents AS bcd ON bcd.broker_company_agent_properties_id = bca.id
INNER JOIN documents_category AS dc ON dc.id = bcd.documents_category_id
WHERE act_ch.section_id=2
UNION ALL
SELECT act_ch.id,act_ch.activity_date,bcap.property_name,act_ch.field_name AS File_viewed, dc.category, users.username,act_ch.before AS activity FROM activity_changes AS act_ch
INNER JOIN property_hub_activities AS prop_hub_act ON act_ch.activities_id=prop_hub_act.id AND prop_hub_act.file_category=$1 AND prop_hub_act.activity_type=2 AND prop_hub_act.id=$2
INNER JOIN broker_company_agent_properties_branch AS bcap ON bcap.id=prop_hub_act.property_unit_id
INNER JOIN users ON prop_hub_act.user_id=users.id
INNER JOIN broker_company_agent_properties_documents_branch AS bcd ON bcd.broker_company_agent_properties_branch_id = bcap.id
INNER JOIN documents_category AS dc ON dc.id = bcd.documents_category_id
WHERE act_ch.section_id=2)
SELECT id, activity_date, property_name, file_viewed, category, username, activity FROM X
ORDER BY id
LIMIT $2
OFFSET $3
`

type GetActivityViewForPropertyHubActivitiesFileViewParams struct {
	FileCategory pgtype.Int8 `json:"file_category"`
	Limit        int32       `json:"limit"`
	Offset       int32       `json:"offset"`
}

type GetActivityViewForPropertyHubActivitiesFileViewRow struct {
	ID           int64              `json:"id"`
	ActivityDate pgtype.Timestamptz `json:"activity_date"`
	PropertyName string             `json:"property_name"`
	FileViewed   pgtype.Text        `json:"file_viewed"`
	Category     string             `json:"category"`
	Username     string             `json:"username"`
	Activity     pgtype.Text        `json:"activity"`
}

func (q *Queries) GetActivityViewForPropertyHubActivitiesFileView(ctx context.Context, arg GetActivityViewForPropertyHubActivitiesFileViewParams) ([]GetActivityViewForPropertyHubActivitiesFileViewRow, error) {
	rows, err := q.db.Query(ctx, getActivityViewForPropertyHubActivitiesFileView, arg.FileCategory, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetActivityViewForPropertyHubActivitiesFileViewRow
	for rows.Next() {
		var i GetActivityViewForPropertyHubActivitiesFileViewRow
		if err := rows.Scan(
			&i.ID,
			&i.ActivityDate,
			&i.PropertyName,
			&i.FileViewed,
			&i.Category,
			&i.Username,
			&i.Activity,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getActivityViewForPropertyHubActivitiesTransactions = `-- name: GetActivityViewForPropertyHubActivitiesTransactions :many
WITH X AS (
SELECT prop_hub_act.id, fp.property_name, prop_hub_act.activity_date, act_chan.field_name, act_chan.before, act_chan.after FROM activity_changes AS act_chan
INNER JOIN property_hub_activities AS prop_hub_act
ON act_chan.activities_id = prop_hub_act.id
INNER JOIN freelancers_properties AS fp ON prop_hub_act.property_unit_id= fp.id AND prop_hub_act.unit_category = 'Property Hub Freelancer'
AND act_chan.section_id=2 AND act_chan.activities_id = $1
UNION ALL
SELECT prop_hub_act.id, op.property_name, prop_hub_act.activity_date, act_chan.field_name, act_chan.before, act_chan.after  FROM activity_changes AS act_chan
INNER JOIN property_hub_activities AS prop_hub_act
ON act_chan.activities_id = prop_hub_act.id
INNER JOIN owner_properties AS op ON prop_hub_act.property_unit_id= op.id AND prop_hub_act.unit_category = 'Property Hub Owner'
AND act_chan.section_id=2 AND act_chan.activities_id = $1
UNION ALL
SELECT prop_hub_act.id, bca.property_name, prop_hub_act.activity_date, act_chan.field_name, act_chan.before, act_chan.after FROM activity_changes AS act_chan
INNER JOIN property_hub_activities AS prop_hub_act
ON act_chan.activities_id = prop_hub_act.id
INNER JOIN broker_company_agent_properties AS bca ON prop_hub_act.property_unit_id= bca.id AND prop_hub_act.unit_category = 'Property Hub Broker'
AND prop_hub_act.is_branch = FALSE
AND act_chan.section_id=2 AND act_chan.activities_id = $1
UNION ALL
SELECT prop_hub_act.id, bcap.property_name, prop_hub_act.activity_date, act_chan.field_name, act_chan.before, act_chan.after FROM activity_changes AS act_chan
INNER JOIN property_hub_activities AS prop_hub_act
ON act_chan.activities_id = prop_hub_act.id
INNER JOIN broker_company_agent_properties_branch AS bcap ON prop_hub_act.property_unit_id= bcap.id AND prop_hub_act.unit_category = 'Property Hub Broker' AND
prop_hub_act.is_branch = TRUE
AND act_chan.section_id=2 AND act_chan.activities_id = $1)
SELECT id, property_name, activity_date, field_name, before, after FROM X
ORDER BY id
LIMIT $2
OFFSET $3
`

type GetActivityViewForPropertyHubActivitiesTransactionsParams struct {
	ActivitiesID int64 `json:"activities_id"`
	Limit        int32 `json:"limit"`
	Offset       int32 `json:"offset"`
}

type GetActivityViewForPropertyHubActivitiesTransactionsRow struct {
	ID           int64       `json:"id"`
	PropertyName string      `json:"property_name"`
	ActivityDate time.Time   `json:"activity_date"`
	FieldName    pgtype.Text `json:"field_name"`
	Before       pgtype.Text `json:"before"`
	After        pgtype.Text `json:"after"`
}

func (q *Queries) GetActivityViewForPropertyHubActivitiesTransactions(ctx context.Context, arg GetActivityViewForPropertyHubActivitiesTransactionsParams) ([]GetActivityViewForPropertyHubActivitiesTransactionsRow, error) {
	rows, err := q.db.Query(ctx, getActivityViewForPropertyHubActivitiesTransactions, arg.ActivitiesID, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetActivityViewForPropertyHubActivitiesTransactionsRow
	for rows.Next() {
		var i GetActivityViewForPropertyHubActivitiesTransactionsRow
		if err := rows.Scan(
			&i.ID,
			&i.PropertyName,
			&i.ActivityDate,
			&i.FieldName,
			&i.Before,
			&i.After,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getAllPropertyHubActivitiesFileView = `-- name: GetAllPropertyHubActivitiesFileView :many
WITH X AS (
SELECT prop_hub_act.id,fp.property_name, prop_hub_act.activity_date , prop_hub_act.file_category , users.username AS user_name FROM property_hub_activities AS prop_hub_act INNER JOIN freelancers_properties AS fp ON prop_hub_act.property_unit_id= fp.id AND prop_hub_act.unit_category = 'Property Hub Freelancer' AND prop_hub_act.is_property_branch = FALSE
INNER JOIN users ON prop_hub_act.user_id = users.id WHERE prop_hub_act.activity_type = $1
UNION ALL
SELECT prop_hub_act.id,op.property_name, prop_hub_act.activity_date , prop_hub_act.file_category , users.username AS user_name FROM property_hub_activities AS prop_hub_act INNER JOIN owner_properties AS op ON prop_hub_act.property_unit_id= op.id AND prop_hub_act.unit_category = 'Property Hub Owner' AND prop_hub_act.is_property_branch = FALSE
INNER JOIN users ON prop_hub_act.user_id = users.id WHERE prop_hub_act.activity_type = $1
UNION ALL
SELECT  prop_hub_act.id,bca.property_name, prop_hub_act.activity_date , prop_hub_act.file_category , users.username AS user_name FROM property_hub_activities AS prop_hub_act INNER JOIN broker_company_agent_properties AS bca ON prop_hub_act.property_unit_id= bca.id AND prop_hub_act.unit_category = 'Property Hub Broker' AND prop_hub_act.is_property_branch = FALSE
INNER JOIN users ON prop_hub_act.user_id = users.id WHERE prop_hub_act.activity_type = $1
UNION ALL
SELECT prop_hub_act.id,bcap.property_name, prop_hub_act.activity_date , prop_hub_act.file_category , users.username AS user_name FROM property_hub_activities AS prop_hub_act INNER JOIN broker_company_agent_properties_branch AS bcap ON prop_hub_act.property_unit_id= bcap.id AND prop_hub_act.unit_category = 'Property Hub Broker' AND prop_hub_act.is_property_branch = TRUE
INNER JOIN users ON prop_hub_act.user_id = users.id WHERE prop_hub_act.activity_type = $1
)
SELECT id, property_name, activity_date, file_category, user_name FROM X
ORDER BY id
LIMIT $2
OFFSET $3
`

type GetAllPropertyHubActivitiesFileViewParams struct {
	ActivityType int64 `json:"activity_type"`
	Limit        int32 `json:"limit"`
	Offset       int32 `json:"offset"`
}

type GetAllPropertyHubActivitiesFileViewRow struct {
	ID           int64       `json:"id"`
	PropertyName string      `json:"property_name"`
	ActivityDate time.Time   `json:"activity_date"`
	FileCategory pgtype.Int8 `json:"file_category"`
	UserName     string      `json:"user_name"`
}

func (q *Queries) GetAllPropertyHubActivitiesFileView(ctx context.Context, arg GetAllPropertyHubActivitiesFileViewParams) ([]GetAllPropertyHubActivitiesFileViewRow, error) {
	rows, err := q.db.Query(ctx, getAllPropertyHubActivitiesFileView, arg.ActivityType, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAllPropertyHubActivitiesFileViewRow
	for rows.Next() {
		var i GetAllPropertyHubActivitiesFileViewRow
		if err := rows.Scan(
			&i.ID,
			&i.PropertyName,
			&i.ActivityDate,
			&i.FileCategory,
			&i.UserName,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getAllPropertyHubActivitiesTransactions = `-- name: GetAllPropertyHubActivitiesTransactions :many
WITH X AS (
SELECT prop_hub_act.id,fp.property_name, prop_hub_act.activity_date , prop_hub_act.module_name , users.username AS user_name FROM property_hub_activities AS prop_hub_act INNER JOIN freelancers_properties AS fp ON prop_hub_act.property_unit_id= fp.id AND prop_hub_act.unit_category = 'Property Hub Freelancer' AND prop_hub_act.is_property_branch = FALSE
INNER JOIN users ON prop_hub_act.user_id = users.id WHERE prop_hub_act.activity_type = $1
UNION ALL
SELECT prop_hub_act.id,op.property_name, prop_hub_act.activity_date , prop_hub_act.module_name , users.username AS user_name FROM property_hub_activities AS prop_hub_act INNER JOIN owner_properties AS op ON prop_hub_act.property_unit_id= op.id AND prop_hub_act.unit_category = 'Property Hub Owner' AND prop_hub_act.is_property_branch = FALSE
INNER JOIN users ON prop_hub_act.user_id = users.id WHERE prop_hub_act.activity_type = $1
UNION ALL
SELECT  prop_hub_act.id,bca.property_name, prop_hub_act.activity_date , prop_hub_act.module_name , users.username AS user_name FROM property_hub_activities AS prop_hub_act INNER JOIN broker_company_agent_properties AS bca ON prop_hub_act.property_unit_id= bca.id AND prop_hub_act.unit_category = 'Property Hub Broker' AND prop_hub_act.is_property_branch = FALSE
INNER JOIN users ON prop_hub_act.user_id = users.id WHERE prop_hub_act.activity_type = $1
UNION ALL
SELECT prop_hub_act.id,bcap.property_name, prop_hub_act.activity_date , prop_hub_act.module_name , users.username AS user_name FROM property_hub_activities AS prop_hub_act INNER JOIN broker_company_agent_properties_branch AS bcap ON prop_hub_act.property_unit_id= bcap.id AND prop_hub_act.unit_category = 'Property Hub Broker' AND prop_hub_act.is_property_branch = TRUE
INNER JOIN users ON prop_hub_act.user_id = users.id WHERE prop_hub_act.activity_type = $1
)
SELECT id, property_name, activity_date, module_name, user_name FROM X
ORDER BY id
LIMIT $2
OFFSET $3
`

type GetAllPropertyHubActivitiesTransactionsParams struct {
	ActivityType int64 `json:"activity_type"`
	Limit        int32 `json:"limit"`
	Offset       int32 `json:"offset"`
}

type GetAllPropertyHubActivitiesTransactionsRow struct {
	ID           int64     `json:"id"`
	PropertyName string    `json:"property_name"`
	ActivityDate time.Time `json:"activity_date"`
	ModuleName   string    `json:"module_name"`
	UserName     string    `json:"user_name"`
}

func (q *Queries) GetAllPropertyHubActivitiesTransactions(ctx context.Context, arg GetAllPropertyHubActivitiesTransactionsParams) ([]GetAllPropertyHubActivitiesTransactionsRow, error) {
	rows, err := q.db.Query(ctx, getAllPropertyHubActivitiesTransactions, arg.ActivityType, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAllPropertyHubActivitiesTransactionsRow
	for rows.Next() {
		var i GetAllPropertyHubActivitiesTransactionsRow
		if err := rows.Scan(
			&i.ID,
			&i.PropertyName,
			&i.ActivityDate,
			&i.ModuleName,
			&i.UserName,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getAllPropertyHubActivity = `-- name: GetAllPropertyHubActivity :many
SELECT id, company_types_id, companies_id, is_branch, is_property, is_property_branch, unit_category, property_unit_id, module_name, activity_type, file_category, file_url, portal_url, activity, user_id, activity_date FROM property_hub_activities
ORDER BY id
LIMIT $1 OFFSET $2
`

type GetAllPropertyHubActivityParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) GetAllPropertyHubActivity(ctx context.Context, arg GetAllPropertyHubActivityParams) ([]PropertyHubActivity, error) {
	rows, err := q.db.Query(ctx, getAllPropertyHubActivity, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []PropertyHubActivity
	for rows.Next() {
		var i PropertyHubActivity
		if err := rows.Scan(
			&i.ID,
			&i.CompanyTypesID,
			&i.CompaniesID,
			&i.IsBranch,
			&i.IsProperty,
			&i.IsPropertyBranch,
			&i.UnitCategory,
			&i.PropertyUnitID,
			&i.ModuleName,
			&i.ActivityType,
			&i.FileCategory,
			&i.FileUrl,
			&i.PortalUrl,
			&i.Activity,
			&i.UserID,
			&i.ActivityDate,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getCountPropertyActivitiesByType = `-- name: GetCountPropertyActivitiesByType :one
SELECT
count(*)
FROM
property_hub_activities
WHERE
activity_type = $1
`

func (q *Queries) GetCountPropertyActivitiesByType(ctx context.Context, activityType int64) (int64, error) {
	row := q.db.QueryRow(ctx, getCountPropertyActivitiesByType, activityType)
	var count int64
	err := row.Scan(&count)
	return count, err
}

const getPropertyHubActivities = `-- name: GetPropertyHubActivities :one
SELECT id, company_types_id, companies_id, is_branch, is_property, is_property_branch, unit_category, property_unit_id, module_name, activity_type, file_category, file_url, portal_url, activity, user_id, activity_date FROM property_hub_activities
WHERE property_hub_activities.property_unit_id = $1 AND property_hub_activities.is_property = $2 AND property_hub_activities.is_branch = $3
`

type GetPropertyHubActivitiesParams struct {
	PropertyUnitID pgtype.Int8 `json:"property_unit_id"`
	IsProperty     pgtype.Bool `json:"is_property"`
	IsBranch       pgtype.Bool `json:"is_branch"`
}

func (q *Queries) GetPropertyHubActivities(ctx context.Context, arg GetPropertyHubActivitiesParams) (PropertyHubActivity, error) {
	row := q.db.QueryRow(ctx, getPropertyHubActivities, arg.PropertyUnitID, arg.IsProperty, arg.IsBranch)
	var i PropertyHubActivity
	err := row.Scan(
		&i.ID,
		&i.CompanyTypesID,
		&i.CompaniesID,
		&i.IsBranch,
		&i.IsProperty,
		&i.IsPropertyBranch,
		&i.UnitCategory,
		&i.PropertyUnitID,
		&i.ModuleName,
		&i.ActivityType,
		&i.FileCategory,
		&i.FileUrl,
		&i.PortalUrl,
		&i.Activity,
		&i.UserID,
		&i.ActivityDate,
	)
	return i, err
}

const getPropertyHubActivity = `-- name: GetPropertyHubActivity :one
SELECT id, company_types_id, companies_id, is_branch, is_property, is_property_branch, unit_category, property_unit_id, module_name, activity_type, file_category, file_url, portal_url, activity, user_id, activity_date FROM  property_hub_activities
WHERE id=$1 LIMIT $1
`

func (q *Queries) GetPropertyHubActivity(ctx context.Context, limit int32) (PropertyHubActivity, error) {
	row := q.db.QueryRow(ctx, getPropertyHubActivity, limit)
	var i PropertyHubActivity
	err := row.Scan(
		&i.ID,
		&i.CompanyTypesID,
		&i.CompaniesID,
		&i.IsBranch,
		&i.IsProperty,
		&i.IsPropertyBranch,
		&i.UnitCategory,
		&i.PropertyUnitID,
		&i.ModuleName,
		&i.ActivityType,
		&i.FileCategory,
		&i.FileUrl,
		&i.PortalUrl,
		&i.Activity,
		&i.UserID,
		&i.ActivityDate,
	)
	return i, err
}

const getPropertyHubActivityByPropertyId = `-- name: GetPropertyHubActivityByPropertyId :one
SELECT id, company_types_id, companies_id, is_branch, is_property, is_property_branch, unit_category, property_unit_id, module_name, activity_type, file_category, file_url, portal_url, activity, user_id, activity_date FROM property_hub_activities WHERE property_unit_id = $1 AND module_name = $2
`

type GetPropertyHubActivityByPropertyIdParams struct {
	PropertyUnitID pgtype.Int8 `json:"property_unit_id"`
	ModuleName     string      `json:"module_name"`
}

func (q *Queries) GetPropertyHubActivityByPropertyId(ctx context.Context, arg GetPropertyHubActivityByPropertyIdParams) (PropertyHubActivity, error) {
	row := q.db.QueryRow(ctx, getPropertyHubActivityByPropertyId, arg.PropertyUnitID, arg.ModuleName)
	var i PropertyHubActivity
	err := row.Scan(
		&i.ID,
		&i.CompanyTypesID,
		&i.CompaniesID,
		&i.IsBranch,
		&i.IsProperty,
		&i.IsPropertyBranch,
		&i.UnitCategory,
		&i.PropertyUnitID,
		&i.ModuleName,
		&i.ActivityType,
		&i.FileCategory,
		&i.FileUrl,
		&i.PortalUrl,
		&i.Activity,
		&i.UserID,
		&i.ActivityDate,
	)
	return i, err
}

const updatePropertyHubActivities = `-- name: UpdatePropertyHubActivities :one
UPDATE property_hub_activities
SET  company_types_id = $2,  
companies_id = $3, 
is_branch = $4,  
is_property = $5, 
is_property_branch = $6, 
unit_category = $7, 
property_unit_id = $8,  
module_name = $9, 
activity_type = $10, 
file_category = $11,  
file_url = $12,  
portal_url = $13,  
activity = $14, 
user_id = $15,  
activity_date = $16 
Where id = $1
RETURNING id, company_types_id, companies_id, is_branch, is_property, is_property_branch, unit_category, property_unit_id, module_name, activity_type, file_category, file_url, portal_url, activity, user_id, activity_date
`

type UpdatePropertyHubActivitiesParams struct {
	ID               int64       `json:"id"`
	CompanyTypesID   pgtype.Int8 `json:"company_types_id"`
	CompaniesID      pgtype.Int8 `json:"companies_id"`
	IsBranch         pgtype.Bool `json:"is_branch"`
	IsProperty       pgtype.Bool `json:"is_property"`
	IsPropertyBranch pgtype.Bool `json:"is_property_branch"`
	UnitCategory     pgtype.Text `json:"unit_category"`
	PropertyUnitID   pgtype.Int8 `json:"property_unit_id"`
	ModuleName       string      `json:"module_name"`
	ActivityType     int64       `json:"activity_type"`
	FileCategory     pgtype.Int8 `json:"file_category"`
	FileUrl          pgtype.Text `json:"file_url"`
	PortalUrl        pgtype.Text `json:"portal_url"`
	Activity         string      `json:"activity"`
	UserID           int64       `json:"user_id"`
	ActivityDate     time.Time   `json:"activity_date"`
}

func (q *Queries) UpdatePropertyHubActivities(ctx context.Context, arg UpdatePropertyHubActivitiesParams) (PropertyHubActivity, error) {
	row := q.db.QueryRow(ctx, updatePropertyHubActivities,
		arg.ID,
		arg.CompanyTypesID,
		arg.CompaniesID,
		arg.IsBranch,
		arg.IsProperty,
		arg.IsPropertyBranch,
		arg.UnitCategory,
		arg.PropertyUnitID,
		arg.ModuleName,
		arg.ActivityType,
		arg.FileCategory,
		arg.FileUrl,
		arg.PortalUrl,
		arg.Activity,
		arg.UserID,
		arg.ActivityDate,
	)
	var i PropertyHubActivity
	err := row.Scan(
		&i.ID,
		&i.CompanyTypesID,
		&i.CompaniesID,
		&i.IsBranch,
		&i.IsProperty,
		&i.IsPropertyBranch,
		&i.UnitCategory,
		&i.PropertyUnitID,
		&i.ModuleName,
		&i.ActivityType,
		&i.FileCategory,
		&i.FileUrl,
		&i.PortalUrl,
		&i.Activity,
		&i.UserID,
		&i.ActivityDate,
	)
	return i, err
}

const updatePropertyHubActivity = `-- name: UpdatePropertyHubActivity :one
UPDATE property_hub_activities
SET    
        module_name=$2,
        activity_type=$3,
        portal_url=$4,
        -- before=$5,
        activity=$5,
        activity_date=$6
Where id = $1
RETURNING id, company_types_id, companies_id, is_branch, is_property, is_property_branch, unit_category, property_unit_id, module_name, activity_type, file_category, file_url, portal_url, activity, user_id, activity_date
`

type UpdatePropertyHubActivityParams struct {
	ID           int64       `json:"id"`
	ModuleName   string      `json:"module_name"`
	ActivityType int64       `json:"activity_type"`
	PortalUrl    pgtype.Text `json:"portal_url"`
	Activity     string      `json:"activity"`
	ActivityDate time.Time   `json:"activity_date"`
}

func (q *Queries) UpdatePropertyHubActivity(ctx context.Context, arg UpdatePropertyHubActivityParams) (PropertyHubActivity, error) {
	row := q.db.QueryRow(ctx, updatePropertyHubActivity,
		arg.ID,
		arg.ModuleName,
		arg.ActivityType,
		arg.PortalUrl,
		arg.Activity,
		arg.ActivityDate,
	)
	var i PropertyHubActivity
	err := row.Scan(
		&i.ID,
		&i.CompanyTypesID,
		&i.CompaniesID,
		&i.IsBranch,
		&i.IsProperty,
		&i.IsPropertyBranch,
		&i.UnitCategory,
		&i.PropertyUnitID,
		&i.ModuleName,
		&i.ActivityType,
		&i.FileCategory,
		&i.FileUrl,
		&i.PortalUrl,
		&i.Activity,
		&i.UserID,
		&i.ActivityDate,
	)
	return i, err
}
