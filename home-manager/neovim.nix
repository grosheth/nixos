{ pkgs, ... }:
let
  
  treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
		p.bash
		p.c
		p.comment
		p.css
		p.dockerfile
		p.gitattributes
		p.gitignore
		p.go
		p.gomod
		p.gowork
		p.hcl
		p.javascript
		p.jq
		p.json5
		p.json
		p.lua
		p.make
		p.markdown
		p.nix
		p.python
		p.rust
		p.toml
		p.typescript
		p.vue
		p.vimdoc
		p.yaml
  ]));
  in
  {
    home.packages = with pkgs; [
      ripgrep
      fd
      lua-language-server
      rust-analyzer-unwrapped
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

    # Treesitter is configured as a locally developed module in lazy.nvim
    # we hardcode a symlink here so that we can refer to it in our lazy config
    home.file."./.local/share/nvim/nix/nvim-treesitter/" = {
      recursive = true;
      source = treesitterWithGrammars;
    };


  }
