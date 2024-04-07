{ pkgs, ... }:
{
  home.packages = with pkgs; with nodePackages_latest; with gnome; [
    # langs
    ansible
    nodejs
    go
    gcc
    typescript
    eslint
		
    # Python BS
    python311Packages.matplotlib
		python3
  ];
}
