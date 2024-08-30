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
    theme = "kaolin";
    theme.kaolin.fg = "#e6e6e8";
    theme.kaolin.bg = "#18181b";
    theme.kaolin.black = "#18181b";
    theme.kaolin.red = "#e55c74";
    theme.kaolin.green = "#6dd797";
    theme.kaolin.blue = "#0db9d7";
    theme.kaolin.yellow = "#eed891";
    theme.kaolin.magenta = "#cea2ca";
    theme.kaolin.cyan = "#6bd9db";
    theme.kaolin.white = "#e6e6e8";
    theme.kaolin.orange = "#ff9e64";
  };
}
