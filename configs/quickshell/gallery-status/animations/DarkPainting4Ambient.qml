import QtQuick

Item {
  id: root

  property bool active: true

  AmbientEffects {
    anchors.fill: parent
    active: root.active
    glows: [
      { "x": 680, "y": 168, "w": 600, "h": 520, "color": "#D699B6", "from": 0.035, "to": 0.14, "up": 2800, "down": 4300 },
      { "x": 762, "y": 272, "w": 260, "h": 330, "color": "#DBBC7F", "from": 0.02, "to": 0.08, "up": 2100, "down": 3400, "delay": 900 }
    ]
    particles: [
      { "x": 660, "y": 548, "rise": 88, "size": 3, "color": "#E67E80", "peak": 0.64, "delay": 0, "duration": 3000 },
      { "x": 820, "y": 610, "rise": 108, "size": 2, "color": "#D699B6", "peak": 0.58, "delay": 780, "duration": 3600 },
      { "x": 1128, "y": 520, "rise": 82, "size": 2, "color": "#E67E80", "peak": 0.56, "delay": 1500, "duration": 3100 },
      { "x": 1408, "y": 394, "rise": 74, "size": 3, "color": "#E67E80", "peak": 0.48, "delay": 2300, "duration": 3300 }
    ]
    sweeps: [
      { "x": 748, "y": 302, "w": 146, "h": 3, "travelX": 58, "travelY": 230, "color": "#DBBC7F", "opacity": 0.13, "rotation": 76, "duration": 2500, "rest": 5600 },
      { "x": 340, "y": 716, "w": 280, "h": 2, "travelX": 900, "color": "#D699B6", "opacity": 0.08, "rotation": -1, "duration": 6200, "delay": 1000, "rest": 2600 }
    ]
    twinkles: [
      { "x": 920, "y": 190, "size": 4, "color": "#DBBC7F", "delay": 1800, "rest": 6500 },
      { "x": 1194, "y": 258, "size": 3, "color": "#E67E80", "delay": 3400, "rest": 5900 }
    ]
  }
}
