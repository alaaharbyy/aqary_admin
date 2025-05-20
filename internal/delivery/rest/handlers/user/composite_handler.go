// package user_handler

package user_handler

import (
	usecase "aqary_admin/internal/usecases/user"

	"github.com/gin-gonic/gin"
)

type Handler interface {
	RegisterAuthRoutes(*gin.RouterGroup)
	RegisterNonAuthRoutes(*gin.RouterGroup)
}

type CompositeHandler struct {
	handlers []Handler
	useCase  usecase.UserCompositeUseCase
}

func NewCompositeHandler(useCase usecase.UserCompositeUseCase) *CompositeHandler {
	return &CompositeHandler{
		useCase: useCase,
	}
}

func (ch *CompositeHandler) AddHandler(h Handler) {
	ch.handlers = append(ch.handlers, h)
}

func (ch *CompositeHandler) RegisterAuthRoutes(r *gin.RouterGroup) {
	for _, h := range ch.handlers {
		h.RegisterAuthRoutes(r)
	}
}

func (ch *CompositeHandler) RegisterNonAuthRoutes(r *gin.RouterGroup) {
	for _, h := range ch.handlers {
		h.RegisterNonAuthRoutes(r)
	}
}
