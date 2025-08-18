{ lib }:

let
  color = name: hex: { inherit name hex; };
in
{
  foreground = color "foreground" "#ffffff";
  background = color "background" "#14161b";
  selection_foreground = color "selection_forground" "#000000";
  selection_background = color "selection_background" "#FFFACD";
  cursor     = color "cursor"     "#ffffff";
  red        = color "red"        "#e55c74";
  green      = color "green"      "#6dd797";
  yellow     = color "yellow"     "#eed891";
  blue       = color "blue"       "#4fa6ed";
  magenta    = color "magenta"    "#DF215A";
  cyan       = color "cyan"       "#56b6c2";
  white      = color "white"      "#dcdfe4";
}

