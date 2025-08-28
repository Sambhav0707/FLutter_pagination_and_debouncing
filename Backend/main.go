package main

import (
	"log"
	"net/http"
	"players-list/routes"
)

func main() {
	r := routes.RegisterRoutes()

	log.Fatal(http.ListenAndServe(":8081", r))
}