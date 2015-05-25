//#!/usr/bin/env qml

import QtMultimedia 5.0
import QtQuick 2.3
import QtQuick.Dialogs 1.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import Controller 0.1

ApplicationWindow {
  id: root
  visible: true
  width: Screen.width; height: Screen.height
  color: "white"
  
  function show() {
    video.source = files.current
    start.value = 0
    end.value = 1
    video.play()
    video.pause()
  }
   
  Controller {
    id: files
  }

  Component.onCompleted: root.show()

  Grid {

    columns: 1
    focus: true

    Keys.onPressed: {
      if (event.key == Qt.Key_Return) {
        files.cut (video.duration*start.value, video.duration*end.value);
        root.show();
      }
      else if (event.key == Qt.Key_Q) files.quit()
      else if (event.key == Qt.Key_Space) {
        if (video.playbackState == MediaPlayer.PlayingState) video.pause() 
        else {
          video.stop()
          video.seek(video.duration*start.value)
          video.play()
        }
      }
      else if (event.key == Qt.Key_D) {
        files.delete()
        console.log("delete: "+video.source);
        files.shift()
        root.show();
      }
    }

    Video {
      id: video
      width: Screen.width
      height: Screen.height*0.9
      autoLoad: true
      muted: true
      source: files.current
      onPositionChanged: {
        progress.value = video.position/video.duration
        if (video.position >= video.duration*end.value) video.seek(video.duration*start.value)
      }
    }

    Slider {
      id: progress
      value: 0.0
      width: Screen.width
    }

    Slider {
      id: start
      value: 0.0
      width: Screen.width
      onValueChanged: video.seek(parseInt(video.duration*start.value))
    }

    Slider {
      id: end
      value: 1.0
      width: Screen.width
      onValueChanged: video.seek(parseInt(video.duration*end.value))
    }
  }
}
