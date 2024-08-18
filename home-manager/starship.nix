{ ... }:
let
  arrow = "";
  pad = {
    left = "";
    right = "";
  };
  langs = "$nodejs$python$rust$golang$lua";
	colors = {
		black = "#69735";
		pink = "#fbaed2";
		red = "#ef6787";
		green = "#47ba99";
		purple = "#bd92f8";
		yellow = "#f5c791";
		cyan = "#49bdb0";
		blue = "#4eb8ca";
		blue_alt = "#91b9c7";
		white = "#f8f8f2";
		bg = "#1e1f28";
	};
in
{
  programs.starship = {
    enable = true;
    settings = {
      format = ''
        [${pad.left}](bg:${colors.bg} fg:${colors.red})$os[${arrow}](bg:${colors.yellow} fg:${colors.red})$username[${arrow}](bg:${colors.green} fg:${colors.yellow})$directory[${arrow}](bg:${colors.cyan} fg:${colors.green})$git_branch[${arrow}](bg:${colors.blue} fg:${colors.cyan})${langs}[${arrow}](bg:${colors.pink} fg:${colors.blue})$nix_shell[${arrow}](bg:${colors.pink} fg:${colors.pink})$time[${arrow}](bg:${colors.bg} fg:${colors.pink})
        ${arrow} 
        '';
      continuation_prompt = "[∙](bright-black) ";
      line_break = { disabled = false; };
      os = {
        disabled = false;
        style = "bg:${colors.red} fg:${colors.white}";
        format = "[$symbol NIXOS]($style)";
      };
			username = {
				show_always = true;
				style_user = "bg:${colors.yellow}";
				format = "[$user]($style)";
			};
      directory = {
				style = "bg:${colors.green} fg:${colors.bg}";
        format = "[  $path]($style)";
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
        format = "[ $symbol $branch ]($style)(:$remote_branch)";
      };
			time = {
				disabled = false;
				time_format = "%Y-%m-%d %R:%S";
				style = "bg:${colors.pink} fg:${colors.bg}";
				format = "[󰔟 $time]($style)";	
			};
			python = {
				symbol = " ";
				format = "[$symbol$pyenv_prefix($version)(\($virtualenv\))](bg:${colors.blue} fg:${colors.black})";
			};
			nodejs = {
				symbol = " ";
				format = "[$symbol($version)](bg:${colors.blue} fg:${colors.black})";
			};
			lua = {
				symbol = "󰢱 ";
				format = "[$symbol($version)](bg:${colors.blue} fg:${colors.black})";
			};
      golang = {
				symbol = " ";
				format = "[$symbol($version)](bg:${colors.blue})";
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
