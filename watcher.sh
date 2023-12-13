#!/bin/bash

# Description: This is intended to run on the host and MOVE files temporarily
# saved in the output directory over to their permanent location.

# Exit on error
set -e

# Set working directory (for running from cron)
SCPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCPT_DIR="$(dirname "$SCPT_PATH")"
cd "$SCPT_DIR"

# Declare constants
LIBRARY="./lib"
RESOURCE_DIR="./resources"
SETTINGS="./settings"

curl_pid=
duration_min=$DURATION
duration_sec=
retry_delay=5
output_path="/output"
output_file_basename="$OUTPUT_FILE_BASENAME"
stream_url="$STREAM_URL"

# Initialize script
init() {

	# Source library file
	if [ -e "$LIBRARY" ]; then

		source "$LIBRARY"

	else

		echo "\'$LIBRARY\' file not found, terminating."
		exit 1

	fi

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

	# Create watcher directory if it doesn't already exit
	mkdir -p "${WATCHER_DIR:="$HOME"}"

}

# Main logic
main() {

	init

	# Sleep for one minute to wait for container to start
	echo "Waiting one minute for container start..."
	sleep 1m

	# Summary: If container running, wait until down then move contents of
	# output dir to watcher dir, if not already running, exit immediately with
	# message.

	# Attempt to get main container id of this docker service
	container_id_main=$(docker ps -aqf "name=$CONTAINER_BASENAME_MAIN")

	# Temporarily disable "exit on error" behavior, attempt to inspect the
	# container and see if it's running
	set +e
	container_status=$(docker inspect -f '{{.State.Status}}' "$container_id_main")
	set -e

	# (relevant values: running, exited)
	if [ "$container_status" == "running" ]; then

		echo "Container running, waiting for container to finish..."

		# Hang out in this loop and move on only when the container is down
		while [ "$container_status" == "running" ]; do

			sleep 5

			# Get new container status
			set +e
			container_status=$(docker inspect -f '{{.State.Status}}' "$container_id_main")
			set -e

		done

		# Container is no longer running, move contents of output dir to watcher
		# dir
		echo "Container finished running, moving contents of ${OUTPUT_DIR} to ${WATCHER_DIR}..."
		mv "$OUTPUT_DIR"/* "$WATCHER_DIR"/

	else

		echo "Container is not currently running, exiting."
		exit 1
	
	fi

	echo "Done."

}

main
