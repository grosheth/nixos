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
      format = ''
        [${pad.left}](bg:${colors.bg} fg:${colors.red})$os[${arrow}](bg:${colors.yellow} fg:${colors.red})$username[${arrow}](bg:${colors.green} fg:${colors.yellow})$directory[${arrow}](bg:${colors.cyan} fg:${colors.green})$git_branch[${arrow}](bg:${colors.blue} fg:${colors.cyan})${langs}[${arrow}](bg:${colors.pink} fg:${colors.blue})$time[${arrow}](bg:${colors.bg} fg:${colors.pink})
        ${arrow_no_space} 
        '';
      continuation_prompt = "[∙](bright-black) ";
      line_break = { disabled = false; };
      os = {
        disabled = false;
        style = "bg:${colors.red} fg:${colors.bg}";
        format = "[$symbol NIXOS ]($style)";
      };
			username = {
				show_always = true;
				style_user = "bg:${colors.yellow} fg:${colors.bg}";
				format = "[$user ]($style)";
			};
      directory = {
				style = "bg:${colors.green} fg:${colors.bg}";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "~/󰇘/";
      };
      nix_shell = {
        disabled = false;
        style = "bg:${colors.purple} fg:${colors.bg}";
        format = "[ NIX SHELL ]($style)";
      };
      git_branch = {
        symbol = "";
        style = "bg:${colors.cyan} fg:${colors.bg}";
        format = "[$symbol $branch ]($style)(:$remote_branch)";
      };
			time = {
				disabled = false;
				time_format = "%Y-%m-%d %R:%S";
				style = "bg:${colors.pink} fg:${colors.bg}";
				format = "[󰔟 $time ]($style)";
			};
			python = {
				symbol = " ";
				format = "[$symbol$pyenv_prefix($version)(\($virtualenv\)) ](bg:${colors.blue})";
			};
			nodejs = {
				symbol = " ";
				format = "[$symbol($version) ](bg:${colors.blue} fg:${colors.bg})";
			};
			lua = {
				symbol = "󰢱 ";
				format = "[$symbol($version) ](bg:${colors.blue} fg:${colors.bg})";
			};
      golang = {
				symbol = " ";
				format = "[$symbol($version) ](bg:${colors.blue} fg:${colors.bg})";
			};
      os.symbols = {
        Arch = "[ ](fg:bright-color)";
        Debian = "[ ](fg:red)";
        EndeavourOS = "[ ](fg:purple)";
        Fedora = "[ ](fg:color bg:#246449)";
        NixOS = "[](fg:${colors.white} bg:${colors.red})";
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
