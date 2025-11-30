{ pkgs, ... }:
let
  # Import colorscheme
  colorscheme = import ./colorscheme.nix { inherit (pkgs) lib; };

  # Helper function to add alpha channel to hex color
  withAlpha = color: alpha: "${color}${alpha}";

  # Derived colors for UI elements (keeping some specific UI colors)
  # For colors not in colorscheme, we derive or keep sensible defaults
  uiColors = {
    border = "#313244";
    muted = "#7f849c";
    disabled = "#6c7086";
    hover = "#45475a";
    selected = "#585b70";
    accent_purple = "#cba6f7";
    accent_pink = "#f5c2e7";
    accent_blue = "#b4befe";
    accent_peach = "#fab387";
    accent_rosewater = "#f2cdcd";
    accent_flamingo = "#f5e0dc";
    accent_maroon = "#eba0ac";
    accent_sky = "#89dceb";
    accent_sapphire = "#74c7ec";
    punctuation = "#9399b2";
  };

  customTheme =
  ''
    {
        "$schema": "https://zed.dev/schema/themes/v0.2.0.json",
        "name": "Kaolin",
        "author": "Kaolin",
        "themes": [
            {
                "name": "Kaolin",
                "appearance": "dark",
                "style": {
                    "accents": [
                        "${withAlpha uiColors.accent_purple "66"}",
                        "${withAlpha uiColors.accent_blue "66"}",
                        "${withAlpha colorscheme.cyan.hex "66"}",
                        "${withAlpha colorscheme.green.hex "66"}",
                        "${withAlpha colorscheme.yellow.hex "66"}",
                        "${withAlpha colorscheme.purple.hex "66"}",
                        "${withAlpha colorscheme.magenta.hex "66"}"
                    ],
                    "background.appearance": "opaque",
                    "border": "${uiColors.border}",
                    "border.variant": "${colorscheme.cursor.hex}",
                    "border.focused": "${uiColors.accent_blue}",
                    "border.selected": "${uiColors.accent_purple}",
                    "border.transparent": "${colorscheme.green.hex}",
                    "border.disabled": "${uiColors.disabled}",
                    "elevated_surface.background": "${colorscheme.background.hex}",
                    "surface.background": "${colorscheme.background.hex}",
                    "background": "${colorscheme.background.hex}",
                    "element.background": "${colorscheme.black.hex}",
                    "element.hover": "${withAlpha uiColors.hover "4d"}",
                    "element.active": "${withAlpha uiColors.selected "4d"}",
                    "element.selected": "${withAlpha uiColors.border "4d"}",
                    "element.disabled": "${uiColors.disabled}",
                    "drop_target.background": "${withAlpha uiColors.border "66"}",
                    "ghost_element.background": "${withAlpha colorscheme.black.hex "59"}",
                    "ghost_element.hover": "${withAlpha uiColors.hover "4d"}",
                    "ghost_element.active": "${withAlpha uiColors.selected "99"}",
                    "ghost_element.selected": "${withAlpha colorscheme.white.hex "1a"}",
                    "ghost_element.disabled": "${uiColors.disabled}",
                    "text": "${colorscheme.foreground.hex}",
                    "text.muted": "${uiColors.muted}",
                    "text.placeholder": "${uiColors.selected}",
                    "text.disabled": "${uiColors.hover}",
                    "text.accent": "${uiColors.accent_purple}",
                    "icon": "${colorscheme.foreground.hex}",
                    "icon.muted": "${uiColors.muted}",
                    "icon.disabled": "${uiColors.disabled}",
                    "icon.placeholder": "${uiColors.selected}",
                    "icon.accent": "${uiColors.accent_purple}",
                    "status_bar.background": "${colorscheme.black.hex}",
                    "title_bar.background": "${colorscheme.black.hex}",
                    "title_bar.inactive_background": "${withAlpha colorscheme.black.hex "d9"}",
                    "toolbar.background": "${colorscheme.background.hex}",
                    "tab_bar.background": "${colorscheme.black.hex}",
                    "tab.inactive_background": "${colorscheme.black.hex}",
                    "tab.active_background": "${colorscheme.background.hex}",
                    "search.match_background": "${withAlpha colorscheme.cyan.hex "33"}",
                    "panel.background": "${colorscheme.background.hex}",
                    "panel.focused_border": "${colorscheme.foreground.hex}",
                    "panel.indent_guide": "${withAlpha uiColors.border "99"}",
                    "panel.indent_guide_active": "${uiColors.selected}",
                    "panel.indent_guide_hover": "${uiColors.accent_purple}",
                    "pane.focused_border": "${colorscheme.foreground.hex}",
                    "pane_group.border": "${uiColors.border}",
                    "scrollbar.thumb.background": "${withAlpha uiColors.accent_purple "33"}",
                    "scrollbar.thumb.hover_background": "${uiColors.disabled}",
                    "scrollbar.thumb.border": "${colorscheme.foreground.hex}",
                    "scrollbar.track.background": null,
                    "scrollbar.track.border": "${withAlpha colorscheme.foreground.hex "12"}",
                    "editor.foreground": "${colorscheme.foreground.hex}",
                    "editor.background": "${colorscheme.background.hex}",
                    "editor.gutter.background": "${colorscheme.background.hex}",
                    "editor.subheader.background": "${colorscheme.background.hex}",
                    "editor.active_line.background": "${withAlpha colorscheme.foreground.hex "0d"}",
                    "editor.highlighted_line.background": null,
                    "editor.line_number": "${uiColors.muted}",
                    "editor.active_line_number": "${colorscheme.cursor.hex}",
                    "editor.invisible": "${withAlpha uiColors.punctuation "66"}",
                    "editor.wrap_guide": "${uiColors.selected}",
                    "editor.active_wrap_guide": "${uiColors.selected}",
                    "editor.document_highlight.bracket_background": "${withAlpha uiColors.accent_flamingo "40"}",
                    "editor.document_highlight.read_background": "${withAlpha colorscheme.white.hex "29"}",
                    "editor.document_highlight.write_background": "${withAlpha colorscheme.white.hex "29"}",
                    "editor.indent_guide": "${withAlpha uiColors.border "99"}",
                    "editor.indent_guide_active": "${uiColors.selected}",
                    "terminal.background": "${colorscheme.background.hex}",
                    "terminal.ansi.background": "${colorscheme.background.hex}",
                    "terminal.foreground": "${colorscheme.foreground.hex}",
                    "terminal.dim_foreground": "${uiColors.muted}",
                    "terminal.bright_foreground": "${colorscheme.foreground.hex}",
                    "terminal.ansi.black": "${colorscheme.black.hex}",
                    "terminal.ansi.red": "${colorscheme.red.hex}",
                    "terminal.ansi.green": "${colorscheme.green.hex}",
                    "terminal.ansi.yellow": "${colorscheme.yellow.hex}",
                    "terminal.ansi.blue": "${colorscheme.blue.hex}",
                    "terminal.ansi.magenta": "${colorscheme.magenta.hex}",
                    "terminal.ansi.cyan": "${colorscheme.cyan.hex}",
                    "terminal.ansi.white": "${colorscheme.white.hex}",
                    "terminal.ansi.bright_black": "${uiColors.selected}",
                    "terminal.ansi.bright_red": "${colorscheme.red.hex}",
                    "terminal.ansi.bright_green": "${colorscheme.green.hex}",
                    "terminal.ansi.bright_yellow": "${colorscheme.yellow.hex}",
                    "terminal.ansi.bright_blue": "${colorscheme.blue.hex}",
                    "terminal.ansi.bright_magenta": "${colorscheme.magenta.hex}",
                    "terminal.ansi.bright_cyan": "${colorscheme.cyan.hex}",
                    "terminal.ansi.bright_white": "${colorscheme.white.hex}",
                    "terminal.ansi.dim_black": "${colorscheme.black.hex}",
                    "terminal.ansi.dim_red": "${colorscheme.red.hex}",
                    "terminal.ansi.dim_green": "${colorscheme.green.hex}",
                    "terminal.ansi.dim_yellow": "${colorscheme.yellow.hex}",
                    "terminal.ansi.dim_blue": "${colorscheme.blue.hex}",
                    "terminal.ansi.dim_magenta": "${colorscheme.magenta.hex}",
                    "terminal.ansi.dim_cyan": "${colorscheme.cyan.hex}",
                    "terminal.ansi.dim_white": "${colorscheme.white.hex}",
                    "link_text.hover": "${colorscheme.cyan.hex}",
                    "conflict": "${colorscheme.yellow.hex}",
                    "conflict.border": "${colorscheme.yellow.hex}",
                    "conflict.background": "${colorscheme.background.hex}",
                    "created": "${colorscheme.green.hex}",
                    "created.border": "${colorscheme.green.hex}",
                    "created.background": "${colorscheme.background.hex}",
                    "deleted": "${colorscheme.red.hex}",
                    "deleted.border": "${colorscheme.red.hex}",
                    "deleted.background": "${colorscheme.background.hex}",
                    "hidden": "${uiColors.disabled}",
                    "hidden.border": "${uiColors.disabled}",
                    "hidden.background": "${colorscheme.background.hex}",
                    "hint": "${uiColors.selected}",
                    "hint.border": "${uiColors.selected}",
                    "hint.background": "${colorscheme.background.hex}",
                    "ignored": "${uiColors.disabled}",
                    "ignored.border": "${uiColors.disabled}",
                    "ignored.background": "${colorscheme.background.hex}",
                    "modified": "${colorscheme.yellow.hex}",
                    "modified.border": "${colorscheme.yellow.hex}",
                    "modified.background": "${colorscheme.background.hex}",
                    "predictive": "${uiColors.disabled}",
                    "predictive.border": "${uiColors.accent_blue}",
                    "predictive.background": "${colorscheme.background.hex}",
                    "renamed": "${colorscheme.cyan.hex}",
                    "renamed.border": "${colorscheme.cyan.hex}",
                    "renamed.background": "${colorscheme.background.hex}",
                    "info": "${colorscheme.cyan.hex}",
                    "info.border": "${colorscheme.cyan.hex}",
                    "info.background": "${withAlpha uiColors.punctuation "33"}",
                    "warning": "${colorscheme.yellow.hex}",
                    "warning.border": "${colorscheme.yellow.hex}",
                    "warning.background": "${withAlpha colorscheme.yellow.hex "1f"}",
                    "error": "${colorscheme.red.hex}",
                    "error.border": "${colorscheme.red.hex}",
                    "error.background": "${withAlpha colorscheme.red.hex "1f"}",
                    "success": "${colorscheme.green.hex}",
                    "success.border": "${colorscheme.green.hex}",
                    "success.background": "${withAlpha colorscheme.green.hex "1f"}",
                    "unreachable": "${colorscheme.red.hex}",
                    "unreachable.border": "${colorscheme.red.hex}",
                    "unreachable.background": "${withAlpha colorscheme.red.hex "1f"}",
                    "players": [
                        {
                            "cursor": "${colorscheme.cursor.hex}",
                            "selection": "${withAlpha uiColors.selected "80"}",
                            "background": "${uiColors.accent_flamingo}"
                        },
                        {
                            "cursor": "${uiColors.accent_purple}",
                            "selection": "${withAlpha uiColors.accent_purple "33"}",
                            "background": "${uiColors.accent_purple}"
                        },
                        {
                            "cursor": "${uiColors.accent_blue}",
                            "selection": "${withAlpha uiColors.accent_blue "33"}",
                            "background": "${uiColors.accent_blue}"
                        },
                        {
                            "cursor": "${colorscheme.cyan.hex}",
                            "selection": "${withAlpha colorscheme.cyan.hex "33"}",
                            "background": "${colorscheme.cyan.hex}"
                        },
                        {
                            "cursor": "${colorscheme.green.hex}",
                            "selection": "${withAlpha colorscheme.green.hex "33"}",
                            "background": "${colorscheme.green.hex}"
                        },
                        {
                            "cursor": "${colorscheme.yellow.hex}",
                            "selection": "${withAlpha colorscheme.yellow.hex "33"}",
                            "background": "${colorscheme.yellow.hex}"
                        },
                        {
                            "cursor": "${colorscheme.purple.hex}",
                            "selection": "${withAlpha colorscheme.purple.hex "33"}",
                            "background": "${colorscheme.purple.hex}"
                        },
                        {
                            "cursor": "${colorscheme.magenta.hex}",
                            "selection": "${withAlpha colorscheme.magenta.hex "33"}",
                            "background": "${colorscheme.magenta.hex}"
                        }
                    ],
                    "syntax": {
                        "variable": {
                            "color": "${colorscheme.foreground.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "variable.builtin": {
                            "color": "${colorscheme.red.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "variable.parameter": {
                            "color": "${uiColors.accent_maroon}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "variable.member": {
                            "color": "${colorscheme.cursor.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "variable.special": {
                            "color": "${uiColors.accent_pink}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "constant": {
                            "color": "${colorscheme.purple.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "constant.builtin": {
                            "color": "${colorscheme.purple.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "constant.macro": {
                            "color": "${uiColors.accent_purple}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "module": {
                            "color": "${colorscheme.yellow.hex}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "label": {
                            "color": "${colorscheme.cyan.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string": {
                            "color": "${colorscheme.green.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.documentation": {
                            "color": "${colorscheme.cyan.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.regexp": {
                            "color": "${colorscheme.purple.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.escape": {
                            "color": "${uiColors.accent_pink}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.special": {
                            "color": "${uiColors.accent_pink}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.special.path": {
                            "color": "${uiColors.accent_pink}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.special.symbol": {
                            "color": "${uiColors.accent_rosewater}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.special.url": {
                            "color": "${uiColors.accent_flamingo}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "character": {
                            "color": "${colorscheme.cyan.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "character.special": {
                            "color": "${uiColors.accent_pink}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "boolean": {
                            "color": "${colorscheme.purple.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "number": {
                            "color": "${colorscheme.purple.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "number.float": {
                            "color": "${colorscheme.purple.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "type": {
                            "color": "${colorscheme.yellow.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "type.builtin": {
                            "color": "${uiColors.accent_purple}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "type.definition": {
                            "color": "${colorscheme.yellow.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "type.interface": {
                            "color": "${colorscheme.yellow.hex}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "type.super": {
                            "color": "${colorscheme.yellow.hex}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "attribute": {
                            "color": "${colorscheme.purple.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "property": {
                            "color": "${colorscheme.blue.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "function": {
                            "color": "${colorscheme.blue.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "function.builtin": {
                            "color": "${colorscheme.purple.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "function.call": {
                            "color": "${colorscheme.blue.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "function.macro": {
                            "color": "${colorscheme.cyan.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "function.method": {
                            "color": "${colorscheme.blue.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "function.method.call": {
                            "color": "${colorscheme.blue.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "constructor": {
                            "color": "${uiColors.accent_rosewater}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "operator": {
                            "font_style": null,
                            "font_weight": 700
                        },
                        "keyword": {
                            "color": "${colorscheme.red.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.modifier": {
                            "color": "${uiColors.accent_purple}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.type": {
                            "color": "${uiColors.accent_purple}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.coroutine": {
                            "color": "${uiColors.accent_purple}",
                            "font_style": null,
                            "font_weight": null,
                        },
                        "keyword.function": {
                            "color": "${uiColors.accent_purple}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.operator": {
                            "color": "${uiColors.accent_purple}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.import": {
                            "color": "${uiColors.accent_purple}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.repeat": {
                            "color": "${uiColors.accent_purple}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.return": {
                            "color": "${uiColors.accent_purple}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.debug": {
                            "color": "${uiColors.accent_purple}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.exception": {
                            "color": "${uiColors.accent_purple}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.conditional": {
                            "color": "${uiColors.accent_purple}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.conditional.ternary": {
                            "color": "${uiColors.accent_purple}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.directive": {
                            "color": "${uiColors.accent_pink}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.directive.define": {
                            "color": "${uiColors.accent_pink}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.export": {
                            "color": "${uiColors.accent_sky}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "punctuation": {
                            "color": "${uiColors.punctuation}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "punctuation.delimiter": {
                            "color": "${uiColors.punctuation}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "punctuation.bracket": {
                            "color": "${uiColors.punctuation}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "punctuation.special": {
                            "color": "${uiColors.accent_pink}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "punctuation.special.symbol": {
                            "color": "${uiColors.accent_rosewater}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "punctuation.list_marker": {
                            "color": "${colorscheme.cyan.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "comment": {
                            "color": "${uiColors.punctuation}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "comment.doc": {
                            "color": "${uiColors.punctuation}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "comment.documentation": {
                            "color": "${uiColors.punctuation}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "comment.error": {
                            "color": "${colorscheme.red.hex}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "comment.warning": {
                            "color": "${colorscheme.yellow.hex}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "comment.hint": {
                            "color": "${colorscheme.blue.hex}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "comment.todo": {
                            "color": "${uiColors.accent_rosewater}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "comment.note": {
                            "color": "${uiColors.accent_flamingo}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "diff.plus": {
                            "color": "${colorscheme.green.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "diff.minus": {
                            "color": "${colorscheme.red.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "tag": {
                            "color": "${colorscheme.blue.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "tag.attribute": {
                            "color": "${colorscheme.yellow.hex}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "tag.delimiter": {
                            "color": "${colorscheme.cyan.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "parameter": {
                            "color": "${uiColors.accent_maroon}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "field": {
                            "color": "${uiColors.accent_blue}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "namespace": {
                            "color": "${colorscheme.yellow.hex}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "float": {
                            "color": "${colorscheme.purple.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "symbol": {
                            "color": "${uiColors.accent_pink}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.regex": {
                            "color": "${colorscheme.purple.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "text": {
                            "color": "${colorscheme.foreground.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "emphasis.strong": {
                            "color": "${uiColors.accent_maroon}",
                            "font_style": null,
                            "font_weight": 700
                        },
                        "emphasis": {
                            "color": "${uiColors.accent_maroon}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "embedded": {
                            "color": "${uiColors.accent_maroon}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "text.literal": {
                            "color": "${colorscheme.green.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "concept": {
                            "color": "${uiColors.accent_sapphire}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "enum": {
                            "color": "${colorscheme.cyan.hex}",
                            "font_style": null,
                            "font_weight": 700
                        },
                        "function.decorator": {
                            "color": "${colorscheme.purple.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "type.class.definition": {
                            "color": "${colorscheme.yellow.hex}",
                            "font_style": null,
                            "font_weight": 700
                        },
                        "hint": {
                            "color": "${uiColors.selected}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "link_text": {
                            "color": "${colorscheme.blue.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "link_uri": {
                            "color": "${uiColors.accent_flamingo}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "parent": {
                            "color": "${colorscheme.purple.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "predictive": {
                            "color": "${uiColors.disabled}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "predoc": {
                            "color": "${colorscheme.red.hex}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "primary": {
                            "color": "${uiColors.accent_maroon}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "tag.doctype": {
                            "color": "${uiColors.accent_purple}",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.doc": {
                            "color": "${colorscheme.cyan.hex}",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "title": {
                            "color": "${colorscheme.foreground.hex}",
                            "font_style": null,
                            "font_weight": 800
                        },
                        "variant": {
                            "color": "${colorscheme.red.hex}",
                            "font_style": null,
                            "font_weight": null
                        }
                    }
                }
            }
        ]
    }
  '';
  customThemeName = "Kaolin.json";
in
{
  home.file.".config/zed/themes/${customThemeName}".text = customTheme;

  home.packages = with pkgs; [
    zed-editor
  ];

  programs.zed-editor = {
    enable = true;
    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          "ctrl-shift-j" = "workspace::ToggleBottomDock";
        };
      }
      {
        context = "Editor";
        bindings = {
          "ctrl-shift-j" = "terminal_panel::ToggleFocus";
        };
      }
      {
        context = "Terminal";
        bindings = {
          "ctrl-shift-j" = "workspace::ToggleBottomDock";
        };
      }
      {
        context = "Workspace";
        bindings = {
          "ctrl-shift-i" = "assistant::ToggleFocus";
        };
      }
    ];

    userSettings = {
      vim_mode = true;
      ui_font_size = 16;
      base_keymaps = "VSCode";
      assistant =  {
        default_model = {
          provider = "copilot_chat";
          model =  "gpt-4o";
        };
        version = "2";
      };
      theme = {
        mode = "dark";
        dark = "Kaolin";
        light = "Kaolin";
      };
      buffer_font_family = "JetBrainsMono Nerd Font";
      buffer_font_size = 15;
      buffer_font_weight = 300;
      terminal = {
        font_size = 15;
        shell = "system";
        env = {
          TERM = "ghostty";
        };
      };
    };
    extensions = [ "nix" "dockerfile" "lua" ];
  };
}
