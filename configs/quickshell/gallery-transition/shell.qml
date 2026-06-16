import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

ShellRoot {
  id: root

  property bool overlayVisible: false
  property bool workspaceSwitchDispatched: false
  property bool wallpaperDispatched: false
  property int targetWorkspace: 1
  property real zoomX: 0.5
  property real zoomY: 0.5
  property real zoomScale: 3.5
  property string galleryImage: "schoolofathens.jpg"
  property string mainScreen: "DP-3"
  property string wallpaperOutput: "DP-3"

  function paintingX(ws) {
    if (ws === 1) return 0.25;
    if (ws === 2) return 0.50;
    if (ws === 3) return 0.75;
    return 0.50;
  }

  function paintingY(ws) {
    if (ws === 1) return 0.45;
    if (ws === 2) return 0.42;
    if (ws === 3) return 0.48;
    return 0.50;
  }

  function paintingScale(ws) {
    if (ws === 1) return 3.2;
    if (ws === 2) return 3.8;
    if (ws === 3) return 3.4;
    if (ws === 10) return 1.0;
    return 3.5;
  }

  function wallpaperImage(ws) {
    if (ws >= 1 && ws <= 6)
      return "$HOME/.config/quickshell/gallery-transition/painting-" + String(ws) + ".png";

    return "$HOME/.config/quickshell/gallery-transition/gallery.png";
  }

  function enter(ws) {
    if (overlayVisible)
      return;

    targetWorkspace = ws === 0 ? 10 : ws;
    workspaceSwitchDispatched = false;
    wallpaperDispatched = false;
    zoomX = paintingX(targetWorkspace);
    zoomY = paintingY(targetWorkspace);
    zoomScale = paintingScale(targetWorkspace);
    overlayVisible = true;
  }

  function updateWallpaper() {
    if (wallpaperDispatched)
      return;

    wallpaperDispatched = true;
    wallpaperProc.command = [
      "sh",
      "-c",
      "awww img --outputs " + root.wallpaperOutput + " " + wallpaperImage(targetWorkspace)
    ];
    wallpaperProc.running = true;
  }

  function switchWorkspace() {
    if (workspaceSwitchDispatched)
      return;

    workspaceSwitchDispatched = true;
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
            enterAnimation.restart();
        }

        Rectangle {
          id: scene
          anchors.fill: parent
          color: "black"

          Item {
            id: camera
            anchors.fill: parent
            clip: true
            visible: win.isMainScreen

            Image {
              id: gallery
              source: root.galleryImage
              width: camera.width
              height: camera.height
              fillMode: Image.Stretch
              smooth: true
              transformOrigin: Item.TopLeft
            }
          }

        }

        SequentialAnimation {
          id: enterAnimation

          ScriptAction {
            script: {
              gallery.scale = 1.0;
              gallery.x = 0;
              gallery.y = 0;
            }
          }

          ParallelAnimation {
            NumberAnimation {
              target: gallery
              property: "scale"
              to: root.zoomScale
              duration: 1400
              easing.type: Easing.InOutCubic
            }

            NumberAnimation {
              target: gallery
              property: "x"
              to: (gallery.width / 2) - (root.zoomX * gallery.width * root.zoomScale)
              duration: 1400
              easing.type: Easing.InOutCubic
            }

            NumberAnimation {
              target: gallery
              property: "y"
              to: (gallery.height / 2) - (root.zoomY * gallery.height * root.zoomScale)
              duration: 1400
              easing.type: Easing.InOutCubic
            }
          }

          ScriptAction {
            script: root.updateWallpaper()
          }

          ScriptAction {
            script: root.switchWorkspace()
          }

          PauseAnimation {
            duration: 90
          }

          ScriptAction {
            script: {
              gallery.scale = 1.0;
              gallery.x = 0;
              gallery.y = 0;
              root.overlayVisible = false;
            }
          }
        }
      }
    }
  }
}
