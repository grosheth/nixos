import QtQuick

Item {
  id: root

  property bool active: true

  AmbientEffects {
    anchors.fill: parent
    active: root.active
    glows: [
      { "x": 876, "y": 40, "w": 340, "h": 220, "color": "#fff4dc", "from": 0.04, "to": 0.12, "up": 4800, "down": 5600 },
      { "x": 850, "y": 540, "w": 260, "h": 92, "color": "#7FBBB3", "from": 0.025, "to": 0.10, "up": 3600, "down": 4400, "delay": 1400 }
    ]
    rays: [
      { "x": 946, "y": 84, "w": 46, "h": 420, "rotation": 27, "color": "#fff4dc", "from": 0.02, "to": 0.08, "up": 6200, "down": 6800 },
      { "x": 1110, "y": 110, "w": 32, "h": 350, "rotation": 38, "color": "#fff4dc", "from": 0.018, "to": 0.065, "up": 5400, "down": 6000, "delay": 1700 }
    ]
    sweeps: [
      { "x": 660, "y": 565, "w": 190, "h": 3, "travelX": 360, "travelY": 86, "color": "#d8e5ff", "opacity": 0.14, "rotation": 18, "duration": 4200, "rest": 2600 },
      { "x": 970, "y": 624, "w": 160, "h": 2, "travelX": 260, "travelY": 36, "color": "#7FBBB3", "opacity": 0.12, "rotation": -4, "duration": 3600, "delay": 1300, "rest": 3200 }
    ]
    wisps: [
      { "x": 392, "y": 455, "w": 94, "h": 24, "rise": 34, "fromX": -18, "toX": 22, "color": "#d8e5ff", "peak": 0.07, "delay": 500, "duration": 5600 },
      { "x": 1128, "y": 468, "w": 120, "h": 28, "rise": 38, "fromX": -20, "toX": 28, "color": "#d8e5ff", "peak": 0.06, "delay": 2100, "duration": 6400 }
    ]
    particles: [
      { "x": 230, "y": 488, "rise": 48, "size": 3, "color": "#A7C080", "peak": 0.44, "delay": 0, "duration": 3400 },
      { "x": 1582, "y": 508, "rise": 52, "size": 2, "color": "#A7C080", "peak": 0.42, "delay": 1500, "duration": 3600 }
    ]
  }
}
