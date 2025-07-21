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
    # kaolin
    black = "#212026";
    pink = "#EE87A9";
    red = "#e55c74";
    green = "#6dd797";
    purple = "#c678dd";
    yellow = "#eed891";
    cyan = "#56b6c2";
    blue = "#0db9d7";
    blue_alt = "#0bc9cf";
    white = "#dcdfe4";
    fg = "#ffffff";
    bg = "#18181b";

    # neovim
    # black = "#14161b";
    # pink = "#ffcaff";
    # red = "#ffc0b9";
    # green = "#b3f6c0";
    # purple = "#ffcaff";
    # yellow = "#fce094";
    # cyan = "#8cf8f7";
    # blue = "#a6dbff";
    # blue_alt = "#0bc9cf";
    # white = "#ffffff";
    # fg = "#eef1f8";
    # bg = "#14161b";

};
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
        style = "bg:${colors.bg} fg:${colors.red}";
        format = "[$symbol ]($style)";
      };
      hostname = {
        ssh_only = false;
        style = "fg:${colors.red} bg:${colors.bg}";
        format = "[$hostname ]($style)";
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
        style = "bg:${colors.bg} fg:${colors.white}";
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
      cmd_duration = {
        min_time = 0;
        style = "bg:${colors.bg} fg:${colors.pink}";
        format = "[$duration ]($style)";
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
        Arch = "[ ](fg:${colors.blue})";
        Debian = "[ ](fg:${colors.red})";
        EndeavourOS = "[ ](fg:${colors.purple})";
        Fedora = "[ ](fg:color bg:${colors.blue})";
        NixOS = "[](fg:${colors.white} bg:${colors.bg})";
        openSUSE = "[ ](fg:${colors.green})";
        SUSE = "[ ](fg:${colors.green})";
        Ubuntu = "[ ](fg:${colors.purple}";
      };
      container = {
        style = "bg:${colors.black} fg:${colors.bg}";
        symbol = " 󰏖";
        format = "[$symbol ](style)";
      };
    };
  };
}
