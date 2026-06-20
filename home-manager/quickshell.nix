{ pkgs, ... }:

{
  home.packages = with pkgs; [
    quickshell
    (writeShellScriptBin "gallery-status-snapshot" ''
      cpu="$(top -bn1 | awk '/Cpu\(s\)/ {print $2}' | cut -d% -f1)"
      mem="$(free | awk '/Mem/ {printf "%.0f", $3 / $2 * 100}')"
      disk="$(df / | awk 'END {gsub("%", "", $5); print $5}')"
      volume="$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | awk 'NR == 1 {print $5}' || true)"
      volume="''${volume:-N/A}"
      uptime_value="$(uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}' | sed 's/^ *//;s/ *$//')"
      ssh_count="$(ss -tn state established 2>/dev/null | grep -c ':22 ' || true)"

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

      jq -n \
        --arg vpn "$vpn" \
        --arg ip "$ip_addr" \
        --arg cpu "''${cpu:-0}" \
        --arg mem "''${mem:-0}" \
        --arg disk "''${disk:-0}" \
        --arg temp "$temp" \
        --arg volume "$volume" \
        --arg uptime "$uptime_value" \
        --arg ssh "$ssh_count" \
        --arg media "$media" \
        '{vpn: $vpn, ip: $ip, cpu: $cpu, mem: $mem, disk: $disk, temp: $temp, volume: $volume, uptime: $uptime, ssh: $ssh, media: $media}'
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

      ${pkgs.quickshell}/bin/qs ipc -c gallery-status call status toggle >/dev/null 2>&1 || true
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
    "quickshell/gallery-transition/gallery.png".source = ../assets/hyprland/art-gallery-neo.png;
    "quickshell/gallery-transition/painting-1.png".source = ../assets/hyprland/painting-1.png;
    "quickshell/gallery-transition/painting-2.png".source = ../assets/hyprland/painting-2.png;
    "quickshell/gallery-transition/painting-3.png".source = ../assets/hyprland/painting-3.png;
    "quickshell/gallery-transition/painting-4.png".source = ../assets/hyprland/painting-4.png;
    "quickshell/gallery-transition/painting-5.png".source = ../assets/hyprland/painting-5.png;
    "quickshell/gallery-transition/painting-6.png".source = ../assets/hyprland/painting-6.png;
  };
}
