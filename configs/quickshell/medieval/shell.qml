import Quickshell
import Quickshell.Wayland
import QtQuick

ShellRoot {
  id: root

  property url wallpaper: Quickshell.env("MEDIEVAL_WALLPAPER_URL")

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
          source: root.wallpaper
          fillMode: Image.PreserveAspectCrop
          asynchronous: true
        }
      }
    }
  }
}
