import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

ShellRoot {
  id: root

  property bool panelOpen: false
  property int workspace: 10
  property string mainScreen: "DP-3"
  property string currentTime: Qt.formatTime(new Date(), "HH:mm")
  property string currentDate: Qt.formatDate(new Date(), "ddd dd MMM")
  property var status: ({
    "vpn": "OFF",
    "ip": "unknown",
    "cpu": "0",
    "mem": "0",
    "disk": "0",
    "temp": "N/A",
    "volume": "N/A",
    "uptime": "unknown",
    "ssh": "0",
    "media": ""
  })

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

  function normalizeWorkspace(ws) {
    return ws === 0 ? 10 : ws;
  }

  function metricColor(value, warning, critical) {
    var n = Number(value);
    if (isNaN(n)) return "#7FBBB3";
    if (n >= critical) return "#E67E80";
    if (n >= warning) return "#DBBC7F";
    return "#A7C080";
  }

  function refreshStatus() {
    snapshotProc.exec(["gallery-status-snapshot"]);
  }

  function applySnapshot(text) {
    try {
      var parsed = JSON.parse(text);
      root.status = parsed;
    } catch (error) {
      console.log("gallery-status: invalid snapshot: " + error);
    }
  }

  IpcHandler {
    target: "status"

    function set(ws: int): void {
      root.workspace = root.normalizeWorkspace(ws);
    }

    function toggle(): void {
      root.panelOpen = !root.panelOpen;
      root.refreshStatus();
    }

    function close(): void {
      root.panelOpen = false;
    }

    function refresh(): void {
      root.refreshStatus();
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      root.currentTime = Qt.formatTime(new Date(), "HH:mm");
      root.currentDate = Qt.formatDate(new Date(), "ddd dd MMM");
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refreshStatus()
  }

  StdioCollector {
    id: snapshotOut
    waitForEnd: true
    onStreamFinished: root.applySnapshot(text)
  }

  Process {
    id: snapshotProc
    stdout: snapshotOut
  }

  Variants {
    model: Quickshell.screens

    delegate: Component {
      PanelWindow {
        id: win

        required property var modelData
        property bool isMainScreen: modelData.name === root.mainScreen

        screen: modelData
        visible: isMainScreen
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
        WlrLayershell.namespace: "gallery-status"

        Item {
          anchors.fill: parent

          Rectangle {
            id: signature

            width: 310
            height: 88
            x: parent.width - width - 34
            y: parent.height - height - 34

            color: "#cc14161b"
            radius: 4
            border.width: 1
            border.color: root.accent(root.workspace)

            Rectangle {
              width: 3
              anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                margins: 10
              }
              color: root.accent(root.workspace)
            }

            Text {
              id: room

              anchors {
                left: parent.left
                leftMargin: 24
                right: parent.right
                rightMargin: 18
                top: parent.top
                topMargin: 12
              }
              text: "No. " + root.roomNumber(root.workspace) + " / " + root.currentTime
              color: "#D3C6AA"
              font.family: "JetBrains Mono Nerd Font"
              font.pixelSize: 13
              font.bold: true
              elide: Text.ElideRight
            }

            Text {
              anchors {
                left: room.left
                right: room.right
                top: room.bottom
                topMargin: 2
              }
              text: root.roomName(root.workspace)
              color: "#fff275"
              font.family: "EB Garamond"
              font.pixelSize: 28
              font.italic: true
              elide: Text.ElideRight
            }

            Text {
              anchors {
                left: room.left
                right: room.right
                bottom: parent.bottom
                bottomMargin: 10
              }
              text: root.status.vpn + "  /  " + root.status.cpu + "% CPU  /  " + root.status.mem + "% MEM"
              color: "#a7a39a"
              font.family: "JetBrains Mono Nerd Font"
              font.pixelSize: 11
              elide: Text.ElideRight
            }
          }

          Rectangle {
            id: statusPanel

            width: 390
            height: 410
            x: parent.width - width - 34
            y: root.panelOpen ? parent.height - height - 136 : parent.height + 18
            opacity: root.panelOpen ? 1 : 0

            color: "#e614161b"
            radius: 6
            border.width: 1
            border.color: root.accent(root.workspace)

            Behavior on y {
              NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
            }

            Behavior on opacity {
              NumberAnimation { duration: 120 }
            }

            Column {
              anchors.fill: parent
              anchors.margins: 22
              spacing: 14

              Text {
                width: parent.width
                text: "CATALOGUE " + root.roomNumber(root.workspace)
                color: root.accent(root.workspace)
                font.family: "JetBrains Mono Nerd Font"
                font.pixelSize: 13
                font.bold: true
              }

              Text {
                width: parent.width
                text: root.roomName(root.workspace)
                color: "#fff275"
                font.family: "EB Garamond"
                font.pixelSize: 36
                font.italic: true
                elide: Text.ElideRight
              }

              Rectangle {
                width: parent.width
                height: 1
                color: root.muted(root.workspace)
              }

              Grid {
                width: parent.width
                columns: 2
                columnSpacing: 18
                rowSpacing: 12

                Repeater {
                  model: [
                    ["VPN", root.status.vpn, root.status.vpn === "OFF" ? "#E67E80" : "#A7C080"],
                    ["IP", root.status.ip, "#D3C6AA"],
                    ["CPU", root.status.cpu + "%", root.metricColor(root.status.cpu, 70, 90)],
                    ["MEM", root.status.mem + "%", root.metricColor(root.status.mem, 70, 85)],
                    ["DISK", root.status.disk + "%", root.metricColor(root.status.disk, 80, 92)],
                    ["TEMP", root.status.temp + "C", root.metricColor(root.status.temp, 65, 80)],
                    ["VOL", root.status.volume, "#DBBC7F"],
                    ["SSH", root.status.ssh, root.status.ssh === "0" ? "#7FBBB3" : "#E67E80"],
                    ["UP", root.status.uptime, "#A7C080"],
                    ["DATE", root.currentDate, "#D3C6AA"]
                  ]

                  delegate: Column {
                    width: (statusPanel.width - 62) / 2
                    spacing: 3

                    Text {
                      width: parent.width
                      text: modelData[0]
                      color: "#8f8a82"
                      font.family: "JetBrains Mono Nerd Font"
                      font.pixelSize: 10
                      font.bold: true
                    }

                    Text {
                      width: parent.width
                      text: modelData[1]
                      color: modelData[2]
                      font.family: "JetBrains Mono Nerd Font"
                      font.pixelSize: 14
                      elide: Text.ElideRight
                    }
                  }
                }
              }

              Rectangle {
                width: parent.width
                height: 1
                color: root.muted(root.workspace)
              }

              Text {
                width: parent.width
                text: root.status.media === "" ? "No active media" : root.status.media
                color: root.status.media === "" ? "#8f8a82" : "#D3C6AA"
                font.family: "JetBrains Mono Nerd Font"
                font.pixelSize: 13
                elide: Text.ElideRight
              }
            }
          }
        }
      }
    }
  }
}
