package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
)

func main() {
	// Get the current directory
	dir, err := os.Getwd()
	if err != nil {
		fmt.Println("Error getting current directory:", err)
		return
	}

	// Read all files in the current directory
	files, err := ioutil.ReadDir(dir)
	if err != nil {
		fmt.Println("Error reading files in the current directory:", err)
		return
	}

	// Loop over each file
	for _, file := range files {
		// Check if the file is not a directory and has a .mp4 extension
		if !file.IsDir() && filepath.Ext(file.Name()) == ".mp4" {
			// Get the creation time of the file
			createdTime := file.ModTime()

			// Generate the new name with the ISO format of the created time
			newName := "NAME-" + createdTime.Format("2006-01-02") + filepath.Ext(file.Name())

			// Rename the file
			err := os.Rename(file.Name(), newName)
			if err != nil {
				fmt.Printf("Error renaming file %s to %s: %v\n", file.Name(), newName, err)
			} else {
				fmt.Printf("Renamed %s to %s\n", file.Name(), newName)
			}
		}
	}
}
