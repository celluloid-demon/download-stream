#!/bin/bash

# Exit on error
set -e

# Declare constants
SETTINGS="./settings"

# Initialize script
init() {

	# Source settings file
	. "$SETTINGS"

}

# Main logic
main() {

    init

    docker compose down

}

main
