{ config, pkgs, ... }:

let
  # Import the local nixpkgs repository
  localPkgs = import /home/salledelavage/work/nixpkgs {};

  # Import the local home-manager repository
  homeManager = import /home/salledelavage/work/home-manager {
    pkgs = localPkgs;
    # Add any other necessary arguments here
  };
in
{
  # Use the home-manager module
  imports = [
    homeManager.home-manager.nixosModules.home-manager
  ];

  home-manager.users.salledelavage = { pkgs, ... }: {
    programs.gysmo = {
      enable = true;
      package = pkgs.gysmo;
      config = {
        items = [
          {
            text = "Item 1";
            keyword = "kw1";
            icon = "icon1";
            valueColor = "#ff0000";
            textColor = "#00ff00";
            iconColor = "#0000ff";
          }
          {
            text = "Item 2";
            value = "val2";
            icon = "icon2";
            valueColor = "#ff00ff";
            textColor = "#00ffff";
            iconColor = "#ffff00";
          }
        ];
        ascii = {
          path = "/path/to/ascii";
          colors = "#ffffff";
          enabled = true;
          horizontalPadding = 2;
          verticalPadding = 2;
          position = "center";
        };
        header = {
          enabled = true;
          line = "Header Line";
          text = true;
          textColor = "#ff00ff";
          lineColor = "#00ffff";
        };
        footer = {
          enabled = true;
          line = "Footer Line";
          text = true;
          textColor = "#ffff00";
          lineColor = "#ff00ff";
        };
        general = {
          menuType = "box";
          columns = true;
          menuPadding = 5;
        };
      };
    };
  };
}
