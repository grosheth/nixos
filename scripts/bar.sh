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
TEMP_PARTICLES=("●" "●" "●" "●" "●")
CPU_COLOR="#EE87A9"
MEM_COLOR="#6dd797"
DISK_COLOR="#eed891"
USAGE_THRESHOLDS=(10 25 50 75 100)

# Critical thresholds for color changes
CPU_CRITICAL=90
MEM_CRITICAL=85
DISK_CRITICAL=90
TEMP_CRITICAL=80
UPTIME_CRITICAL=$((7 * 24 * 60 * 60)) # 7 days in seconds

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
    if ip link show "$VPN_NAME" >/dev/null 2>&1 && ip addr show "$VPN_NAME" | grep -q "inet"; then
        echo "proton"
    else
        if ip link show "tun0" >/dev/null 2>&1 && ip addr show "tun0" | grep -q "inet"; then
            echo "tryhackme"
        else
            echo "OFF"
        fi
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
    # Use lm-sensors for accurate CPU temperature
    local temp="N/A"

    # Method 1: Try lm-sensors (most accurate for CPU)
    if command -v sensors >/dev/null 2>&1; then
        # Try to get CPU temperature from sensors output
        local cpu_temp=$(sensors | grep -i "core\|cpu\|package\|temp1" | head -1 | grep -oP '\d+\.?\d*' | head -1)
        if [ -n "$cpu_temp" ] && [ "$cpu_temp" != "0" ] && [ "$cpu_temp" != "N/A" ] && [ "$cpu_temp" -gt 10 ]; then
            # Convert to integer
            temp=$(printf "%.0f" "$cpu_temp")
        fi
    fi

    # Method 2: Fallback to hwmon if lm-sensors fails
    if [ "$temp" = "N/A" ]; then
        for hwmon_dir in /sys/class/hwmon/hwmon*; do
            if [ -d "$hwmon_dir" ]; then
                # Check if this is a CPU sensor by looking at the name
                local hwmon_name=""
                if [ -f "$hwmon_dir/name" ]; then
                    hwmon_name=$(cat "$hwmon_dir/name")
                fi

                # Look for CPU-related sensors
                if [[ "$hwmon_name" =~ (coretemp|k10temp|zenpower|cpu|amd) ]]; then
                    for temp_file in "$hwmon_dir"/temp*_input; do
                        if [ -f "$temp_file" ]; then
                            local hwmon_temp=$(($(cat "$temp_file") / 1000))
                            # Only use reasonable temperatures (between 30-100°C for CPU)
                            if [ $hwmon_temp -ge 30 ] && [ $hwmon_temp -le 100 ]; then
                                temp=$hwmon_temp
                                break 2
                            fi
                        fi
                    done
                fi
            fi
        done
    fi

    # Method 3: Try any thermal zone as last resort
    if [ "$temp" = "N/A" ]; then
        for zone in /sys/class/thermal/thermal_zone*/temp; do
            if [ -f "$zone" ]; then
                local zone_temp=$(($(cat "$zone") / 1000))
                # Only use reasonable temperatures (between 30-100°C)
                if [ $zone_temp -ge 30 ] && [ $zone_temp -le 100 ]; then
                    temp=$zone_temp
                    break
                fi
            fi
        done
    fi

    # Method 4: Try any hwmon sensor as absolute last resort (but be more strict)
    if [ "$temp" = "N/A" ]; then
        for hwmon_dir in /sys/class/hwmon/hwmon*; do
            if [ -d "$hwmon_dir" ]; then
                local hwmon_name=""
                if [ -f "$hwmon_dir/name" ]; then
                    hwmon_name=$(cat "$hwmon_dir/name")
                fi

                # Skip known ambient/motherboard sensors
                if [[ "$hwmon_name" =~ (acpitz|thermal|ambient|motherboard) ]]; then
                    continue
                fi

                for temp_file in "$hwmon_dir"/temp*_input; do
                    if [ -f "$temp_file" ]; then
                        local hwmon_temp=$(($(cat "$temp_file") / 1000))
                        # Accept any reasonable temperature above 25°C
                        if [ $hwmon_temp -ge 25 ] && [ $hwmon_temp -le 100 ]; then
                            temp=$hwmon_temp
                            break 2
                        fi
                    fi
                done
            fi
        done
    fi

    echo "$temp"
}

get_ip_address() {
    if ip link show "tun0" >/dev/null 2>&1 && ip addr show "tun0" | grep -q "inet"; then
        ip link show "tun0" >/dev/null 2>&1 && ip addr show "tun0" | grep -w "inet" | awk '{print $2}' | cut -d'/' -f1 | head -1
    else
        ip route get 1.1.1.1 | awk '{print $7}' | head -1
    fi
}

get_uptime() {
    uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}' | sed 's/ //g'
}

get_uptime_seconds() {
    awk '{print int($1)}' /proc/uptime
}

get_uptime_color() {
    local uptime_seconds=$1
    if [ "$uptime_seconds" -ge "$UPTIME_CRITICAL" ]; then
        echo "#e55c74"
    else
        echo "#6dd797"
    fi
}

get_current_time() {
    date '+%H:%M'
}

get_current_date() {
    date '+%m-%d'
}

# Color functions for critical values
get_cpu_color() {
    local cpu_usage=$1
    local cpu_usage_int=$(printf "%.0f" "$cpu_usage")
    if [ $cpu_usage_int -ge $CPU_CRITICAL ]; then
        echo "#e55c74" # Red for critical
    else
        echo "$CPU_COLOR"
    fi
}

get_mem_color() {
    local mem_usage=$1
    local mem_usage_int=$(printf "%.0f" "$mem_usage")
    if [ $mem_usage_int -ge $MEM_CRITICAL ]; then
        echo "#e55c74" # Red for critical
    else
        echo "$MEM_COLOR"
    fi
}

get_disk_color() {
    local disk_usage=$1
    local disk_usage_int=$(printf "%.0f" "$disk_usage")
    if [ $disk_usage_int -ge $DISK_CRITICAL ]; then
        echo "#e55c74" # Red for critical
    else
        echo "$DISK_COLOR"
    fi
}

get_temp_color() {
    local temp=$1
    if [ "$temp" = "N/A" ]; then
        echo "#0db9d7" # Default/fallback color
    elif [ $temp -ge 80 ]; then
        echo "#e55c74" # Red for critical (80+)
    elif [ $temp -ge 60 ]; then
        echo "#eed891" # Yellow for 60-79
    else
        echo "#0db9d7" # Blue for 0-49
    fi
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
    local cpu_color=$(get_cpu_color $cpu_usage)

    local particles="%{F$cpu_color}"
    for ((i = 0; i < PARTICLE_COUNT; i++)); do
        local threshold=${USAGE_THRESHOLDS[$i]}
        if [ $cpu_usage_int -ge $threshold ]; then
            # Active particle (stable position)
            particles+=" ${CPU_PARTICLES[$i]}"
        else
            # Inactive particle (dimmed, stable position)
            particles+=" %{F#666666}${CPU_PARTICLES[$i]}%{F$cpu_color}"
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
    local mem_color=$(get_mem_color $mem_usage)

    local particles="%{F$mem_color}"
    for ((i = 0; i < PARTICLE_COUNT; i++)); do
        local threshold=${USAGE_THRESHOLDS[$i]}
        if [ $mem_usage_int -ge $threshold ]; then
            # Active particle (stable position)
            particles+=" ${MEM_PARTICLES[$i]}"
        else
            # Inactive particle (dimmed, stable position)
            particles+=" %{F#666666}${MEM_PARTICLES[$i]}%{F$mem_color}"
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
    local disk_color=$(get_disk_color $disk_usage)

    local particles="%{F$disk_color}"
    for ((i = 0; i < PARTICLE_COUNT; i++)); do
        local threshold=${USAGE_THRESHOLDS[$i]}
        if [ $disk_usage_int -ge $threshold ]; then
            # Active particle (stable position)
            particles+=" ${DISK_PARTICLES[$i]}"
        else
            # Inactive particle (dimmed, stable position)
            particles+=" %{F#666666}${DISK_PARTICLES[$i]}%{F$disk_color}"
        fi
    done
    particles+="%{F-}"

    echo "$particles"
}

generate_temp_particles() {
    local temp=$1
    local timestamp=$2
    local temp_color=$(get_temp_color $temp)
    local particles="%{F$temp_color}"
    local temp_int=0
    if [ "$temp" != "N/A" ]; then
        temp_int=$(printf "%d" "$temp")
    fi
    for ((i = 0; i < PARTICLE_COUNT; i++)); do
        local threshold=${USAGE_THRESHOLDS[$i]}
        if [ "$temp" = "N/A" ]; then
            particles+=" %{F#666666}${TEMP_PARTICLES[$i]}%{F$temp_color}"
        elif [ $temp_int -ge $threshold ]; then
            particles+=" ${TEMP_PARTICLES[$i]}"
        else
            particles+=" %{F#666666}${TEMP_PARTICLES[$i]}%{F$temp_color}"
        fi
    done
    particles+="%{F-}"
    echo "$particles"
}

get_media_info() {
    if command -v playerctl >/dev/null 2>&1; then
        # Try Spotify first
        local song=""
        song=$(playerctl -p spotify metadata --format '{{artist}} - {{title}}' 2>/dev/null)
        if [ -n "$song" ]; then
            echo "spotify|$song"
            return
        fi
        # Try YouTube (look for player names containing 'youtube')
        for player in $(playerctl -l 2>/dev/null); do
            if [[ "$player" =~ [Yy]ou[Tt]ube ]]; then
                song=$(playerctl -p "$player" metadata --format '{{artist}} - {{title}}' 2>/dev/null)
                if [ -n "$song" ]; then
                    echo "youtube|$song"
                    return
                fi
            fi
        done
        # Fallback: try any available player
        for player in $(playerctl -l 2>/dev/null); do
            song=$(playerctl -p "$player" metadata --format '{{artist}} - {{title}}' 2>/dev/null)
            if [ -n "$song" ]; then
                echo "$player|$song"
                return
            fi
        done
        echo "|"
    else
        echo "|"
    fi
}

truncate_string() {
    local str="$1"
    local maxlen="$2"
    local ellipsis="…"
    local len=${#str}
    if [ "$len" -gt "$maxlen" ]; then
        echo "${str:0:maxlen-1}$ellipsis"
    else
        echo "$str"
    fi
}

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
            MEDIA_INFO=$(get_media_info)
            MEDIA_PLAYER=$(echo "$MEDIA_INFO" | cut -d'|' -f1)
            MEDIA_SONG=$(echo "$MEDIA_INFO" | cut -d'|' -f2-)
            MEDIA_SONG=$(truncate_string "$MEDIA_SONG" 40)

            local current_time=$(date +%s)
            local time_diff=$((current_time - last_time))
            if [ $time_diff -gt 0 ]; then
                local current_network=$(get_network_speed)
                local current_rx=$(echo $current_network | awk '{print $1}')
                local current_tx=$(echo $current_network | awk '{print $2}')
                local rx_speed=$(((current_rx - last_rx) / time_diff / 1024))
                local tx_speed=$(((current_tx - last_tx) / time_diff / 1024))
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
            local cpu_color=$(get_cpu_color $CPU)
            local mem_color=$(get_mem_color $MEM)
            local disk_color=$(get_disk_color $DISK)

            bar_content+="  %{F#0db9d7}%{F-} $IP"
            if [ "$STATUS" = "proton" ]; then
                bar_content+="%{F#6dd797}   %{F-}ON (Proton)"
            elif [ "$STATUS" = "tryhackme" ]; then
                bar_content+="%{F#6dd797}   %{F-}ON (TryHackMe)"
            else
                bar_content+="%{F#e55c74}   %{F-}OFF"
            fi

            if [ "$SSH_CONN" != "0" ]; then
                bar_content+="  %{F#ff6b6b}%{F-} ${SSH_CONN}"
            fi
            if [ $time_diff -gt 0 ]; then
                local rx_formatted=$(printf "%6s" "${rx_speed}K↓")
                local tx_formatted=$(printf "%6s" "${tx_speed}K↑")
                bar_content+="  %{F#eed891}%{F-} ${rx_formatted} ${tx_formatted}"
            fi

            # Center
            bar_content+="%{c}"

            local temp_color=$(get_temp_color $TEMP)
            if [ -n "$MEDIA_SONG" ]; then
                if [ "$MEDIA_PLAYER" = "spotify" ]; then
                    bar_content+="  %{F#1DB954}%{F-} $MEDIA_SONG "
                else
                    bar_content+="  %{F#FF0000}%{F-} $MEDIA_SONG "
                fi
            fi
            UPTIME_SECONDS=$(get_uptime_seconds)
            UPTIME_COLOR=$(get_uptime_color $UPTIME_SECONDS)
            bar_content+="%{F$UPTIME_COLOR}%{F-} $UPTIME  "
            bar_content+="%{F#e55c74}%{F-} $DATE  "
            bar_content+="%{F#eed891}%{F-} $TIME  "

            # Right side
            bar_content+="%{r}"

            local temp_color=$(get_temp_color $TEMP)
            local temp_particles=$(generate_temp_particles $TEMP $animation_frame)
            bar_content+="%{F$temp_color}%{F-} ${TEMP}°C$temp_particles "
            bar_content+="%{F$mem_color}%{F-} ${mem_formatted} $mem_particles "
            bar_content+="%{F$cpu_color} %{F-} ${cpu_formatted} $cpu_particles "
            bar_content+="%{F$disk_color}%{F-} ${disk_formatted} $disk_particles"
            echo "$bar_content"

            # Increment animation frame for particle movement
            animation_frame=$((animation_frame + 1))
            sleep 1
        done | lemonbar -p -g "$GEOM" -B "#18181b" -F "#ffffff" -a 20 -n bar -f "JetBrainsMonoNL Nerd Font:size=10"
    ) &

    echo $! >"$PID_FILE"
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
temp)
    echo "Testing temperature detection..."
    echo "lm-sensors output:"
    sensors 2>/dev/null || echo "sensors command not found"
    echo ""
    echo "hwmon sensors:"
    for dir in /sys/class/hwmon/hwmon*; do
        if [ -d "$dir" ]; then
            echo "=== $(basename $dir) ==="
            cat "$dir/name" 2>/dev/null || echo "No name file"
            ls "$dir"/temp*_input 2>/dev/null || echo "No temp files"
        fi
    done
    echo ""
    echo "thermal zones:"
    ls /sys/class/thermal/thermal_zone*/temp 2>/dev/null || echo "No thermal zones"
    echo ""
    echo "Current temperature: $(get_temperature)"
    ;;
toggle)
    toggle_bar
    ;;
*)
    toggle_bar
    ;;
esac
