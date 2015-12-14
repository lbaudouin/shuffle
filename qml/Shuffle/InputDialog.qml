import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.1

Dialog {
    title: "Blue sky dialog"

    contentItem: Rectangle {
        color: "lightskyblue"
        implicitWidth: 400
        implicitHeight: 100
        Text {
            text: "Hello blue sky!"
            color: "navy"
            anchors.centerIn: parent
        }
    }
}
