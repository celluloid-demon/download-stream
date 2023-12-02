#!/bin/bash

# Declare vars
curl_pid=
retry_delay=5
output_path="/output"
output_file_basename="wfpk"
stream_url="http://lpm.streamguys1.com/wfpk-web"

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

	# Start time
	start_time=$(date +%s)

	# End time
	end_time=$((start_time + 10800))  # 3 hours in seconds

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
