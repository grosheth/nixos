import QtQuick

Item {
  id: root

  property bool active: true

  AmbientEffects {
    anchors.fill: parent
    active: root.active
    glows: [
      { "x": 418, "y": 34, "w": 250, "h": 230, "color": "#d8e5ff", "from": 0.06, "to": 0.18, "up": 3800, "down": 4800 },
      { "x": 676, "y": 348, "w": 230, "h": 118, "color": "#DBBC7F", "from": 0.05, "to": 0.16, "up": 720, "down": 1220, "delay": 300 }
    ]
    sweeps: [
      { "x": 350, "y": 560, "w": 260, "h": 3, "travelX": 520, "color": "#d8e5ff", "opacity": 0.13, "rotation": -3, "duration": 4400, "rest": 1800 },
      { "x": 610, "y": 602, "w": 320, "h": 2, "travelX": 470, "color": "#7FBBB3", "opacity": 0.10, "rotation": 2, "duration": 5200, "delay": 1200, "rest": 2400 }
    ]
    wisps: [
      { "x": 286, "y": 160, "w": 126, "h": 32, "rise": 22, "fromX": -20, "toX": 32, "color": "#d8e5ff", "peak": 0.06, "delay": 600, "duration": 6200 },
      { "x": 1024, "y": 132, "w": 168, "h": 34, "rise": 18, "fromX": -30, "toX": 36, "color": "#d8e5ff", "peak": 0.05, "delay": 2500, "duration": 7200 }
    ]
    twinkles: [
      { "x": 706, "y": 340, "size": 4, "color": "#DBBC7F", "delay": 400, "rest": 2100 },
      { "x": 764, "y": 382, "size": 3, "color": "#DBBC7F", "delay": 1300, "rest": 2400 }
    ]
  }
}
