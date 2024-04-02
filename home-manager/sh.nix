{ pkgs, config, ... }:
let
  aliases = {
    # Git aliases
    "gs" = "git status";
    "gch" = "git checkout";
    "gc" = "git commit -am";
		"gp" = "git push";
    "ga" = "git add --all";
    # ssh rapspberry pies
    "pi1" = "ssh pi@192.168.10.120";
    "pi2" = "ssh pi@192.168.10.121";
    # basic commands
    "cls" = "clear";
    "ll" = "ls -la";
    "lr" = "ls -lrt";
    "l" = "ls";
    # Quick move aliases
    "work" = "cd ~/work";
    "pool" = "cd ~/work/hockey-pool/ && n";
    "bot" = "cd ~/work/discord-bot/ && n";
    "nixcfg" = "cd ~/nixos-configs && n";
		"termify" = "cd ~/work/termify && n";
    # Neovim / Neovide
    "n" = "neovide .";
		"nv" = "neovide";
    "vim" = "neovide";
		# "nvim" = "neovide";
		# "nv" = "neovim";
		# "vim" = "neovim";
		# "nvim" = "neovim";
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
        theme = "rkj-repos";
        # theme = "simonoff";
      };
      initExtra = ''
        SHELL=${pkgs.zsh}/bin/zsh
        function cd() {
            builtin cd "$@" || return
            
            if [[ -d .git ]]; then
                onefetch
            fi

        }
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
