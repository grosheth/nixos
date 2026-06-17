import Quickshell
import Quickshell.Wayland
import QtQuick

ShellRoot {
  id: root

  property int workspace: 10
  property string mainScreen: "DP-3"
  property string currentTime: Qt.formatTime(new Date(), "HH:mm")

  function roomName(ws) {
    if (ws === 1) return "Tricolor Rupture";
    if (ws === 2) return "Blue Dress Study";
    if (ws === 3) return "Mountain Study";
    if (ws === 4) return "Man in Black";
    if (ws === 5) return "Color Blocks";
    if (ws === 6) return "Flowers and Ash";
    return "Gallery Hall";
  }

  function roomNumber(ws) {
    if (ws === 10) return "00";
    if (ws < 10) return "0" + String(ws);
    return String(ws);
  }

  function accent(ws) {
    if (ws === 1) return "#c45145";
    if (ws === 2) return "#3d86a7";
    if (ws === 3) return "#86b6c7";
    if (ws === 4) return "#d65a20";
    if (ws === 5) return "#3d86a7";
    if (ws === 6) return "#c69781";
    return "#7FBBB3";
  }

  function muted(ws) {
    if (ws === 1) return "#4f4642";
    if (ws === 2) return "#5f554f";
    if (ws === 3) return "#4f625b";
    if (ws === 4) return "#333435";
    if (ws === 5) return "#5a5b56";
    if (ws === 6) return "#4f4642";
    return "#4f4642";
  }

  function signatureX(ws, width, itemWidth) {
    if (ws === 1) return width * 0.075;
    if (ws === 2) return width * 0.285;
    if (ws === 3) return width * 0.415;
    if (ws === 4) return width * 0.610;
    if (ws === 5) return width * 0.780;
    if (ws === 6) return width * 0.840;
    return width - itemWidth - 52;
  }

  function signatureY(ws, height, itemHeight) {
    if (ws === 1) return height * 0.600;
    if (ws === 2) return height * 0.445;
    if (ws === 3) return height * 0.425;
    if (ws === 4) return height * 0.460;
    if (ws === 5) return height * 0.455;
    if (ws === 6) return height * 0.500;
    return height - itemHeight - 54;
  }

  IpcHandler {
    target: "signature"

    function set(ws: int): void {
      root.workspace = ws === 0 ? 10 : ws;
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: root.currentTime = Qt.formatTime(new Date(), "HH:mm")
  }

  Variants {
    model: Quickshell.screens

    delegate: Component {
      PanelWindow {
        id: win

        required property var modelData
        screen: modelData
        visible: true
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
        WlrLayershell.namespace: "gallery-signature"

        Item {
          anchors.fill: parent

          Rectangle {
            id: signature

            width: signatureText.implicitWidth + 48
            height: signatureText.implicitHeight + 28
            x: (parent.width - width) / 2
            y: 72

            color: "#cc14161b"
            opacity: 1.0
            radius: 4
            border.width: 2
            border.color: root.accent(root.workspace)

            Text {
              id: signatureText

              anchors.centerIn: parent
              text: "SIGNATURE TEST · " + root.currentTime + " · No. " + root.roomNumber(root.workspace) + "\n" + root.roomName(root.workspace)
              color: "#fff275"
              style: Text.Outline
              styleColor: "#000000"
              font.family: "EB Garamond"
              font.pixelSize: 52
              font.italic: true
              lineHeight: 0.86
              horizontalAlignment: Text.AlignRight
            }
          }
        }
      }
    }
  }
}
