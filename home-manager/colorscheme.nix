{ lib, ... }:

let
  color = name: hex: { inherit name hex; };
in
# everforest
{
  fg = color "foreground" "#D3C6AA";
  bg = color "background" "#14161b";
  foreground = color "foreground" "#D3C6AA";
  background = color "background" "#14161b";
  selection_foreground = color "selection_forground" "#000000";
  selection_background = color "selection_background" "#FFFACD";
  cursor     = color "cursor"     "#ffffff";
  black      = color "black"      "#212026";
  red        = color "red"        "#E67E80";
  green      = color "green"      "#A7C080";
  yellow     = color "yellow"     "#DBBC7F";
  blue       = color "blue"       "#7FBBB3";
  blue_alt   = color "blue_alt"   "#0bc9cf";
  magenta    = color "magenta"    "#D699B6";
  cyan       = color "cyan"       "#83C092";
  purple     = color "purple"     "#E69875";
  white      = color "white"      "#D3C6AA";
}

# kaolic678ddn
# {
#   fg = color "foreground" "#ffffff";
#   bg = color "background" "#14161b";
#   foreground = color "foreground" "#ffffff";
#   background = color "background" "#14161b";
#   selection_foreground = color "selection_forground" "#000000";
#   selection_background = color "selection_background" "#FFFACD";
#   cursor     = color "cursor"     "#ffffff";
#   black      = color "black"      "#212026";
#   red        = color "red"        "#e55c74";
#   green      = color "green"      "#6dd797";
#   yellow     = color "yellow"     "#eed891";
#   blue       = color "blue"       "#4fa6ed";
#   blue_alt   = color "blue_alt"   "#0bc9cf";
#   magenta    = color "magenta"    "#DF215A";
#   cyan       = color "cyan"       "#56b6c2";
#   purple     = color "purple"     "#c678dd";
#   white      = color "white"      "#dcdfe4";
# }
