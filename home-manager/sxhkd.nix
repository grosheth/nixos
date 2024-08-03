{ pkgs, ... }:
# Keyboard daemon for bspwm
{
  home.packages = with pkgs; [
    sxhkd 
  ];

  services.sxhkd = {
    enable = true;
    keybindings = {
      "alt + Return" = "kitty";
      "alt + @space" = "rofi -show drun";
      "alt + q" = "rofi -show ssh";
      "alt + v" = "bash rofi-vpn";
      "alt + p" = "bash rofi-projects";
      "alt + d" = "dmenu_run";
      "alt + c" = "bspc node -c";
      "alt + t" = "bspc node -t tiled";
      "alt + f" = "bspc node -t fullscreen";
      "alt + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";
      "alt + bracket{left,right}" = "bspc desktop -f {prev,next}.local";
      "alt + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";
      "alt + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";
      "alt + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";

      "ctrl + w" = "rofi -show window";
      "ctrl + Escape" = "pkill -USR1 -x sxhkd";
    };
  };
}
