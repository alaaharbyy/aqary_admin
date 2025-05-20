package main

import (
	_ "aqary_admin/cmd/docs"
	"aqary_admin/config"
	"aqary_admin/internal/delivery/routes"
)

func init() {

}

// ! it's a dispatcher
// var gocial = gocialite.NewDispatcher()
//
// @title Aqary  APIs
// @version 1.06
// @description Testing Swagger APIs.
// @securityDefinitions.apikey bearerToken
// @in header
// @name Authorization
// @host localhost:8080
// @schemes http

func main() {

	config.Initialize()
	routes.StartServer()

}
