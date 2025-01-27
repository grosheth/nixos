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
      themes.kaolin.black = "#212026";
      themes.kaolin.red = "#e55c74";
      themes.kaolin.green = "#6dd797";
      themes.kaolin.blue = "#4fa6ed";
      themes.kaolin.yellow = "#e55c74";
      themes.kaolin.magenta = "#DF215A";
      themes.kaolin.cyan = "#56b6c2";
      themes.kaolin.white = "#eef1f8";
      themes.kaolin.orange = "#56b6c2";

      # theme = "neovim";
      # themes.neovim.fg = "#e6e6e8";
      # themes.neovim.bg = "#18181b";
      # themes.neovim.black = "#18181b";
      # themes.neovim.red = "#18181b";
      # themes.neovim.green = "#b3f6c0";
      # themes.neovim.blue = "#a6dbff";
      # themes.neovim.yellow = "#ffc0b9";
      # themes.neovim.magenta = "#ffcaff";
      # themes.neovim.cyan = "#8cf8f7";
      # themes.neovim.white = "#eef1f8";
      # themes.neovim.orange = "#8cf8f7";
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
