{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rofi
  ];

  programs.rofi = {
    enable = true;
    location = "center";
    theme = "dracula";
    font = "JetBrainsMonoNerdFontMono-Regular";
    extraConfig = {
      show-icons = true;
      display-drun = "";
      disable-history = false;
    };
  };
}
