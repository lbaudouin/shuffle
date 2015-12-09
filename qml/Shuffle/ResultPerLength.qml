import QtQuick 2.0
import QtQuick.Controls 1.1

Rectangle {

    height: lengthText.height

    property int length: -1
    property int found: -1
    property int total: -1

    Text{
        id: lengthText
        text: length + ":"
    }

    ProgressBar{
        id: progressBar
        anchors.left: lengthText.right
        anchors.right: parent.right
        maximumValue: total
        value: found
    }
    Text{
        text: found + "/" + total
        anchors.centerIn: progressBar
    }
}
