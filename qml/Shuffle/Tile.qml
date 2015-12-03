import QtQuick 2.0
import QtGraphicalEffects 1.0

Item{
    width: 100
    height: width

    property alias letter: letterText.text
    property alias points: pointsText.text
    property int bonus : 0
    property bool selected: false

    DropShadow {
        id: rectShadow;
        anchors.fill: source
        //cached: true;
        horizontalOffset: 3;
        verticalOffset: 3;
        radius: 5;
        samples: 24;
        color: "#80000000";
        smooth: true;
        source: rect;
    }
    Rectangle {
        id: rect
        anchors.fill: parent
        anchors.margins: 3
        radius: 5

        color: selected?"#ffb74d":"white"

        border.color: (bonus===1?"green":(bonus===2?"blue":(bonus===3?"orange":(bonus===4?"red":"magenta"))))
        border.width: bonus>0?3:0


        Text{
            id: letterText
            anchors.centerIn: parent
            text: model.letter
            font.pointSize: 35
            font.bold: true
        }

        Text{
            id: pointsText
            text: model.point
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 5
        }
    }
}
