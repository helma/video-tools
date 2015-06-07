import QtQuick 2.3
import QtMultimedia 5.0
import QtQuick.Window 2.2
import Controller 0.1

Item {

  id: videoDisplay
  anchors.fill: parent
  focus: true

  property alias rate: v.playbackRate
  property alias source: v.source
  property alias position: v.position

  property real start: 0
  property real end: v.duration
  property bool loop
  property real ratio: Screen.width/v.duration

  function play() { v.play() }
  function pause() { v.pause() }
  function seek(s) { v.seek(s) }
  function toggle() { v.playbackState == MediaPlayer.PlayingState ? v.pause() : v.play() }
  function slower() { v.playbackRate = v.playbackRate/2.0 }
  function faster() { v.playbackRate = v.playbackRate*2.0 }
  function setStart() { start = v.position; s.x = start*ratio }
  function setEnd() { end = v.position }
  function deleteStart() { start = 0 }
  function deleteEnd() { end = v.duration }
  function ffwd() { v.seek(v.position + 1000) }
  function fbwd() { v.seek(v.position - 1000) }
  function fwd() { v.seek(v.position + 50) }
  function bwd() { v.seek(v.position - 50) }
  function setMark() { controller.add_marker(v.position) }

  Component.onCompleted: {
    video.source = controller.files[0]
  }
   
  Controller {
    id: controller
  }

  Timer {
    id: t
    interval: 1; running: true; repeat: true
    onTriggered: {
      cursor.x = videoDisplay.ratio * v.position - cursor.width/2
      if (v.position > 0 && v.position >= videoDisplay.end) {
        seek(videoDisplay.start)
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
    Text {
      text: "Start: " + (videoDisplay.start/1000).toFixed(2) + ", "
      color: "white"
    }
    Text {
      text: "End: " + (videoDisplay.end/1000).toFixed(2) + ", "
      color: "white"
    }
    Text {
      text: "Dur: " + ((videoDisplay.end-videoDisplay.start)/1000).toFixed(2) 
      color: "white"
    }
  }

  Rectangle {
    id: cursor
    x: 0
    y: Screen.height - 3*height/2
    width: 4
    height: 12
    color: "white"
  }

  Rectangle {
    id: s
    x: start * ratio 
    y: Screen.height - 3*height/2
    width: 5
    height: 12
    color: "green"
  }

  Rectangle {
    id: e
    x: end * ratio - width
    y: Screen.height - 3*height/2
    width: 5
    height: 12
    color: "red"
  }

  Component {
    id: delegate
    Rectangle {
      x: t*ratio
      y: Screen.height - 3*height/2
      width: 5
      height: 5
      color: "blue"
    }
  }

  Repeater {
    id: m
    model: controller.markers
    anchors.fill: parent
    delegate: delegate
  }
  /*
  Text {
    //anchors.bottom: parent.bottom
      y: Screen.height - 10
    //id: tm
    text: controller.markers.count
    color: "white"
  }
  */
}
