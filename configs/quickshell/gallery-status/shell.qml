import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

ShellRoot {
  id: root

  property bool panelOpen: false
  property bool compactOpen: true
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
    "load": "0.00 0.00 0.00",
    "memUsed": "unknown",
    "diskUsed": "unknown",
    "kernel": "unknown",
    "host": "nixos",
    "packages": "N/A",
    "battery": "AC",
    "monitors": "unknown",
    "media": ""
  })

  function roomName(ws) {
    if (ws === 1) return "Tricolor Rupture";
    if (ws === 2) return "Blue Dress Study";
    if (ws === 3) return "Mountain Study";
    if (ws === 4) return "Man in Black";
    if (ws === 5) return "Color Blocks";
    if (ws === 6) return "Flowers and Ash";
    if (ws === 10) return "Gallery Hall";
    return "Workspace " + root.roomNumber(ws);
  }

  function wallpaperSource(ws) {
    if (ws >= 1 && ws <= 6)
      return "file:///home/salledelavage/.config/quickshell/gallery-transition/painting-" + String(ws) + ".png";

    return "file:///home/salledelavage/.config/quickshell/gallery-transition/gallery.png";
  }

  function roomNumber(ws) {
    if (ws === 10) return "00";
    if (ws < 10) return "0" + String(ws);
    return String(ws);
  }

  function palette(ws) {
    if (ws === 1) return {
      bg: "#14161b", fg: "#D3C6AA", black: "#212026",
      red: "#b94a42", green: "#6f8a68", yellow: "#c8914c",
      blue: "#1e5d78", magenta: "#9d352f", cyan: "#3d86a7",
      accent: "#b94a42", accent2: "#1e5d78", muted: "#4f4642",
      active: "#c45145"
    };
    if (ws === 2) return {
      bg: "#14161b", fg: "#D3C6AA", black: "#212026",
      red: "#a14232", green: "#788347", yellow: "#d1a55a",
      blue: "#1f5f86", magenta: "#8b5b72", cyan: "#5a9bb8",
      accent: "#1f5f86", accent2: "#d1a55a", muted: "#5f554f",
      active: "#3d86a7"
    };
    if (ws === 3) return {
      bg: "#14161b", fg: "#D3C6AA", black: "#212026",
      red: "#9d352f", green: "#4d6b45", yellow: "#d8c6a7",
      blue: "#3d86a7", magenta: "#b9853d", cyan: "#86b6c7",
      accent: "#3d86a7", accent2: "#d8c6a7", muted: "#4f625b",
      active: "#86b6c7"
    };
    if (ws === 4) return {
      bg: "#14161b", fg: "#D3C6AA", black: "#212026",
      red: "#8e331c", green: "#5a5b56", yellow: "#f0a24b",
      blue: "#252d34", magenta: "#9d352f", cyan: "#9a9891",
      accent: "#d65a20", accent2: "#f0a24b", muted: "#333435",
      active: "#d65a20"
    };
    if (ws === 5) return {
      bg: "#14161b", fg: "#D3C6AA", black: "#212026",
      red: "#a14232", green: "#5a7564", yellow: "#d8c6a7",
      blue: "#1e5d78", magenta: "#b9853d", cyan: "#3d86a7",
      accent: "#1e5d78", accent2: "#a14232", muted: "#5a5b56",
      active: "#3d86a7"
    };
    if (ws === 6) return {
      bg: "#14161b", fg: "#D3C6AA", black: "#212026",
      red: "#a14232", green: "#4d5c2f", yellow: "#d1a55a",
      blue: "#2f6f86", magenta: "#c69781", cyan: "#6f9e91",
      accent: "#c69781", accent2: "#4d5c2f", muted: "#4f4642",
      active: "#c69781"
    };
    return {
      bg: "#14161b", fg: "#D3C6AA", black: "#212026",
      red: "#E67E80", green: "#A7C080", yellow: "#DBBC7F",
      blue: "#7FBBB3", magenta: "#D699B6", cyan: "#83C092",
      accent: "#7FBBB3", accent2: "#DBBC7F", muted: "#4f4642",
      active: "#7FBBB3"
    };
  }

  function alpha(hex, aa) {
    return "#" + aa + hex.slice(1);
  }

  function accent(ws) {
    return root.palette(ws).active;
  }

  function accent2(ws) {
    return root.palette(ws).accent2;
  }

  function muted(ws) {
    return root.palette(ws).muted;
  }

  function foreground(ws) {
    return root.palette(ws).fg;
  }

  function panelFill(ws) {
    return root.alpha(root.palette(ws).accent, "d0");
  }

  function overlayPanelFill(ws) {
    return "transparent";
  }

  function quietText(ws) {
    return root.palette(ws).cyan;
  }

  function dividerColor(ws) {
    return root.alpha(root.palette(ws).muted, "88");
  }

  function normalizeWorkspace(ws) {
    return ws === 0 ? 10 : ws;
  }

  function metricColor(value, warning, critical) {
    var p = root.palette(root.workspace);
    var n = Number(value);
    if (isNaN(n)) return p.cyan;
    if (n >= critical) return p.red;
    if (n >= warning) return p.yellow;
    return p.green;
  }

  function metricValue(value) {
    var n = Number(String(value).replace("%", "").replace(" C", ""));
    return isNaN(n) ? 0 : Math.max(0, Math.min(100, n));
  }

  function tempLabel() {
    return root.status.temp === "N/A" ? "N/A" : root.status.temp + " C";
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

    function toggleWorkspace(ws: int): void {
      root.workspace = root.normalizeWorkspace(ws);
      root.panelOpen = !root.panelOpen;
      root.refreshStatus();
    }

    function open(): void {
      root.panelOpen = true;
      root.refreshStatus();
    }

    function toggleCompact(): void {
      root.compactOpen = !root.compactOpen;
      if (!root.compactOpen) {
        root.panelOpen = false;
      }
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
        property bool isBenqScreen: !isMainScreen

        screen: modelData
        visible: (isMainScreen && root.panelOpen) || (isBenqScreen && root.compactOpen)
        implicitWidth: 430
        implicitHeight: 116
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        focusable: false

        anchors {
          top: isMainScreen
          left: isMainScreen
          right: true
          bottom: true
        }

        margins {
          top: 0
          left: 0
          right: isMainScreen ? 0 : 34
          bottom: isMainScreen ? 0 : 34
        }

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "gallery-status"

        Item {
          anchors.fill: parent

          Image {
            id: overlayWallpaper

            visible: win.isMainScreen && root.panelOpen
            anchors.fill: parent
            source: root.wallpaperSource(root.workspace)
            fillMode: Image.Stretch
            smooth: true
          }

          Rectangle {
            id: signature

            visible: win.isBenqScreen
            width: 350
            height: 116
            x: parent.width - width
            y: parent.height - height

            color: root.alpha(root.palette(root.workspace).black, "cc")
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
                leftMargin: 28
                right: parent.right
                rightMargin: 22
                top: parent.top
                topMargin: 16
              }
              text: "No. " + root.roomNumber(root.workspace) + " / " + root.currentTime
              color: root.foreground(root.workspace)
              font.family: "JetBrains Mono Nerd Font"
              font.pixelSize: 16
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
              color: root.accent2(root.workspace)
              font.family: "EB Garamond"
              font.pixelSize: 34
              font.italic: true
              elide: Text.ElideRight
            }

            Text {
              anchors {
                left: room.left
                right: room.right
                bottom: parent.bottom
                bottomMargin: 14
              }
              text: root.status.vpn + "  /  " + root.status.cpu + "% CPU  /  " + root.status.mem + "% MEM"
              color: root.quietText(root.workspace)
              font.family: "JetBrains Mono Nerd Font"
              font.pixelSize: 14
              elide: Text.ElideRight
            }
          }

          Rectangle {
            id: statusPanel

            visible: win.isMainScreen
            width: parent.width
            height: parent.height
            x: 0
            y: 0
            opacity: root.panelOpen ? 1 : 0

            color: "transparent"

            Behavior on opacity {
              NumberAnimation { duration: 120 }
            }

            Rectangle {
              id: titlePlaque

              width: 760
              height: 178
              x: 72
              y: 62

              color: "transparent"

              Rectangle {
                width: 132
                height: 1
                x: 2
                y: 26
                color: root.alpha(root.accent(root.workspace), "cc")
              }

              Text {
                id: roomMeta

                width: parent.width
                height: 28
                x: 0
                y: 0
                text: "No. " + root.roomNumber(root.workspace) + " / " + root.currentDate + " / " + root.currentTime
                color: root.alpha(root.accent(root.workspace), "e6")
                font.family: "JetBrains Mono Nerd Font"
                font.pixelSize: 14
                font.bold: true
                elide: Text.ElideRight
                style: Text.Raised
                styleColor: root.alpha(root.palette(root.workspace).black, "bb")
              }

              Text {
                width: parent.width
                height: 94
                x: 0
                y: 30
                text: root.roomName(root.workspace)
                color: root.accent2(root.workspace)
                font.family: "EB Garamond"
                font.pixelSize: 78
                font.italic: true
                elide: Text.ElideRight
                style: Text.Raised
                styleColor: root.alpha(root.palette(root.workspace).black, "dd")
              }

              Text {
                width: 440
                height: 26
                x: 4
                y: 134
                text: root.status.host + "  /  uptime " + root.status.uptime
                color: root.alpha(root.foreground(root.workspace), "dd")
                font.family: "JetBrains Mono Nerd Font"
                font.pixelSize: 13
                elide: Text.ElideRight
                style: Text.Raised
                styleColor: root.alpha(root.palette(root.workspace).black, "bb")
              }

              Row {
                x: 4
                y: 164
                height: 10
                spacing: 8

                Repeater {
                  model: [root.accent(root.workspace), root.accent2(root.workspace), root.quietText(root.workspace), root.palette(root.workspace).red]

                  delegate: Rectangle {
                    width: modelData === root.palette(root.workspace).red ? 28 : 46
                    height: 2
                    color: modelData
                    opacity: 0.86
                  }
                }
              }
            }

            Rectangle {
              id: hardwarePlaque

              width: 480
              height: 292
              x: parent.width - width - 72
              y: 96

              color: "transparent"

              Rectangle {
                width: 154
                height: 1
                x: parent.width - width
                y: 22
                color: root.alpha(root.accent(root.workspace), "bb")
              }

              Rectangle {
                width: 74
                height: 1
                x: parent.width - width
                y: 236
                color: root.alpha(root.accent2(root.workspace), "99")
              }

              Column {
                anchors.fill: parent
                anchors.margins: 0
                spacing: 7

                Row {
                  width: parent.width
                  height: 18
                  spacing: 10

                  Text {
                    width: 56
                    text: "btop"
                    color: root.accent2(root.workspace)
                    font.family: "JetBrains Mono Nerd Font"
                    font.pixelSize: 13
                    font.bold: true
                    style: Text.Raised
                    styleColor: root.alpha(root.palette(root.workspace).black, "bb")
                  }

                  Text {
                    width: parent.width - 66
                    text: root.status.load + " load"
                    color: root.quietText(root.workspace)
                    font.family: "JetBrains Mono Nerd Font"
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignRight
                    elide: Text.ElideRight
                    style: Text.Raised
                    styleColor: root.alpha(root.palette(root.workspace).black, "bb")
                  }
                }

                Repeater {
                  model: [
                    ["CPU", root.status.cpu + "%", root.metricColor(root.status.cpu, 70, 90)],
                    ["MEM", root.status.mem + "%", root.metricColor(root.status.mem, 70, 85)],
                    ["DISK", root.status.disk + "%", root.metricColor(root.status.disk, 80, 92)],
                    ["TEMP", root.tempLabel(), root.metricColor(root.status.temp, 65, 80)]
                  ]

                  delegate: Row {
                    id: metricRow

                    width: parent.width
                    height: 30
                    spacing: 10
                    property var metric: modelData
                    property int fillValue: root.metricValue(metric[1])

                    Text {
                      width: 48
                      height: parent.height
                      text: metric[0]
                      color: root.quietText(root.workspace)
                      font.family: "JetBrains Mono Nerd Font"
                      font.pixelSize: 12
                      font.bold: true
                      verticalAlignment: Text.AlignVCenter
                      style: Text.Raised
                      styleColor: root.alpha(root.palette(root.workspace).black, "bb")
                    }

                    Rectangle {
                      width: parent.width - 128
                      height: 18
                      y: 8
                      color: root.alpha(root.palette(root.workspace).black, "66")
                      radius: 2
                      clip: true

                      Rectangle {
                        width: parent.width * metricRow.fillValue / 100
                        height: parent.height
                        color: metric[2]
                        opacity: 0.82
                      }

                      Row {
                        anchors.fill: parent
                        spacing: 2

                        Repeater {
                          model: 16

                          delegate: Rectangle {
                            width: (parent.width - 30) / 16
                            height: parent.height
                            color: "transparent"
                            border.width: 1
                            border.color: root.alpha(root.palette(root.workspace).black, "99")
                          }
                        }
                      }
                    }

                    Text {
                      width: 60
                      height: parent.height
                      text: metric[1]
                      color: metric[2]
                      font.family: "JetBrains Mono Nerd Font"
                      font.pixelSize: 14
                      font.bold: true
                      horizontalAlignment: Text.AlignRight
                      verticalAlignment: Text.AlignVCenter
                      style: Text.Raised
                      styleColor: root.alpha(root.palette(root.workspace).black, "bb")
                    }
                  }
                }

                Rectangle {
                  width: 104
                  height: 1
                  color: root.alpha(root.muted(root.workspace), "99")
                }

                Grid {
                  width: parent.width
                  height: 42
                  columns: 2
                  rowSpacing: 6
                  columnSpacing: 12

                  Repeater {
                    model: [
                      ["MEM", root.status.memUsed],
                      ["DISK", root.status.diskUsed],
                      ["PKGS", root.status.packages],
                      ["BAT", root.status.battery]
                    ]

                    delegate: Text {
                      width: (parent.width - 12) / 2
                      height: 18
                      text: modelData[0] + " " + modelData[1]
                      color: root.foreground(root.workspace)
                      font.family: "JetBrains Mono Nerd Font"
                      font.pixelSize: 11
                      elide: Text.ElideRight
                      style: Text.Raised
                      styleColor: root.alpha(root.palette(root.workspace).black, "bb")
                    }
                  }
                }
              }
            }

            Rectangle {
              id: networkPlaque

              width: 360
              height: 128
              x: 92
              y: parent.height - height - 104

              color: "transparent"

              Rectangle {
                width: 118
                height: 1
                x: 0
                y: 20
                color: root.alpha(root.accent(root.workspace), "bb")
              }

              Rectangle {
                width: 54
                height: 1
                x: 0
                y: 104
                color: root.alpha(root.accent2(root.workspace), "99")
              }

              Column {
                anchors.fill: parent
                anchors.margins: 0
                spacing: 8

                Text {
                  width: parent.width
                  text: "NETWORK"
                  color: root.accent(root.workspace)
                  font.family: "JetBrains Mono Nerd Font"
                  font.pixelSize: 12
                  font.bold: true
                  style: Text.Raised
                  styleColor: root.alpha(root.palette(root.workspace).black, "bb")
                }

                Text {
                  width: parent.width
                  text: root.status.ip
                  color: root.foreground(root.workspace)
                  font.family: "JetBrains Mono Nerd Font"
                  font.pixelSize: 18
                  font.bold: true
                  elide: Text.ElideRight
                  style: Text.Raised
                  styleColor: root.alpha(root.palette(root.workspace).black, "bb")
                }

                Text {
                  width: parent.width
                  text: "VPN " + root.status.vpn + "  /  SSH " + root.status.ssh
                  color: root.status.vpn === "OFF" ? root.palette(root.workspace).red : root.palette(root.workspace).green
                  font.family: "JetBrains Mono Nerd Font"
                  font.pixelSize: 13
                  elide: Text.ElideRight
                  style: Text.Raised
                  styleColor: root.alpha(root.palette(root.workspace).black, "bb")
                }
              }
            }

            Rectangle {
              id: mediaPlaque

              width: 900
              height: 104
              x: (parent.width - width) / 2
              y: parent.height - height - 82

              color: "transparent"
              border.width: 0

              Rectangle {
                width: 190
                height: 1
                x: (parent.width - width) / 2
                y: 0
                color: root.alpha(root.accent(root.workspace), "bb")
              }

              Rectangle {
                width: 92
                height: 1
                x: (parent.width - width) / 2
                y: parent.height - 1
                color: root.alpha(root.accent2(root.workspace), "99")
              }

              Column {
                anchors.fill: parent
                anchors.topMargin: 12
                anchors.leftMargin: 32
                anchors.rightMargin: 32
                spacing: 8

                Text {
                  width: parent.width
                  height: 40
                  text: root.status.media === "" ? "No active media  /  " + root.status.volume : root.status.media + "  /  " + root.status.volume
                  color: root.status.media === "" ? root.alpha(root.accent(root.workspace), "dd") : root.accent2(root.workspace)
                  font.family: "JetBrains Mono Nerd Font"
                  font.pixelSize: 18
                  font.bold: root.status.media !== ""
                  verticalAlignment: Text.AlignVCenter
                  horizontalAlignment: Text.AlignHCenter
                  elide: Text.ElideRight
                  style: Text.Raised
                  styleColor: root.alpha(root.palette(root.workspace).black, "bb")
                }

                Text {
                  width: parent.width
                  height: 34
                  text: root.status.kernel + "  /  " + root.status.memUsed + " MEM  /  " + root.status.diskUsed + " DISK  /  " + root.status.monitors
                  color: root.alpha(root.quietText(root.workspace), "e6")
                  font.family: "JetBrains Mono Nerd Font"
                  font.pixelSize: 13
                  verticalAlignment: Text.AlignVCenter
                  horizontalAlignment: Text.AlignHCenter
                  elide: Text.ElideRight
                  style: Text.Raised
                  styleColor: root.alpha(root.palette(root.workspace).black, "bb")
                }
              }
            }

            Text {
              width: 310
              height: 86
              x: parent.width - width - 72
              y: parent.height - height - 108
              text: root.currentTime
              color: root.accent2(root.workspace)
              font.family: "EB Garamond"
              font.pixelSize: 72
              font.italic: true
              horizontalAlignment: Text.AlignRight
              verticalAlignment: Text.AlignVCenter
            }

            Rectangle {
              visible: false
              width: 1
              height: parent.height - 190
              x: parent.width - 538
              y: 72
              color: root.dividerColor(root.workspace)
            }

            Rectangle {
              visible: false
              width: parent.width - 210
              height: 1
              x: 72
              y: parent.height - 176
              color: root.dividerColor(root.workspace)
            }
          }
        }
      }
    }
  }
}
