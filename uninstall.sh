#!/bin/sh

# Declare constants
IMAGE_NAME="download-stream-main"
RESOURCE_DIR="./resources"
SETTINGS="./settings"

# Initialize script
init() {

	# Create settings file if it doesn't already exist
	if [ ! -e "$SETTINGS" ]; then

		cp ${RESOURCE_DIR}/$(basename "$SETTINGS")* ./
		mv "$SETTINGS"* "$SETTINGS"
		
	fi

	# Source settings file
	. "$SETTINGS"

}

# Main logic
main() {

    init

    docker compose down
    docker image rm $IMAGE_NAME
    docker system prune

	crontab -l | grep -v "$CRON_MARKER" | crontab - && crontab -l

	echo "Done."

}

main
