package utils

import (
	"encoding/csv"
	"fmt"
	"os"
)

func ReadCSV(filePath string) ([][]string, error) {

	// Open the CSV file
	file, err := os.Open(filePath)
	if err != nil {
		fmt.Println("Error:", err)
		return nil, fmt.Errorf("failed to open a file:Error:%v", err)
	}
	defer file.Close()

	// Create a new CSV reader
	reader := csv.NewReader(file)

	// Read the CSV records
	records, err := reader.ReadAll()
	if err != nil {
		fmt.Println("Error:", err)
		return nil, fmt.Errorf("failed to read:Error:%v", err)
	}

	return records, nil
}
