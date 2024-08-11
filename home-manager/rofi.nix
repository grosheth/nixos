{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rofi
  ];

  programs.rofi = {
    enable = true;
    location = "center";
    theme = "dracula";
    font = "JetBrainsMonoNerdFontMono-Regular";
    extraConfig = {
      show-icons = true;
      display-drun = "";
      disable-history = false;
      # combi-modi = "Project:~/nixos/scripts/rofi-projects.sh";
      # modi = "combi";
    };
  };
}


# configuration {
#     combi-modi: "window,drun,ssh,Project:~/.config/rofi/project.sh";
#     modi: "combi";
# }

# Now, rofi -show combi should open with a default combi mode+project launcher.
