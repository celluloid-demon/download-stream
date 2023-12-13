#!/bin/bash

# Exit on error
set -e

# Set working directory (for running from cron)
SCPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCPT_DIR="$(dirname "$SCPT_PATH")"
cd "$SCPT_DIR"

# Declare constants
RESOURCE_DIR="./resources"
SETTINGS="./settings"

# Initialize script
init() {

	# Create settings file if it doesn't already exist
	if [ ! -e "$SETTINGS" ]; then

		echo "\'$SETTINGS\' file not found, creating..."

		cp ${RESOURCE_DIR}/$(basename "$SETTINGS")* ./

		mv "$SETTINGS"* "$SETTINGS"
		
	fi

}

# Main logic
main() {

	init
	
}

main
