package main

import (
	"log"
	"net/http"
	"os"
)

func getEnv(key string, defaultValue string) string {
	value := os.Getenv(key)
	if value == "" {
		return defaultValue
	}
	return value
}

func main() {
	port := getEnv("PORT", "3000")
	dir := getEnv("DIRECTORY", "/static")

	log.Println("Serving " + dir + " on port " + port)

	http.Handle("/", http.FileServer(http.Dir(dir)))

	log.Println("Listening...")
	http.ListenAndServe(":"+port, nil)
}
