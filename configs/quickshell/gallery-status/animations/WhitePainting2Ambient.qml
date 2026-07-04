import QtQuick

Item {
  id: root

  property bool active: true

  AmbientEffects {
    anchors.fill: parent
    active: root.active
    glows: [
      { "x": 960, "y": 54, "w": 540, "h": 590, "color": "#fff4dc", "from": 0.04, "to": 0.14, "up": 4200, "down": 5400 },
      { "x": 1208, "y": 220, "w": 220, "h": 340, "color": "#DBBC7F", "from": 0.03, "to": 0.10, "up": 2800, "down": 3600, "delay": 800 }
    ]
    rays: [
      { "x": 1030, "y": -12, "w": 42, "h": 650, "rotation": -15, "color": "#fff4dc", "from": 0.025, "to": 0.10, "up": 5600, "down": 6200 },
      { "x": 1282, "y": -22, "w": 34, "h": 580, "rotation": 10, "color": "#fff4dc", "from": 0.02, "to": 0.08, "up": 4600, "down": 5300, "delay": 1200 }
    ]
    sweeps: [
      { "x": 1150, "y": 384, "w": 126, "h": 3, "travelX": 96, "travelY": 80, "color": "#fff4dc", "opacity": 0.18, "rotation": 54, "duration": 2300, "delay": 700, "rest": 5200 },
      { "x": 1312, "y": 258, "w": 138, "h": 2, "travelX": 40, "travelY": 145, "color": "#DBBC7F", "opacity": 0.16, "rotation": 78, "duration": 2600, "delay": 2800, "rest": 6200 }
    ]
    particles: [
      { "x": 612, "y": 348, "rise": 54, "size": 3, "color": "#DBBC7F", "peak": 0.56, "delay": 200, "duration": 2800 },
      { "x": 790, "y": 280, "rise": 74, "size": 2, "color": "#fff4dc", "peak": 0.62, "delay": 920, "duration": 3400 },
      { "x": 1510, "y": 392, "rise": 68, "size": 3, "color": "#DBBC7F", "peak": 0.50, "delay": 1700, "duration": 3000 },
      { "x": 1010, "y": 514, "rise": 48, "size": 2, "color": "#fff4dc", "peak": 0.54, "delay": 2400, "duration": 2600 }
    ]
  }
}
