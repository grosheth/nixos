{ pkgs, ... }:
{
  programs.gysmo = {
    enable = true;
    package = pkgs.gysmo;
    configs = [
      {
        name = "example-config";
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
      {
        name = "example-config-2";
        config = {
          items = [
            {
              text = "User";
              value = "user";
              icon = "";
              value_color = "red";
              text_color = "";
              icon_color = "red";
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
      { name = "gysmo"; content = "ASCII Art Content"; }
    ];
  };
}