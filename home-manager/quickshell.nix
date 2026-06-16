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

      if ! ${pkgs.procps}/bin/pgrep -f "quickshell.*gallery-transition" >/dev/null; then
        ${pkgs.quickshell}/bin/quickshell -c gallery-transition >/dev/null 2>&1 &
        sleep 0.2
      fi

      ${pkgs.quickshell}/bin/qs ipc -c gallery-transition call gallery enter "$workspace"
    '')
  ];

  xdg.configFile = {
    "quickshell/gallery-transition/shell.qml".source = ../configs/quickshell/gallery-transition/shell.qml;
    "quickshell/gallery-transition/schoolofathens.jpg".source = ../assets/images/hyprland/art-gallery-neo.png;
  };
}
