import QtQuick

Item {
  id: root

  property bool active: true

  AmbientEffects {
    anchors.fill: parent
    active: root.active
    glows: [
      { "x": 820, "y": -36, "w": 300, "h": 160, "color": "#fff4dc", "from": 0.05, "to": 0.16, "up": 3600, "down": 4200 },
      { "x": 1500, "y": 448, "w": 118, "h": 112, "color": "#7FBBB3", "from": 0.05, "to": 0.18, "up": 1300, "down": 1800, "delay": 600 },
      { "x": 1666, "y": 210, "w": 150, "h": 210, "color": "#fff4dc", "from": 0.04, "to": 0.12, "up": 2800, "down": 3400, "delay": 1200 }
    ]
    rays: [
      { "x": 895, "y": 20, "w": 42, "h": 342, "rotation": 10, "color": "#fff4dc", "from": 0.02, "to": 0.08, "up": 4200, "down": 5200 },
      { "x": 1538, "y": 384, "w": 30, "h": 190, "rotation": -6, "color": "#7FBBB3", "from": 0.03, "to": 0.11, "up": 1600, "down": 2300 }
    ]
    sweeps: [
      { "x": 330, "y": 642, "w": 420, "h": 3, "travelX": 760, "color": "#DBBC7F", "opacity": 0.10, "rotation": -3, "duration": 6200, "rest": 2200 },
      { "x": 40, "y": 101, "w": 245, "h": 3, "travelX": 66, "color": "#DBBC7F", "opacity": 0.26, "duration": 2600, "delay": 900, "rest": 6400 },
      { "x": 1218, "y": 126, "w": 176, "h": 3, "travelX": 52, "color": "#DBBC7F", "opacity": 0.22, "duration": 2300, "delay": 2800, "rest": 7000 }
    ]
    particles: [
      { "x": 1544, "y": 546, "rise": 82, "size": 2, "color": "#7FBBB3", "peak": 0.72, "delay": 0, "duration": 2400 },
      { "x": 1584, "y": 560, "rise": 70, "size": 2, "color": "#7FBBB3", "peak": 0.62, "delay": 760, "duration": 2600 },
      { "x": 1528, "y": 572, "rise": 62, "size": 3, "color": "#7FBBB3", "peak": 0.58, "delay": 1320, "duration": 2200 }
    ]
  }
}
