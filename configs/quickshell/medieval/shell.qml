import Quickshell
import Quickshell.Wayland
import QtQuick

ShellRoot {
  id: root

  // Keep every display within the Medieval set. Unknown displays use the main image.
  function wallpaperFor(screenName) {
    if (screenName === "HDMI-A-1")
      return Qt.resolvedUrl("../../../assets/hyprland/Medieval/castle-round.png");
    if (screenName === "DP-1")
      return Qt.resolvedUrl("../../../assets/hyprland/Medieval/castle-tesse.png");
    return Qt.resolvedUrl("../../../assets/hyprland/Medieval/medieval.png");
  }

  Variants {
    model: Quickshell.screens

    delegate: Component {
      PanelWindow {
        required property var modelData

        screen: modelData
        color: "black"
        exclusionMode: ExclusionMode.Ignore
        focusable: false

        anchors {
          top: true
          bottom: true
          left: true
          right: true
        }

        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.namespace: "medieval-wallpaper"

        Image {
          anchors.fill: parent
          source: root.wallpaperFor(modelData.name)
          fillMode: Image.PreserveAspectCrop
          asynchronous: true
        }
      }
    }
  }
}
