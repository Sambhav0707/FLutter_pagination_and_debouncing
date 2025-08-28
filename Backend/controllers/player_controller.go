package controllers

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"players-list/models"
	"strings"
)

func GetAllPlayers(w http.ResponseWriter, r *http.Request) {
	// set the content type to json
	w.Header().Set("Content-Type", "application/json")

	// check if the request method is GET
	if r.Method != "GET" {
		w.WriteHeader(http.StatusMethodNotAllowed)
		errorResponse := map[string]string{
			"error": "Method not allowed. Only GET requests are supported.",
		}
		json.NewEncoder(w).Encode(errorResponse)
		return
	}

	// check if PLayerList is empty
	if len(models.PLayerList) == 0 {
		w.WriteHeader(http.StatusNotFound)
		errorResponse := map[string]string{
			"error": "No players found in the database.",
		}
		json.NewEncoder(w).Encode(errorResponse)
		return
	}

	// set the status code to 200
	w.WriteHeader(http.StatusOK)

	// return all players from the PLayerList with error handling
	err := json.NewEncoder(w).Encode(models.PLayerList)
	if err != nil {
		log.Printf("Error encoding players to JSON: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		errorResponse := map[string]string{
			"error": "Internal server error while processing request.",
		}
		json.NewEncoder(w).Encode(errorResponse)
		return
	}
}

func SearchPlayers(w http.ResponseWriter, r *http.Request) {
	// set the content type to json
	w.Header().Set("Content-Type", "application/json")

	// check if the request method is GET
	if r.Method != "GET" {
		w.WriteHeader(http.StatusMethodNotAllowed)
		errorResponse := map[string]string{
			"error": "Method not allowed. Only GET requests are supported.",
		}
		json.NewEncoder(w).Encode(errorResponse)
		return
	}

	// get query parameters
	query := r.URL.Query()
	searchQuery := strings.TrimSpace(strings.ToLower(query.Get("q"))) // single search parameter
	nameQuery := strings.TrimSpace(strings.ToLower(query.Get("name")))
	roleQuery := strings.TrimSpace(strings.ToLower(query.Get("role")))

	// Debug: Print the search parameters
	fmt.Printf("Search Query: '%s', Name Query: '%s', Role Query: '%s'\n", searchQuery, nameQuery, roleQuery)

	// validate query parameters
	if searchQuery == "" && nameQuery == "" && roleQuery == "" {
		w.WriteHeader(http.StatusBadRequest)
		errorResponse := map[string]string{
			"error": "Search query is required. Use 'q' for general search, or 'name'/'role' for specific search.",
		}
		json.NewEncoder(w).Encode(errorResponse)
		return
	}

	// Check if user is searching for a role using the name parameter
	validRoles := []string{"batsman", "bowler", "all-rounder", "wicket-keeper", "wicket keeper"}
	if nameQuery != "" {
		for _, role := range validRoles {
			if strings.Contains(nameQuery, role) {
				w.WriteHeader(http.StatusBadRequest)
				errorResponse := map[string]string{
					"error":      fmt.Sprintf("'%s' is a role, not a player name. Use '?q=%s' or '?role=%s' to search by role.", nameQuery, nameQuery, nameQuery),
					"suggestion": fmt.Sprintf("Try: /api/searchPlayers?q=%s or /api/searchPlayers?role=%s", nameQuery, nameQuery),
				}
				json.NewEncoder(w).Encode(errorResponse)
				return
			}
		}
	}

	// create a slice to store filtered players
	var filteredPlayers []models.Player

	// filter players based on query parameters
	for _, player := range models.PLayerList {
		playerName := strings.ToLower(player.Name)
		playerRole := strings.ToLower(player.Role)

		var matches bool = false

		// If using general search parameter 'q'
		if searchQuery != "" {
			// Check if search query matches name OR role
			nameMatches := strings.Contains(playerName, searchQuery)
			roleMatches := strings.Contains(playerRole, searchQuery)
			matches = nameMatches || roleMatches

			// Debug: Print matching details
			if nameMatches || roleMatches {
				fmt.Printf("Match found: %s (Name: %s, Role: %s)\n", player.Name, playerName, playerRole)
			}
		} else {
			// Use specific name and role parameters
			nameMatches := nameQuery == "" || strings.Contains(playerName, nameQuery)
			roleMatches := roleQuery == "" || playerRole == roleQuery
			matches = nameMatches && roleMatches
		}

		// if conditions are met, add player to filtered list
		if matches {
			filteredPlayers = append(filteredPlayers, player)
		}
	}

	// Debug: Print total matches found
	fmt.Printf("Total matches found: %d\n", len(filteredPlayers))

	// check if any players were found
	if len(filteredPlayers) == 0 {
		// set the status code to 404 (Not Found)
		w.WriteHeader(http.StatusNotFound)

		// create error response with helpful suggestions
		var errorMessage string
		if nameQuery != "" {
			errorMessage = fmt.Sprintf("No players found with name containing '%s'. Try searching with '?q=%s' to search both names and roles.", nameQuery, nameQuery)
		} else if roleQuery != "" {
			errorMessage = fmt.Sprintf("No players found with role '%s'. Valid roles are: batsman, bowler, all-rounder, wicket-keeper", roleQuery)
		} else {
			errorMessage = fmt.Sprintf("No players found matching '%s'. Try different search terms.", searchQuery)
		}

		errorResponse := map[string]string{
			"error": errorMessage,
		}

		fmt.Println("No results found, returning 404 error")

		// return the error message
		err := json.NewEncoder(w).Encode(errorResponse)
		if err != nil {
			log.Printf("Error encoding error response to JSON: %v", err)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
		}
		return
	}

	// set the status code to 200
	w.WriteHeader(http.StatusOK)

	//print the filtered players
	fmt.Printf("Returning %d players:\n", len(filteredPlayers))
	for _, player := range filteredPlayers {
		fmt.Printf("  - %s (%s)\n", player.Name, player.Role)
	}

	// return the filtered players with error handling
	err := json.NewEncoder(w).Encode(filteredPlayers)
	if err != nil {
		log.Printf("Error encoding filtered players to JSON: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		errorResponse := map[string]string{
			"error": "Internal server error while processing request.",
		}
		json.NewEncoder(w).Encode(errorResponse)
		return
	}
}
