import QtQuick 2.0

Rectangle {
    id: root
    width: 480
    height: 640

    property int totalPoints: 0
    property int points: 0
    property string word: ""
    property int timeout: 120

    function check(){
        console.debug("CHECK", root.word)

        if(gridModel.exists(root.word)){
            totalPoints += points;
            points = 0;
            console.debug(totalPoints)
        }else{
            console.debug("doesn't exist")
        }

        for(var i=0;i<letters.count;i++){
            letters.get(i).selected = false;
        }

        word = ""
    }

    function finish(){
        console.debug("FINISH", root.totalPoints)
    }

    Timer{
        running: timeout>0
        interval: 1000
        repeat: true
        onTriggered:{
            timeout--
            if(timeout<=0){
                root.finish()
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
            text: totalPoints.toString()
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
                    for(var i=0;i<letters.count;i++){
                        letters.get(i).letter = "";
                        letters.get(i).points = -1;
                        letters.get(i).selected = false;
                    }
                    root.word = ""
                    root.points = 0;
                    root.totalPoints = 0;
                    root.timeout = 119
                    gridModel.generate();
                }
            }
        }
    }

    ListModel{
        id: letters
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
                    columns: gridModel.columns
                    rows: gridModel.rows

                    Repeater{
                        model: letters

                        Tile{
                            width: grid.width / grid.columns
                            letter: model.letter || ""
                            points: model.points || -1
                            bonus: model.bonus || 0
                            selected: model.selected
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
                            var index = y*grid.columns + x;
                            console.debug("pos",posX,posY,index,letters.count)
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

                        if( tempPosX<0 || tempPosY<0 || tempPosX>=grid.columns || tempPosY>=grid.rows){
                            return;
                        }

                        var near = false;
                        if(posX<0 || posY<0){
                            near = true;
                        }else{
                            if(Math.abs(posX-tempPosX)<=1 && Math.abs(posY-tempPosY)<=1){
                                near = true;
                            }
                        }
                        //console.debug(posX,posY,tempPosX,tempPosY,near)

                        if( near && (Math.abs((tempPosX+0.5)*w - x) + Math.abs((tempPosY+0.5)*w - y)) <0.6*w ){
                            posX = tempPosX
                            posY = tempPosY
                            posChanged(posX,posY)
                        }
                    }

                    onPressed: mousePosChanged(mouseX,mouseY);
                    onMouseXChanged: mousePosChanged(mouseX,mouseY);
                    onMouseYChanged: mousePosChanged(mouseX,mouseY);

                    onReleased: {
                        posX = -1;
                        posY = -1;
                        if(enabled )
                            root.check()
                    }
                }
            }
        }
    }

    Connections{
        target: gridModel
        onGenerated:{
            var temp = gridModel.getTilesJS();
            console.debug( JSON.stringify( temp ))
            letters.clear()
            for(var i=0;i<temp.length;i++){
                temp[i].letter = temp[i].letter.toUpperCase() || "";
                temp[i].points = temp[i].points || -1;
                temp[i].bonus =  temp[i].bonus  || 0;
                temp[i].selected = temp[i].selected || false;
                console.debug( JSON.stringify( temp[i] ))
                letters.append( temp[i] )
            }
        }
    }

    Component.onCompleted: {
        gridModel.generate()
    }
}
