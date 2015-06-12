import QtQuick 2.3

Item {

  property alias source: videoDisplay.source
  property alias position: videoDisplay.position
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
      case(Qt.Key_Return): videoDisplay.setMark();break
      case(Qt.Key_Backspace): videoDisplay.deleteMark();break
      case(Qt.Key_Tab): videoDisplay.next_marker();break
      case(Qt.Key_Backtab): videoDisplay.prev_marker();break
      case(Qt.Key_S): model.save();break
      case(Qt.Key_Q): model.quit();break
    }
  }

  VideoDisplay {
    id: videoDisplay
    anchors.fill: parent
  }
}
