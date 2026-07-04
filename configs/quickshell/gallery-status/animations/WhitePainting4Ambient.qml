import QtQuick

Item {
  id: root

  property bool active: true

  AmbientEffects {
    anchors.fill: parent
    active: root.active
    glows: [
      { "x": 638, "y": 118, "w": 620, "h": 560, "color": "#D699B6", "from": 0.045, "to": 0.16, "up": 3000, "down": 4300 },
      { "x": 786, "y": 236, "w": 300, "h": 340, "color": "#7FBBB3", "from": 0.025, "to": 0.08, "up": 2400, "down": 3200, "delay": 1300 }
    ]
    sweeps: [
      { "x": 716, "y": 260, "w": 176, "h": 3, "travelX": 78, "travelY": 260, "color": "#D699B6", "opacity": 0.20, "rotation": 72, "duration": 2600, "rest": 5600 },
      { "x": 1020, "y": 318, "w": 154, "h": 2, "travelX": 46, "travelY": 210, "color": "#DBBC7F", "opacity": 0.14, "rotation": 78, "duration": 2300, "delay": 2600, "rest": 6100 }
    ]
    particles: [
      { "x": 610, "y": 564, "rise": 88, "size": 3, "color": "#D699B6", "peak": 0.66, "delay": 0, "duration": 3200 },
      { "x": 760, "y": 610, "rise": 94, "size": 2, "color": "#DBBC7F", "peak": 0.58, "delay": 780, "duration": 3500 },
      { "x": 1118, "y": 564, "rise": 76, "size": 3, "color": "#D699B6", "peak": 0.62, "delay": 1520, "duration": 3000 },
      { "x": 1310, "y": 500, "rise": 72, "size": 2, "color": "#7FBBB3", "peak": 0.48, "delay": 2400, "duration": 3300 }
    ]
    twinkles: [
      { "x": 782, "y": 178, "size": 4, "color": "#fff4dc", "delay": 1700, "rest": 5900 },
      { "x": 1184, "y": 240, "size": 3, "color": "#D699B6", "delay": 3700, "rest": 6900 }
    ]
  }
}
