{ pkgs, username, ... }:
let
  homeDirectory = "/home/${username}";
in
{
  imports = [
    ./git.nix
    # ./kitty.nix
    ./i3.nix
    ./lf.nix
    ./neovim.nix
    # ./picom.nix
    ./sh.nix
    ./starship.nix
    ./theme.nix
    ./tools.nix
  ];

  news.display = "show";

  targets.genericLinux.enable = true;

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  home = {
    inherit username homeDirectory;

    sessionVariables = {
      QT_XCB_GL_INTEGRATION = "none"; # kde-connect
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      BAT_THEME = "base16";
      GOPATH = "${homeDirectory}/.local/share/go";
      GOMODCACHE="${homeDirectory}/./go/pkg/mod";
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  gtk.gtk3.bookmarks = [
    "file://${homeDirectory}/Documents"
    "file://${homeDirectory}/Music"
    "file://${homeDirectory}/Pictures"
    "file://${homeDirectory}/Videos"
    "file://${homeDirectory}/Downloads"
    "file://${homeDirectory}/Desktop"
    "file://${homeDirectory}/Projects"
    "file://${homeDirectory}/.config Config"
    "file://${homeDirectory}/.local/share Local"
  ];

  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "21.11";

}
