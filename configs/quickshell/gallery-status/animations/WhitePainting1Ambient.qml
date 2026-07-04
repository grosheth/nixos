import QtQuick

Item {
  id: root

  property bool active: true

  AmbientEffects {
    anchors.fill: parent
    active: root.active
    glows: [
      { "x": 450, "y": 12, "w": 260, "h": 220, "color": "#fff4dc", "from": 0.06, "to": 0.18, "up": 3600, "down": 4200 },
      { "x": 676, "y": 318, "w": 190, "h": 112, "color": "#DBBC7F", "from": 0.04, "to": 0.13, "up": 900, "down": 1500, "delay": 500 }
    ]
    rays: [
      { "x": 500, "y": 92, "w": 44, "h": 390, "rotation": 22, "color": "#fff4dc", "from": 0.025, "to": 0.095, "up": 4800, "down": 5600 },
      { "x": 640, "y": 70, "w": 30, "h": 310, "rotation": 35, "color": "#fff4dc", "from": 0.02, "to": 0.07, "up": 5200, "down": 4600, "delay": 1600 }
    ]
    sweeps: [
      { "x": 168, "y": 482, "w": 330, "h": 3, "travelX": 980, "color": "#d8e5ff", "opacity": 0.16, "rotation": -3, "duration": 4400, "rest": 1700 },
      { "x": 260, "y": 542, "w": 420, "h": 2, "travelX": 760, "color": "#7FBBB3", "opacity": 0.14, "rotation": 2, "duration": 5200, "delay": 1200, "rest": 2200 },
      { "x": 884, "y": 118, "w": 120, "h": 3, "travelX": 120, "color": "#E67E80", "opacity": 0.20, "rotation": 4, "duration": 1800, "delay": 2600, "rest": 6200 }
    ]
    twinkles: [
      { "x": 1168, "y": 168, "size": 4, "color": "#fff4dc", "delay": 1200, "rest": 5200 },
      { "x": 1460, "y": 214, "size": 3, "color": "#fff4dc", "delay": 3200, "rest": 6100 }
    ]
  }
}
