{ pkgs, ... }:
let
  aliases = {
    # Git aliases
    "gs" = "git status";
    "gch" = "git checkout";
    "gc" = "git commit -am";
    "gp" = "git push";
    "ga" = "git add --all";

    # basic commands
    "cls" = "clear";
    "ll" = "ls -lat";
    "lr" = "ls -lrt";
    "l" = "ls";

    # Quick move aliases 
    "wrk" = "cd ~/work";
    "cfg" = "cd ~/nixos";
    ".cfg" = "cd ~/.config";

    "db" = "distrobox";
    # Neovim
    "nvim" = "neovim";
    "n" = "nvim .";
    "nv" = "nvim";
    "vim" = "nvim";
    "neovim" = "nvim";
  };
in
{ 
  programs = {
    thefuck.enable = true; 

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
      sessionVariables = {
        GO = " ";
        NIX = "";
        LUA = "󰢱 ";
        NODEJS = " ";
        PYTHON = " ";
      };
      initExtra = ''
        SHELL=${pkgs.zsh}/bin/zsh

        function cd() {
            builtin cd "$@" || return

            if [[ -d .git ]]; then
                onefetch
            fi
        }
        nitch
      '';
      shellAliases = aliases;
    };

    bash = {
      enable = true;
      initExtra = "SHELL=${pkgs.bash}";
      shellAliases = aliases;
    };
  };
}
