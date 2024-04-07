{ pkgs, ... }:
{
  imports = [
    ./languages/lang.nix
    ./monitoring/monitoring.nix
    ./tools/tools.nix
    ./fun/fun.nix
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
