package middleware

import (
	"fmt"
	"net/http"
	"testing"
	"time"

	"aqary_admin/pkg/utils/security"

	"github.com/stretchr/testify/require"
)

func AddTestAuthorization(
	t *testing.T,
	request *http.Request,
	tokenMaker security.Maker,
	username string,
	duration time.Duration,
) {

	auth := ""
	var err error

	auth, err = tokenMaker.CreateToken(username, duration)
	require.NoError(t, err)

	authorizationHeader := fmt.Sprintf("%s %s", "bearer", auth)
	request.Header.Set("authorization", authorizationHeader)
}
