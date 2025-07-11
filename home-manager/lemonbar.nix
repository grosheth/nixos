{ pkgs, ... }:
let
  vpnbarBin = pkgs.writeShellScriptBin "vpnbar.sh" ''
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
    done | lemonbar -p -g "$GEOM" -B "#222222" -F "#ffffff" -f "monospace-10"
  '';
  vpntoggleBin = pkgs.writeShellScriptBin "vpn-toggle.sh" ''
    #!/usr/bin/env bash
    VPN_NAME="wg-enp5s0"

    if sudo wg show "$VPN_NAME" > /dev/null 2>&1; then
        wg-quick down "$VPN_NAME"
        echo "VPN down"
    else
        wg-quick up "$VPN_NAME"
        echo "VPN up"
    fi
  '';
in
{
  home.packages = [
    vpnbarBin
    vpntoggleBin
    pkgs.lemonbar
  ];

  systemd.user.services.vpnbar = {
    Unit = {
      Description = "VPN Lemonbar Status Bar";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${vpnbarBin}/bin/vpnbar.sh";
      Restart = "on-failure";
      Environment = "DISPLAY=:0";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
