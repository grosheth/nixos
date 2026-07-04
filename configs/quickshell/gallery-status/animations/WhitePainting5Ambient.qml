import QtQuick

Item {
  id: root

  property bool active: true

  AmbientEffects {
    anchors.fill: parent
    active: root.active
    glows: [
      { "x": 1130, "y": 112, "w": 330, "h": 280, "color": "#fff4dc", "from": 0.06, "to": 0.18, "up": 3400, "down": 4300 },
      { "x": 1438, "y": 538, "w": 118, "h": 88, "color": "#DBBC7F", "from": 0.035, "to": 0.12, "up": 780, "down": 1280, "delay": 900 }
    ]
    rays: [
      { "x": 1056, "y": 18, "w": 44, "h": 520, "rotation": 22, "color": "#fff4dc", "from": 0.025, "to": 0.095, "up": 5600, "down": 6200 },
      { "x": 1220, "y": 18, "w": 32, "h": 430, "rotation": 36, "color": "#fff4dc", "from": 0.018, "to": 0.075, "up": 5200, "down": 5800, "delay": 1300 }
    ]
    particles: [
      { "x": 320, "y": 544, "rise": 58, "size": 4, "color": "#fff4dc", "peak": 0.48, "delay": 200, "duration": 4200 },
      { "x": 492, "y": 486, "rise": 62, "size": 3, "color": "#fff4dc", "peak": 0.46, "delay": 1200, "duration": 3900 },
      { "x": 1514, "y": 442, "rise": 70, "size": 3, "color": "#fff4dc", "peak": 0.50, "delay": 2300, "duration": 4300 },
      { "x": 1660, "y": 506, "rise": 52, "size": 3, "color": "#A7C080", "peak": 0.42, "delay": 3300, "duration": 3600 }
    ]
    sweeps: [
      { "x": 1160, "y": 205, "w": 126, "h": 3, "travelX": 118, "color": "#fff4dc", "opacity": 0.18, "rotation": 6, "duration": 2400, "delay": 800, "rest": 6200 },
      { "x": 1372, "y": 602, "w": 180, "h": 2, "travelX": 110, "color": "#DBBC7F", "opacity": 0.12, "rotation": -2, "duration": 3100, "delay": 2400, "rest": 5400 }
    ]
  }
}
