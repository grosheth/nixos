import QtQuick

Item {
  id: root

  property bool active: true

  AmbientEffects {
    anchors.fill: parent
    active: root.active
    glows: [
      { "x": 988, "y": 108, "w": 220, "h": 170, "color": "#E67E80", "from": 0.08, "to": 0.23, "up": 1400, "down": 2400 },
      { "x": 812, "y": 560, "w": 310, "h": 90, "color": "#D699B6", "from": 0.025, "to": 0.10, "up": 3400, "down": 4200, "delay": 900 }
    ]
    particles: [
      { "x": 1058, "y": 206, "rise": 74, "size": 3, "color": "#E67E80", "peak": 0.76, "delay": 0, "duration": 2800 },
      { "x": 1090, "y": 224, "rise": 92, "size": 2, "color": "#DBBC7F", "peak": 0.64, "delay": 680, "duration": 3400 },
      { "x": 1016, "y": 236, "rise": 68, "size": 2, "color": "#E67E80", "peak": 0.62, "delay": 1500, "duration": 3000 }
    ]
    wisps: [
      { "x": 960, "y": 176, "w": 96, "h": 28, "rise": 84, "fromX": -12, "toX": 30, "color": "#D3C6AA", "peak": 0.06, "delay": 300, "duration": 6200 },
      { "x": 1084, "y": 166, "w": 118, "h": 30, "rise": 96, "fromX": -16, "toX": 38, "color": "#D3C6AA", "peak": 0.055, "delay": 1900, "duration": 7000 }
    ]
    sweeps: [
      { "x": 690, "y": 596, "w": 220, "h": 3, "travelX": 350, "travelY": 82, "color": "#d8e5ff", "opacity": 0.12, "rotation": 16, "duration": 4600, "rest": 2600 },
      { "x": 1032, "y": 640, "w": 180, "h": 2, "travelX": 260, "color": "#D699B6", "opacity": 0.10, "rotation": -6, "duration": 3800, "delay": 1300, "rest": 3200 }
    ]
  }
}
