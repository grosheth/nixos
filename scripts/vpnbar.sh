#!/usr/bin/env bash
VPN_NAME="wg-enp5s0"

# Get main monitor geometry
MONITOR_INFO=$(xrandr | awk '/ connected primary/ {print $0}')
RESOLUTION=$(echo $MONITOR_INFO | grep -oP '\d+x\d+\+\d+\+\d+')
WIDTH=$(echo $RESOLUTION | cut -d'x' -f1)
HEIGHT=$(echo $RESOLUTION | cut -d'x' -f2 | cut -d'+' -f1)
X=$(echo $RESOLUTION | cut -d'+' -f2)
Y=$(echo $RESOLUTION | cut -d'+' -f3)
BAR_HEIGHT=30
GEOM="${WIDTH}x${BAR_HEIGHT}+${X}+${Y}"

get_status() {
    wg show "$VPN_NAME" > /dev/null 2>&1 && echo "ON" || echo "OFF"
}

while :; do
    STATUS=$(get_status)
    if [ "$STATUS" = "ON" ]; then
        echo "%{A1:vpn-toggle.sh:}VPN: ON%{A}"
    else
        echo "%{A1:vpn-toggle.sh:}VPN: OFF%{A}"
    fi
    sleep 1
done | lemonbar -p -g "$GEOM" -B "#222222" -F "#ffffff" -f "JetBrains Nerd Font Mono  14"