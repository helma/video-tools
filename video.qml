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
          video1.play()
      }
      Component.onCompleted: visible = false
  }
  FileDialog {
      id: fileDialog2
      title: "Please choose a file"
      onAccepted: {
          video2.stop()
          video2.source = fileDialog2.fileUrl
          video2.play()
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
          source: "../videos/climbing/rissprojekt/riss1.mp4"
          autoLoad: true
          muted: true
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
            onValueChanged: video1.seek(video1.duration*pos1.value)
          }
        }
      }
      Column {
        Video {
          id: video2
          width: Screen.width/2
          height: Screen.height*0.95
          source: "../videos/climbing/rissprojekt/riss3.mp4"
          autoLoad: true
          muted: true
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
            onValueChanged: video2.seek(video2.duration*pos2.value)
          }
        }
      }
    }
    Row {
      Button {
        text: ">"
        onClicked: {
        video1.playbackState == MediaPlayer.PlayingState ? video1.pause() : video1.play()
        video2.playbackState == MediaPlayer.PlayingState ? video2.pause() : video2.play()
          }
      }
    }
  }
}
