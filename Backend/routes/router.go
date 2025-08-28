package routes

import (
	"players-list/controllers"

	"github.com/gorilla/mux"
)

func RegisterRoutes() *mux.Router {
	router := mux.NewRouter()
	router.HandleFunc("/api/players", controllers.GetAllPlayers).Methods("GET")
	router.HandleFunc("/api/searchPlayers", controllers.SearchPlayers).Methods("GET")

	return router

}
