import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

ShellRoot {
  id: root

  property bool overlayVisible: false
  property bool workspaceSwitchDispatched: false
  property int targetWorkspace: 1
  property real zoomX: 0.5
  property real zoomY: 0.5
  property real zoomScale: 3.5
  property string galleryImage: "schoolofathens.jpg"

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
    return 3.5;
  }

  function enter(ws) {
    if (overlayVisible)
      return;

    targetWorkspace = ws;
    workspaceSwitchDispatched = false;
    zoomX = paintingX(ws);
    zoomY = paintingY(ws);
    zoomScale = paintingScale(ws);
    overlayVisible = true;
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

  Variants {
    model: Quickshell.screens

    delegate: Component {
      PanelWindow {
        id: win

        required property var modelData
        screen: modelData

        visible: root.overlayVisible
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
          if (visible)
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

          Rectangle {
            id: flash
            anchors.fill: parent
            color: "white"
            opacity: 0
          }
        }

        SequentialAnimation {
          id: enterAnimation

          ScriptAction {
            script: {
              flash.opacity = 0;
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
              duration: 520
              easing.type: Easing.InOutCubic
            }

            NumberAnimation {
              target: gallery
              property: "x"
              to: (gallery.width / 2) - (root.zoomX * gallery.width * root.zoomScale)
              duration: 520
              easing.type: Easing.InOutCubic
            }

            NumberAnimation {
              target: gallery
              property: "y"
              to: (gallery.height / 2) - (root.zoomY * gallery.height * root.zoomScale)
              duration: 520
              easing.type: Easing.InOutCubic
            }
          }

          NumberAnimation {
            target: flash
            property: "opacity"
            to: 1.0
            duration: 120
            easing.type: Easing.OutQuad
          }

          ScriptAction {
            script: root.switchWorkspace()
          }

          PauseAnimation {
            duration: 90
          }

          NumberAnimation {
            target: flash
            property: "opacity"
            to: 0.0
            duration: 260
            easing.type: Easing.OutCubic
          }

          ScriptAction {
            script: {
              gallery.scale = 1.0;
              gallery.x = 0;
              gallery.y = 0;
              flash.opacity = 0;
              root.overlayVisible = false;
            }
          }
        }
      }
    }
  }
}
