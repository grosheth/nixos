{ pkgs, ... }:
{
  home.packages = with pkgs; with nodePackages_latest; with gnome; [
    ansible
    nodejs
    go
    gcc
    eslint
		
    python311Packages.matplotlib
		python3
  ];
}
