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

# kaolin
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

# Gallery
# {
#   "name": "tragic_anime_bande_dessinee_gallery",
#   "description": "A muted but colorful anime / bande dessinée palette for a chaotic museum gallery: cool grey walls, warm polished wood, deep blues, antique gold frames, controlled ember orange, soft smoke, and tragic shadow tones.",
#   "overall_mood": {
#     "style": "smooth anime + bande dessinée",
#     "feeling": "beautiful, warm, slightly tragic, smoky, museum-like",
#     "contrast": "medium-high",
#     "saturation": "medium",
#     "temperature": "warm floor and fire balanced with cool blue/grey shadows"
#   },
#   "base_palette": {
#     "wall_shadow_taupe": "#4f4642",
#     "wall_mid_taupe": "#6f625b",
#     "wall_soft_grey": "#8a8179",
#     "wall_light_plaster": "#b8aa9b",
#     "ceiling_highlight": "#d5c6b2",
#     "ink_linework": "#1e1b1a"
#   },
#   "floor_palette": {
#     "dark_parquet_shadow": "#30241f",
#     "burnt_wood_brown": "#5f3828",
#     "warm_parquet_mid": "#8a5437",
#     "polished_wood_reflection": "#a66a43",
#     "soft_gold_reflection": "#c18755",
#     "floor_highlight": "#d3a06e"
#   },
#   "painting_palette": {
#     "deep_gallery_blue": "#123f59",
#     "muted_ocean_blue": "#1e5d78",
#     "clear_sky_blue": "#3d86a7",
#     "cream_paint": "#d8c6a7",
#     "aged_white": "#efe0c3",
#     "tragic_crimson": "#9d352f",
#     "dark_red_shadow": "#5b2525",
#     "forest_green": "#24382f",
#     "pine_shadow": "#182320",
#     "muted_flower_red": "#a14232",
#     "soft_floral_pink": "#c69781"
#   },
#   "frame_palette": {
#     "antique_gold_dark": "#4b311d",
#     "antique_gold_mid": "#8b5b28",
#     "antique_gold_light": "#b9853d",
#     "thin_gold_highlight": "#d1a55a"
#   },
#   "chaos_objects": {
#     "museum_bin_dark_grey": "#343839",
#     "museum_bin_panel_grey": "#5a5b56",
#     "museum_bin_highlight": "#78766c",
#     "black_boot": "#11171b",
#     "boot_highlight": "#353a3d",
#     "bench_black_leather": "#131619",
#     "bench_soft_highlight": "#3b3e40",
#     "terracotta_pot": "#8f4e33",
#     "pot_shadow": "#4a2b20",
#     "soil_dark": "#241a12",
#     "plant_leaf_dark": "#28351d",
#     "plant_leaf_mid": "#4d5c2f",
#     "plant_leaf_highlight": "#788347",
#     "paper_warm_white": "#d9d2c4",
#     "paper_shadow": "#a79f91"
#   },
#   "smoke_and_fire": {
#     "smoke_dark": "#333435",
#     "smoke_mid": "#666867",
#     "smoke_soft_grey": "#9a9891",
#     "smoke_light": "#c4beb3",
#     "charcoal_black": "#171312",
#     "ember_dark_orange": "#8e331c",
#     "fire_orange": "#d65a20",
#     "fire_gold": "#f0a24b",
#     "small_flame_core": "#ffd28a"
#   },
#   "lighting": {
#     "warm_spotlight": "#e0b46f",
#     "soft_sky_light": "#c8d2d7",
#     "cool_shadow_blue": "#252d34",
#     "ambient_shadow": "#2d2928",
#     "glow_on_floor": "#b76f3f"
#   },
#   "recommended_gradient_backgrounds": {
#     "wall_gradient": ["#8a8179", "#6f625b", "#4f4642"],
#     "floor_gradient": ["#c18755", "#8a5437", "#30241f"],
#     "smoke_gradient": ["#c4beb3", "#666867", "#333435"],
#     "fire_glow_gradient": ["#ffd28a", "#d65a20", "#8e331c", "#171312"]
#   },
#   "css_variables": {
#     "--gallery-wall-shadow": "#4f4642",
#     "--gallery-wall-mid": "#6f625b",
#     "--gallery-wall-light": "#b8aa9b",
#     "--gallery-ink": "#1e1b1a",
#     "--floor-dark": "#30241f",
#     "--floor-mid": "#8a5437",
#     "--floor-reflection": "#a66a43",
#     "--painting-blue": "#1e5d78",
#     "--painting-red": "#9d352f",
#     "--painting-cream": "#d8c6a7",
#     "--frame-gold": "#b9853d",
#     "--smoke-mid": "#666867",
#     "--fire-orange": "#d65a20",
#     "--ember-gold": "#f0a24b",
#     "--bench-black": "#131619",
#     "--plant-green": "#4d5c2f",
#     "--terracotta-pot": "#8f4e33"
#   }
# }
