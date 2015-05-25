import QtQuick 2.3
import QtMultimedia 5.0
import QtQuick.Dialogs 1.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0

Window {
  id: root
  visible: true
  width: Screen.width; height: Screen.height
  color: "black"

  FileDialog {
      id: fileDialog1
      title: "Please choose a file"
      onAccepted: {
          video1.stop()
          video1.source = fileDialog1.fileUrl
      }
      Component.onCompleted: visible = false
  }
  FileDialog {
      id: fileDialog2
      title: "Please choose a file"
      onAccepted: {
          video2.stop()
          video2.source = fileDialog2.fileUrl
      }
      Component.onCompleted: visible = false
  }

  Column {
    Row {
      Column {
        Video {
          id: video1
          width: Screen.width/2
          height: Screen.height*0.95
          muted: true
          onPositionChanged: pos1.value = video1.position/video1.duration
        }
        Row {
          anchors.horizontalCenter: video1.horizontalCenter
          Button {
            text: "Open"
            onClicked: fileDialog1.open()
          }
          Slider {
            id: pos1
            value: 0.0
            onValueChanged: {
              //video1.stop()
              //video2.stop()
              video1.seek(video1.duration*pos1.value)
            }
          }
        }
      }
      Column {
        Video {
          id: video2
          width: Screen.width/2
          height: Screen.height*0.95
          muted: true
          onPositionChanged: pos2.value = video2.position/video2.duration
        }
        Row {
          anchors.horizontalCenter: video2.horizontalCenter
          Button {
            text: "Open"
            onClicked: fileDialog2.open()
          }
          Slider {
            id: pos2
            value: 0.0
            onValueChanged: {
              if (pos2.pressed) {
                video2.pause()
                video2.seek(video2.duration*pos2.value)
                if (player.running) { video2.play() }
              }
            }
          }
        }
      }
    }
    Row {
      anchors.horizontalCenter: root.horizontalCenter
      Button {
        id: player
        property bool running
        text: ">"
        onClicked: {
          if (player.running) {
            video1.pause()
            video2.pause()
            player.running = false
            player.text = ">"
          } else {
            video1.play()
            video2.play()
            player.running = true
            player.text = "||"
          }
        }
      }
      Slider {
        id: speed
        value: 1.0
        maximumValue: 4.0
        onValueChanged: {
          video1.playbackRate = value
          video2.playbackRate = value
        }
      }
    }
  }
}
