{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zed-editor
  ];

  programs.zed-editor = {
    enable = true;
    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          "ctrl+j" = "workspace::NewTerminal";
        };
      }

    ];

    userSettings = {
      vim_mode = true;
      assistant =  {
        default_model = {
          provider = "copilot_chat";
          model =  "gpt-4o";
        };
        version = "2";
      };
      theme = {
        mode = "system";
        dark = "One Dark";
        light = "One Light";
      };
      buffer_settings = {
        font_family = "JetBrainsMono Nerd Font Mono";
        font_size = 14;
      };
      terminal = {
        font_family = "JetBrainsMono Nerd Font Mono";
        font_size = 14;
        shell = "system";
        env = {
          TERM = "ghostty";
        };
      };
    };
  };
}
