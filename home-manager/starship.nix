{ lib, ... }:
let
  lang = icon: color: {
    symbol = icon;
    format = "[$symbol ](${color})";
  };
  pad = {
    left = "";
    right = "";
  };
	colors = {
		beige = "#ac9d82";
		beige2 = "#bbab7e"; 
		beige3 = "#e6dfc1";
		black = "#060301";
		white = "#faf7dd";
	};
in
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = "[](${colors.beige})$os$username[](bg:${colors.beige2} fg:${colors.beige})$directory[](fg:${colors.beige2} bg:${colors.beige3})$git_branch[](fg:${colors.beige3} bg:${colors.beige3})$nodejs$python$rust$golang$lua[](fg:${colors.beige3} bg:${colors.white})$time[ ](fg:${colors.white})$line_break[ ](fg:${colors.white})";
      continuation_prompt = "[∙](bright-black) ";
      line_break = { disabled = false; };
      status = {
        symbol = "✗";
        not_found_symbol = "󰍉 Not Found";
        not_executable_symbol = " Can't Execute E";
        sigint_symbol = "󰂭 ";
        signal_symbol = "󱑽 ";
        success_symbol = "";
        format = "[$symbol](fg:${colors.black})";
        map_symbol = true;
        disabled = false;
      };
			username = {
				show_always = true;
				style_user = "bg:${colors.beige} fg:${colors.black}";
				style_root = "bg:${colors.beige} fg:${colors.black}";
				format = "[$user ]($style)";
			};
      cmd_duration = {
        min_time = 1000;
        format = "[$duration ](fg:yellow)";
      };
      nix_shell = {
        disabled = false;
        format = "[${pad.left}](fg:${colors.white})[ ](bg:${colors.white} fg:${colors.white})[${pad.right}](fg:${colors.white}) ";
      };
      container = {
        symbol = " 󰏖";
        format = "[$symbol ](yellow dimmed)";
      };
      directory = {
				style = "bg:${colors.beige2} fg:${colors.black}";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "~/󰇘/";
      };
      git_branch = {
        symbol = "";
        format = "[ $symbol $branch](bg:${colors.beige3} fg:${colors.black})(:$remote_branch)";
      };
      os = {
        disabled = false;
        format = "$symbol";
      };
      os.symbols = {
        Arch = "[ ](fg:bright-beige)";
        Debian = "[ ](fg:red)";
        EndeavourOS = "[ ](fg:purple)";
        Fedora = "[ ](fg:beige bg:#246449)";
        NixOS = "[ ](fg:${colors.black} bg:${colors.beige})";
        openSUSE = "[ ](fg:green)";
        SUSE = "[ ](fg:green)";
        Ubuntu = "[ ](fg:bright-purple)";
      };
			time = {
				disabled = false;
				time_format = "%R";
				style = "bg:${colors.white} fg:${colors.black}";
				format = "[ ♥ $time ]($style)";	
			};
			python = {
				symbol = " ";
				format = "[$symbol$pyenv_prefix($version )(\($virtualenv\) )](bg:${colors.beige3} fg:${colors.black})";
			};
			nodejs = {
				symbol = " ";
				format = "[$symbol($version)](bg:${colors.beige3} fg:${colors.black})";
			};
			lua = {
				symbol = "󰢱 ";
				format = "[$symbol($version)](bg:${colors.beige3} fg:${colors.black})";
			};
      rust = {
				symbol = " ";
				format = "[$symbol($version)](bg:${colors.beige3} fg:${colors.black})";
			};
      golang = {
				symbol = " ";
				format = "[$symbol($version)](bg:${colors.beige3} fg:${colors.black})";
			};
    };
  };
}
