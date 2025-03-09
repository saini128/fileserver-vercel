#!/bin/bash

# Store the base directory when the script starts
BASE_DIR="$(pwd)"

# Function to display menu
show_menu() {
    while true; do
        clear
        echo "===== File Browser ====="
        echo "Current Directory: $(pwd)"
        echo "========================"

        # List files and folders
        options=()
        i=1
        for item in *; do
            options+=("$item")
            echo "$i) $item"
            ((i++))
        done

        # Add navigation options
        if [[ "$(pwd)" != "$BASE_DIR" ]]; then
            echo "$i) 🔙 Go Back"
            echo "$((i+1))) 🚪 Exit"
        else
            echo "$i) 🚪 Exit"
        fi

        # Get user input
        read -p "Enter your choice: " choice
        choice=$((choice - 1))

        # Process user choice
        if [[ $choice -ge 0 && $choice -lt ${#options[@]} ]]; then
            selected="${options[$choice]}"

            if [[ -d "$selected" ]]; then
                cd "$selected"
                if [[ -f "menu.sh" ]]; then
                    echo "Executing menu.sh in $selected..."
                    bash "menu.sh"
                else
                    show_menu  # Recursively show menu in the new directory
                fi
                cd ..
            elif [[ -f "$selected" ]]; then
                echo "Downloading $selected..."
                curl -O "https://files.singhropar.com/$selected" && echo "✅ Download Complete!" || echo "❌ Download Failed!"
                sleep 2
            fi

        elif [[ $choice -eq ${#options[@]} ]]; then
            if [[ "$(pwd)" != "$BASE_DIR" ]]; then
                cd ..
            else
                echo "Already in base folder!"
                sleep 1
            fi

        elif [[ $choice -eq $(( ${#options[@]} + 1 )) ]]; then
            echo "Exiting..."
            exit 0
        else
            echo "Invalid choice, try again."
            sleep 1
        fi
    done
}

# Start menu
show_menu
