{ pkgs, ... }:
{
  programs.gysmo = {
    enable = true;
    package = pkgs.gysmo;
    configs = [
      {
        name = "config";
        config = {
          items = [
            {
              text = "User";
              keyword = "user";
              icon = "";
              value_color = "red";
              text_color = "";
              icon_color = "red";
            }
            {
              text = "Kernel";
              value = "kernel";
              icon = "󰌽";
              value_color = "";
              text_color = "";
              icon_color = "";
            }
            {
              text = "WM";
              value = "wm";
              icon = "󱂬";
              value_color = "yellow";
              text_color = "";
              icon_color = "yellow";
            }
            {
              text = "GPU";
              value = "gpu";
              icon = "";
              value_color = "green";
              text_color = "";
              icon_color = "green";
            }
            {
              text = "Term";
              value = "term";
              icon = "";
              value_color = "blue";
              text_color = "";
              icon_color = "blue";
            }
            {
              text = "CPU";
              value = "cpu";
              icon = "";
              value_color = "red";
              text_color = "";
              icon_color = "red";
            }
            {
              text = "OS";
              value = "NixOs";
              icon = "";
              value_color = "";
              text_color = "";
              icon_color = "";
            }
            {
              text = "RAM";
              value = "ram";
              icon = "";
              value_color = "yellow";
              text_color = "";
              icon_color = "yellow";
            }
            {
              text = "Shell";
              value = "zsh";
              icon = "";
              value_color = "green";
              text_color = "";
              icon_color = "green";
            }
            {
              text = "Uptime";
              value = "uptime";
              icon = "󱑆";
              value_color = "blue";
              text_color = "";
              icon_color = "blue";
            }
          ];
          ascii = {
            path = "ascii/gysmo";
            colors = "#ffffff";
            enabled = true;
            horizontal_padding = 2;
            vertical_padding = 2;
            position = "top";
          };
          header = {
            enabled = false;
            line = true;
            text = "";
            text_color = "";
            line_color = "";
          };
          footer = {
            enabled = false;
            line = true;
            text = "";
            text_color = "";
            line_color = "";
          };
          general = {
            menu_type = "box";
            columns = true;
            menu_padding = 5;
          };
        };
      }
    ];
    asciiFiles = [
      { name = "gysmo"; content = ''
        _______    __  __   ______   ___ __ __   ______
       /______/\  /_/\/_/\ /_____/\ /__//_//_/\ /_____/\
       \::::__\/__\ \ \ \ \\::::_\/_\::\| \| \ \\:::_ \ \
        \:\ /____/\\:\_\ \ \\:\/___/\\:.      \ \\:\ \ \ \
         \:\\_  _\/ \::::_\/ \_::._\:\\:.\-/\  \ \\:\ \ \ \
          \:\_\ \ \   \::\ \   /____\:\\. \  \  \ \\:\_\ \ \
           \_____\/    \__\/   \_____\/ \__\/ \__\/ \_____\/
      ''; }
      { name = "nixos"; content = ''
        ___   __     ________  __     __   ______   ______
       /__/\ /__/\  /_______/\/__/\ /__/\ /_____/\ /_____/\
       \::\_\\  \ \ \__.::._\/\ \::\\:.\ \\:::_ \ \\::::_\/_
        \:. `-\  \ \   \::\ \  \_\::_\:_\/ \:\ \ \ \\:\/___/\
         \:. _    \ \  _\::\ \__ _\/__\_\_/\\:\ \ \ \\_::._\:\
          \. \`-\  \ \/__\::\__/\\ \ \ \::\ \\:\_\ \ \ /____\:\
           \__\/ \__\/\________\/ \_\/  \__\/ \_____\/ \_____\/
      ''; }
    ];
  };
}
