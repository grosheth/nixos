import QtQuick

Item {
  id: effects

  property bool active: true
  property real sourceWidth: 1916
  property real sourceHeight: 821
  property var glows: []
  property var particles: []
  property var rays: []
  property var sweeps: []
  property var twinkles: []
  property var wisps: []

  function pick(item, key, fallback) {
    return item && item[key] !== undefined ? item[key] : fallback;
  }

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

  Repeater {
    model: effects.glows

    delegate: Rectangle {
      id: glow

      property var effect: modelData

      x: effects.gx(effects.pick(effect, "x", 0))
      y: effects.gy(effects.pick(effect, "y", 0))
      width: effects.gw(effects.pick(effect, "w", 80))
      height: effects.gh(effects.pick(effect, "h", effects.pick(effect, "w", 80)))
      radius: effects.pick(effect, "radius", Math.min(width, height) / 2)
      color: effects.pick(effect, "color", "#ffffff")
      opacity: effects.pick(effect, "from", 0.06)
      rotation: effects.pick(effect, "rotation", 0)

      SequentialAnimation on opacity {
        running: effects.active && effects.visible
        loops: Animation.Infinite
        PauseAnimation { duration: effects.pick(glow.effect, "delay", 0) }
        NumberAnimation {
          from: effects.pick(glow.effect, "from", 0.06)
          to: effects.pick(glow.effect, "to", 0.16)
          duration: effects.pick(glow.effect, "up", 1400)
          easing.type: Easing.InOutCubic
        }
        NumberAnimation {
          to: effects.pick(glow.effect, "from", 0.06)
          duration: effects.pick(glow.effect, "down", 2200)
          easing.type: Easing.InOutCubic
        }
        PauseAnimation { duration: effects.pick(glow.effect, "rest", 0) }
      }

      SequentialAnimation on scale {
        running: effects.active && effects.visible
        loops: Animation.Infinite
        PauseAnimation { duration: effects.pick(glow.effect, "delay", 0) }
        NumberAnimation {
          from: effects.pick(glow.effect, "scaleFrom", 0.96)
          to: effects.pick(glow.effect, "scaleTo", 1.06)
          duration: effects.pick(glow.effect, "up", 1400)
          easing.type: Easing.InOutCubic
        }
        NumberAnimation {
          to: effects.pick(glow.effect, "scaleFrom", 0.96)
          duration: effects.pick(glow.effect, "down", 2200)
          easing.type: Easing.InOutCubic
        }
        PauseAnimation { duration: effects.pick(glow.effect, "rest", 0) }
      }
    }
  }

  Repeater {
    model: effects.rays

    delegate: Rectangle {
      id: ray

      property var effect: modelData

      x: effects.gx(effects.pick(effect, "x", 0))
      y: effects.gy(effects.pick(effect, "y", 0))
      width: effects.gw(effects.pick(effect, "w", 80))
      height: effects.gh(effects.pick(effect, "h", 260))
      radius: effects.pick(effect, "radius", Math.max(2, width / 2))
      rotation: effects.pick(effect, "rotation", 0)
      color: effects.pick(effect, "color", "#ffffff")
      opacity: effects.pick(effect, "from", 0.03)

      SequentialAnimation on opacity {
        running: effects.active && effects.visible
        loops: Animation.Infinite
        PauseAnimation { duration: effects.pick(ray.effect, "delay", 0) }
        NumberAnimation {
          from: effects.pick(ray.effect, "from", 0.03)
          to: effects.pick(ray.effect, "to", 0.10)
          duration: effects.pick(ray.effect, "up", 2600)
          easing.type: Easing.InOutCubic
        }
        NumberAnimation {
          to: effects.pick(ray.effect, "from", 0.03)
          duration: effects.pick(ray.effect, "down", 3600)
          easing.type: Easing.InOutCubic
        }
        PauseAnimation { duration: effects.pick(ray.effect, "rest", 0) }
      }
    }
  }

  Repeater {
    model: effects.sweeps

    delegate: Rectangle {
      id: sweep

      property var effect: modelData
      property real pass: effects.pick(effect, "start", -0.2)

      x: effects.gx(effects.pick(effect, "x", 0) + effects.pick(effect, "travelX", 0) * pass)
      y: effects.gy(effects.pick(effect, "y", 0) + effects.pick(effect, "travelY", 0) * pass)
      width: effects.gw(effects.pick(effect, "w", 160))
      height: Math.max(1, effects.gh(effects.pick(effect, "h", 3)))
      radius: height
      rotation: effects.pick(effect, "rotation", 0)
      color: effects.pick(effect, "color", "#ffffff")
      opacity: effects.pick(effect, "opacity", 0.12)

      SequentialAnimation on pass {
        running: effects.active && effects.visible
        loops: Animation.Infinite
        PauseAnimation { duration: effects.pick(sweep.effect, "delay", 0) }
        NumberAnimation {
          from: effects.pick(sweep.effect, "start", -0.2)
          to: effects.pick(sweep.effect, "end", 1.1)
          duration: effects.pick(sweep.effect, "duration", 3600)
          easing.type: Easing.InOutCubic
        }
        PauseAnimation { duration: effects.pick(sweep.effect, "rest", 2200) }
      }
    }
  }

  Repeater {
    model: effects.particles

    delegate: Rectangle {
      id: particle

      property var effect: modelData
      property real lift: 0
      property real drift: effects.pick(effect, "fromX", 0)

      x: effects.gx(effects.pick(effect, "x", 0) + drift)
      y: effects.gy(effects.pick(effect, "y", 0) - lift)
      width: Math.max(1, effects.gw(effects.pick(effect, "size", 3)))
      height: width
      radius: width / 2
      color: effects.pick(effect, "color", "#ffffff")
      opacity: 0

      SequentialAnimation on lift {
        running: effects.active && effects.visible
        loops: Animation.Infinite
        PauseAnimation { duration: effects.pick(particle.effect, "delay", 0) }
        NumberAnimation {
          from: 0
          to: effects.pick(particle.effect, "rise", 40)
          duration: effects.pick(particle.effect, "duration", 2600)
          easing.type: Easing.OutCubic
        }
        PauseAnimation { duration: effects.pick(particle.effect, "rest", 1600) }
      }

      SequentialAnimation on drift {
        running: effects.active && effects.visible
        loops: Animation.Infinite
        PauseAnimation { duration: effects.pick(particle.effect, "delay", 0) }
        NumberAnimation {
          from: effects.pick(particle.effect, "fromX", -4)
          to: effects.pick(particle.effect, "toX", 8)
          duration: effects.pick(particle.effect, "duration", 2600)
          easing.type: Easing.InOutCubic
        }
        PauseAnimation { duration: effects.pick(particle.effect, "rest", 1600) }
      }

      SequentialAnimation on opacity {
        running: effects.active && effects.visible
        loops: Animation.Infinite
        PauseAnimation { duration: effects.pick(particle.effect, "delay", 0) }
        NumberAnimation {
          from: 0
          to: effects.pick(particle.effect, "peak", 0.72)
          duration: effects.pick(particle.effect, "fadeIn", 500)
          easing.type: Easing.InOutCubic
        }
        NumberAnimation {
          to: 0
          duration: Math.max(1, effects.pick(particle.effect, "duration", 2600) - effects.pick(particle.effect, "fadeIn", 500))
          easing.type: Easing.OutCubic
        }
        PauseAnimation { duration: effects.pick(particle.effect, "rest", 1600) }
      }
    }
  }

  Repeater {
    model: effects.wisps

    delegate: Rectangle {
      id: wisp

      property var effect: modelData
      property real lift: 0
      property real drift: effects.pick(effect, "fromX", 0)

      x: effects.gx(effects.pick(effect, "x", 0) + drift)
      y: effects.gy(effects.pick(effect, "y", 0) - lift)
      width: effects.gw(effects.pick(effect, "w", 34))
      height: effects.gh(effects.pick(effect, "h", 16))
      radius: Math.min(width, height) / 2
      color: effects.pick(effect, "color", "#ffffff")
      opacity: 0

      SequentialAnimation on lift {
        running: effects.active && effects.visible
        loops: Animation.Infinite
        PauseAnimation { duration: effects.pick(wisp.effect, "delay", 0) }
        NumberAnimation {
          from: 0
          to: effects.pick(wisp.effect, "rise", 50)
          duration: effects.pick(wisp.effect, "duration", 5200)
          easing.type: Easing.OutCubic
        }
        PauseAnimation { duration: effects.pick(wisp.effect, "rest", 2400) }
      }

      SequentialAnimation on drift {
        running: effects.active && effects.visible
        loops: Animation.Infinite
        PauseAnimation { duration: effects.pick(wisp.effect, "delay", 0) }
        NumberAnimation {
          from: effects.pick(wisp.effect, "fromX", -6)
          to: effects.pick(wisp.effect, "toX", 16)
          duration: effects.pick(wisp.effect, "duration", 5200)
          easing.type: Easing.InOutCubic
        }
        PauseAnimation { duration: effects.pick(wisp.effect, "rest", 2400) }
      }

      SequentialAnimation on opacity {
        running: effects.active && effects.visible
        loops: Animation.Infinite
        PauseAnimation { duration: effects.pick(wisp.effect, "delay", 0) }
        NumberAnimation {
          from: 0
          to: effects.pick(wisp.effect, "peak", 0.08)
          duration: effects.pick(wisp.effect, "fadeIn", 1200)
          easing.type: Easing.InOutCubic
        }
        NumberAnimation {
          to: 0
          duration: Math.max(1, effects.pick(wisp.effect, "duration", 5200) - effects.pick(wisp.effect, "fadeIn", 1200))
          easing.type: Easing.OutCubic
        }
        PauseAnimation { duration: effects.pick(wisp.effect, "rest", 2400) }
      }
    }
  }

  Repeater {
    model: effects.twinkles

    delegate: Rectangle {
      id: twinkle

      property var effect: modelData

      x: effects.gx(effects.pick(effect, "x", 0))
      y: effects.gy(effects.pick(effect, "y", 0))
      width: Math.max(2, effects.gw(effects.pick(effect, "size", 4)))
      height: width
      radius: width / 2
      color: effects.pick(effect, "color", "#ffffff")
      opacity: 0

      SequentialAnimation on opacity {
        running: effects.active && effects.visible
        loops: Animation.Infinite
        PauseAnimation { duration: effects.pick(twinkle.effect, "delay", 0) }
        NumberAnimation {
          from: 0
          to: effects.pick(twinkle.effect, "peak", 0.85)
          duration: effects.pick(twinkle.effect, "up", 180)
          easing.type: Easing.InOutCubic
        }
        NumberAnimation {
          to: 0
          duration: effects.pick(twinkle.effect, "down", 760)
          easing.type: Easing.OutCubic
        }
        PauseAnimation { duration: effects.pick(twinkle.effect, "rest", 4200) }
      }
    }
  }
}
