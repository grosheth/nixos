{ pkgs, ... }:
{
  imports = [
    ./packages/languages/lang.nix
    ./packages/monitoring/monitoring.nix
    ./packages/tools/tools.nix
    ./packages/fun/fun.nix
  ];
	xdg.desktopEntries = {
    "lf" = {
      name = "lf";
      noDisplay = true;
    };
  };

  home.packages = with pkgs; with nodePackages_latest; with gnome; [
    (import ./colorscript.nix { inherit pkgs; })
    (mpv.override { scripts = [mpvScripts.mpris]; })
  ];
}
