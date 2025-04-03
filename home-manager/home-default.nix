{ pkgs, username, lib, ... }:
let
  homeDirectory = "/home/${username}";

  # WM
  hyprland = false;
  bspwm = true;
  i3 = false;
in
{
  imports = lib.filter (x: x != null) [
    (if bspwm then ./bspwm.nix else null)
    (if hyprland then ./hyprland.nix else null)
    (if i3 then ./i3.nix else null)
    ./git.nix
    ./ghostty.nix
    ./kitty.nix
    ./lf.nix
    ./neovim.nix
    # ./nitch.nix
    ./packages.nix
    ./picom.nix
    # ./polybar.nix
    ./rofi.nix
    ./sh.nix
    ./starship.nix
    ./theme.nix
    # ./tmux.nix
    ./zed-editor.nix
    # ./zellij.nix
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

  # change home-manager path to use the development one
  # run to apply `home-manager switch`
  programs.home-manager.enable = true;
  # programs.home-manager.path = "$HOME/work/home-manager";

  home.stateVersion = "21.11";
}
