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

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Item {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            bottomMargin: 60
        }

        MediaPlayer {
            id: player
            source: "qrc:/file_1.mp4"
            onError: (error, errorString) => {
                console.log("Video error = ", errorString)
            }
            onStopped: button_img.source = "qrc:/play.png"
        }

        VideoOutput {
            id: video
            anchors.fill: parent
            source: player
        }

        Component.onCompleted: {
            player.play();
        }
    }

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
}
