{ pkgs, ... }:

{
  home.packages = with pkgs; [
    quickshell
    (writeShellScriptBin "gallery-status-snapshot" ''
      cpu="$(top -bn1 | awk '/Cpu\(s\)/ {print $2}' | cut -d% -f1)"
      mem="$(free | awk '/Mem/ {printf "%.0f", $3 / $2 * 100}')"
      mem_used="$(free -h | awk '/Mem/ {print $3 " / " $2}')"
      disk="$(df / | awk 'END {gsub("%", "", $5); print $5}')"
      disk_used="$(df -h / | awk 'END {print $3 " / " $2}')"
      load="$(awk '{print $1 " " $2 " " $3}' /proc/loadavg)"
      kernel="$(uname -r)"
      host="$(hostname)"
      packages="$(command -v nix-store >/dev/null 2>&1 && nix-store -q --requisites /run/current-system 2>/dev/null | wc -l || echo N/A)"
      battery="$(command -v upower >/dev/null 2>&1 && upower -e 2>/dev/null | grep -m1 battery | xargs -r upower -i 2>/dev/null | awk -F': *' '/percentage/ {print $2; exit}')"
      battery="''${battery:-AC}"
      volume="$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | awk 'NR == 1 {print $5}' || true)"
      volume="''${volume:-N/A}"
      uptime_value="$(uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}' | sed 's/^ *//;s/ *$//')"
      ssh_count="$(awk '
        FNR == 1 { next }
        {
          split($2, local, ":")
          split($3, remote, ":")
          if ($4 == "01" && (toupper(local[2]) == "0016" || toupper(remote[2]) == "0016")) {
            count++
          }
        }
        END { print count + 0 }
      ' /proc/net/tcp /proc/net/tcp6 2>/dev/null || echo 0)"

      if ip link show wg-enp5s0 >/dev/null 2>&1 && ip addr show wg-enp5s0 | grep -q inet; then
        vpn="Proton"
      elif ip link show tun0 >/dev/null 2>&1 && ip addr show tun0 | grep -q inet; then
        vpn="TryHackMe"
      else
        vpn="OFF"
      fi

      if ip link show tun0 >/dev/null 2>&1 && ip addr show tun0 | grep -q inet; then
        ip_addr="$(ip addr show tun0 | awk '/ inet / {print $2}' | cut -d/ -f1 | head -1)"
      else
        ip_addr="$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}')"
      fi
      ip_addr="''${ip_addr:-unknown}"

      temp="N/A"
      if command -v sensors >/dev/null 2>&1; then
        temp="$(sensors 2>/dev/null | awk '/Package id 0|Tctl|CPU|temp1/ {for (i = 1; i <= NF; i++) if ($i ~ /^\+[0-9.]+°C$/) {gsub(/[+°C]/, "", $i); printf "%.0f", $i; exit}}')"
      fi
      if [ -z "$temp" ]; then
        for zone in /sys/class/thermal/thermal_zone*/temp; do
          [ -r "$zone" ] || continue
          raw="$(cat "$zone")"
          candidate="$((raw / 1000))"
          if [ "$candidate" -ge 25 ] && [ "$candidate" -le 100 ]; then
            temp="$candidate"
            break
          fi
        done
      fi
      temp="''${temp:-N/A}"

      media=""
      if command -v playerctl >/dev/null 2>&1; then
        media="$(playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null | head -1 || true)"
      fi

      monitors="$(hyprctl monitors -j 2>/dev/null | jq -r 'map(.name + " " + (.width|tostring) + "x" + (.height|tostring) + "@" + ((.refreshRate|floor)|tostring) + "Hz") | join("  /  ")' 2>/dev/null || true)"
      monitors="''${monitors:-unknown}"

      jq -n \
        --arg vpn "$vpn" \
        --arg ip "$ip_addr" \
        --arg cpu "''${cpu:-0}" \
        --arg mem "''${mem:-0}" \
        --arg memUsed "$mem_used" \
        --arg disk "''${disk:-0}" \
        --arg diskUsed "$disk_used" \
        --arg temp "$temp" \
        --arg volume "$volume" \
        --arg uptime "$uptime_value" \
        --arg ssh "$ssh_count" \
        --arg load "$load" \
        --arg kernel "$kernel" \
        --arg host "$host" \
        --arg packages "$packages" \
        --arg battery "$battery" \
        --arg monitors "$monitors" \
        --arg media "$media" \
        '{vpn: $vpn, ip: $ip, cpu: $cpu, mem: $mem, memUsed: $memUsed, disk: $disk, diskUsed: $diskUsed, temp: $temp, volume: $volume, uptime: $uptime, ssh: $ssh, load: $load, kernel: $kernel, host: $host, packages: $packages, battery: $battery, monitors: $monitors, media: $media}'
    '')
    (writeShellScriptBin "gallery-status" ''
      if [ -f /tmp/hyprbar.pid ] && command -v hyprbar >/dev/null 2>&1; then
        hyprbar stop >/dev/null 2>&1 || true
      fi

      if ! ${pkgs.procps}/bin/pgrep -f "quickshell.*gallery-status" >/dev/null; then
        ${pkgs.quickshell}/bin/quickshell -c gallery-status >/dev/null 2>&1 &
      fi
    '')
    (writeShellScriptBin "gallery-status-toggle" ''
      if ! ${pkgs.procps}/bin/pgrep -f "quickshell.*gallery-status" >/dev/null; then
        ${pkgs.quickshell}/bin/quickshell -c gallery-status >/dev/null 2>&1 &
        sleep 0.2
      fi

      state_dir="''${XDG_RUNTIME_DIR:-/tmp}"
      current_workspace_file="$state_dir/gallery-current-workspace"

      workspace="$(cat "$current_workspace_file" 2>/dev/null || true)"
      if [ -z "$workspace" ]; then
        workspace="$(hyprctl monitors -j 2>/dev/null | jq -r '.[] | select(.name == "DP-3") | .activeWorkspace.id // empty' 2>/dev/null || true)"
      fi
      if [ -z "$workspace" ]; then
        workspace="$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id // empty' 2>/dev/null || true)"
      fi
      workspace="''${workspace:-10}"
      if [ "$workspace" = "0" ]; then
        workspace=10
      fi

      ${pkgs.quickshell}/bin/qs ipc -c gallery-status call status toggleWorkspace "$workspace" >/dev/null 2>&1 || true
    '')
    (writeShellScriptBin "gallery-status-compact-toggle" ''
      if ! ${pkgs.procps}/bin/pgrep -f "quickshell.*gallery-status" >/dev/null; then
        ${pkgs.quickshell}/bin/quickshell -c gallery-status >/dev/null 2>&1 &
        sleep 0.2
      fi

      ${pkgs.quickshell}/bin/qs ipc -c gallery-status call status toggleCompact >/dev/null 2>&1 || true
    '')
    (writeShellScriptBin "gallery-transition" ''
      if ! ${pkgs.procps}/bin/pgrep -f "quickshell.*gallery-transition" >/dev/null; then
        ${pkgs.quickshell}/bin/quickshell -c gallery-transition >/dev/null 2>&1 &
      fi
    '')
    (writeShellScriptBin "gallery-signature" ''
      if ! ${pkgs.procps}/bin/pgrep -f "quickshell.*gallery-signature" >/dev/null; then
        ${pkgs.quickshell}/bin/quickshell -c gallery-signature >/dev/null 2>&1 &
      fi
    '')
    (writeShellScriptBin "gallery-enter" ''
      workspace="''${1:-1}"
      if [ "$workspace" = "0" ]; then
        workspace=10
      fi

      state_dir="''${XDG_RUNTIME_DIR:-/tmp}"
      printf '%s\n' "$workspace" > "$state_dir/gallery-current-workspace"

      if ! ${pkgs.procps}/bin/pgrep -f "quickshell.*gallery-status" >/dev/null; then
        ${pkgs.quickshell}/bin/quickshell -c gallery-status >/dev/null 2>&1 &
        sleep 0.2
      fi

      if ! ${pkgs.procps}/bin/pgrep -f "quickshell.*gallery-transition" >/dev/null; then
        ${pkgs.quickshell}/bin/quickshell -c gallery-transition >/dev/null 2>&1 &
        sleep 0.2
      fi

      ${pkgs.quickshell}/bin/qs ipc -c gallery-status call status set "$workspace" >/dev/null 2>&1 || true
      ${pkgs.quickshell}/bin/qs ipc -c gallery-transition call gallery enter "$workspace"
    '')
  ];

  xdg.configFile = {
    "quickshell/gallery-transition/shell.qml".source = ../configs/quickshell/gallery-transition/shell.qml;
    "quickshell/gallery-signature/shell.qml".source = ../configs/quickshell/gallery-signature/shell.qml;
    "quickshell/gallery-status/shell.qml".source = ../configs/quickshell/gallery-status/shell.qml;
    "quickshell/gallery-status/gallery.png".source = ../assets/hyprland/art-gallery-neo.png;
    "quickshell/gallery-transition/gallery.png".source = ../assets/hyprland/art-gallery-neo.png;
    "quickshell/gallery-transition/painting-1.png".source = ../assets/hyprland/painting-1.png;
    "quickshell/gallery-transition/painting-2.png".source = ../assets/hyprland/painting-2.png;
    "quickshell/gallery-transition/painting-3.png".source = ../assets/hyprland/painting-3.png;
    "quickshell/gallery-transition/painting-4.png".source = ../assets/hyprland/painting-4.png;
    "quickshell/gallery-transition/painting-5.png".source = ../assets/hyprland/painting-5.png;
    "quickshell/gallery-transition/painting-6.png".source = ../assets/hyprland/painting-6.png;
  };
}
