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
    video1.source = controller.files[0]
    //video2.source = controller.files[1]
  }
   
  Controller {
    id: controller
  }


  Item {

    Keys.onPressed: {
      switch (event.key) {
        case(Qt.Key_Q): controller.quit()
      }
      event.accepted = true
    }

    Row {
      id: videos
      KeyboardVideo {
        //activeFocusOnTab : true
        id: video1
        focus: true
        width: Screen.width/2
        height: Screen.height/2
      }
      /*
      KeyboardVideo {
        //activeFocusOnTab : true
        id: video2
        //focus: false
        width: Screen.width/2
        height: Screen.height/2
      }
      */
    }

  }
}
