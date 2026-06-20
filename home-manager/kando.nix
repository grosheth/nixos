{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kando
  ];
}
