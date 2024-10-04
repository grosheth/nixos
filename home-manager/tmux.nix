{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      tmux
      fzf
    ];
  };

  programs.fzf = {
    enable = true;
    tmux = {
      enableShellIntegration = true;
    };
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
  };
}
