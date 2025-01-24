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
          "ctrl-shift-j" = "workspace::ToggleBottomDock";
        };
      }
      {
        context = "Editor";
        bindings = {
          "ctrl-shift-j" = "terminal_panel::ToggleFocus";
        };
      }
      {
        context = "Terminal";
        bindings = {
          "ctrl-shift-j" = "workspace::ToggleBottomDock";
        };
      }
    ];

    userSettings = {
      vim_mode = true;
      ui_font_size = 16;
      base_keymaps = "VSCode";
      assistant =  {
        default_model = {
          provider = "copilot_chat";
          model =  "gpt-4o";
        };
        version = "2";
      };
      theme = {
        mode = "dark";
        dark = "One Dark";
        light = "One Light";
      };
      buffer_settings = {
        font_family = "JetBrainsMono Nerd Font Mono";
        font_size = 16;
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
    extensions = [ "nix" "dockerfile" "lua" ];
  };
}
