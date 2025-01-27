{ pkgs, ... }:
let
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
                        "#cbb0f766",
                        "#b9c3fc66",
                        "#86caee66",
                        "#aee1b266",
                        "#f0e0bd66",
                        "#f1ba9d66",
                        "#eb9ab766"
                    ],
                    "background.appearance": "opaque",
                    "border": "#313244",
                    "border.variant": "#ffffff",
                    "border.focused": "#b4befe",
                    "border.selected": "#cba6f7",
                    "border.transparent": "#6dd797",
                    "border.disabled": "#6c7086",
                    "elevated_surface.background": "#18181b",
                    "surface.background": "#18181b",
                    "background": "#18181b",
                    "element.background": "#11111b",
                    "element.hover": "#45475a4d",
                    "element.active": "#585b704d",
                    "element.selected": "#3132444d",
                    "element.disabled": "#6c7086",
                    "drop_target.background": "#31324466",
                    "ghost_element.background": "#11111b59",
                    "ghost_element.hover": "#45475a4d",
                    "ghost_element.active": "#585b7099",
                    "ghost_element.selected": "#e6e6e81a",
                    "ghost_element.disabled": "#6c7086",
                    "text": "#e6e6e8",
                    "text.muted": "#bac2de",
                    "text.placeholder": "#585b70",
                    "text.disabled": "#45475a",
                    "text.accent": "#cba6f7",
                    "icon": "#e6e6e8",
                    "icon.muted": "#7f849c",
                    "icon.disabled": "#6c7086",
                    "icon.placeholder": "#585b70",
                    "icon.accent": "#cba6f7",
                    "status_bar.background": "#11111b",
                    "title_bar.background": "#11111b",
                    "title_bar.inactive_background": "#11111bd9",
                    "toolbar.background": "#18181b",
                    "tab_bar.background": "#11111b",
                    "tab.inactive_background": "#0b0b11",
                    "tab.active_background": "#18181b",
                    "search.match_background": "#6bd9db33",
                    "panel.background": "#18181b",
                    "panel.focused_border": "#e6e6e8",
                    "panel.indent_guide": "#31324499",
                    "panel.indent_guide_active": "#585b70",
                    "panel.indent_guide_hover": "#cba6f7",
                    "pane.focused_border": "#e6e6e8",
                    "pane_group.border": "#313244",
                    "scrollbar.thumb.background": "#cba6f733",
                    "scrollbar.thumb.hover_background": "#6c7086",
                    "scrollbar.thumb.border": "#e6e6e8",
                    "scrollbar.track.background": null,
                    "scrollbar.track.border": "#e6e6e812",
                    "editor.foreground": "#e6e6e8",
                    "editor.background": "#18181b",
                    "editor.gutter.background": "#18181b",
                    "editor.subheader.background": "#18181b",
                    "editor.active_line.background": "#e6e6e80d",
                    "editor.highlighted_line.background": null,
                    "editor.line_number": "#7f849c",
                    "editor.active_line_number": "#ffffff",
                    "editor.invisible": "#9399b266",
                    "editor.wrap_guide": "#585b70",
                    "editor.active_wrap_guide": "#585b70",
                    "editor.document_highlight.bracket_background": "#f5e0dc40",
                    "editor.document_highlight.read_background": "#a6adc829",
                    "editor.document_highlight.write_background": "#a6adc829",
                    "editor.indent_guide": "#31324499",
                    "editor.indent_guide_active": "#585b70",
                    "terminal.background": "#18181b",
                    "terminal.ansi.background": "#18181b",
                    "terminal.foreground": "#e6e6e8",
                    "terminal.dim_foreground": "#7f849c",
                    "terminal.bright_foreground": "#e6e6e8",
                    "terminal.ansi.black": "#45475a",
                    "terminal.ansi.red": "#e55c74",
                    "terminal.ansi.green": "#6dd797",
                    "terminal.ansi.yellow": "#eed891",
                    "terminal.ansi.blue": "#0db9d7",
                    "terminal.ansi.magenta": "#f5c2e7",
                    "terminal.ansi.cyan": "#6bd9db",
                    "terminal.ansi.white": "#bac2de",
                    "terminal.ansi.bright_black": "#585b70",
                    "terminal.ansi.bright_red": "#e55c74",
                    "terminal.ansi.bright_green": "#6dd797",
                    "terminal.ansi.bright_yellow": "#eed891",
                    "terminal.ansi.bright_blue": "#0db9d7",
                    "terminal.ansi.bright_magenta": "#f5c2e7",
                    "terminal.ansi.bright_cyan": "#6bd9db",
                    "terminal.ansi.bright_white": "#a6adc8",
                    "terminal.ansi.dim_black": "#45475a",
                    "terminal.ansi.dim_red": "#e55c74",
                    "terminal.ansi.dim_green": "#6dd797",
                    "terminal.ansi.dim_yellow": "#eed891",
                    "terminal.ansi.dim_blue": "#0db9d7",
                    "terminal.ansi.dim_magenta": "#f5c2e7",
                    "terminal.ansi.dim_cyan": "#6bd9db",
                    "terminal.ansi.dim_white": "#bac2de",
                    "link_text.hover": "#89dceb",
                    "conflict": "#eed891",
                    "conflict.border": "#eed891",
                    "conflict.background": "#18181b",
                    "created": "#6dd797",
                    "created.border": "#6dd797",
                    "created.background": "#18181b",
                    "deleted": "#e55c74",
                    "deleted.border": "#e55c74",
                    "deleted.background": "#18181b",
                    "hidden": "#6c7086",
                    "hidden.border": "#6c7086",
                    "hidden.background": "#18181b",
                    "hint": "#585b70",
                    "hint.border": "#585b70",
                    "hint.background": "#18181b",
                    "ignored": "#6c7086",
                    "ignored.border": "#6c7086",
                    "ignored.background": "#18181b",
                    "modified": "#eed891",
                    "modified.border": "#eed891",
                    "modified.background": "#18181b",
                    "predictive": "#6c7086",
                    "predictive.border": "#b4befe",
                    "predictive.background": "#18181b",
                    "renamed": "#74c7ec",
                    "renamed.border": "#74c7ec",
                    "renamed.background": "#18181b",
                    "info": "#6bd9db",
                    "info.border": "#6bd9db",
                    "info.background": "#9399b233",
                    "warning": "#eed891",
                    "warning.border": "#eed891",
                    "warning.background": "#eed8911f",
                    "error": "#e55c74",
                    "error.border": "#e55c74",
                    "error.background": "#e55c741f",
                    "success": "#6dd797",
                    "success.border": "#6dd797",
                    "success.background": "#6dd7971f",
                    "unreachable": "#e55c74",
                    "unreachable.border": "#e55c74",
                    "unreachable.background": "#e55c741f",
                    "players": [
                        {
                            "cursor": "#ffffff",
                            "selection": "#585b7080",
                            "background": "#f5e0dc"
                        },
                        {
                            "cursor": "#cbb0f7",
                            "selection": "#cbb0f733",
                            "background": "#cbb0f7"
                        },
                        {
                            "cursor": "#b9c3fc",
                            "selection": "#b9c3fc33",
                            "background": "#b9c3fc"
                        },
                        {
                            "cursor": "#86caee",
                            "selection": "#86caee33",
                            "background": "#86caee"
                        },
                        {
                            "cursor": "#aee1b2",
                            "selection": "#aee1b233",
                            "background": "#aee1b2"
                        },
                        {
                            "cursor": "#f0e0bd",
                            "selection": "#f0e0bd33",
                            "background": "#f0e0bd"
                        },
                        {
                            "cursor": "#f1ba9d",
                            "selection": "#f1ba9d33",
                            "background": "#f1ba9d"
                        },
                        {
                            "cursor": "#eb9ab7",
                            "selection": "#eb9ab733",
                            "background": "#eb9ab7"
                        }
                    ],
                    "syntax": {
                        "variable": {
                            "color": "#e6e6e8",
                            "font_style": null,
                            "font_weight": null
                        },
                        "variable.builtin": {
                            "color": "#e55c74",
                            "font_style": null,
                            "font_weight": null
                        },
                        "variable.parameter": {
                            "color": "#eba0ac",
                            "font_style": null,
                            "font_weight": null
                        },
                        "variable.member": {
                            "color": "#ffffff",
                            "font_style": null,
                            "font_weight": null
                        },
                        "variable.special": {
                            "color": "#f5c2e7",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "constant": {
                            "color": "#fab387",
                            "font_style": null,
                            "font_weight": null
                        },
                        "constant.builtin": {
                            "color": "#fab387",
                            "font_style": null,
                            "font_weight": null
                        },
                        "constant.macro": {
                            "color": "#cba6f7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "module": {
                            "color": "#eed891",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "label": {
                            "color": "#74c7ec",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string": {
                            "color": "#6dd797",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.documentation": {
                            "color": "#6bd9db",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.regexp": {
                            "color": "#fab387",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.escape": {
                            "color": "#f5c2e7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.special": {
                            "color": "#f5c2e7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.special.path": {
                            "color": "#f5c2e7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.special.symbol": {
                            "color": "#f2cdcd",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.special.url": {
                            "color": "#f5e0dc",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "character": {
                            "color": "#6bd9db",
                            "font_style": null,
                            "font_weight": null
                        },
                        "character.special": {
                            "color": "#f5c2e7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "boolean": {
                            "color": "#fab387",
                            "font_style": null,
                            "font_weight": null
                        },
                        "number": {
                            "color": "#fab387",
                            "font_style": null,
                            "font_weight": null
                        },
                        "number.float": {
                            "color": "#fab387",
                            "font_style": null,
                            "font_weight": null
                        },
                        "type": {
                            "color": "#eed891",
                            "font_style": null,
                            "font_weight": null
                        },
                        "type.builtin": {
                            "color": "#cba6f7",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "type.definition": {
                            "color": "#eed891",
                            "font_style": null,
                            "font_weight": null
                        },
                        "type.interface": {
                            "color": "#eed891",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "type.super": {
                            "color": "#eed891",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "attribute": {
                            "color": "#fab387",
                            "font_style": null,
                            "font_weight": null
                        },
                        "property": {
                            "color": "#0db9d7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "function": {
                            "color": "#0db9d7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "function.builtin": {
                            "color": "#fab387",
                            "font_style": null,
                            "font_weight": null
                        },
                        "function.call": {
                            "color": "#0db9d7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "function.macro": {
                            "color": "#6bd9db",
                            "font_style": null,
                            "font_weight": null
                        },
                        "function.method": {
                            "color": "#0db9d7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "function.method.call": {
                            "color": "#0db9d7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "constructor": {
                            "color": "#f2cdcd",
                            "font_style": null,
                            "font_weight": null
                        },
                        "operator": {
                            "font_style": null,
                            "font_weight": 700
                        },
                        "keyword": {
                            "color": "#e55c74",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.modifier": {
                            "color": "#cba6f7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.type": {
                            "color": "#cba6f7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.coroutine": {
                            "color": "#cba6f7",
                            "font_style": null,
                            "font_weight": null,
                        },
                        "keyword.function": {
                            "color": "#cba6f7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.operator": {
                            "color": "#cba6f7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.import": {
                            "color": "#cba6f7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.repeat": {
                            "color": "#cba6f7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.return": {
                            "color": "#cba6f7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.debug": {
                            "color": "#cba6f7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.exception": {
                            "color": "#cba6f7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.conditional": {
                            "color": "#cba6f7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.conditional.ternary": {
                            "color": "#cba6f7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.directive": {
                            "color": "#f5c2e7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.directive.define": {
                            "color": "#f5c2e7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "keyword.export": {
                            "color": "#89dceb",
                            "font_style": null,
                            "font_weight": null
                        },
                        "punctuation": {
                            "color": "#9399b2",
                            "font_style": null,
                            "font_weight": null
                        },
                        "punctuation.delimiter": {
                            "color": "#9399b2",
                            "font_style": null,
                            "font_weight": null
                        },
                        "punctuation.bracket": {
                            "color": "#9399b2",
                            "font_style": null,
                            "font_weight": null
                        },
                        "punctuation.special": {
                            "color": "#f5c2e7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "punctuation.special.symbol": {
                            "color": "#f2cdcd",
                            "font_style": null,
                            "font_weight": null
                        },
                        "punctuation.list_marker": {
                            "color": "#6bd9db",
                            "font_style": null,
                            "font_weight": null
                        },
                        "comment": {
                            "color": "#9399b2",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "comment.doc": {
                            "color": "#9399b2",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "comment.documentation": {
                            "color": "#9399b2",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "comment.error": {
                            "color": "#e55c74",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "comment.warning": {
                            "color": "#eed891",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "comment.hint": {
                            "color": "#0db9d7",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "comment.todo": {
                            "color": "#f2cdcd",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "comment.note": {
                            "color": "#f5e0dc",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "diff.plus": {
                            "color": "#6dd797",
                            "font_style": null,
                            "font_weight": null
                        },
                        "diff.minus": {
                            "color": "#e55c74",
                            "font_style": null,
                            "font_weight": null
                        },
                        "tag": {
                            "color": "#0db9d7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "tag.attribute": {
                            "color": "#eed891",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "tag.delimiter": {
                            "color": "#6bd9db",
                            "font_style": null,
                            "font_weight": null
                        },
                        "parameter": {
                            "color": "#eba0ac",
                            "font_style": null,
                            "font_weight": null
                        },
                        "field": {
                            "color": "#b4befe",
                            "font_style": null,
                            "font_weight": null
                        },
                        "namespace": {
                            "color": "#eed891",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "float": {
                            "color": "#fab387",
                            "font_style": null,
                            "font_weight": null
                        },
                        "symbol": {
                            "color": "#f5c2e7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.regex": {
                            "color": "#fab387",
                            "font_style": null,
                            "font_weight": null
                        },
                        "text": {
                            "color": "#e6e6e8",
                            "font_style": null,
                            "font_weight": null
                        },
                        "emphasis.strong": {
                            "color": "#eba0ac",
                            "font_style": null,
                            "font_weight": 700
                        },
                        "emphasis": {
                            "color": "#eba0ac",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "embedded": {
                            "color": "#eba0ac",
                            "font_style": null,
                            "font_weight": null
                        },
                        "text.literal": {
                            "color": "#6dd797",
                            "font_style": null,
                            "font_weight": null
                        },
                        "concept": {
                            "color": "#74c7ec",
                            "font_style": null,
                            "font_weight": null
                        },
                        "enum": {
                            "color": "#6bd9db",
                            "font_style": null,
                            "font_weight": 700
                        },
                        "function.decorator": {
                            "color": "#fab387",
                            "font_style": null,
                            "font_weight": null
                        },
                        "type.class.definition": {
                            "color": "#eed891",
                            "font_style": null,
                            "font_weight": 700
                        },
                        "hint": {
                            "color": "#585b70",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "link_text": {
                            "color": "#0db9d7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "link_uri": {
                            "color": "#f5e0dc",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "parent": {
                            "color": "#fab387",
                            "font_style": null,
                            "font_weight": null
                        },
                        "predictive": {
                            "color": "#6c7086",
                            "font_style": null,
                            "font_weight": null
                        },
                        "predoc": {
                            "color": "#e55c74",
                            "font_style": null,
                            "font_weight": null
                        },
                        "primary": {
                            "color": "#eba0ac",
                            "font_style": null,
                            "font_weight": null
                        },
                        "tag.doctype": {
                            "color": "#cba6f7",
                            "font_style": null,
                            "font_weight": null
                        },
                        "string.doc": {
                            "color": "#6bd9db",
                            "font_style": "italic",
                            "font_weight": null
                        },
                        "title": {
                            "color": "#e6e6e8",
                            "font_style": null,
                            "font_weight": 800
                        },
                        "variant": {
                            "color": "#e55c74",
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
          "ctrl-shift-i" = "project_panel::TogggleFocus";
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
      buffer_font_size = 18;
      buffer_font_weight = 300;
      terminal = {
        font_size = 18;
        shell = "system";
        env = {
          TERM = "ghostty";
        };
      };
    };
    extensions = [ "nix" "dockerfile" "lua" ];
  };
}
