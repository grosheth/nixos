{ pkgs, ... }:
let
  aliases = {
    # Git aliases
    "gs" = "git status";
    "gch" = "git checkout";
    "gc" = "git commit -am";
    "gp" = "git push";
    "ga" = "git add --all";
    "gt" = "git tag";

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
    "gg" = "lazygit";
    # Neovim
    "nvim" = "neovim";
    "n" = "nvim .";
    "nv" = "nvim";
    "vim" = "nvim";
    "neovim" = "nvim";

    # ssh-manager alias
    "s" = "~/work/ssh-manager/target/debug/ssh-manager";
    "ssh-manager" = "~/work/ssh-manager/target/debug/ssh-manager";

    # kaolin theme creator alias
    "kaolin" = "~/work/kaolin-theme-creator/target/debug/kaolin-theme-creator";

    # Update nix system
    "update" = "nix flake update";

    # zed close terminal
    "zed" = "zeditor . && exit";
    # zed keep terminal
    "zedk" = "zeditor";

    "code" = "cursor . &";
    "codek" = "cursor";
  };
in
{
  programs = {
    # thefuck.enable = true;

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
      initContent = ''
        SHELL=${pkgs.zsh}/bin/zsh

        function cd() {
            builtin cd "$@" || return

            if [[ -d .git ]]; then
                onefetch
            fi
        }
        gysmo
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
