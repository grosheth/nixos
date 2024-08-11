{ pkgs, ... }:
let
  aliases = {
    # Git aliases
    "gs" = "git status";
    "gch" = "git checkout";
    "gc" = "git commit -am";
		"gp" = "git push";
    "ga" = "git add --all";

    # ssh rapspberry pies
    # "pi1" = "ssh pi@192.168.10.120";
    # "pi2" = "ssh pi@192.168.10.121";
    
    # basic commands
    "cls" = "clear";
    "ll" = "ls -la";
    "lr" = "ls -lrt";
    "l" = "ls";

    # Quick move aliases "work" = "cd ~/work";
    "wrk" = "cd ~/work";
    "advent" = "cd ~/work/Advent-of-code/";
    "pool" = "cd ~/work/hockey-pool/ && n";
    "bot" = "cd ~/work/discord-bot/ && n";
    "nixcfg" = "cd ~/nixos-configs && n";
		"termify" = "cd ~/work/termify && n";

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
      envExtra = '' 
        _PROJECTS_PATH="''${HOME}/work"
        for project in $(ls -rt ''${PROJECT_PATH}); do
          REPO_LANG=$(onefetch "''${PROJECTS_PATH}/''${project}" | grep -A 5 "Languages" || exit 0)
          if [ $? != 1 ]; then
            new_project=$project
            if [[ ''${REPO_LANG} == *"Python"* ]]; then
              new_project="''${new_project} ''${PYTHON}"
            fi
            if [[ ''${REPO_LANG} == *"Go"* ]]; then
              new_project="''${new_project} ''${GO}"
            fi
            if [[ ''${REPO_LANG} == *"JavaScript"* ]]; then
              new_project="''${new_project} ''${NODEJS}"
            fi
            if [[ ''${REPO_LANG} == *"Nix"* ]]; then
              new_project="''${new_project} ''${NIX}"
            fi
            if [[ ''${REPO_LANG} == *"Lua"* ]]; then
              new_project="''${new_project} ''${LUA}"
            fi
          fi
          _PROJECT_LIST="''${PROJECT_LIST/''$project/''$new_project}"
        done
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
