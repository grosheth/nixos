{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rofi
  ];

  programs.rofi = {
    enable = true;
    location = "center";
    theme = "dracula";
    # yoffset = 50;
    # xoffset = 50;
    font = "JetBrainsMonoNerdFontMono-Regular";
    extraConfig = {
      show-icons = true;
      display-drun = "";
      disable-history = false;
    };
  };
}
