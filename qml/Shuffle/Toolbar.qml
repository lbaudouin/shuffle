import QtQuick 2.0
import QtQuick.Controls 1.1

Rectangle {
    id: toolbar
    color: "#757575"

    signal reset();
    signal display();

    signal solve(string text)

    property alias points: totalPoints.text
    property int timeout: 0

    Item{
        id: frontItem
        width: parent.width
        height: parent.height

        Text{
            color: "white"
            text: timeout<0?"0:00":(Math.floor(timeout/60).toString() + ":" + ((timeout%60)<10?("0"+(timeout%60).toString()):(timeout%60).toString()))
            font.pointSize: 18
            font.bold: true

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
        }

        Text{id: totalPoints
            color: "white"
            font.pointSize: 18
            font.bold: true

            anchors.centerIn: parent

            MouseArea{
                anchors.fill: parent
                onPressAndHold: {
                    display()
                }
            }
        }

        Text{
            color: "white"
            text: "Reset"
            font.pointSize: 18
            font.bold: true

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    reset()
                }
            }
        }
    }

    Item{
        id: backItem
        width: parent.width
        height: parent.height
        x: width
        enabled: false

        TextField{
            id: solveText
            height: parent.height
            anchors.left: parent.left
            anchors.right: button.left

            inputMethodHints: Qt.ImhUppercaseOnly

        }
        Button{
            id: button
            text: qsTr("Solve")
            height: parent.height
            anchors.right: parent.right

            onClicked: solve(solveText.text)
        }
    }

    states: State {
          name: "solver";
          PropertyChanges { target: frontItem; x: -frontItem.width; enabled: false }
          PropertyChanges { target: backItem; x: 0; enabled: true }
      }

    transitions: Transition{
        NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 250 }
    }
}
