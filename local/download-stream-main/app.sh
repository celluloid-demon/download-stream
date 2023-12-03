#!/bin/bash

# Declare vars
curl_pid=
duration_min=$DURATION
duration_sec=
retry_delay=5
output_path="/output"
output_file_basename="$OUTPUT_FILE_BASENAME"
stream_url="$STREAM_URL"

# Check and restart curl process if needed
check_and_restart_curl() {

	if ! kill -0 $curl_pid 2>/dev/null; then

		# Increment version for each new output file
		output_file="${output_file_basename}_$(date +%Y%m%d%H%M%S).mp3"
		curl --fail -o $output_path/$output_file $stream_url &
		curl_pid=$!

	fi

}

# Main logic
main() {

	# Check for dependencies (curl) and exit on error if missing
	if ! command -v curl &> /dev/null; then

		echo "Error: 'curl' command not found. Please install curl before running this script."
		exit 1

	fi

	# Exit on error if no radio stream url specified
	if [ -z "$STREAM_URL" ]; then

		echo "Error: '\$STREAM_URL' not set, terminating."
		exit 1

	fi

	# Start time
	start_time=$(date +%s)

	# Convert duration from minutes to seconds
	duration_sec=$((duration_min * 60))

	# End time
	end_time=$((start_time + duration_sec))  # 3 hours in seconds

	# Attempt to download the stream with retries for 3 hours
	while [ $(date +%s) -lt $end_time ]; do

		# Sleep before the next attempt
		check_and_restart_curl
		sleep $retry_delay

	done

	# Terminate the curl process
	kill $curl_pid

}

main
