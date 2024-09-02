{ pkgs, ... }:
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
      theme = "kaolin";
      themes.kaolin.fg = "#e6e6e8";
      themes.kaolin.bg = "#18181b";
      themes.kaolin.black = "#18181b";
      themes.kaolin.red = "#ff9e64";
      themes.kaolin.green = "#6dd797";
      themes.kaolin.blue = "#0db9d7";
      themes.kaolin.yellow = "#eed891";
      themes.kaolin.magenta = "#cea2ca";
      themes.kaolin.cyan = "#eed891";
      themes.kaolin.white = "#e6e6e8";
      themes.kaolin.orange = "#6bd9db";
    };
    # extraConfig = ''
    #     {
    #         theme "custom"
    #         themes {
    #             custom {
    #                 fg "#e6e6e8"
    #             }
    #         }
    #         plugins {
    #             tab-bar location="zellij:tab-bar"
    #             status-bar location="zellij:status-bar"
    #         }
    #     }
    # '';
  };
}
