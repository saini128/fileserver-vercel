#!/bin/bash

# Base URL for downloads
BASE_URL="http://localhost:5555"

# Files and folders
FILES=(
    "base.txt"
)
FOLDERS=(
    "gitswift"
)

# Menu Loop
while true; do
    clear
    echo "===== Download Menu ====="
    
    # Display files first
    for i in "${!FILES[@]}"; do
        echo "$((i+1)): ${FILES[i]}"
    done

    # Display folders after files
    folder_start_index=$(( ${#FILES[@]} + 1 ))
    for i in "${!FOLDERS[@]}"; do
        echo "$((folder_start_index + i)): ${FOLDERS[i]}/"
    done

    # Exit option (Fixed)
    exit_index=$((folder_start_index + ${#FOLDERS[@]}))
    echo "$exit_index. Exit"

    # Get user input
    read -p "Enter your choice: " choice

    # Validate input
    if [[ ! "$choice" =~ ^[0-9]+$ ]]; then
        echo "Invalid input. Please enter a number."
        sleep 1
        continue
    fi

    # Convert to index
    index=$((choice - 1))
    # File selection handling
    if [[ $index -ge 0 && $index -lt ${#FILES[@]} ]]; then
        FILE_NAME="${FILES[$index]}"
        echo "Downloading $FILE_NAME..."
        curl -O "$BASE_URL/$FILE_NAME" && echo "✅ Download Complete!" || echo "❌ Download Failed!"
        sleep 2

    # Folder selection handling
    elif [[ $index -ge ${#FILES[@]} && $index -lt $exit_index-1 ]]; then
        folder_index=$((index - ${#FILES[@]}))
        SELECTED_FOLDER="${FOLDERS[$folder_index]}"
        echo "Entering $SELECTED_FOLDER..."
        exec bash <(curl -s "$BASE_URL/$SELECTED_FOLDER/menu.sh")
        

    # Exit option (Corrected)
    elif [[ $index -le $exit_index ]]; then
        echo "Exiting..."
        exit 0

    else
        echo "Invalid choice, try again."
        sleep 1
    fi
done