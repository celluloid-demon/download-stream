#!/bin/bash

# Exit on error
set -e

# Declare constants
LIBRARY="./lib"
RESOURCE_DIR="./resources"
SETTINGS="./settings"

# Initialize script
init() {

	# Source library file
	if [ -e "$LIBRARY" ]; then

		source "$LIBRARY"

	else

		echo "\'$LIBRARY\' file not found, terminating."
		exit 1

	fi

	# Set default docker command to look for based on host system

	OS_TYPE="$(get_os_type)"

	[ "$OS_TYPE" == "LINUX" ]		&& DOCKER_CMD="docker"
	[ "$OS_TYPE" == "MACOS" ]		&& DOCKER_CMD="/Applications/Docker.app/Contents/Resources/docker"
	[ "$OS_TYPE" == "WSL" ]			&& DOCKER_CMD="/mnt/c/Program\ Files/Docker/Docker/Docker\ Desktop.exe"
	[ "$OS_TYPE" == "WINDOWS" ]		&& echo "Unsupported runtime (please run from WSL instead), terminating." && exit 1
	[ "$OS_TYPE" == "UNKNOWN_OS" ]	&& echo "Unknown OS type ('uname -s' output: $(uname -s)), terminating." && exit 1

	# Create settings file if it doesn't already exist
	if [ ! -e "$SETTINGS" ]; then

		echo "\'$SETTINGS\' file not found, creating..."

		cp ${RESOURCE_DIR}/$(basename "$SETTINGS")* ./

		mv "$SETTINGS"* "$SETTINGS"
		
	fi

	# Source settings file
	. "$SETTINGS"

	# Create output directory if it doesn't already exist
	mkdir -p "${OUTPUT_DIR:='./output'}"

}

# Main logic
main() {

	init
	
	# Start docker engine if there is no PID under the process name of 'docker'
	if ! pidof docker > /dev/null; then

		echo "Starting docker..."

		eval "$DOCKER_CMD"

		wait_for_process docker

	fi

	docker compose up --detach

}

main
