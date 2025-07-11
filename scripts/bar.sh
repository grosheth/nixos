#!/usr/bin/env bash
VPN_NAME="wg-enp5s0"
PID_FILE="/tmp/vpnbar.pid"

# Get main monitor geometry
MONITOR_INFO=$(xrandr | awk '/ connected primary/ {print $0}')
RESOLUTION=$(echo $MONITOR_INFO | grep -oP '\d+x\d+\+\d+\+\d+')
WIDTH=$(echo $RESOLUTION | cut -d'x' -f1)
HEIGHT=$(echo $RESOLUTION | cut -d'x' -f2 | cut -d'+' -f1)
X=$(echo $RESOLUTION | cut -d'+' -f2)
Y=$(echo $RESOLUTION | cut -d'+' -f3)
BAR_HEIGHT=30
TOP_MARGIN=5
GEOM="${WIDTH}x${BAR_HEIGHT}+${X}+$((Y + TOP_MARGIN))"

get_status() {
    # Check if interface exists and is up
    if ip link show "$VPN_NAME" > /dev/null 2>&1 && ip addr show "$VPN_NAME" | grep -q "inet"; then
        echo "ON"
    else
        echo "OFF"
    fi
}

# Might do a simple process manager to follow some services and stop/start them
start_bar() {
    if [ -f "$PID_FILE" ]; then
        echo "VPN bar is already running (PID: $(cat $PID_FILE))"
        exit 1
    fi
    
    echo "Starting VPN bar..."
    
    # Start the bar in background and save PID
    (
        while :; do
            STATUS=$(get_status)
            if [ "$STATUS" = "ON" ]; then
                echo "%{A1:kitty -e /home/salledelavage/nixos/scripts/vpn.sh:}%{F#6dd797}  󰒃 VPN: ON%{F-}%{A}"
            else
                echo "%{A1:kitty -e /home/salledelavage/nixos/scripts/vpn.sh:}%{F#e55c74}  󰒃 VPN: OFF%{F-}%{A}"
            fi
            sleep 1
        done | lemonbar -p -g "$GEOM" -B "#18181b" -F "#dcdfe4" -a 20 -n bar
    ) &
    
    echo $! > "$PID_FILE"
    echo "VPN bar started (PID: $(cat $PID_FILE))"
}

stop_bar() {
    if [ ! -f "$PID_FILE" ]; then
        echo "VPN bar is not running"
        exit 1
    fi
    
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        echo "Stopping VPN bar (PID: $PID)..."
        # Kill the main process and all its children
        pkill -P "$PID" 2>/dev/null
        kill "$PID" 2>/dev/null
        # Also kill any lemonbar processes that might be orphaned
        pkill -f "lemonbar.*bar" 2>/dev/null
        rm -f "$PID_FILE"
        echo "VPN bar stopped"
    else
        echo "VPN bar process not found, cleaning up PID file"
        # Kill any orphaned lemonbar processes
        pkill -f "lemonbar.*bar" 2>/dev/null
        rm -f "$PID_FILE"
    fi
}

toggle_bar() {
    if [ -f "$PID_FILE" ]; then
        stop_bar
    else
        start_bar
    fi
}

show_status() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            echo "VPN bar is running (PID: $PID)"
        else
            echo "VPN bar PID file exists but process is not running"
            rm -f "$PID_FILE"
        fi
    else
        echo "VPN bar is not running"
    fi
}

case "${1:-toggle}" in
    start)
        start_bar
        ;;
    stop)
        stop_bar
        ;;
    restart)
        stop_bar
        sleep 1
        start_bar
        ;;
    status)
        show_status
        ;;
    toggle)
        toggle_bar
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|toggle}"
        echo "  start   - Start the VPN bar"
        echo "  stop    - Stop the VPN bar"
        echo "  restart - Restart the VPN bar"
        echo "  status  - Show VPN bar status"
        echo "  toggle  - Toggle VPN bar on/off (default)"
        exit 1
        ;;
esac 