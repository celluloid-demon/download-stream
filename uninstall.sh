#!/bin/sh

# Declare constants
IMAGE_NAME="download-stream-main"
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
    docker image rm $IMAGE_NAME
    docker system prune

}

main
