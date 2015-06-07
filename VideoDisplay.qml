import QtQuick 2.3
import QtMultimedia 5.0
import QtQuick.Window 2.2
import Controller 0.1

Item {

  id: videoDisplay
  anchors.fill: parent

  property alias rate: v.playbackRate
  property alias source: v.source
  property alias position: v.position

  property bool loop
  property real ratio: Screen.width/v.duration

  function play() { v.play() }
  function pause() { v.pause() }
  function seek(s) { v.seek(s) }
  function toggle() { v.playbackState == MediaPlayer.PlayingState ? v.pause() : v.play() }
  function slower() { v.playbackRate = v.playbackRate/2.0 }
  function faster() { v.playbackRate = v.playbackRate*2.0 }
  function setStart() { controller.reset_marker("start",v.position) }
  function setEnd() { controller.reset_marker("end",v.position) }
  function deleteStart() { controller.reset_marker("start",0) }
  function deleteEnd() { controller.reset_marker("end",v.duration) }
  function ffwd() { v.seek(v.position + 1000) }
  function fbwd() { v.seek(v.position - 1000) }
  function fwd() { v.seek(v.position + 50) }
  function bwd() { v.seek(v.position - 50) }
  function setMark() { controller.add_marker("marker",v.position) }
  function deleteMark() { controller.delete_marker("marker",v.position) }

  Component.onCompleted: {
    video.source = controller.file
    if (!controller.start) controller.add_marker("start", 0)
  }
   
  Controller {
    id: controller
  }

  Timer {
    id: t
    interval: 10; running: true; repeat: true
    onTriggered: {
      cursor.x = videoDisplay.ratio * v.position - cursor.width/2
      if (v.position > 0 && v.position >= controller.ende()) {
        seek(controller.start())
      }
    }
  }

  Video {
    id: v
    autoPlay: true
    anchors.top: parent.top
    anchors.left: parent.left
    width: parent.width
    height: parent.height*0.95
    muted: true
    onStatusChanged: {
      if ((status == 6) && (!controller.ende())) controller.add_marker("end", 0)
    }

  }

  Row {
    id: r
    anchors.top: v.bottom
    anchors.verticalCenter: parent.verticalCenter
    Text {
      text: (v.position/1000).toFixed(1) + "/" + (v.duration/1000).toFixed(1) + '", '
      color: "white"
    }
    Text {
      text: "Rate: " + v.playbackRate.toFixed(2) + ", "
      color: "white"
    }
  }

  Rectangle {
    id: cursor
    x: 0
    y: Screen.height - 3*height/2
    width: 1
    height: 12
    color: "white"
  }

  Component {
    id: delegate
    Rectangle {
      x: time*ratio - width/2
      y: Screen.height - 3*height/2
      width: 6
      height: 6
      color: {
        switch (name) {
          case("start"): return "green"; break
          case("end"): return "red"; break
          case("marker"): return "blue"; break
        }
      }
    }
  }

  Repeater {
    id: m
    model: controller.markers
    anchors.fill: parent
    delegate: delegate
  }

}
