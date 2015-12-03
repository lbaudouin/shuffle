import QtQuick 2.0

Rectangle {
    width: 480
    height: 640

    Rectangle{
        id: toolbar
        color: "#388e3c"
        height: 50
        width: parent.width


        Text{
            color: "white"
            text: "1:45"
            font.pointSize: 18
            font.bold: true

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
        }

        Text{
            color: "white"
            text: "425"
            font.pointSize: 18
            font.bold: true

            anchors.centerIn: parent
        }
    }

    ListModel{
        id: letters
        ListElement { letter: "A"; points: 1; bonus: 0; selected: true }
        ListElement { letter: "B"; points: 1; bonus: 1 }
        ListElement { letter: "C"; points: 1; bonus: 0 }
        ListElement { letter: "D"; points: 2; bonus: 0 }

        ListElement { letter: "E"; points: 1; bonus: 0; selected: true }
        ListElement { letter: "F"; points: 4; bonus: 0 }
        ListElement { letter: "G"; points: 3; bonus: 2 }
        ListElement { letter: "A"; points: 1; bonus: 0 }

        ListElement { letter: "A"; points: 1; bonus: 0 }
        ListElement { letter: "R"; points: 1; bonus: 3; selected: true }
        ListElement { letter: "A"; points: 1; bonus: 0 }
        ListElement { letter: "A"; points: 1; bonus: 0 }

        ListElement { letter: "A"; points: 1; bonus: 0 }
        ListElement { letter: "A"; points: 1; bonus: 4 }
        ListElement { letter: "O"; points: 1; bonus: 0; selected: true }
        ListElement { letter: "A"; points: 1; bonus: 5 }
    }

    Rectangle{
        id: background
        color: "#4caf50"
        anchors.top: toolbar.bottom
        anchors.bottom: parent.bottom
        width: parent.width

        Rectangle {
            id: current
            color: "#388e3c"
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            height: 50
            width: parent.width * 0.75
            radius: 3
        }

        Item{
            anchors.top: current.bottom
            anchors.bottom: parent.bottom
            width: parent.width

            Item{
                id: content
                //color: "yellow"
                anchors.centerIn: parent
                width: Math.min(parent.width,parent.height) * 0.75
                height: width
                //border.color: "black"
                //border.width: 2

                property int tileSize: content.width / grid.columns

                Grid{
                    id: grid
                    anchors.fill: parent
                    anchors.margins: 1
                    columns: 4

                    Repeater{
                        model: letters

                        Tile{
                            width: grid.width / grid.columns
                            letter: model.letter
                            points: model.points
                            bonus: model.bonus
                            selected: model.selected || false
                        }
                    }
                }

                MouseArea{
                    anchors.fill: parent

                    property int posX : -1
                    property int posY : -1

                    onPosXChanged: {
                        if(posX>=0 && posY>=0){
                            console.debug("pos",posX,posY)
                        }
                    }
                    onPosYChanged: {
                        if(posX>=0 && posY>=0){
                            console.debug("pos",posX,posY)
                        }
                    }


                    onPressed:{
                        posX = mouseX/content.tileSize
                        posY = mouseY/content.tileSize
                    }

                    onReleased: {
                        posX = -1;
                        posY = -1;
                    }

                    onMouseXChanged:{
                        posX = mouseX/content.tileSize
                    }
                    onMouseYChanged:{
                        posY = mouseY/content.tileSize
                    }

                }
            }
        }
    }
}
