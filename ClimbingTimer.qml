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
  width: Screen.width
  height: Screen.height
  color: "black"

  Component.onCompleted: {
    root.show()
    video.source = controller.files[0]
  }
   
  Controller {
    id: controller
  }


  Item {

    id: m
    width: Screen.width
    height: Screen.height
    focus: true

    //property var times : []
    property var holds : []
    property var releases : []
    property int lasttime
    property bool hold: false

    function add_time() {
      var pos = video.position
      if (!lasttime) { lasttime = pos; hold = true }
      else {
        if (hold) {
          holds.push(((pos - lasttime)/1000).toFixed(2))
          htext.text = holds.toString()
        } else {
          releases.push(((pos - lasttime)/1000).toFixed(2))
          rtext.text = releases.toString()
        }
        lasttime = pos
        hold = !hold
      }
    }

    function remove_time() {
      hold != hold
      hold ? holds.pop() : releases.pop()
    }

    Keys.onPressed: {
      switch (event.key) {
        case(Qt.Key_Q): controller.quit(); break
        case(Qt.Key_Return): add_time();break
        case(Qt.Key_Backspace): remove_time();break
      }
      event.accepted = true
    }
    Keys.forwardTo: video

    KeyboardVideo {
      id: video
      anchors.fill: parent
    }
    Text {
      id: htext
      anchors.bottom: rtext.top
      text: "NONE"
      color: "green"
    }
    Text {
      id: rtext
      anchors.bottom: parent.bottom
      text: "NONE"
      color: "red"
    }

  }
}
