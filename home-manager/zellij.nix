{ pkgs, ... }:
let
  colors = import ./colorscheme.nix { inherit (pkgs) lib; };
in
{
  home = {
    packages = with pkgs; [
      zellij
    ];
  };

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "custom";
      themes.custom.fg = colors.foreground.hex;
      themes.custom.bg = colors.background.hex;
      themes.custom.black = colors.black.hex;
      themes.custom.red = colors.red.hex;
      themes.custom.green = colors.green.hex;
      themes.custom.blue = colors.blue.hex;
      themes.custom.yellow = colors.yellow.hex;
      themes.custom.magenta = colors.magenta.hex;
      themes.custom.cyan = colors.cyan.hex;
      themes.custom.white = colors.white.hex;
      themes.custom.orange = colors.purple.hex;
    };
  };
}
