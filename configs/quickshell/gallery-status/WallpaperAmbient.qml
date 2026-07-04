import QtQuick
import "animations" as Animations

Item {
  id: root

  property bool active: true
  property int workspace: 12

  function hasAmbient(ws) {
    return ws >= 1 && ws <= 12;
  }

  function componentForWorkspace(ws) {
    if (ws === 1) return whitePainting1;
    if (ws === 2) return whitePainting2;
    if (ws === 3) return whitePainting3;
    if (ws === 4) return whitePainting4;
    if (ws === 5) return whitePainting5;
    if (ws === 6) return darkPainting1;
    if (ws === 7) return darkPainting2;
    if (ws === 8) return darkPainting3;
    if (ws === 9) return darkPainting4;
    if (ws === 10) return darkPainting5;
    if (ws === 11) return lightGallery;
    if (ws === 12) return darkGallery;
    return null;
  }

  Loader {
    id: ambientLoader

    anchors.fill: parent
    active: root.active && root.visible && root.hasAmbient(root.workspace)
    sourceComponent: root.componentForWorkspace(root.workspace)
  }

  Component {
    id: whitePainting1

    Animations.WhitePainting1Ambient {
      anchors.fill: parent
      active: root.active
    }
  }

  Component {
    id: whitePainting2

    Animations.WhitePainting2Ambient {
      anchors.fill: parent
      active: root.active
    }
  }

  Component {
    id: whitePainting3

    Animations.WhitePainting3Ambient {
      anchors.fill: parent
      active: root.active
    }
  }

  Component {
    id: whitePainting4

    Animations.WhitePainting4Ambient {
      anchors.fill: parent
      active: root.active
    }
  }

  Component {
    id: whitePainting5

    Animations.WhitePainting5Ambient {
      anchors.fill: parent
      active: root.active
    }
  }

  Component {
    id: darkPainting1

    Animations.DarkPainting1Ambient {
      anchors.fill: parent
      active: root.active
    }
  }

  Component {
    id: darkPainting2

    Animations.DarkPainting2Ambient {
      anchors.fill: parent
      active: root.active
    }
  }

  Component {
    id: darkPainting3

    Animations.DarkPainting3Ambient {
      anchors.fill: parent
      active: root.active
    }
  }

  Component {
    id: darkPainting4

    Animations.DarkPainting4Ambient {
      anchors.fill: parent
      active: root.active
    }
  }

  Component {
    id: darkPainting5

    Animations.DarkPainting5Ambient {
      anchors.fill: parent
      active: root.active
    }
  }

  Component {
    id: lightGallery

    Animations.LightGalleryAmbient {
      anchors.fill: parent
      active: root.active
    }
  }

  Component {
    id: darkGallery

    DarkGalleryAmbient {
      anchors.fill: parent
      active: root.active
    }
  }
}
