{ config, pkgs, ... }:
let
  gysmoConfig = ''
    {
      "items": [
        {
          "text": "User",
          "keyword": "user",
          "icon": "",
          "value_color": "red",
          "text_color": "",
          "icon_color": "red"
        },
        {
          "text": "Kernel",
          "keyword": "kernel",
          "icon": "󰌽",
          "value_color": "",
          "text_color": "",
          "icon_color": ""
        },
        {
          "text": "WM",
          "keyword": "wm",
          "icon": "󱂬",
          "value_color": "yellow",
          "text_color": "",
          "icon_color": "yellow"
        },
        {
          "text": "GPU",
          "keyword": "gpu",
          "icon": "",
          "value_color": "green",
          "text_color": "",
          "icon_color": "green"
        },
        {
          "text": "Term",
          "keyword": "term",
          "icon": "",
          "value_color": "blue",
          "text_color": "",
          "icon_color": "blue"
        },
        {
          "text": "CPU",
          "value": "Intel(R) Core(TM) i7-10700K",
          "icon": "",
          "value_color": "red",
          "text_color": "",
          "icon_color": "red"
        },
        {
          "text": "OS",
          "value": "NixOs",
          "icon": "",
          "value_color": "",
          "text_color": "",
          "icon_color": ""
        },
        {
          "text": "RAM",
          "keyword": "ram",
          "icon": "",
          "value_color": "yellow",
          "text_color": "",
          "icon_color": "yellow"
        },
        {
          "text": "Shell",
          "value": "zsh",
          "icon": "",
          "value_color": "green",
          "text_color": "",
          "icon_color": "green"
        },
        {
          "text": "Uptime",
          "keyword": "uptime",
          "icon": "󱑆",
          "value_color": "blue",
          "text_color": "",
          "icon_color": "blue"
        }
      ],
      "ascii": {
        "path": "salledelavage",
        "colors": "",
        "enabled": true,
        "horizontal_padding": 2,
        "vertical_padding": 0,
        "position": "top"
      },
      "header": {
        "enabled": false,
        "text": "NixOS",
        "text_color": "purple",
        "line": true,
        "line_color": ""
      },
      "footer": {
        "enabled": false,
        "text": "gysmo",
        "text_color": "blue",
        "line": true,
        "line_color": ""
      },
      "general": {
        "menu_type": "box",
        "columns": false,
        "menu_padding": 2
      }
    }
  '';

  asciiConfig2 = ''
 ______   ________   __       __       ______                    
/_____/\ /_______/\ /_/\     /_/\     /_____/\                   
\::::_\/_\::: _  \ \\:\ \    \:\ \    \::::_\/_                  
 \:\/___/\\::(_)  \ \\:\ \    \:\ \    \:\/___/\                 
  \_::._\:\\:: __  \ \\:\ \____\:\ \____\::___\/_                
    /____\:\\:.\ \  \ \\:\/___/\\:\/___/\\:\____/\               
    \_____\/ \__\/\__\/ \_____\/ \_____\/ \_____\/               
               /_____/\ /_____/\                                 
               \:::_ \ \\::::_\/_                                
                \:\ \ \ \\:\/___/\                               
                 \:\ \ \ \\::___\/_                              
                  \:\/.:| |\:\____/\                             
 __       ________ \____/_/_\_____\/___   _______    ______      
/_/\     /_______/\ /_/\ /_/\ /_______/\ /______/\  /_____/\     
\:\ \    \::: _  \ \\:\ \\ \ \\::: _  \ \\::::__\/__\::::_\/_    
 \:\ \    \::(_)  \ \\:\ \\ \ \\::(_)  \ \\:\ /____/\\:\/___/\   
  \:\ \____\:: __  \ \\:\_/.:\ \\:: __  \ \\:\\_  _\/ \::___\/_  
   \:\/___/\\:.\ \  \ \\ ..::/ / \:.\ \  \ \\:\_\ \ \  \:\____/\ 
    \_____\/ \__\/\__\/ \___/_(   \__\/\__\/ \_____\/   \_____\/
  '';
  asciiConfig = ''
   ___       ___       ___       ___       ___   
  /\  \     /\__\     /\  \     /\__\     /\  \  
 /::\  \   |::L__L   /::\  \   /::L_L_   /::\  \ 
/:/\:\__\  |:::\__\ /\:\:\__\ /:/L:\__\ /:/\:\__\
\:\:\/__/  /:;;/__/ \:\:\/__/ \/_/:/  / \:\/:/  /
 \::/  /   \/__/     \::/  /    /:/  /   \::/  / 
  \/__/               \/__/     \/__/     \/__/ 
  '';
in
{
  home.file.".config/gysmo/config/config.json".text = gysmoConfig;
  home.file.".config/gysmo/ascii/gysmo".text = asciiConfig;
  home.file.".config/gysmo/ascii/salledelavage".text = asciiConfig2;
}
