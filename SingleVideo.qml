import QtQuick 2.3
import QtMultimedia 5.0
import QtQuick.Dialogs 1.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0
import Controller 0.1

ApplicationWindow {
  id: root
  visible: true
  width: Screen.width; height: Screen.height
  color: "black"

  Component.onCompleted: {
    root.show()
    video.source = controller.files[0]
  }
   
  Controller {
    id: controller
  }


  Item {

    width: Screen.width
    height: Screen.height
    focus: true

    Keys.onPressed: {
      switch (event.key) {
        case(Qt.Key_Q): controller.quit()
      }
      event.accepted = true
    }
    Keys.forwardTo: video

    //VideoDisplay {
    KeyboardVideo {
      id: video
      anchors.fill: parent
    }

  }
}
