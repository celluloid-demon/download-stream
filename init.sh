#!/bin/sh

# Note: This is just `up.sh` in interactive mode to watch first-time setup
# progress for any new containers / image builds.

# If docker process is not running
if ! pidof docker ; then

    echo "Starting Docker Desktop..."

    eval "$DOCKER"

    # Wait for Docker Desktop to start ('until' will run loop until condition is
    # true)
    until pids=$(pidof docker) ; do

        sleep 1
        echo "..."

    done

    echo "Up."

fi

docker compose up
