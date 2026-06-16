{ pkgs, ... }:

{
  home.packages = with pkgs; [
    quickshell
    (writeShellScriptBin "gallery-transition" ''
      if ! ${pkgs.procps}/bin/pgrep -f "quickshell.*gallery-transition" >/dev/null; then
        ${pkgs.quickshell}/bin/quickshell -c gallery-transition >/dev/null 2>&1 &
      fi
    '')
    (writeShellScriptBin "gallery-enter" ''
      workspace="''${1:-1}"
      if [ "$workspace" = "0" ]; then
        workspace=10
      fi

      if ! ${pkgs.procps}/bin/pgrep -f "quickshell.*gallery-transition" >/dev/null; then
        ${pkgs.quickshell}/bin/quickshell -c gallery-transition >/dev/null 2>&1 &
        sleep 0.2
      fi

      ${pkgs.quickshell}/bin/qs ipc -c gallery-transition call gallery enter "$workspace"
    '')
  ];

  xdg.configFile = {
    "quickshell/gallery-transition/shell.qml".source = ../configs/quickshell/gallery-transition/shell.qml;
    "quickshell/gallery-transition/gallery.png".source = ../assets/hyprland/art-gallery-neo-taller.png;
    "quickshell/gallery-transition/painting-1.png".source = ../assets/hyprland/painting-1.png;
    "quickshell/gallery-transition/painting-2.png".source = ../assets/hyprland/painting-2.png;
    "quickshell/gallery-transition/painting-3.png".source = ../assets/hyprland/painting-3.png;
    "quickshell/gallery-transition/painting-4.png".source = ../assets/hyprland/painting-4.png;
    "quickshell/gallery-transition/painting-5.png".source = ../assets/hyprland/painting-5.png;
    "quickshell/gallery-transition/painting-6.png".source = ../assets/hyprland/painting-6.png;
  };
}
