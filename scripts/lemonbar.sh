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
    # Check if interface exists and is up
    if ip link show "$VPN_NAME" > /dev/null 2>&1 && ip addr show "$VPN_NAME" | grep -q "inet"; then
        echo "ON"
    else
        echo "OFF"
    fi
}

while :; do
    STATUS=$(get_status)
    if [ "$STATUS" = "ON" ]; then
        echo "%{A1:vpn-toggler.sh:}%{F#6dd797}  󰒃 VPN: ON%{F-}%{A}"
    else
        echo "%{A1:vpn-toggler.sh:}%{F#e55c74}  󰒃 VPN: OFF%{F-}%{A}"
    fi
    sleep 1
done | lemonbar -p -g "$GEOM" -B "#18181b" -F "#dcdfe4" -a 20