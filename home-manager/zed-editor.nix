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
      {
        context = "Workspace";
        bindings = {
          "ctrl-shift-i" = "project_panel::TogggleFocus";
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
        dark = "Kaolin";
        light = "Kaolin";
      };
      buffer_font_family = "JetBrainsMono Nerd Font";
      buffer_font_size = 18;
      buffer_font_weight = 300;
      terminal = {
        font_size = 18;
        shell = "system";
        env = {
          TERM = "ghostty";
        };
      };
    };
    extensions = [ "nix" "dockerfile" "lua" ];
  };
}
