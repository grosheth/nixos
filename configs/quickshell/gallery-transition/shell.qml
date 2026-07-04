import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

ShellRoot {
  id: root

  property bool overlayVisible: false
  property bool transitionDispatched: false
  property int targetWorkspace: 12
  property int dimDuration: 320
  property int relightDuration: 460
  property color lightTint: "#fff4dc"
  property color darkTint: "#8db8ff"
  property string mainScreen: "DP-3"
  property string wallpaperOutput: "DP-3"

  function isLightWorkspace(ws) {
    return (ws >= 1 && ws <= 5) || ws === 11;
  }

  function galleryImage(ws) {
    if (ws >= 1 && ws <= 5)
      return "file:///home/salledelavage/.config/quickshell/gallery-transition/white-painting-" + String(ws) + ".png";
    if (ws >= 6 && ws <= 10)
      return "file:///home/salledelavage/.config/quickshell/gallery-transition/dark-painting-" + String(ws - 5) + ".png";
    if (isLightWorkspace(ws))
      return "file:///home/salledelavage/.config/quickshell/gallery-transition/light-gallery.png";

    return "file:///home/salledelavage/.config/quickshell/gallery-transition/dark-gallery.png";
  }

  function wallpaperImage(ws) {
    if (ws >= 1 && ws <= 5)
      return "$HOME/.config/quickshell/gallery-transition/white-painting-" + String(ws) + ".png";
    if (ws >= 6 && ws <= 10)
      return "$HOME/.config/quickshell/gallery-transition/dark-painting-" + String(ws - 5) + ".png";
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
          color: "transparent"

          Image {
            id: gallery
            anchors.fill: parent
            fillMode: Image.Stretch
            smooth: true
            source: root.galleryImage(root.targetWorkspace)
            opacity: 0
          }

          Rectangle {
            id: tint
            anchors.fill: parent
            color: root.isLightWorkspace(root.targetWorkspace) ? root.lightTint : root.darkTint
            opacity: 0
          }

          Rectangle {
            id: blackout
            anchors.fill: parent
            color: "black"
            opacity: 0
          }
        }

        SequentialAnimation {
          id: fadeAnimation

          ScriptAction {
            script: {
              gallery.opacity = 0;
              tint.opacity = 0;
              blackout.opacity = 0;
              tint.color = root.isLightWorkspace(root.targetWorkspace) ? root.lightTint : root.darkTint;
              gallery.source = root.galleryImage(root.targetWorkspace);
            }
          }

          ParallelAnimation {
            NumberAnimation {
              target: blackout
              property: "opacity"
              to: 1
              duration: root.dimDuration
              easing.type: Easing.InOutCubic
            }

            SequentialAnimation {
              PauseAnimation {
                duration: 80
              }

              NumberAnimation {
                target: tint
                property: "opacity"
                to: 0.16
                duration: root.dimDuration - 80
                easing.type: Easing.InOutCubic
              }
            }
          }

          ScriptAction {
            script: root.commitTransition()
          }

          PauseAnimation {
            duration: 80
          }

          ParallelAnimation {
            NumberAnimation {
              target: gallery
              property: "opacity"
              to: 1
              duration: root.relightDuration
              easing.type: Easing.OutCubic
            }

            NumberAnimation {
              target: blackout
              property: "opacity"
              to: 0
              duration: root.relightDuration
              easing.type: Easing.OutCubic
            }

            SequentialAnimation {
              PauseAnimation {
                duration: root.relightDuration * 0.45
              }

              NumberAnimation {
                target: tint
                property: "opacity"
                to: 0
                duration: root.relightDuration * 0.55
                easing.type: Easing.OutCubic
              }
            }
          }

          ScriptAction {
            script: {
              gallery.opacity = 0;
              tint.opacity = 0;
              blackout.opacity = 0;
              root.overlayVisible = false;
            }
          }
        }
      }
    }
  }
}
