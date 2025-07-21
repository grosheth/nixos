#!/usr/bin/env bash

# Disable DPMS and screensaver so the screen never goes black
xset -dpms
xset s off

IDLE_LIMIT=$((5 * 60 * 1000)) # 5 minutes in milliseconds
# IDLE_LIMIT=$((5 * 60)) # 5 minutes in milliseconds

while true; do
    idle=$(xprintidle)
    if [ "$idle" -ge "$IDLE_LIMIT" ]; then
        # Run your lock screen and wait for it to exit
        ~/work/homeDash/target/debug/homeDash
        # After unlock, wait for activity before starting to watch again
        while [ "$(xprintidle)" -ge 1000 ]; do
            sleep 1
        done
    fi
    sleep 5
done