import QtQuick 2.3
import QtMultimedia 5.0

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

  function play() { v.play() }
  function pause() { v.pause() }
  function seek(s) { v.seek(s) }
  function toggle() { v.playbackState == MediaPlayer.PlayingState ? v.pause() : v.play() }
  function slower() { v.playbackRate = v.playbackRate/2.0 }
  function faster() { v.playbackRate = v.playbackRate*2.0 }
  function setStart() { start = v.position }
  function setEnd() { end = v.position }
  function deleteStart() { start = 0 }
  function deleteEnd() { end = v.duration }
  function ffwd() { v.seek(v.position + 1000) }
  function fbwd() { v.seek(v.position - 1000) }
  function fwd() { v.seek(v.position + 50) }
  function bwd() { v.seek(v.position - 50) }

  Video {
    id: v
    autoPlay: true
    anchors.top: parent.top
    anchors.left: parent.left
    width: parent.width
    height: parent.height*0.95
    muted: true
    onPositionChanged: {
      if (v.position > 0 && v.position >= videoDisplay.end) {
        seek(videoDisplay.start)
      }
    }
  }

  Row {
    id: r
    anchors.top: v.bottom
    anchors.verticalCenter: parent.verticalCenter
    Text {
      text: (v.position/1000).toFixed(1) + "/" + (v.duration/1000).toFixed(1) + '", '
      color: videoDisplay.activeFocus ? "green" : "white"
    }
    Text {
      text: "Rate: " + v.playbackRate.toFixed(2) + ", "
      color: videoDisplay.activeFocus ? "green" : "white"
    }
    Text {
      text: "Start: " + (videoDisplay.start/1000).toFixed(2) + ", "
      color: videoDisplay.activeFocus ? "green" : "white"
    }
    Text {
      text: "End: " + (videoDisplay.end/1000).toFixed(2) + ", "
      color: videoDisplay.activeFocus ? "green" : "white"
    }
    Text {
      text: "Dur: " + ((videoDisplay.end-videoDisplay.start)/1000).toFixed(2) 
      color: videoDisplay.activeFocus ? "green" : "white"
    }
  }
}
