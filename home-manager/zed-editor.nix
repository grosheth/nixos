{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zed-editor
  ];

  programs.zed-editor = {
    enable = true;
    userKeymaps = [
      {
        context = "workspace";
        bindings = {
          "ctrl+shift+j" = "workspace::NewTerminal";
        };
      }
    ];
    userSettings = {
      vim_mode = true;
    };
  };
}