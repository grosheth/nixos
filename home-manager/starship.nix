{ lib, ... }:
let
  arrow = " ";
  arrow_no_space = "";
  pad = {
    left = "";
    right = "";
  };
  langs = "$nodejs$python$rust$golang$lua";
  colors = import ./colorscheme.nix { inherit lib; };
in
{
  programs.starship = {
    enable = true;
    settings = {
      format =  ''$os$hostname$username$directory$fill $all$time
$character
      '';
      add_newline = true;
      continuation_prompt = "[∙](bright-black) ";
      line_break = { disabled = true; };
      os = {
        disabled = false;
        style = "bg:${colors.bg.hex} fg:${colors.red.hex}";
        format = "[$symbol ]($style)";
      };
      hostname = {
        ssh_only = false;
        style = "fg:${colors.red.hex} bg:${colors.bg.hex}";
        format = "[$hostname ]($style)";
      };
      username = {
	show_always = true;
	style_user = "bg:${colors.bg.hex} fg:${colors.yellow.hex}";
	format = "[$user ]($style)";
      };
      directory = {
	style = "bg:${colors.bg.hex} fg:${colors.green.hex}";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "~/󰇘/";
      };
      nix_shell = {
        disabled = false;
        style = "bg:${colors.bg.hex} fg:${colors.white.hex}";
        format = "[ NIX SHELL ]($style)";
      };
      time = {
	disabled = false;
	time_format = "%m-%d %R";
	style = "bg:${colors.bg.hex} fg:${colors.blue.hex}";
	format = "[󰔟 $time ]($style)";
      };
      git_branch = {
        symbol = "";
        style = "bg:${colors.bg.hex} fg:${colors.cyan.hex}";
        format = "[$symbol$branch ](:$remote_branch)($style)";
      };
      cmd_duration = {
        min_time = 0;
        style = "bg:${colors.bg.hex} fg:${colors.magenta.hex}";
        format = "[$duration ]($style)";
      };
      git_commit = {
	commit_hash_length = 4;
	tag_symbol = "🔖";
      };
      python = {
	symbol = " ";
	format = "[$symbol$pyenv_prefix($version)(\($virtualenv\)) ](bg:${colors.bg.hex} fg:${colors.cyan.hex})";
      };
      nodejs = {
	symbol = " ";
	format = "[$symbol($version) ](bg:${colors.bg.hex} fg:${colors.yellow.hex})";
      };
      lua = {
	symbol = "󰢱 ";
	format = "[$symbol($version) ](bg:${colors.bg.hex} fg:${colors.blue_alt.hex})";
      };
      golang = {
	  symbol = " ";
	  format = "[$symbol($version) ](bg:${colors.bg.hex} fg:${colors.blue.hex})";
	};
      os.symbols = {
        Arch = "[ ](fg:${colors.blue.hex})";
        Debian = "[ ](fg:${colors.red.hex})";
        EndeavourOS = "[ ](fg:${colors.purple.hex})";
        Fedora = "[ ](fg:color bg:${colors.blue.hex})";
        NixOS = "[](fg:${colors.white.hex} bg:${colors.bg.hex})";
        openSUSE = "[ ](fg:${colors.green.hex})";
        SUSE = "[ ](fg:${colors.green.hex})";
        Ubuntu = "[ ](fg:${colors.purple.hex}";
      };
      container = {
        style = "bg:${colors.black.hex} fg:${colors.bg.hex}";
        symbol = " 󰏖";
        format = "[$symbol ](style)";
      };
    };
  };
}
