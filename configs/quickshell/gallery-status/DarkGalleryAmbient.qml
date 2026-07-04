import QtQuick

Item {
  id: ambient

  property bool active: true
  property real sourceWidth: 1916
  property real sourceHeight: 821
  property real floorSweep: 0

  function gx(value) {
    return width * value / sourceWidth;
  }

  function gy(value) {
    return height * value / sourceHeight;
  }

  function gw(value) {
    return width * value / sourceWidth;
  }

  function gh(value) {
    return height * value / sourceHeight;
  }

  clip: true

  SequentialAnimation on floorSweep {
    running: ambient.active && ambient.visible
    loops: Animation.Infinite
    PauseAnimation { duration: 2200 }
    NumberAnimation {
      from: 0
      to: 1
      duration: 6200
      easing.type: Easing.InOutCubic
    }
    PauseAnimation { duration: 1800 }
  }

  Rectangle {
    id: floorReflection

    x: ambient.gx(260 + 1050 * ambient.floorSweep)
    y: ambient.gy(622)
    width: ambient.gw(460)
    height: Math.max(2, ambient.gh(3))
    rotation: -4
    color: "#7FBBB3"
    opacity: 0.10
  }

  Rectangle {
    x: ambient.gx(510 + 720 * ambient.floorSweep)
    y: ambient.gy(681)
    width: ambient.gw(340)
    height: Math.max(1, ambient.gh(2))
    rotation: -2
    color: "#DBBC7F"
    opacity: 0.08
  }

  Rectangle {
    id: moonGlow

    x: ambient.gx(103)
    y: ambient.gy(62)
    width: ambient.gw(132)
    height: ambient.gh(132)
    radius: Math.min(width, height) / 2
    color: "#d8e5ff"
    opacity: 0.10

    SequentialAnimation on opacity {
      running: ambient.active && ambient.visible
      loops: Animation.Infinite
      NumberAnimation { from: 0.07; to: 0.15; duration: 3600; easing.type: Easing.InOutCubic }
      NumberAnimation { to: 0.08; duration: 4200; easing.type: Easing.InOutCubic }
    }

    SequentialAnimation on scale {
      running: ambient.active && ambient.visible
      loops: Animation.Infinite
      NumberAnimation { from: 0.96; to: 1.08; duration: 4200; easing.type: Easing.InOutCubic }
      NumberAnimation { to: 0.98; duration: 3600; easing.type: Easing.InOutCubic }
    }
  }

  Repeater {
    model: [
      { "x": 86, "y": 351, "w": 176, "delay": 0 },
      { "x": 118, "y": 384, "w": 214, "delay": 900 },
      { "x": 48, "y": 421, "w": 156, "delay": 1700 }
    ]

    delegate: Rectangle {
      id: waterLine

      property var shimmer: modelData
      property real drift: 0

      x: ambient.gx(shimmer.x + drift)
      y: ambient.gy(shimmer.y)
      width: ambient.gw(shimmer.w)
      height: Math.max(1, ambient.gh(2))
      radius: height
      color: "#d8e5ff"
      opacity: 0

      SequentialAnimation on drift {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: waterLine.shimmer.delay }
        NumberAnimation { from: -12; to: 18; duration: 3100; easing.type: Easing.InOutCubic }
        PauseAnimation { duration: 1900 }
      }

      SequentialAnimation on opacity {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: waterLine.shimmer.delay }
        NumberAnimation { from: 0; to: 0.24; duration: 900; easing.type: Easing.InOutCubic }
        NumberAnimation { to: 0; duration: 2200; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 1900 }
      }
    }
  }

  Rectangle {
    id: portraitBacklight

    x: ambient.gx(415)
    y: ambient.gy(174)
    width: ambient.gw(124)
    height: ambient.gh(278)
    radius: Math.max(4, ambient.gw(18))
    color: "#E67E80"
    opacity: 0.05

    SequentialAnimation on opacity {
      running: ambient.active && ambient.visible
      loops: Animation.Infinite
      PauseAnimation { duration: 600 }
      NumberAnimation { from: 0.04; to: 0.11; duration: 1800; easing.type: Easing.InOutCubic }
      NumberAnimation { to: 0.05; duration: 2700; easing.type: Easing.InOutCubic }
      PauseAnimation { duration: 1300 }
    }
  }

  Repeater {
    model: [
      { "x": 424, "y": 407, "rise": 44, "size": 3, "delay": 0, "duration": 2600 },
      { "x": 452, "y": 431, "rise": 52, "size": 2, "delay": 850, "duration": 3000 },
      { "x": 504, "y": 382, "rise": 42, "size": 2, "delay": 1500, "duration": 2500 },
      { "x": 527, "y": 458, "rise": 58, "size": 3, "delay": 2200, "duration": 3200 }
    ]

    delegate: Rectangle {
      id: portraitEmber

      property var spark: modelData
      property real lift: 0
      property real side: 0

      x: ambient.gx(spark.x + side)
      y: ambient.gy(spark.y - lift)
      width: Math.max(2, ambient.gw(spark.size))
      height: width
      radius: width / 2
      color: "#E67E80"
      opacity: 0

      SequentialAnimation on lift {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: portraitEmber.spark.delay }
        NumberAnimation { from: 0; to: portraitEmber.spark.rise; duration: portraitEmber.spark.duration; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 1600 }
      }

      SequentialAnimation on side {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: portraitEmber.spark.delay }
        NumberAnimation { from: -4; to: 5; duration: portraitEmber.spark.duration; easing.type: Easing.InOutCubic }
        PauseAnimation { duration: 1600 }
      }

      SequentialAnimation on opacity {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: portraitEmber.spark.delay }
        NumberAnimation { from: 0; to: 0.74; duration: 520; easing.type: Easing.InOutCubic }
        NumberAnimation { to: 0; duration: portraitEmber.spark.duration - 520; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 1600 }
      }
    }
  }

  Rectangle {
    id: volcanoGlow

    x: ambient.gx(935)
    y: ambient.gy(204)
    width: ambient.gw(112)
    height: ambient.gh(80)
    radius: Math.min(width, height) / 2
    color: "#E67E80"
    opacity: 0.10

    SequentialAnimation on opacity {
      running: ambient.active && ambient.visible
      loops: Animation.Infinite
      NumberAnimation { from: 0.08; to: 0.20; duration: 1500; easing.type: Easing.InOutCubic }
      NumberAnimation { to: 0.09; duration: 2300; easing.type: Easing.InOutCubic }
      PauseAnimation { duration: 900 }
    }

    SequentialAnimation on scale {
      running: ambient.active && ambient.visible
      loops: Animation.Infinite
      NumberAnimation { from: 0.94; to: 1.10; duration: 2100; easing.type: Easing.InOutCubic }
      NumberAnimation { to: 0.98; duration: 2600; easing.type: Easing.InOutCubic }
    }
  }

  Repeater {
    model: [
      { "x": 972, "y": 231, "rise": 66, "size": 3, "delay": 0, "duration": 2800, "color": "#E67E80" },
      { "x": 1000, "y": 238, "rise": 74, "size": 2, "delay": 700, "duration": 3400, "color": "#DBBC7F" },
      { "x": 950, "y": 244, "rise": 48, "size": 2, "delay": 1600, "duration": 2600, "color": "#E67E80" }
    ]

    delegate: Rectangle {
      id: volcanoEmber

      property var ember: modelData
      property real lift: 0
      property real drift: 0

      x: ambient.gx(ember.x + drift)
      y: ambient.gy(ember.y - lift)
      width: Math.max(2, ambient.gw(ember.size))
      height: width
      radius: width / 2
      color: ember.color
      opacity: 0

      SequentialAnimation on lift {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: volcanoEmber.ember.delay }
        NumberAnimation { from: 0; to: volcanoEmber.ember.rise; duration: volcanoEmber.ember.duration; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 1700 }
      }

      SequentialAnimation on drift {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: volcanoEmber.ember.delay }
        NumberAnimation { from: -2; to: 8; duration: volcanoEmber.ember.duration; easing.type: Easing.InOutCubic }
        PauseAnimation { duration: 1700 }
      }

      SequentialAnimation on opacity {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: volcanoEmber.ember.delay }
        NumberAnimation { from: 0; to: 0.70; duration: 560; easing.type: Easing.InOutCubic }
        NumberAnimation { to: 0; duration: volcanoEmber.ember.duration - 560; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 1700 }
      }
    }
  }

  Rectangle {
    id: blueFlameOuter

    x: ambient.gx(1324)
    y: ambient.gy(442)
    width: ambient.gw(142)
    height: ambient.gh(132)
    radius: Math.min(width, height) / 2
    color: "#3b82ff"
    opacity: 0.16

    SequentialAnimation on opacity {
      running: ambient.active && ambient.visible
      loops: Animation.Infinite
      NumberAnimation { from: 0.11; to: 0.25; duration: 820; easing.type: Easing.InOutCubic }
      NumberAnimation { to: 0.14; duration: 1160; easing.type: Easing.InOutCubic }
      NumberAnimation { to: 0.22; duration: 680; easing.type: Easing.InOutCubic }
      NumberAnimation { to: 0.12; duration: 1320; easing.type: Easing.InOutCubic }
    }

    SequentialAnimation on scale {
      running: ambient.active && ambient.visible
      loops: Animation.Infinite
      NumberAnimation { from: 0.96; to: 1.07; duration: 980; easing.type: Easing.InOutCubic }
      NumberAnimation { to: 1.00; duration: 1280; easing.type: Easing.InOutCubic }
    }
  }

  Rectangle {
    id: blueFlameCore

    x: ambient.gx(1371)
    y: ambient.gy(476)
    width: ambient.gw(42)
    height: ambient.gh(72)
    radius: Math.min(width, height) / 2
    color: "#83C092"
    opacity: 0.34

    SequentialAnimation on opacity {
      running: ambient.active && ambient.visible
      loops: Animation.Infinite
      NumberAnimation { from: 0.22; to: 0.50; duration: 460; easing.type: Easing.InOutCubic }
      NumberAnimation { to: 0.28; duration: 760; easing.type: Easing.InOutCubic }
      NumberAnimation { to: 0.42; duration: 380; easing.type: Easing.InOutCubic }
      NumberAnimation { to: 0.24; duration: 940; easing.type: Easing.InOutCubic }
    }
  }

  Repeater {
    model: [
      { "x": 1354, "y": 540, "rise": 92, "size": 3, "delay": 0, "duration": 2200 },
      { "x": 1390, "y": 528, "rise": 112, "size": 2, "delay": 440, "duration": 2500 },
      { "x": 1428, "y": 548, "rise": 86, "size": 2, "delay": 980, "duration": 2100 },
      { "x": 1368, "y": 574, "rise": 74, "size": 2, "delay": 1500, "duration": 2300 },
      { "x": 1450, "y": 586, "rise": 70, "size": 3, "delay": 2100, "duration": 2600 }
    ]

    delegate: Rectangle {
      id: blueSpark

      property var spark: modelData
      property real lift: 0
      property real drift: 0

      x: ambient.gx(spark.x + drift)
      y: ambient.gy(spark.y - lift)
      width: Math.max(2, ambient.gw(spark.size))
      height: width
      radius: width / 2
      color: "#83C092"
      opacity: 0

      SequentialAnimation on lift {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: blueSpark.spark.delay }
        NumberAnimation { from: 0; to: blueSpark.spark.rise; duration: blueSpark.spark.duration; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 1200 }
      }

      SequentialAnimation on drift {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: blueSpark.spark.delay }
        NumberAnimation { from: -5; to: 6; duration: blueSpark.spark.duration; easing.type: Easing.InOutCubic }
        PauseAnimation { duration: 1200 }
      }

      SequentialAnimation on opacity {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: blueSpark.spark.delay }
        NumberAnimation { from: 0; to: 0.86; duration: 380; easing.type: Easing.InOutCubic }
        NumberAnimation { to: 0; duration: blueSpark.spark.duration - 380; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 1200 }
      }
    }
  }

  Rectangle {
    id: doorLight

    x: ambient.gx(1496)
    y: ambient.gy(252)
    width: ambient.gw(58)
    height: ambient.gh(304)
    radius: Math.max(2, ambient.gw(8))
    color: "#DBBC7F"
    opacity: 0.07

    SequentialAnimation on opacity {
      running: ambient.active && ambient.visible
      loops: Animation.Infinite
      NumberAnimation { from: 0.05; to: 0.13; duration: 5200; easing.type: Easing.InOutCubic }
      NumberAnimation { to: 0.06; duration: 6100; easing.type: Easing.InOutCubic }
    }
  }

  Rectangle {
    id: ravenSigil

    x: ambient.gx(1718)
    y: ambient.gy(89)
    width: ambient.gw(142)
    height: ambient.gh(212)
    radius: Math.max(4, ambient.gw(18))
    color: "#E67E80"
    opacity: 0.07

    SequentialAnimation on opacity {
      running: ambient.active && ambient.visible
      loops: Animation.Infinite
      PauseAnimation { duration: 1200 }
      NumberAnimation { from: 0.05; to: 0.16; duration: 1400; easing.type: Easing.InOutCubic }
      NumberAnimation { to: 0.06; duration: 2800; easing.type: Easing.InOutCubic }
      PauseAnimation { duration: 2200 }
    }
  }

  Rectangle {
    id: ravenEye

    x: ambient.gx(1742)
    y: ambient.gy(176)
    width: Math.max(3, ambient.gw(5))
    height: width
    radius: width / 2
    color: "#DBBC7F"
    opacity: 0

    SequentialAnimation on opacity {
      running: ambient.active && ambient.visible
      loops: Animation.Infinite
      PauseAnimation { duration: 4200 }
      NumberAnimation { from: 0; to: 0.95; duration: 140; easing.type: Easing.InOutCubic }
      NumberAnimation { to: 0; duration: 520; easing.type: Easing.OutCubic }
      PauseAnimation { duration: 7600 }
    }
  }

  Repeater {
    model: [
      { "x": 1698, "y": 523, "w": 24, "h": 58, "delay": 0 },
      { "x": 1768, "y": 534, "w": 20, "h": 48, "delay": 360 },
      { "x": 1832, "y": 512, "w": 22, "h": 62, "delay": 820 }
    ]

    delegate: Rectangle {
      id: candle

      property var flame: modelData

      x: ambient.gx(flame.x)
      y: ambient.gy(flame.y)
      width: ambient.gw(flame.w)
      height: ambient.gh(flame.h)
      radius: Math.min(width, height) / 2
      color: "#DBBC7F"
      opacity: 0.20

      SequentialAnimation on opacity {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: candle.flame.delay }
        NumberAnimation { from: 0.14; to: 0.36; duration: 300; easing.type: Easing.InOutCubic }
        NumberAnimation { to: 0.18; duration: 520; easing.type: Easing.InOutCubic }
        NumberAnimation { to: 0.30; duration: 260; easing.type: Easing.InOutCubic }
        NumberAnimation { to: 0.16; duration: 700; easing.type: Easing.InOutCubic }
      }

      SequentialAnimation on scale {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: candle.flame.delay }
        NumberAnimation { from: 0.92; to: 1.12; duration: 360; easing.type: Easing.InOutCubic }
        NumberAnimation { to: 0.96; duration: 560; easing.type: Easing.InOutCubic }
      }
    }
  }

  Repeater {
    model: [
      { "x": 38, "y": 101, "w": 266, "delay": 700 },
      { "x": 616, "y": 165, "w": 500, "delay": 2600 },
      { "x": 1218, "y": 128, "w": 182, "delay": 4600 },
      { "x": 1668, "y": 43, "w": 206, "delay": 6400 }
    ]

    delegate: Item {
      id: frameGlint

      property var glint: modelData
      property real pass: -0.24

      x: ambient.gx(glint.x)
      y: ambient.gy(glint.y)
      width: ambient.gw(glint.w)
      height: Math.max(2, ambient.gh(3))
      clip: true
      rotation: -1
      opacity: 0.75

      Rectangle {
        x: parent.width * frameGlint.pass
        y: 0
        width: Math.max(18, parent.width * 0.16)
        height: parent.height
        radius: height
        color: "#DBBC7F"
        opacity: 0.55
      }

      SequentialAnimation on pass {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: frameGlint.glint.delay }
        NumberAnimation { from: -0.24; to: 1.10; duration: 2100; easing.type: Easing.InOutCubic }
        PauseAnimation { duration: 7200 }
      }
    }
  }
}
