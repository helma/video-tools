import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.3

ApplicationWindow {
  id: root
  visible: true
  width: Screen.width; height: Screen.height
  color: "black"

  Component.onCompleted: { root.show() }

  Item {

    width: Screen.width
    height: Screen.height

    KeyboardVideo {
      id: video
      anchors.fill: parent
    }

  }
}
