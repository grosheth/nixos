import QtQuick

Item {
  id: root

  property bool active: true

  AmbientEffects {
    anchors.fill: parent
    active: root.active
    glows: [
      { "x": 802, "y": 236, "w": 520, "h": 420, "color": "#E67E80", "from": 0.04, "to": 0.15, "up": 2300, "down": 3600 },
      { "x": 1080, "y": 228, "w": 250, "h": 360, "color": "#DBBC7F", "from": 0.02, "to": 0.08, "up": 3200, "down": 4300, "delay": 1100 }
    ]
    particles: [
      { "x": 740, "y": 562, "rise": 78, "size": 3, "color": "#E67E80", "peak": 0.72, "delay": 0, "duration": 2800 },
      { "x": 860, "y": 500, "rise": 96, "size": 2, "color": "#E67E80", "peak": 0.62, "delay": 760, "duration": 3200 },
      { "x": 1220, "y": 506, "rise": 84, "size": 3, "color": "#DBBC7F", "peak": 0.46, "delay": 1480, "duration": 3000 },
      { "x": 1440, "y": 388, "rise": 76, "size": 2, "color": "#E67E80", "peak": 0.58, "delay": 2300, "duration": 3300 }
    ]
    sweeps: [
      { "x": 1124, "y": 274, "w": 130, "h": 3, "travelX": 44, "travelY": 230, "color": "#E67E80", "opacity": 0.15, "rotation": 74, "duration": 2300, "rest": 5200 },
      { "x": 984, "y": 430, "w": 116, "h": 2, "travelX": 38, "travelY": 132, "color": "#DBBC7F", "opacity": 0.12, "rotation": 70, "duration": 2100, "delay": 2600, "rest": 6200 }
    ]
    wisps: [
      { "x": 602, "y": 284, "w": 120, "h": 28, "rise": 44, "fromX": -10, "toX": 22, "color": "#E67E80", "peak": 0.045, "delay": 1000, "duration": 5600 },
      { "x": 1336, "y": 256, "w": 132, "h": 26, "rise": 52, "fromX": -18, "toX": 26, "color": "#E67E80", "peak": 0.04, "delay": 3000, "duration": 6200 }
    ]
  }
}
