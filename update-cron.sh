#!/bin/bash

# Declare constants
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

	# Get full path of command for cron
	CRON_COMMAND_PATH="$(readlink -f "$CRON_COMMAND")"

}

# Main logic
main() {

	init

	# Create a temporary file to store the current crontab
	temp_cron=$(mktemp)

	# Copy the existing crontab
	crontab -l > "$temp_cron"

	# Add the new cron entry
	echo "$CRON_SCHEDULE $CRON_COMMAND_PATH # $CRON_DESCRIPTION $CRON_MARKER" >> "$temp_cron"

	# Install the new crontab
	crontab "$temp_cron"

	# Clean up the temporary file
	rm "$temp_cron"

	echo "Done."

}

main
