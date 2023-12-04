#!/bin/bash

# Exit on error
set -e

# Declare constants
SETTINGS="./settings"

# Main logic
main() {

    # Remove settings file if it exists
	if [ -e "$SETTINGS" ]; then

        rm "$SETTINGS"
		
	fi

    echo "Done."

}

main
