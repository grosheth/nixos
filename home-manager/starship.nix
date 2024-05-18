{ ... }:
let
  pad = {
    left = "";
    right = "";
  };
	colors = {
    # black 
		color = "#545454";
		# color = "#bd92f8";
		color2 = "#ff78c5";
		# color2 = "#ff5555"; 
    # green
		color3 = "#50fa7b";
    # purple
		# color3 = "#bd92f8";
    # yellow
		# color3 = "#f0fa8b";
		white = "#f8f8f2";
		black = "#1e1f28";
    # Tokyonight
		# color = "#f7768e";
		# color2 = "#e0af68"; 
		# color3 = "#9ece6a";
		# white = "#7aa2f7";
		# black = "#1d202f";
	};
in
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = "[](${colors.color})$os$username[](bg:${colors.color2} fg:${colors.color})$directory[](fg:${colors.color2} bg:${colors.color3})$git_branch[](fg:${colors.color3} bg:${colors.color3})$nodejs$python$rust$golang$lua[](fg:${colors.color3} bg:${colors.white})$time[ ](fg:${colors.white})$line_break[ ](fg:${colors.white})";
      continuation_prompt = "[∙](bright-black) ";
      line_break = { disabled = false; };
			username = {
				show_always = true;
				style_user = "bg:${colors.color} fg:${colors.black}";
				format = "[$user ]($style)";
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
				style = "bg:${colors.color2} fg:${colors.black}";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "~/󰇘/";
      };
      git_branch = {
        symbol = "";
        format = "[ $symbol $branch](bg:${colors.color3} fg:${colors.black})(:$remote_branch)";
      };
      os = {
        disabled = false;
        format = "$symbol";
      };
      os.symbols = {
        Arch = "[ ](fg:bright-color)";
        Debian = "[ ](fg:red)";
        EndeavourOS = "[ ](fg:purple)";
        Fedora = "[ ](fg:color bg:#246449)";
        NixOS = "[ ](fg:${colors.white} bg:${colors.color})";
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
				format = "[$symbol$pyenv_prefix($version )(\($virtualenv\) )](bg:${colors.color3} fg:${colors.black})";
			};
			nodejs = {
				symbol = " ";
				format = "[$symbol($version)](bg:${colors.color3} fg:${colors.black})";
			};
			lua = {
				symbol = "󰢱 ";
				format = "[$symbol($version)](bg:${colors.color3} fg:${colors.black})";
			};
      golang = {
				symbol = " ";
				format = "[$symbol($version)](bg:${colors.color3} fg:${colors.black})";
			};
    };
  };
}
