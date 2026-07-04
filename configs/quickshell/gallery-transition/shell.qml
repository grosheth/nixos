import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

ShellRoot {
  id: root

  property bool overlayVisible: false
  property bool transitionDispatched: false
  property int targetWorkspace: 12
  property int fadeDuration: 260
  property string mainScreen: "DP-3"
  property string wallpaperOutput: "DP-3"

  function isLightWorkspace(ws) {
    return (ws >= 1 && ws <= 5) || ws === 11;
  }

  function galleryImage(ws) {
    if (isLightWorkspace(ws))
      return "file:///home/salledelavage/.config/quickshell/gallery-transition/light-gallery.png";

    return "file:///home/salledelavage/.config/quickshell/gallery-transition/dark-gallery.png";
  }

  function wallpaperImage(ws) {
    if (isLightWorkspace(ws))
      return "$HOME/.config/quickshell/gallery-transition/light-gallery.png";

    return "$HOME/.config/quickshell/gallery-transition/dark-gallery.png";
  }

  function enter(ws) {
    if (overlayVisible)
      return;

    targetWorkspace = ws;
    transitionDispatched = false;
    overlayVisible = true;
  }

  function commitTransition() {
    if (transitionDispatched)
      return;

    transitionDispatched = true;

    galleryThemeProc.command = ["gallery-theme", String(targetWorkspace)];
    galleryThemeProc.running = true;

    signatureProc.command = [
      "qs",
      "ipc",
      "-c",
      "gallery-status",
      "call",
      "status",
      "set",
      String(targetWorkspace)
    ];
    signatureProc.running = true;

    wallpaperProc.command = [
      "sh",
      "-c",
      "awww img --transition-type none --resize stretch --outputs " + root.wallpaperOutput + " " + wallpaperImage(targetWorkspace)
    ];
    wallpaperProc.running = true;

    switchWorkspaceProc.command = [
      "hyprctl",
      "dispatch",
      "workspace",
      String(targetWorkspace)
    ];
    switchWorkspaceProc.running = true;
  }

  IpcHandler {
    target: "gallery"

    function enter(ws: int): void {
      root.enter(ws);
    }
  }

  Process {
    id: switchWorkspaceProc
  }

  Process {
    id: wallpaperProc
  }

  Process {
    id: galleryThemeProc
  }

  Process {
    id: signatureProc
  }

  Variants {
    model: Quickshell.screens

    delegate: Component {
      PanelWindow {
        id: win

        required property var modelData
        property bool isMainScreen: modelData.name === root.mainScreen

        screen: modelData
        visible: isMainScreen && root.overlayVisible
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        focusable: false

        anchors {
          top: true
          bottom: true
          left: true
          right: true
        }

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "gallery-transition"

        onVisibleChanged: {
          if (visible && isMainScreen)
            fadeAnimation.restart();
        }

        Rectangle {
          id: scene
          anchors.fill: parent
          color: "black"
          opacity: 0

          Image {
            id: gallery
            anchors.fill: parent
            fillMode: Image.Stretch
            smooth: true
            source: root.galleryImage(root.targetWorkspace)
          }
        }

        SequentialAnimation {
          id: fadeAnimation

          ScriptAction {
            script: {
              scene.opacity = 0;
              gallery.source = root.galleryImage(root.targetWorkspace);
            }
          }

          NumberAnimation {
            target: scene
            property: "opacity"
            to: 1
            duration: root.fadeDuration
            easing.type: Easing.InOutCubic
          }

          ScriptAction {
            script: root.commitTransition()
          }

          PauseAnimation {
            duration: 80
          }

          NumberAnimation {
            target: scene
            property: "opacity"
            to: 0
            duration: root.fadeDuration
            easing.type: Easing.InOutCubic
          }

          ScriptAction {
            script: root.overlayVisible = false
          }
        }
      }
    }
  }
}
