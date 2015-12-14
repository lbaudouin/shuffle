import QtQuick 2.0
import QtGraphicalEffects 1.0

Item{
    id: tile
    width: 100
    height: width

    property alias letter: letterText.text
    property alias points: pointsText.text
    property int bonus : 0
    property bool selected: false
    property int display : 0

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

        color: display===0?(selected?"#ffb74d":"white"):(display===1?"green":(display===2?"red":"orange"))

        border.color: (bonus<0?"gray":(bonus===1?"green":(bonus===2?"blue":(bonus===3?"orange":(bonus===4?"red":"magenta")))))
        border.width: (bonus<0?1:(bonus>0?3:0))


        Text{
            id: letterText
            visible: text!==""
            anchors.centerIn: parent
            text: model.letter
            font.pointSize: tile.state==="small"?8:35

            Behavior on font.pointSize {
                NumberAnimation{ duration: 250 }
            }
            font.bold: true
        }

        Text{
            id: pointsText
            visible: text!=-1 && opacity>0
            opacity: tile.state==="small"?0:1

            Behavior on opacity {
                NumberAnimation{ duration: 100 }
            }

            text: model.point
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 5
        }
    }
}
