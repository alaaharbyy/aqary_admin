package httpclient

import (
	"context"
	"io"
	"net/http"
)

type HTTPClient interface {
	DoRequest(ctx context.Context, method, url string, body io.Reader, headers map[string]string) (*http.Response, error)
}

type httpClient struct{}

func (d *httpClient) DoRequest(ctx context.Context, method, url string, body io.Reader, headers map[string]string) (*http.Response, error) {
	req, err := http.NewRequestWithContext(ctx, method, url, body)
	if err != nil {
		return nil, err
	}

	for key, value := range headers {
		req.Header.Set(key, value)
	}

	return http.DefaultClient.Do(req)
}

func NewHTTPClient() HTTPClient {
	return &httpClient{}
}
