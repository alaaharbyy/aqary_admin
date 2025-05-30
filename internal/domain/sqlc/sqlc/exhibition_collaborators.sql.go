// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: exhibition_collaborators.sql

package sqlc

import (
	"context"
)

const getNumbersOfExhibitionCollaboratorsByType = `-- name: GetNumbersOfExhibitionCollaboratorsByType :many

SELECT collaborator_type,COUNT(id)

FROM exhibition_collaborators 

WHERE exhibitions_id=$1 AND is_deleted=false

GROUP BY 

	collaborator_type
`

type GetNumbersOfExhibitionCollaboratorsByTypeRow struct {
	CollaboratorType int64 `json:"collaborator_type"`
	Count            int64 `json:"count"`
}

func (q *Queries) GetNumbersOfExhibitionCollaboratorsByType(ctx context.Context, exhibitionsID int64) ([]GetNumbersOfExhibitionCollaboratorsByTypeRow, error) {
	rows, err := q.db.Query(ctx, getNumbersOfExhibitionCollaboratorsByType, exhibitionsID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetNumbersOfExhibitionCollaboratorsByTypeRow
	for rows.Next() {
		var i GetNumbersOfExhibitionCollaboratorsByTypeRow
		if err := rows.Scan(&i.CollaboratorType, &i.Count); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}
