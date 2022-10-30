import QtQuick 2.15
import QtQuick.Window 2.15
import QtMultimedia 5.6
import QtQuick.Controls 2.0

Window {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Video Player")

    // Background
    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Component.onCompleted: {
        console.log("onCompleted")
    }

    // Video player wrapper
    Item {
        anchors.bottomMargin: 60
        width: parent.width
        height: parent.height

        MediaPlayer {
            id: player
            objectName: "player"
            source: "qrc:/file_1.mp4"
            onError: (error, errorString) => {
                console.log("Video error = ", errorString)
            }
            onStopped: button_img.source = "qrc:/play.png"

            function change_video(video_name: string): string {
                player.stop();
                player.source = video_name;
                player.play();

                return "OK";
            }
        }

        VideoOutput {
            id: video
            anchors.fill: parent
            source: player
        }

        Component.onCompleted: {
            player.play();
        }

        // For dragging
        Drag.active: dragArea.drag.active
        MouseArea {
            id: dragArea
            anchors.fill: parent

            drag.target: parent
        }
    }

    // Progress bar
    SeekControl {
        id: seek
        anchors {
            left: parent.left
            right: parent.right
            margins: 10
            bottom: parent.bottom
            bottomMargin: 35
        }
        duration: player.duration
        playPosition: player.position
        onSeekPositionChanged: player.seek(seekPosition);
    }

    // Play-Pause button
    Button {
        id: play_button
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 5
        }
        width: 25
        height: 25

        Image {
            id: button_img
            anchors.fill: parent;
            anchors.margins: 2
            fillMode: Image.PreserveAspectFit
            source: "qrc:/pause.png"
        }

        onClicked: {
            if (player.playbackState == MediaPlayer.PlayingState) {
                player.pause();
                button_img.source = "qrc:/play.png";
            } else if (player.playbackState == MediaPlayer.PausedState || player.playbackState == MediaPlayer.StoppedState) {
                player.play();
                button_img.source = "qrc:/pause.png";
            }
        }
    }

    // Load video button
    signal changeVideoSignal()
    Button {
        id: button_change_video
        anchors {
            left: parent.left
            leftMargin: 10
            bottom: parent.bottom
            bottomMargin: 5
        }
        width: 25
        height: 25

        Image {
            anchors.fill: parent;
            anchors.margins: 2
            fillMode: Image.PreserveAspectFit
            source: "qrc:/change_video.png"
        }

        onClicked: {
            window.changeVideoSignal()
        }
    }
}
