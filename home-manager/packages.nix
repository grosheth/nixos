{ ... }:
{
  imports = [
    ./packages/languages/lang.nix
    ./packages/tools/tools.nix
    ./packages/fun/fun.nix
  ];

  # home.packages = with pkgs; with nodePackages_latest; with gnome; [
  #   (import ./colorscript.nix { inherit pkgs; })
  #   (mpv.override { scripts = [mpvScripts.mpris]; })
  # ];
}
