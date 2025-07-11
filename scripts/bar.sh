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

get_cpu_usage() {
    top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1
}

get_memory_usage() {
    free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}'
}

get_disk_usage() {
    df / | tail -1 | awk '{print $5}' | sed 's/%//'
}

get_network_speed() {
    # Get current network interface
    local interface=$(ip route | grep default | awk '{print $5}' | head -1)
    if [ -n "$interface" ]; then
        # Get RX/TX bytes
        local rx=$(cat /sys/class/net/$interface/statistics/rx_bytes 2>/dev/null || echo "0")
        local tx=$(cat /sys/class/net/$interface/statistics/tx_bytes 2>/dev/null || echo "0")
        echo "${rx:-0} ${tx:-0}"
    else
        echo "0 0"
    fi
}

get_volume() {
    if command -v pactl >/dev/null 2>&1; then
        pactl get-sink-volume @DEFAULT_SINK@ | head -1 | awk '{print $5}' | sed 's/%//'
    else
        echo "N/A"
    fi
}

get_temperature() {
    if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
        echo $(( $(cat /sys/class/thermal/thermal_zone0/temp) / 1000 ))
    else
        echo "N/A"
    fi
}

get_ip_address() {
    ip route get 1.1.1.1 | awk '{print $7}' | head -1
}

get_uptime() {
    uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}' | sed 's/ //g'
}

get_current_time() {
    date '+%H:%M:%S'
}

get_current_date() {
    date '+%Y-%m-%d'
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
        # Initialize network speed tracking
        local last_rx=0
        local last_tx=0
        local last_time=$(date +%s)
        
        while :; do
            # Get all system information
            STATUS=$(get_status)
            CPU=$(get_cpu_usage)
            MEM=$(get_memory_usage)
            DISK=$(get_disk_usage)
            VOLUME=$(get_volume)
            TEMP=$(get_temperature)
            IP=$(get_ip_address)
            UPTIME=$(get_uptime)
            TIME=$(get_current_time)
            DATE=$(get_current_date)
            
            # Calculate network speed
            local current_time=$(date +%s)
            local time_diff=$((current_time - last_time))
            if [ $time_diff -gt 0 ]; then
                local current_network=$(get_network_speed)
                local current_rx=$(echo $current_network | awk '{print $1}')
                local current_tx=$(echo $current_network | awk '{print $2}')
                local rx_speed=$(( (current_rx - last_rx) / time_diff / 1024 ))
                local tx_speed=$(( (current_tx - last_tx) / time_diff / 1024 ))
                last_rx=$current_rx
                last_tx=$current_tx
                last_time=$current_time
            fi
            
            # Build the bar content
            local bar_content=""
            
            # Left side - System info
            bar_content+="%{F#dcdfe4}  󰻠 $CPU%%  󰍛 $MEM%%  󰋊 $DISK%%"
            
            # Network speed
            if [ $time_diff -gt 0 ]; then
                bar_content+="  󰇚 ${rx_speed}K↓ ${tx_speed}K↑"
            fi
            
            # Temperature
            if [ "$TEMP" != "N/A" ]; then
                bar_content+="  󰔄 ${TEMP}°C"
            fi
            
            # Center - VPN status
            bar_content+="%{c}"
            if [ "$STATUS" = "ON" ]; then
                bar_content+="%{A1:kitty -e /home/salledelavage/nixos/scripts/vpn.sh:}%{F#6dd797}  󰒃 VPN: ON%{F-}%{A}"
            else
                bar_content+="%{A1:kitty -e /home/salledelavage/nixos/scripts/vpn.sh:}%{F#e55c74}  󰒃 VPN: OFF%{F-}%{A}"
            fi
            
            # Right side - Time, date, and other info
            bar_content+="%{r}"
            bar_content+="%{F#dcdfe4}"
             
            # Volume
            if [ "$VOLUME" != "N/A" ]; then
                bar_content+="  󰕾 $VOLUME%%"
            fi
             
            # IP address
            if [ -n "$IP" ]; then
                bar_content+="  󰖩 $IP"
            fi
            
            # Uptime
            bar_content+="  󰔟 $UPTIME"
            
            # Date and time
            bar_content+="  󰸗 $DATE  󰅐 $TIME"
            
            echo "$bar_content"
            sleep 2
        done | lemonbar-xft -p -g "$GEOM" -B "#18181b" -F "#dcdfe4" -a 20 -n bar -f "JetBrainsMono Nerd Font:size=12"
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