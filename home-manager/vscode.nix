# Need to write in nix 

{
  "redhat.telemetry.enabled": false,
    "editor.codeActionsOnSave": {
    },

    "files.autoSave": "afterDelay",
    
    "workbench.colorCustomizations": {
        
        "editorCursor.foreground": "#ffffff",
        "terminalCursor.foreground": "#e6e6e8",
        "activityBar.background": "#0d1925",
        "editor.background": "#14161b",
        "panel.background": "#14161b",
        "terminal.background": "#14161b",
        "sideBar.background": "#14161b",
        "input.background": "#14161b",
        "editorLineNumber.activeForeground": "#eed891",
        "editorGutter.background": "#14161b",
        "editor.lineHighlightBackground": "#212020",
    },
    "editor.renderWhitespace": "none",


    // "workbench.statusBar.visible": false,
    "editor.minimap.enabled": false,
    "breadcrumbs.enabled": false,
    "workbench.iconTheme": "material-icon-theme",
    "update.showReleaseNotes": false,
    "zenMode.hideLineNumbers": false,
    "editor.lineNumbers": "relative",

    "vim.useSystemClipboard": true,
    "vim.leader": "<Space>",
    "vim.hlsearch": true,
    "vim.normalModeKeyBindingsNonRecursive": [
      // NAVIGATION
      { "before": ["<S-h>"], "commands": [":bprevious"] },
      { "before": ["<S-l>"], "commands": [":bnext"] },
  
      {
          "before": ["s"],
          "commands": ["leap.findForward"]
      },
      {
          "before": ["S"],
          "commands": ["leap.findBackward"]
      },
      // splits
      { "before": ["leader", "v"], "commands": [":vsplit"] },
      { "before": ["leader", "s"], "commands": [":split"] },
  
      // panes
      {
        "before": ["leader", "h"],
        "commands": ["workbench.action.focusLeftGroup"]
      },
      {
        "before": ["leader", "j"],
        "commands": ["workbench.action.focusBelowGroup"]
      },
      {
        "before": ["leader", "k"],
        "commands": ["workbench.action.focusAboveGroup"]
      },
      {
        "before": ["leader", "l"],
        "commands": ["workbench.action.focusRightGroup"]
      },
      // NICE TO HAVE
      { "before": ["leader", "w"], "commands": [":w!"] },
      { "before": ["leader", "q"], "commands": [":q!"] },
      { "before": ["leader", "x"], "commands": [":x!"] },
      {
        "before": ["[", "d"],
        "commands": ["editor.action.marker.prev"]
      },
      {
        "before": ["]", "d"],
        "commands": ["editor.action.marker.next"]
      },
      {
        "before": ["<leader>", "c", "a"],
        "commands": ["editor.action.quickFix"]
      },
      { "before": ["leader", "f"], "commands": ["workbench.action.quickOpen"] },
      { "before": ["leader", "p"], "commands": ["editor.action.formatDocument"] },
      {
        "before": ["g", "h"],
        "commands": ["editor.action.showDefinitionPreviewHover"]
      },
      // toggle comment selection
      { "before": ["g", "c", "c"], "commands": ["editor.action.commentLine"] }
    ],
    "vim.visualModeKeyBindings": [
      // Stay in visual mode while indenting
      { "before": ["<"], "commands": ["editor.action.outdentLines"] },
      { "before": [">"], "commands": ["editor.action.indentLines"] },
      // Move selected lines while staying in visual mode
      { "before": ["J"], "commands": ["editor.action.moveLinesDownAction"] },
      { "before": ["K"], "commands": ["editor.action.moveLinesUpAction"] },
      // toggle comment selection
      { "before": ["g", "c"], "commands": ["editor.action.commentLine"] }
    ],
    "go.toolsManagement.autoUpdate": true,
    "[typescript]": {
      "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[jsonc]": {
      "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "workbench.activityBar.location": "hidden",
    "editor.fontLigatures": true,
    "editor.fontFamily": "JetBrainsMono Nerd Font Mono",
    "window.zoomLevel": 1,
    "workbench.colorTheme": "Atom One Dark"

}
