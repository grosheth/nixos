import QtQuick

Item {
  id: root

  property bool active: true

  AmbientEffects {
    anchors.fill: parent
    active: root.active
    glows: [
      { "x": 1124, "y": 72, "w": 330, "h": 330, "color": "#E67E80", "from": 0.06, "to": 0.20, "up": 1600, "down": 3000, "rest": 1200 },
      { "x": 1246, "y": 596, "w": 240, "h": 112, "color": "#DBBC7F", "from": 0.04, "to": 0.15, "up": 520, "down": 980, "delay": 300 }
    ]
    particles: [
      { "x": 660, "y": 508, "rise": 66, "size": 3, "color": "#E67E80", "peak": 0.52, "delay": 0, "duration": 3300 },
      { "x": 910, "y": 390, "rise": 82, "size": 2, "color": "#E67E80", "peak": 0.58, "delay": 900, "duration": 3400 },
      { "x": 1388, "y": 610, "rise": 78, "size": 3, "color": "#DBBC7F", "peak": 0.50, "delay": 1700, "duration": 3000 },
      { "x": 1560, "y": 468, "rise": 96, "size": 2, "color": "#E67E80", "peak": 0.48, "delay": 2600, "duration": 3600 }
    ]
    sweeps: [
      { "x": 1154, "y": 152, "w": 160, "h": 3, "travelX": 86, "color": "#E67E80", "opacity": 0.20, "rotation": 1, "duration": 2400, "delay": 600, "rest": 5600 },
      { "x": 1284, "y": 648, "w": 120, "h": 2, "travelX": 86, "color": "#DBBC7F", "opacity": 0.14, "rotation": -4, "duration": 2100, "delay": 1900, "rest": 5200 }
    ]
    twinkles: [
      { "x": 1192, "y": 238, "size": 5, "color": "#DBBC7F", "peak": 0.92, "delay": 4200, "rest": 7600 },
      { "x": 1378, "y": 630, "size": 4, "color": "#DBBC7F", "delay": 800, "rest": 1800 },
      { "x": 1438, "y": 648, "size": 3, "color": "#DBBC7F", "delay": 1500, "rest": 2300 }
    ]
    wisps: [
      { "x": 1236, "y": 610, "w": 90, "h": 20, "rise": 66, "fromX": -12, "toX": 20, "color": "#D3C6AA", "peak": 0.055, "delay": 600, "duration": 5400 },
      { "x": 1446, "y": 604, "w": 86, "h": 18, "rise": 58, "fromX": -16, "toX": 18, "color": "#D3C6AA", "peak": 0.045, "delay": 2400, "duration": 6200 }
    ]
  }
}
