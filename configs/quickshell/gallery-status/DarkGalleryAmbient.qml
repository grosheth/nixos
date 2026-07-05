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

  // Rectangle {
  //   id: floorReflection
  //
  //   x: ambient.gx(260 + 1050 * ambient.floorSweep)
  //   y: ambient.gy(622)
  //   width: ambient.gw(460)
  //   height: Math.max(2, ambient.gh(3))
  //   rotation: -4
  //   color: "#7FBBB3"
  //   opacity: 0.10
  // }

  Rectangle {
    x: ambient.gx(510 + 720 * ambient.floorSweep)
    y: ambient.gy(681)
    width: ambient.gw(340)
    height: Math.max(1, ambient.gh(2))
    rotation: -2
    color: "#DBBC7F"
    opacity: 0.03
}

  Rectangle {
    id: moonGlow

    x: ambient.gx(154)
    y: ambient.gy(102)
    width: ambient.gw(41)
    height: ambient.gh(41)
    radius: Math.min(width, height) / 2
    // color: "#d8e5ff"
    color: "#ffffff"
    opacity: 0.01

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
      { "x": 86, "y": 451, "w": 90, "delay": 0 },
      { "x": 118, "y": 484, "w": 100, "delay": 900 },
      { "x": 70, "y": 421, "w": 70, "delay": 1700 }
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

  Repeater {
    model: [
      { "x": 205, "y": 335, "rise": 20, "size": 2, "delay": 0, "duration": 2600 },
      { "x": 215, "y": 335, "rise": 32, "size": 1, "delay": 850, "duration": 3000 },
      { "x": 220, "y": 335, "rise": 22, "size": 1, "delay": 1500, "duration": 2500 },
      { "x": 210, "y": 335, "rise": 38, "size": 2, "delay": 2200, "duration": 3200 }
    ]

    delegate: Rectangle {
      id: shipEmber

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
        PauseAnimation { duration: shipEmber.spark.delay }
        NumberAnimation { from: 0; to: shipEmber.spark.rise; duration: shipEmber.spark.duration; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 1600 }
      }

      SequentialAnimation on side {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: shipEmber.spark.delay }
        NumberAnimation { from: -4; to: 5; duration: shipEmber.spark.duration; easing.type: Easing.InOutCubic }
        PauseAnimation { duration: 1600 }
      }

      SequentialAnimation on opacity {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: shipEmber.spark.delay }
        NumberAnimation { from: 0; to: 0.74; duration: 520; easing.type: Easing.InOutCubic }
        NumberAnimation { to: 0; duration: shipEmber.spark.duration - 520; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 1600 }
      }
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

    x: ambient.gx(1040)
    y: ambient.gy(230)
    width: ambient.gw(10)
    height: ambient.gh(10)
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
      { "x": 1040, "y": 231, "rise": 66, "size": 3, "delay": 0, "duration": 2800, "color": "#E67E80" },
      { "x": 1040, "y": 238, "rise": 74, "size": 2, "delay": 700, "duration": 3400, "color": "#DBBC7F" },
      { "x": 1040, "y": 244, "rise": 48, "size": 2, "delay": 1600, "duration": 2600, "color": "#E67E80" }
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

  Repeater {
    model: [
      { "x": 1040, "y": 221, "rise": 84, "size": 24, "delay": 500, "duration": 5200 },
      { "x": 1040, "y": 214, "rise": 98, "size": 18, "delay": 1800, "duration": 6200 },
      { "x": 1040, "y": 230, "rise": 76, "size": 20, "delay": 3200, "duration": 5600 }
    ]

    delegate: Rectangle {
      id: smokeWisp

      property var wisp: modelData
      property real lift: 0
      property real drift: 0

      x: ambient.gx(wisp.x + drift)
      y: ambient.gy(wisp.y - lift)
      width: ambient.gw(wisp.size)
      height: ambient.gh(wisp.size * 0.62)
      radius: Math.min(width, height) / 2
      color: "#D3C6AA"
      opacity: 0

      SequentialAnimation on lift {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: smokeWisp.wisp.delay }
        NumberAnimation { from: 0; to: smokeWisp.wisp.rise; duration: smokeWisp.wisp.duration; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 2400 }
      }

      SequentialAnimation on drift {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: smokeWisp.wisp.delay }
        NumberAnimation { from: -6; to: 18; duration: smokeWisp.wisp.duration; easing.type: Easing.InOutCubic }
        PauseAnimation { duration: 2400 }
      }

      SequentialAnimation on opacity {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: smokeWisp.wisp.delay }
        NumberAnimation { from: 0; to: 0.06; duration: 1200; easing.type: Easing.InOutCubic }
        NumberAnimation { to: 0; duration: smokeWisp.wisp.duration - 1200; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 2400 }
      }
    }
  }

  Repeater {
    model: [
      { "x": 1246, "y": 350, "rise": 54, "size": 2, "delay": 300, "duration": 2600 },
      { "x": 1296, "y": 421, "rise": 68, "size": 3, "delay": 1100, "duration": 3100 },
      { "x": 1354, "y": 382, "rise": 48, "size": 2, "delay": 1900, "duration": 2800 },
      { "x": 1384, "y": 455, "rise": 56, "size": 2, "delay": 2700, "duration": 3200 }
    ]

    delegate: Rectangle {
      id: topHatEmber

      property var ember: modelData
      property real lift: 0
      property real drift: 0

      x: ambient.gx(ember.x + drift)
      y: ambient.gy(ember.y - lift)
      width: Math.max(2, ambient.gw(ember.size))
      height: width
      radius: width / 2
      color: "#E67E80"
      opacity: 0

      SequentialAnimation on lift {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: topHatEmber.ember.delay }
        NumberAnimation { from: 0; to: topHatEmber.ember.rise; duration: topHatEmber.ember.duration; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 1500 }
      }

      SequentialAnimation on drift {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: topHatEmber.ember.delay }
        NumberAnimation { from: -4; to: 7; duration: topHatEmber.ember.duration; easing.type: Easing.InOutCubic }
        PauseAnimation { duration: 1500 }
      }

      SequentialAnimation on opacity {
        running: ambient.active && ambient.visible
        loops: Animation.Infinite
        PauseAnimation { duration: topHatEmber.ember.delay }
        NumberAnimation { from: 0; to: 0.64; duration: 480; easing.type: Easing.InOutCubic }
        NumberAnimation { to: 0; duration: topHatEmber.ember.duration - 480; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 1500 }
      }
    }
  }

  Rectangle {
    id: blueFlameOuter

    x: ambient.gx(1390)
    y: ambient.gy(470)
    width: ambient.gw(40)
    height: ambient.gh(40)
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

  Repeater {
    model: [
      { "x": 1454, "y": 540, "rise": 92, "size": 3, "delay": 0, "duration": 2200 },
      { "x": 1490, "y": 528, "rise": 112, "size": 2, "delay": 440, "duration": 2500 },
      { "x": 1428, "y": 548, "rise": 86, "size": 2, "delay": 980, "duration": 2100 },
      { "x": 1468, "y": 574, "rise": 74, "size": 2, "delay": 1500, "duration": 2300 },
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
    id: ravenEye

    x: ambient.gx(1736)
    y: ambient.gy(171)
    width: Math.max(1, ambient.gw(2))
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
      { "x": 1772, "y": 456, "w": 5, "h": 10, "delay": 0 },
      { "x": 1791, "y": 428, "w": 5, "h": 10, "delay": 360 },
      { "x": 1817, "y": 433, "w": 5, "h": 10, "delay": 820 }
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
      { "x": 610, "y": 165, "w": 100, "delay": 2600 },
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
      rotation: 0
      opacity: 0.75

      Rectangle {
        x: parent.width * frameGlint.pass
        y: 0
        width: Math.max(1, parent.width * 0.16)
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
