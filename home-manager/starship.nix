{ ... }:
let
  arrow = " ";
  arrow_no_space = "";
  pad = {
    left = "";
    right = "";
  };
  langs = "$nodejs$python$rust$golang$lua";
  colors = {
    black = "#212026";
    pink = "#cea2ca";
    red = "#ef6787";
    green = "#6dd797";
    purple = "#9d81ba";
    yellow = "#eed891";
    cyan = "#0d9c94";
    blue = "#0bc9cf";
    blue_alt = "#2a57cc";
    white = "#f8f8f2";
    bg = "#18181b";
    fg = "#e6e6e8";
};
in
{
  programs.starship = {
    enable = true;
    settings = {
      format =  ''$os$username$directory$fill $all$time
$character
      '';
      add_newline = true;
      # right_format = ''$time$all'';
      continuation_prompt = "[∙](bright-black) ";
      line_break = { disabled = true; };
      os = {
        disabled = false;
        style = "bg:${colors.bg} fg:${colors.red}";
        format = "[$symbol NIXOS ]($style)";
      };
      username = {
	show_always = true;
	style_user = "bg:${colors.bg} fg:${colors.yellow}";
	format = "[$user ]($style)";
      };
      directory = {
	style = "bg:${colors.bg} fg:${colors.green}";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "~/󰇘/";
      };
      nix_shell = {
        disabled = false;
        style = "bg:${colors.bg} fg:${colors.purple}";
        format = "[ NIX SHELL ]($style)";
      };
      time = {
	disabled = false;
	time_format = "%m-%d %R";
	style = "bg:${colors.bg} fg:${colors.blue}";
	format = "[󰔟 $time ]($style)";
      };
      git_branch = {
        symbol = "";
        style = "bg:${colors.bg} fg:${colors.cyan}";
        format = "[$symbol$branch ](:$remote_branch)($style)";
      };
      git_commit = {
	commit_hash_length = 4;
	tag_symbol = "🔖";
      };
      python = {
	symbol = " ";
	format = "[$symbol$pyenv_prefix($version)(\($virtualenv\)) ](bg:${colors.bg} fg:${colors.cyan})";
      };
      nodejs = {
	symbol = " ";
	format = "[$symbol($version) ](bg:${colors.bg} fg:${colors.yellow})";
      };
      lua = {
	symbol = "󰢱 ";
	format = "[$symbol($version) ](bg:${colors.bg} fg:${colors.blue_alt})";
      };
      golang = {
	  symbol = " ";
	  format = "[$symbol($version) ](bg:${colors.bg} fg:${colors.blue})";
	};
      os.symbols = {
        Arch = "[ ](fg:bright-color)";
        Debian = "[ ](fg:red)";
        EndeavourOS = "[ ](fg:purple)";
        Fedora = "[ ](fg:color bg:#246449)";
        NixOS = "[](fg:${colors.white} bg:${colors.bg})";
        openSUSE = "[ ](fg:green)";
        SUSE = "[ ](fg:green)";
        Ubuntu = "[ ](fg:bright-purple)";
      };
      container = {
        style = "bg:${colors.black} fg:${colors.bg}";
        symbol = " 󰏖";
        format = "[$symbol ](style)";
      };
    };
  };
}
