{ pkgs, ... }:
let
  treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withAllGrammars);
  in
  {
    home.packages = with pkgs; [
      ripgrep
      lazygit
      fd
      lua-language-server
      rust-analyzer
    ];
      home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    xdg.desktopEntries."nvim" = {
     name = "NeoVim";
     comment = "Edit text files";
     icon = "nvim";
     # xterm is a symlink and not actually xterm
     exec = "xterm -e ${pkgs.neovim}/bin/nvim %F";
     categories = [ "TerminalEmulator" ];
     terminal = false;
     mimeType = [ "text/plain" ];
    };

    #xdg.configFile.nvim.source = ../../../nvim;
    xdg.configFile."nvim/parser".source = "${pkgs.symlinkJoin {
      name = "treesitter-parsers";
      paths = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
      bash
      c
      comment
      css
      dockerfile
      gitattributes
      gitignore
      go
      gomod
      gowork
      hcl
      javascript
      jq
      json5
      json
      lua
      make
      markdown
      nix
      python
      rust
      toml
      typescript
      vue
      vimdoc
      yaml
      ])).dependencies;
	}}/parser";

    programs.neovim = 
    {
      enable = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      withRuby = true;
      withNodeJs = true;
      withPython3 = true;


      plugins = [
        treesitterWithGrammars
      ];
    };

    home.file."./.config/nvim/" = {
      source = ../nvim;
      recursive = true;
    };
  }
