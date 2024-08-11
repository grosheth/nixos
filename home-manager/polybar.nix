{ pkgs, ... }:
{
  home.packages = with pkgs; [
    polybar
  ];

  services.polybar = {
    enable = true;
    script = "polybar example &";
    config = {
      "bar/top" = {
        monitor = "\${env:MONITOR:HDMI-0}";
        width = "50%";
        height = "2%";
        radius = 10;
        modules-center = "date";
        modules-left = "volume";
      };
      "module/date" = {
        type = "internal/date";
        internal = 5;
        date = "%d.%m.%y";
        time = "%H:%M";
        label = "%time%  %date%";
      };
      "module/volume" = {
        type = "internal/pulseaudio";
        format.volume = " ";
        label.muted.text = "🔇";
        label.muted.foreground = "#666";
        ramp.volume = ["🔈" "🔉" "🔊"];
        click.right = "pavucontrol &";
      };
    };
  };
}
