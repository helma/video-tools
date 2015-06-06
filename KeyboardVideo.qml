import QtQuick 2.3

Item {

  property alias source: videoDisplay.source
  anchors.fill: parent
  focus: true

  Keys.onPressed: {
    switch (event.key) {
      case(Qt.Key_Space): videoDisplay.toggle(); break
      case(Qt.Key_Up): videoDisplay.faster(); break
      case(Qt.Key_Down): videoDisplay.slower(); break
      case(Qt.Key_J): videoDisplay.bwd(); break
      case(Qt.Key_K): videoDisplay.fwd(); break
      case(Qt.Key_H): videoDisplay.fbwd(); break
      case(Qt.Key_L): videoDisplay.ffwd(); break
      case(Qt.Key_Comma): videoDisplay.setStart(); break 
      case(Qt.Key_Period): videoDisplay.setEnd(); break
      case(Qt.Key_M): videoDisplay.deleteStart(); break 
      case(Qt.Key_Slash): videoDisplay.deleteEnd(); break
    }
  }

  VideoDisplay {
    id: videoDisplay
    anchors.fill: parent
  }
}
