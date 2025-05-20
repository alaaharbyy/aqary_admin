package aqaryinvestment

import usecase "aqary_admin/internal/usecases"

type AllHandler struct {
	useCases usecase.AqaryInvestmentUseCase
}

func NewHandler(useCases usecase.AqaryInvestmentUseCase) *AllHandler {
	return &AllHandler{
		useCases: useCases,
	}
}
