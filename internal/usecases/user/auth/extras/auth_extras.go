package extras

import (
	"errors"
	"net/http"

	"aqary_admin/internal/domain/sqlc/sqlc"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
)

func AgentValidation(c *gin.Context, req RegisterRequest, q sqlc.Store) (int, error) {

	if req.BrokerCompanyID == 0 {
		return http.StatusBadRequest, errors.New("broker company id is required for agent")
	}

	if req.IsBranch == nil {
		return http.StatusBadRequest, errors.New("branch is required for agent")
	}
	if *req.IsBranch {
		_, err := q.GetBrokerCompanyBranch(c, req.BrokerCompanyID)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				return http.StatusNotFound, errors.New("broker branch company not found")
			}
			return http.StatusInternalServerError, err
		}
	} else {
		_, err := q.GetBrokerCompany(c, req.BrokerCompanyID)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {

				return http.StatusNotFound, errors.New("broker company not found")
			}
			return http.StatusInternalServerError, err
		}
	}

	if req.BRN == "" {
		return http.StatusBadRequest, errors.New("brn is required for agent")
	}

	if req.BRNExpiry.IsZero() {

		return http.StatusBadRequest, errors.New("brn expiry is required for agent")
	}

	return 0, nil
}
