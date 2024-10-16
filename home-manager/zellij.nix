{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      zellij
    ];
  };

  # kaolin
  # black = "#212026";
  # pink = "#cea2ca";
  # red = "#e55c74";
  # green = "#6dd797";
  # purple = "#c678dd";
  # yellow = "#eed891";
  # cyan = "#56b6c2";
  # blue = "#4fa6ed";
  # blue_alt = "#0bc9cf";
  # white = "#dcdfe4";
  # fg = "#ffffff";
  # bg = "#18181b";

  # neovim
  # black = "#14161b";
  # pink = "#ffcaff";
  # red = "#ffc0b9";
  # green = "#b3f6c0";
  # purple = "#ffcaff";
  # yellow = "#fce094";
  # cyan = "#8cf8f7";
  # blue = "#a6dbff";
  # blue_alt = "#0bc9cf";
  # white = "#ffffff";
  # fg = "#eef1f8";
  # bg = "#14161b";
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "kaolin";
      themes.kaolin.fg = "#e6e6e8";
      themes.kaolin.bg = "#18181b";
      themes.kaolin.black = "#18181b";
      themes.kaolin.red = "#18181b";
      themes.kaolin.green = "#b3f6c0";
      themes.kaolin.blue = "#a6dbff";
      themes.kaolin.yellow = "#ffc0b9";
      themes.kaolin.magenta = "#ffcaff";
      themes.kaolin.cyan = "#8cf8f7";
      themes.kaolin.white = "#eef1f8";
      themes.kaolin.orange = "#8cf8f7";
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
