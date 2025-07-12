#!/usr/bin/env bash
VPN_NAME="wg-enp5s0"
PID_FILE="/tmp/vpnbar.pid"

# Monitor selection (0 = primary, 1 = secondary, etc.)
# pass $2 to select another monitor
if [ -z $2 ]; then
    MONITOR_INDEX=0
else
    MONITOR_INDEX=$2
fi

# Particle system configuration
PARTICLE_COUNT=5
CPU_PARTICLES=("●" "●" "●" "●" "●")
MEM_PARTICLES=("●" "●" "●" "●" "●")
DISK_PARTICLES=("●" "●" "●" "●" "●")
CPU_COLOR="#0db9d7"
MEM_COLOR="#6dd797"
DISK_COLOR="#eed891"
USAGE_THRESHOLDS=(10 25 50 75 100)

get_monitor_geometry() {
    local index=$1
    local monitor_info

    if [ $index -eq 0 ]; then
        # Primary monitor
        monitor_info=$(xrandr | awk '/ connected primary/ {print $0}')
    else
        # Secondary monitor (index + 1 to skip primary)
        monitor_info=$(xrandr | awk '/ connected/ && !/primary/ {count++; if(count=='$index') print $0}')
    fi

    if [ -z "$monitor_info" ]; then
        echo "Monitor $index not found, using primary monitor"
        monitor_info=$(xrandr | awk '/ connected primary/ {print $0}')
    fi

    local resolution=$(echo $monitor_info | grep -oP '\d+x\d+\+\d+\+\d+')
    echo $resolution
}

RESOLUTION=$(get_monitor_geometry $MONITOR_INDEX)
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

get_ssh_connections() {
    # Count active SSH connections
    local ssh_count=$(ss -tn state established | grep -c ":22 ")
    if [ $ssh_count -gt 0 ]; then
        echo "$ssh_count"
    else
        echo "0"
    fi
}

# Particle system functions
generate_cpu_particles() {
    local cpu_usage=$1
    local timestamp=$2
    
    # Convert decimal usage to integer
    local cpu_usage_int=$(printf "%.0f" "$cpu_usage")
    
    local particles="%{F$CPU_COLOR}"
    for ((i=0; i<PARTICLE_COUNT; i++)); do
        local threshold=${USAGE_THRESHOLDS[$i]}
        if [ $cpu_usage_int -ge $threshold ]; then
            # Active particle (stable position)
            particles+=" ${CPU_PARTICLES[$i]}"
        else
            # Inactive particle (dimmed, stable position)
            particles+=" %{F#666666}${CPU_PARTICLES[$i]}%{F$CPU_COLOR}"
        fi
    done
    particles+="%{F-}"
    
    echo "$particles"
}

generate_mem_particles() {
    local mem_usage=$1
    local timestamp=$2
    
    # Convert decimal usage to integer
    local mem_usage_int=$(printf "%.0f" "$mem_usage")
    
    local particles="%{F$MEM_COLOR}"
    for ((i=0; i<PARTICLE_COUNT; i++)); do
        local threshold=${USAGE_THRESHOLDS[$i]}
        if [ $mem_usage_int -ge $threshold ]; then
            # Active particle (stable position)
            particles+=" ${MEM_PARTICLES[$i]}"
        else
            # Inactive particle (dimmed, stable position)
            particles+=" %{F#666666}${MEM_PARTICLES[$i]}%{F$MEM_COLOR}"
        fi
    done
    particles+="%{F-}"
    
    echo "$particles"
}

generate_disk_particles() {
    local disk_usage=$1
    local timestamp=$2
    
    # Convert decimal usage to integer
    local disk_usage_int=$(printf "%.0f" "$disk_usage")
    
    local particles="%{F$DISK_COLOR}"
    for ((i=0; i<PARTICLE_COUNT; i++)); do
        local threshold=${USAGE_THRESHOLDS[$i]}
        if [ $disk_usage_int -ge $threshold ]; then
            # Active particle (stable position)
            particles+=" ${DISK_PARTICLES[$i]}"
        else
            # Inactive particle (dimmed, stable position)
            particles+=" %{F#666666}${DISK_PARTICLES[$i]}%{F$DISK_COLOR}"
        fi
    done
    particles+="%{F-}"
    
    echo "$particles"
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
        local animation_frame=0
        
        while :; do
            STATUS=$(get_status)
            CPU=$(get_cpu_usage)
            MEM=$(get_memory_usage)
            DISK=$(get_disk_usage)
            VOLUME=$(get_volume)
            TEMP=$(get_temperature)
            IP=$(get_ip_address)
            SSH_CONN=$(get_ssh_connections)
            UPTIME=$(get_uptime)
            TIME=$(get_current_time)
            DATE=$(get_current_date)
            
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
            
            # Generate particles based on CPU, memory, and disk usage
            local cpu_particles=$(generate_cpu_particles $CPU $animation_frame)
            local mem_particles=$(generate_mem_particles $MEM $animation_frame)
            local disk_particles=$(generate_disk_particles $DISK $animation_frame)
            
            # Build the bar content
            local bar_content=""
            
            # Left side - System info with particles (fixed width percentages)
            local cpu_formatted=$(printf "%5s" "$CPU%")
            local mem_formatted=$(printf "%5s" "$MEM%")
            local disk_formatted=$(printf "%1s" "$DISK%")
            bar_content+="%{F#0db9d7}  %{F-} ${cpu_formatted} $cpu_particles  %{F#6dd797}%{F-} ${mem_formatted} $mem_particles  %{F#eed891}%{F-} ${disk_formatted} $disk_particles"
             
            if [ "$TEMP" != "N/A" ]; then
                bar_content+="  %{F#e55c74}%{F-} ${TEMP}°C"
            fi
            
            
            # Center - VPN status, network speed, and IP address
            bar_content+="%{c}"
            if [ "$STATUS" = "ON" ]; then
                bar_content+="%{F#6dd797}   ON%{F-}"
            else
                bar_content+="%{F#e55c74}   OFF%{F-}"
            fi
             
            # IP address in center
            bar_content+="  %{F#0db9d7}%{F-} $IP"
            if [ "$SSH_CONN" != "0" ]; then
                bar_content+="  %{F#ff6b6b}%{F-} ${SSH_CONN}"
            fi
            if [ $time_diff -gt 0 ]; then
                # Format with fixed width to prevent layout shifts
                local rx_formatted=$(printf "%6s" "${rx_speed}K↓")
                local tx_formatted=$(printf "%6s" "${tx_speed}K↑")
                bar_content+="  %{F#EE87A9}%{F-} ${rx_formatted} ${tx_formatted}"
            else
                # Show placeholder when no network data
                bar_content+="  %{F#EE87A9}%{F-}     0K↓      0K↑"
            fi
            
            # Right side - Time, date, and other info
            bar_content+="%{r}%{F#6dd797}%{F-} $UPTIME  %{F#EE87A9}%{F-} $DATE %{F#eed891}%{F-} $TIME  "
            
            echo "$bar_content"
            
            # Increment animation frame for particle movement
            animation_frame=$((animation_frame + 1))
            sleep 1
        done | lemonbar -p -g "$GEOM" -B "#18181b" -F "#dcdfe4" -a 20 -n bar -f "JetBrainsMonoNL Nerd Font:size=10"
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
        toggle_bar
        ;;
esac 
