package repoerror

import (
	"errors"
	"fmt"
	"log"
	"regexp"

	"aqary_admin/internal/delivery/rest/middleware"
	"aqary_admin/pkg/utils/exceptions"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
)

func BuildRepoErr(section string, name string, err error) *exceptions.Exception {
	if err != nil {
		log.Printf("[%v.repo.%v] error:%v", section, name, err)

		if errors.Is(err, pgx.ErrNoRows) {
			return exceptions.GetExceptionByErrorCode(exceptions.NoDataFoundErrorCode)
		}

		var pgErr *pgconn.PgError
		if errors.As(err, &pgErr) {
			switch pgErr.Code {
			case "23505": // PostgreSQL error code for unique_violation
				constraintField := extractConstraintField(pgErr.Detail)
				return HandleUniqueConstraintViolation(pgErr, constraintField)
			case "23503": // PostgreSQL error code for foreign_key_violation
				return HandleForeignKeyConstraintViolation(pgErr)
			}
		}

		middleware.IncrementServerErrorCounter(fmt.Errorf("[%v.repo.%v] error:%v", section, name, err).Error())
		return exceptions.GetExceptionByErrorCode(exceptions.SomethingWentWrongErrorCode)
	}
	return nil
}

func extractConstraintField(errorDetail string) string {
	re := regexp.MustCompile(`Key \((.*?)\)=`)
	matches := re.FindStringSubmatch(errorDetail)
	if len(matches) > 1 {
		return matches[1]
	}
	return ""
}

func HandleUniqueConstraintViolation(pgErr *pgconn.PgError, field string) *exceptions.Exception {
	return &exceptions.Exception{
		ErrorCode:    exceptions.UniqueConstraintViolationErrorCode,
		ErrorMessage: exceptions.ErrorMessage(fmt.Sprintf("Unique constraint violation for field: %s", field)),
	}
}

func HandleForeignKeyConstraintViolation(pgErr *pgconn.PgError) *exceptions.Exception {
	msg := fmt.Sprintf("Foreign key constraint violation: %s", pgErr.Message)
	log.Println(msg)
	return &exceptions.Exception{
		ErrorCode:    exceptions.BadRequestErrorCode,
		ErrorMessage: exceptions.ErrorMessage(fmt.Errorf("violates foreign key constraint:%v", pgErr).Error()),
	}
}
