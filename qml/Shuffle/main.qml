import QtQuick 2.0

Rectangle {
    id: root
    width: 480
    height: 640

    property int points: 0
    property string word: ""
    property int timeout: 120

    Timer{
        running: timeout>0
        interval: 1000
        repeat: true
        onTriggered:{
            timeout--
            if(timeout<=0){
                console.debug("FINISHED")
            }
        }
    }

    Rectangle{
        id: toolbar
        color: "#388e3c"
        height: 50
        width: parent.width


        Text{
            color: "white"
            text: Math.floor(timeout/60).toString() + ":" + ((timeout%60)<10?("0"+(timeout%60).toString()):(timeout%60).toString())
            font.pointSize: 18
            font.bold: true

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
        }

        Text{
            color: "white"
            text: points.toString()
            font.pointSize: 18
            font.bold: true

            anchors.centerIn: parent
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
                    for(var i=0;i<letters.count;i++)
                        letters.get(i).selected = false;
                    root.word = ""
                    root.points = 0;
                    root.timeout = 119
                }
            }
        }
    }

    ListModel{
        id: letters
        ListElement { letter: "A"; points: 1; bonus: 0; selected: false }
        ListElement { letter: "B"; points: 1; bonus: 1; selected: false }
        ListElement { letter: "C"; points: 1; bonus: 0; selected: false }
        ListElement { letter: "D"; points: 2; bonus: 0; selected: false }

        ListElement { letter: "E"; points: 1; bonus: 0; selected: false }
        ListElement { letter: "F"; points: 4; bonus: 0; selected: false }
        ListElement { letter: "G"; points: 3; bonus: 2; selected: false }
        ListElement { letter: "A"; points: 1; bonus: 0; selected: false }

        ListElement { letter: "A"; points: 1; bonus: 0; selected: false }
        ListElement { letter: "R"; points: 1; bonus: 3; selected: false }
        ListElement { letter: "A"; points: 1; bonus: 0; selected: false }
        ListElement { letter: "A"; points: 1; bonus: 0; selected: false }

        ListElement { letter: "A"; points: 1; bonus: 0; selected: false }
        ListElement { letter: "A"; points: 1; bonus: 4; selected: false }
        ListElement { letter: "O"; points: 1; bonus: 0; selected: false }
        ListElement { letter: "A"; points: 1; bonus: 5; selected: false }
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
            width: parent.width * 0.80
            radius: 3

            Text{
                id: currentText
                font.pointSize: 25
                font.bold: true
                color: "white"
                text: root.word


                anchors.centerIn: parent
            }
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
                    enabled: timeout>0

                    property int posX : -1
                    property int posY : -1

                    function posChanged(x,y){
                        if(enabled && posX>=0 && posY>=0){
                            console.debug("pos",posX,posY)
                            var index = y*grid.columns + x;
                            if(index<letters.count){
                                if(!letters.get(index).selected){
                                    root.word += letters.get(index).letter
                                    root.points += letters.get(index).points
                                    letters.get(index).selected = true;
                                }
                            }
                        }
                    }

                    function mousePosChanged(x,y){
                        var w = content.tileSize
                        var tempPosX = Math.floor(x/w)
                        var tempPosY = Math.floor(y/w)

                        if( tempPosX<grid.columns && (Math.abs((tempPosX+0.5)*w - x) + Math.abs((tempPosY+0.5)*w - y)) <0.6*w ){
                            posX = tempPosX
                            posY = tempPosY
                        }else{
                            posX = -1
                            posY = -1
                        }
                    }

                    onPosXChanged: posChanged(posX,posY)
                    onPosYChanged: posChanged(posX,posY)

                    onPressed: mousePosChanged(mouseX,mouseY);
                    onMouseXChanged: mousePosChanged(mouseX,mouseY);
                    onMouseYChanged: mousePosChanged(mouseX,mouseY);

                    onReleased: {
                        posX = -1;
                        posY = -1;
                    }
                }
            }
        }
    }
}
