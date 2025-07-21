#!/usr/bin/env bash

# Save current DPMS and screensaver settings
OLD_DPMS=$(xset q | grep 'DPMS is' | awk '{print $3}')
OLD_TIMEOUT=$(xset q | grep 'timeout:' | awk '{print $2}')

# Disable DPMS and screensaver
xset -dpms
xset s off

# Run homeDash
~/work/homeDash/target/debug/homeDash

# Restore previous settings (optional)
if [ "$OLD_DPMS" = "Enabled" ]; then
  xset +dpms
else
  xset -dpms
fi
xset s $OLD_TIMEOUT $OLD_TIMEOUT