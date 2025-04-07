# home-manager/gysmo.nix
{ inputs, pkgs, getLocalCustomPackage, ... }:
  let
    localCustomPackage = getLocalCustomPackage { packageName = "path/to/custom/package.nix"; };
  in
{
  imports = [
    homeModules.programs.gysmo
  ];

  programs.gysmo = {
    enable = true;
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
          keyword = "kernel";
          icon = "󰌽";
          value_color = "";
          text_color = "";
          icon_color = "";
        }
        {
          text = "WM";
          keyword = "wm";
          icon = "󱂬";
          value_color = "yellow";
          text_color = "";
          icon_color = "yellow";
        }
        {
          text = "GPU";
          keyword = "gpu";
          icon = "";
          value_color = "green";
          text_color = "";
          icon_color = "green";
        }
        {
          text = "Term";
          keyword = "term";
          icon = "";
          value_color = "blue";
          text_color = "";
          icon_color = "blue";
        }
        {
          text = "CPU";
          value = "Intel(R) Core(TM) i7-10700K";
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
          keyword = "ram";
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
          keyword = "uptime";
          icon = "󱑆";
          value_color = "blue";
          text_color = "";
          icon_color = "blue";
        }
      ];
      ascii = {
        path = "ascii/nixos";
        colors = "";
        enabled = true;
        horizontal_padding = 2;
        vertical_padding = 0;
        position = "top";
      };
      header = {
        enabled = false;
        text = "NixOS";
        text_color = "purple";
        line = true;
        line_color = "";
      };
      footer = {
        enabled = false;
        text = "gysmo";
        text_color = "blue";
        line = true;
        line_color = "";
      };
      general = {
        menu_type = "box";
        columns = false;
        menu_padding = 2;
      };
    };
  };
}
