import QtQuick 2.3
import QtMultimedia 5.0
import QtQuick.Window 2.2
import Marker 0.1

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
  function setStart() { marker.reset_marker("start",v.position) }
  function setEnd() { marker.reset_marker("end",v.position) }
  function deleteStart() { marker.reset_marker("start",0) }
  function deleteEnd() { marker.reset_marker("end",v.duration) }
  function ffwd() { v.seek(v.position + 1000) }
  function fbwd() { v.seek(v.position - 1000) }
  function fwd() { v.seek(v.position + 50) }
  function bwd() { v.seek(v.position - 50) }
  function setMark() { marker.add_marker("marker",v.position) }
  function deleteMark() { marker.delete_marker_before(v.position) }
  function next_marker() { v.seek(marker.next_marker_position(v.position)) }
  function prev_marker() { v.seek(marker.prev_marker_position(v.position)) }

  Component.onCompleted: { video.source = marker.file }
   
  Marker { id: marker }

  Timer {
    id: t
    interval: 10; running: true; repeat: true
    onTriggered: {
      cursor.x = videoDisplay.ratio * v.position - cursor.width/2
      if (v.position > 0 && v.position >= marker.ende()) {
        seek(marker.start())
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
      if (status == 6) {
        if (!marker.start()) marker.reset_marker("start", 0)
        if (!marker.ende()) marker.reset_marker("end", v.duration)
      }
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

  Text {
    text: ((marker.next_marker_position(v.position) - marker.prev_marker_position(v.position))/1000).toFixed(2)
    color: "white"
    //y: Screen.height - 4*cursor.height/2
    //x: (marker.prev_marker_position(v.position) + (marker.next_marker_position(v.position) - marker.prev_marker_position(v.position))/2)*ratio
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
    Item {
      Rectangle {
        x: time*ratio - width/2
        y: Screen.height //- 3*height/2
        width: 10
        height: 10
        color: {
          switch (name) {
            case("start"): return "green"; break
            case("end"): return "red"; break
            case("marker"): return "blue"; break
          }
        }
        transform: Rotation {
          origin.x: 0
          origin.y: 0
          angle: -45
        }
      }

      Text {
        property int prev: marker.prev_marker_position(time-1) ? marker.prev_marker_position(time-1) : 0
        text: ((time - prev)/1000).toFixed(2)
        color: "white"
        y: Screen.height - 4*cursor.height/2
        x: (prev + (time - prev)/2)*ratio
        font.pointSize: 6
      }
  }
  }

  Repeater {
    id: m
    model: marker.markers
    anchors.fill: parent
    delegate: delegate
  }

}
