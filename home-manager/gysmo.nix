{ pkgs, ... }:
{
  programs.gysmo = {
    enable = true;
    package = pkgs.gysmo; # Ensure `gysmo` is available in your nixpkgs
    config = {
      items = [
        {
          text = "Item 1";
          keyword = "kw1";
          icon = "icon1";
          value_color = "#ff0000";
          text_color = "#00ff00";
          icon_color = "#0000ff";
        }
        {
          text = "Item 2";
          value = "val2";
          icon = "icon2";
          value_color = "#ff00ff";
          text_color = "#00ffff";
          icon_color = "#ffff00";
        }
      ];
      ascii = {
        path = "/path/to/ascii";
        colors = "#ffffff";
        enabled = true;
        horizontal_padding = 2;
        vertical_padding = 2;
        position = "center";
      };
      header = {
        enabled = true;
        line = "Header Line";
        text = true;
        text_color = "#ff00ff";
        line_color = "#00ffff";
      };
      footer = {
        enabled = true;
        line = "Footer Line";
        text = true;
        text_color = "#ffff00";
        line_color = "#ff00ff";
      };
      general = {
        menu_type = "box";
        columns = true;
        menu_padding = 5;
      };
    };
  };
}
