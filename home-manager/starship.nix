{ ... }:
let
  arrow = "";
  pad = {
    left = "";
    right = "";
  };
  langs = "$nodejs$python$rust$golang$lua";
	colors = {
		black = "#545454";
		pink = "#ff78c5";
		green = "#50fa7b";
		purple = "#bd92f8";
		yellow = "#f0fa8b";
		white = "#f8f8f2";
		bg = "#1e1f28";
	};
in
{
  programs.starship = {
    enable = true;
    settings = {
      format = ''
        $os$username $directory $time $git_branch ${langs} $nix_shell
        ${arrow} 
        '';
      continuation_prompt = "[∙](bright-black) ";
      line_break = { disabled = false; };
      os = {
        disabled = false;
        style = "bg:${colors.black} fg:${colors.white}";
        format = "[[${pad.left}](bg:${colors.bg} fg:${colors.black})$symbol]($style)";
      };
			username = {
				show_always = true;
				style_user = "bg:${colors.black} fg:${colors.bg}";
				format = "[$user[${pad.right}](bg:${colors.bg} fg:${colors.black})]($style)";
			};
      directory = {
				style = "bg:${colors.pink} fg:${colors.bg}";
        format = "[[${pad.left}](bg:${colors.bg} fg:${colors.pink}) $path[${pad.right}](bg:${colors.bg} fg:${colors.pink})]($style)";
        truncation_length = 3;
        truncation_symbol = "~/󰇘/";
      };
      nix_shell = {
        disabled = false;
        style = "bg:${colors.purple} fg:${colors.bg}";
        format = "[[${pad.left}](bg:${colors.bg} fg:${colors.purple}) NIX SHELL[${pad.right}](bg:${colors.bg} fg:${colors.purple})]($style)";
      };
      git_branch = {
        symbol = "";
        style = "bg:${colors.yellow} fg:${colors.bg}";
        format = "[[${pad.left}](bg:${colors.bg} fg:${colors.yellow})$symbol $branch [${pad.right}](bg:${colors.bg} fg:${colors.yellow})]($style)(:$remote_branch)";
      };
			time = {
				disabled = false;
				time_format = "%Y-%m-%d %R";
				style = "bg:${colors.white} fg:${colors.bg}";
				format = "[[${pad.left}](bg:${colors.bg} fg:${colors.white})󰔟 $time[${pad.right}](bg:${colors.bg} fg:${colors.white})]($style)";	
			};
			python = {
				symbol = " ";
				format = "[[${pad.left}](bg:${colors.bg} fg:${colors.green})$symbol$pyenv_prefix($version)(\($virtualenv\)) [${pad.right}](bg:${colors.bg} fg:${colors.green})](bg:${colors.green} fg:${colors.black})";
			};
			nodejs = {
				symbol = " ";
				format = "[[${pad.left}](bg:${colors.bg} fg:${colors.green})$symbol($version)[${pad.right}](bg:${colors.bg} fg:${colors.green})](bg:${colors.green} fg:${colors.black})";
			};
			lua = {
				symbol = "󰢱 ";
				format = "[[${pad.left}](bg:${colors.bg} fg:${colors.green})$symbol($version)[${pad.right}](bg:${colors.bg} fg:${colors.green})](bg:${colors.green} fg:${colors.black})";
			};
      golang = {
				symbol = " ";
				format = "[[${pad.left}](bg:${colors.bg} fg:${colors.green})$symbol($version)[${pad.right}](bg:${colors.bg} fg:${colors.green})](bg:${colors.green} fg:${colors.black})";
			};
      os.symbols = {
        Arch = "[ ](fg:bright-color)";
        Debian = "[ ](fg:red)";
        EndeavourOS = "[ ](fg:purple)";
        Fedora = "[ ](fg:color bg:#246449)";
        NixOS = "[ ](fg:${colors.white} bg:${colors.black})";
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
